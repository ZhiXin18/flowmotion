#
# Flowmotion
# ML Pipeline
# OSM Congestion Tagging
#

from argparse import ArgumentParser
from pathlib import Path
from typing import cast

import numpy as np
import osmium as osm
from haversine import Unit, haversine_vector
from osmium.filter import EntityFilter, IdFilter
from osmium.osm import NODE, WAY, Way

from data import Congestion
from db import DatabaseClient
from pipeline import CONGESTION_COLLECTION

if __name__ == "__main__":
    # parse program arguments
    parser = ArgumentParser(
        description="Tag an OSM PBR file with Congestion ratings from Firebase."
    )
    parser.add_argument("in_pbf", type=Path, help="Path to the OSM PBF file to tag.")
    parser.add_argument(
        "out_pbf",
        type=Path,
        help="Path write the tagged OSM PBF file.",
    )
    parser.add_argument(
        "-p",
        "--proximity",
        type=int,
        help="Proximity threshold for tagging in meters."
        "If a OSM way contains a node within the Threshold to a congestion point, "
        "it will be tagged with the congestion point",
        default=50,
    )
    args = parser.parse_args()

    # query last ingestion timestamp
    db = DatabaseClient()
    max_entry = db.max(CONGESTION_COLLECTION, "updated_on")
    if max_entry is None:
        raise RuntimeError(
            f"No congestion ratings stored in '{CONGESTION_COLLECTION}' in Firestore"
        )
    last_ingested_on = max_entry[1]["updated_on"]

    # fetch congestions for last ingestion timestamp
    results = list(
        db.query(CONGESTION_COLLECTION, updated_on=(("==", last_ingested_on)))
    )
    congestions = [Congestion(**entry[1]) for entry in results]
    # build dict for congestion -> document id lookup
    congestion_doc_map = {Congestion(**entry[1]): entry[0] for entry in results}

    # build dict for (latitude, longitude) -> Congestion lookup
    congestion_map = {
        (
            congestion.camera.location.latitude,
            congestion.camera.location.longitude,
        ): congestion
        for congestion in congestions
    }
    congestion_pts = list(congestion_map.keys())

    # extract node location points from OSM ways as waypoints
    in_pbf = (
        osm.FileProcessor(args.in_pbf).with_filter(EntityFilter(WAY | NODE))
        # read location (lat, lon) into way's nodes
        .with_locations()
    )
    # build dict for (latitude, longitude) -> OSM Way id lookup
    way_map = {}
    for obj in in_pbf:
        if isinstance(obj, Way):
            way = cast(Way, obj)
            # check that locations are loaded for all nodes in way
            for node in way.nodes:
                if not node.location.valid():
                    raise ValueError(f"Node {node} has no valid location.")

            way_map |= {(n.location.lat, n.location.lon): way.id for n in way.nodes}

    way_pts = list(way_map.keys())

    # compute distance between each way_pt, congestion_pts combination
    distance = haversine_vector(
        way_pts,
        congestion_pts,
        unit=Unit.METERS,
        check=False,
        comb=True,
    )
    # associate closeby congestion points by proximity to way_pts
    way_congestion_map = {}
    closeby = np.argwhere(distance <= args.proximity)
    for i, j in closeby:
        way_id = way_map[way_pts[j]]
        congestion = congestion_map[congestion_pts[i]]

        # if multiple congestion points match, keep the one with the highest congestion rating
        if (
            way_id in way_congestion_map
            and way_congestion_map[way_id].rating.value > congestion.rating.value
        ):
            congestion = way_congestion_map[way_id]

        way_congestion_map[way_id] = congestion

    # write associated congestion point into OSM way's tags to be used by osrm
    # custom profile congestion_profile.lua for routing
    way_ids = list(way_congestion_map.keys())
    with osm.SimpleWriter(args.out_pbf, overwrite=True) as writer:
        in_pbf = (
            osm.FileProcessor(args.in_pbf)
            .with_filter(EntityFilter(WAY))
            .with_filter(IdFilter(way_ids))
            # write filtered out objects to out_pbf
            .handler_for_filtered(writer)
        )
        for obj in in_pbf:
            way = cast(Way, obj)
            tags = dict(way.tags)

            # write congestion information into tags
            congestion = way_congestion_map[way.id]
            tags["congestion_doc_id"] = congestion_doc_map[congestion]
            tags["congestion_rating"] = str(congestion.rating.value)

            writer.add(way.replace(tags=tags))
