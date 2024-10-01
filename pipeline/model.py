#
# Flowmotion
# Pipeline
# Models
#

from datetime import datetime

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

    camera_id: str
    image_url: str
    captured_on: datetime
    retrieved_on: datetime
    location: Location
