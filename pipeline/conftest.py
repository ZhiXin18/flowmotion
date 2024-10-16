#
# Flowmotion
# Test Fixtures
#

from datetime import datetime
import pytest

from data import TrafficImage
from data import Camera, Location


@pytest.fixture
def camera() -> Camera:
    return Camera(
        id="1001",
        image_url="https://images.data.gov.sg/api/traffic/1001.jpg",
        captured_on=datetime(2024, 9, 27, 8, 30, 0),
        retrieved_on=datetime(2024, 9, 27, 8, 31, 0),
        location=Location(longitude=103.851959, latitude=1.290270),
    )


# Fixture for TrafficImage instance
@pytest.fixture
def traffic_image():
    return TrafficImage(
        image="some_image_url",
        processed=True,
        congestion_rating=0.5,
        camera_id="camera_123",
        longitude=103.851959,
        latitude=1.290270,
        processed_on=datetime(2024, 9, 27, 8, 30, 0),
        model_id="model_v1",
    )
