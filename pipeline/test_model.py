#
# Flowmotion
# Traffic Congestion Model
# Integration Test
#

# Usage:
# - Google Application Default credentials should be provided to authenticate
#       with firestore eg. by setting GOOGLE_APPLICATION_CREDENTIALS env var.


import os
from shutil import rmtree
from tempfile import mkdtemp
from typing import Any, Generator

import pytest
import requests

from data import TrafficImage
from model import Model


@pytest.fixture(scope="session")
def traffic_images() -> Generator[list[TrafficImage], Any, Any]:
    """Fixture downloads traffic camera images from the Traffic Images API into temporary directory.
    Yields Traffic Image instances for each traffic image retrieved.
    """
    # create temporary directory for traffic images
    save_dir = mkdtemp()

    # API URL to fetch images
    api_url = "https://api.data.gov.sg/v1/transport/traffic-images"
    response = requests.get(api_url)
    if response.status_code == 200:
        data = response.json()

        camera_ids = []
        image_urls = []
        locations = []

        for item in data["items"]:
            for camera in item["cameras"]:
                camera_ids.append(camera["camera_id"])
                image_urls.append(camera["image"])
                locations.append(
                    (camera["location"]["latitude"], camera["location"]["longitude"])
                )
        file_paths = []
        for idx, (camera_id, url, location) in enumerate(
            zip(camera_ids, image_urls, locations)
        ):
            response = requests.get(url, stream=True)
            if response.status_code == 200:
                file_path = os.path.join(save_dir, f"image_{camera_id}.jpg")
                with open(file_path, "wb") as file:
                    for chunk in response.iter_content(1024):
                        file.write(chunk)
                file_paths.append((camera_id, file_path, location))

        # Yield TrafficImage objects for each image retrieved
        yield [
            TrafficImage(
                image=path,
                camera_id=camera_id,
                latitude=location[0],
                longitude=location[1],
            )
            for camera_id, path, location in file_paths
        ]

        # clean up traffic images
        rmtree(save_dir)
    else:
        raise Exception(
            f"Failed to retrieve images from API. Status code: {response.status_code}"
        )


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
