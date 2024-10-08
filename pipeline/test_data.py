#
# Flowmotion
# Data Models
# Unit Tests
#


import json
from datetime import datetime
from pathlib import Path

from jsonschema import validate

from data import Camera, Congestion, Location, Rating, to_json_dict

CONGESTION_SCHEMA = Path(__file__).parent.parent / "schema" / "congestion.schema.json"


def test_congestion_json():
    congestion = Congestion(
        camera=Camera(
            id="1001",
            image_url="https://images.data.gov.sg/api/traffic/1001.jpg",
            captured_on=datetime(2024, 9, 27, 8, 30, 0),
            retrieved_on=datetime(2024, 9, 27, 8, 31, 0),
            location=Location(longitude=103.851959, latitude=1.290270),
        ),
        rating=Rating(
            rated_on=datetime(2024, 9, 27, 8, 32, 0), model_id="v1.0", value=0.75
        ),
        updated_on=datetime(2024, 9, 27, 8, 33, 0),
    )

    with open(CONGESTION_SCHEMA, "r") as f:
        schema = json.load(f)

    validate(to_json_dict(congestion), schema)
