#
# Flowmotion
# Pipeline
# Traffic Images API Client
#

import json
from io import SEEK_END
from pathlib import Path
from shutil import rmtree
from tempfile import mkdtemp

import pytest

from api import TrafficImageAPI, parse_cameras
from data import Camera


@pytest.fixture
def api() -> TrafficImageAPI:
    return TrafficImageAPI()


@pytest.fixture
def cameras() -> list[Camera]:
    with open(Path(__file__).parent / "resources" / "traffic_images.json") as f:
        return parse_cameras(json.loads(f.read()))


def test_get_cameras(api: TrafficImageAPI):
    assert len(api.get_cameras()) > 0


def test_get_traffic_images(api: TrafficImageAPI, cameras: list[Camera]):
    image_dir = mkdtemp()
    traffic_images = api.get_traffic_images(cameras, Path(image_dir))
    assert len(traffic_images) > 0

    # check image paths are nonempty
    for traffic_image in traffic_images:
        with open(traffic_image.image) as f:
            f.seek(0, SEEK_END)
            assert f.tell() > 0

    # clean up image files
    rmtree(image_dir)
