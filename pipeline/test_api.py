#
# Flowmotion
# Pipeline
# Traffic Images API Client
#

import json
from pathlib import Path
from typing import Dict

import pytest

from api import TrafficImageAPI, parse_cameras
from model import Camera


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
    assert len(api.get_images(cameras[:1])[0]) > 0
