#
# Flowmotion
# Traffic Congestion Model
# Integration Test
#

# Usage:
# - Google Application Default credentials should be provided to authenticate
#       with firestore eg. by setting GOOGLE_APPLICATION_CREDENTIALS env var.


from pathlib import Path
from shutil import rmtree
from tempfile import mkdtemp
from typing import Any, Generator

import pytest

from api import TrafficImageAPI
from data import TrafficImage
from model import Model


@pytest.fixture(scope="session")
def traffic_images() -> Generator[list[TrafficImage], Any, Any]:
    # create temporary directory for traffic images
    api = TrafficImageAPI()
    image_dir = Path(mkdtemp())
    cameras = api.get_cameras()

    yield api.get_traffic_images(cameras, image_dir)

    # clean up traffic images
    rmtree(image_dir)


@pytest.mark.integration
def test_model(traffic_images: list[TrafficImage]):
    # Initialize the model
    model = Model()

    # Predict congestion ratings
    model.predict(traffic_images)

    for traffic_image in traffic_images:
        assert traffic_image.processed
        assert traffic_image.congestion_rating is not None
        print(
            f"Camera Id: {traffic_image.camera_id}, Congestion Rating: {traffic_image.congestion_rating}"
        )
