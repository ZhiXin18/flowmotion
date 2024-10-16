#
# Flowmotion
# Data Models
# Unit Tests
#


import json
from datetime import datetime
from pathlib import Path

import pytest
from jsonschema import validate

from data import Camera, Congestion, Rating, TrafficImage, to_json_dict
from model import Model

CONGESTION_SCHEMA = Path(__file__).parent.parent / "schema" / "congestion.schema.json"


@pytest.fixture
def congestion(camera: Camera) -> Congestion:
    return Congestion(
        camera=camera,
        rating=Rating(
            rated_on=datetime(2024, 9, 27, 8, 32, 0),
            model_id=Model.MODEL_ID,
            value=0.75,
        ),
        updated_on=datetime(2024, 9, 27, 8, 33, 0),
    )


def test_congestion_json(congestion: Congestion):
    with open(CONGESTION_SCHEMA, "r") as f:
        schema = json.load(f)

    validate(to_json_dict(congestion), schema)


def test_congestion_from_traffic_image(camera: Camera):
    traffic_image = TrafficImage.from_camera(camera, Path("image.png"))
    traffic_image.set_processed(0.75, Model.MODEL_ID)
    updated_on = datetime(2024, 9, 27, 8, 33, 0)

    actual = Congestion.from_traffic_image(traffic_image, camera, updated_on)
    assert actual.camera == camera
    assert actual.rating.equal(Rating.from_traffic_image(traffic_image))
    assert actual.updated_on == updated_on


def test_rating_from_traffic_image(traffic_image: TrafficImage):
    assert Rating.from_traffic_image(traffic_image).equal(
        Rating(
            model_id=Model.MODEL_ID,
            value=traffic_image.congestion_rating,  # type: ignore
            rated_on=traffic_image.processed_on,  # type: ignore
        )
    )


def test_trafficimage_from_camera(camera: Camera):
    image_path = Path("image.jpg")
    traffic_image = TrafficImage.from_camera(camera, image_path)
    assert traffic_image.__dict__ == {
        "image": str(image_path),
        "camera_id": camera.id,
        "longitude": camera.location.longitude,
        "latitude": camera.location.latitude,
        "processed": False,
        "processed_on": None,
        "congestion_rating": None,
        "model_id": None,
    }
