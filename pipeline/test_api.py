#
# Flowmotion
# Pipeline
# Traffic Images API Client
#

import json
from pathlib import Path

import pytest

from api import APIClient
from TrafficImage import TrafficImage


@pytest.fixture
def api() -> APIClient:
    return APIClient(url="https://api.data.gov.sg/v1/transport/traffic-images")


@pytest.fixture
def sample_camera_id() -> str:
    # Load camera ID from a sample JSON file for testing
    with open(Path(__file__).parent / "resources" / "traffic_images.json") as f:
        cameras_data = json.loads(f.read())
        return cameras_data["items"][0]["cameras"][0][
            "camera_id"
        ]  # Grab a camera_id from the file


def test_get_camera_ids(api: APIClient):
    assert len(api.camera_id_array) > 0  # Ensure the APIClient fetched camera IDs


def test_extract_image(api: APIClient, sample_camera_id: str):
    image_url = api.extract_image(sample_camera_id)
    assert isinstance(image_url, str)
    assert image_url.startswith("http")  # Ensure a valid image URL is returned


def test_extract_latlon(api: APIClient, sample_camera_id: str):
    latlon = api.extract_latlon(sample_camera_id)
    assert isinstance(latlon, tuple)
    assert len(latlon) == 2  # Ensure we get a tuple with (longitude, latitude)
    longitude, latitude = latlon
    assert isinstance(longitude, float)
    assert isinstance(latitude, float)


def test_traffic_image_class():
    # Example test for TrafficImage class
    traffic_image = TrafficImage(
        image="some_image_url",
        processed=False,
        congestion_rating=None,
        camera_id="camera_123",
        longitude=103.851959,
        latitude=1.290270,
    )

    assert traffic_image.image == "some_image_url"
    assert traffic_image.camera_id == "camera_123"
    assert not traffic_image.processed  # Ensure it's not processed initially

    # Simulate processing the image
    traffic_image.set_processed(0.5)
    assert traffic_image.processed  # Now it should be processed
    assert traffic_image.congestion_rating == 0.5
