#
# Flowmotion
# Pipeline
# Models
#

from datetime import datetime
import json

from pydantic import BaseModel


class Location(BaseModel):
    """Geolocation consisting of longitude and latitude."""

    longitude: float
    latitude: float


class Rating(BaseModel):
    """Traffic Congestion rating performed by a model"""

    rated_on: datetime
    model_id: str
    value: float


class Camera(BaseModel):
    """Traffic Camera capturing traffic images."""

    id: str
    image_url: str
    captured_on: datetime
    retrieved_on: datetime
    location: Location


class Congestion(BaseModel):
    """Traffic Congestion data."""

    camera: Camera
    rating: Rating
    updated_on: datetime


def to_json_dict(model: BaseModel):
    """Convert given pydantic model into the its JSON dict representation"""
    return json.loads(model.model_dump_json())
