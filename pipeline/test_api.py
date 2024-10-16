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


def test_get_images(api: TrafficImageAPI, cameras: list[Camera]):
    image_dir = mkdtemp()
    image_paths = api.get_images(cameras, Path(image_dir))
    assert len(image_paths) > 0

    # check image paths are nonempty
    for path in image_paths:
        with open(path) as f:
            f.seek(0, SEEK_END)
            assert f.tell() > 0

    # clean up image files
    rmtree(image_dir)
