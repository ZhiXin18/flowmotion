#
# Flowmotion
# Pipeline
# Data Models
#

import json
import math
from datetime import datetime
from pathlib import Path
from types import NotImplementedType
from typing import Optional, cast

from pydantic import BaseModel

from timetools import datetime_sgt


class Location(BaseModel):
    """Geolocation consisting of longitude and latitude."""

    longitude: float
    latitude: float


class Camera(BaseModel):
    """Traffic Camera capturing traffic images."""

    id: str
    image_url: str
    captured_on: datetime
    retrieved_on: datetime
    location: Location


class TrafficImage:
    """Traffic Image to be rated for congestion.

    Attributes:
        image: URL that retrieves Traffic camera image.
        processed: Whether this TrafficImage instance has been processed.
        congestion_rating: 0-1 Congestion Rating
        camera_id: ID of the camera that captured this image
        longitude: Longitude of the camera that captured this image
        latitude: Latitude of the camera that captured this image
        processed_on: Timestamp when this TrafficImage instance has been processed.
        model_id: Unique ID to identify the version of the model the performed the rating.
    """

    def __init__(
        self,
        image,
        camera_id,
        longitude,
        latitude,
        processed=False,
        congestion_rating=None,
        processed_on: Optional[datetime] = None,
        model_id: Optional[str] = None,
    ):
        self.image = image
        self.processed = processed
        self.congestion_rating = congestion_rating
        self.camera_id = camera_id
        self.longitude = longitude
        self.latitude = latitude
        self.processed_on = processed_on
        self.model_id = model_id

    @classmethod
    def from_camera(cls, camera: Camera, image_path: Path) -> "TrafficImage":
        """Create TrafficImage from camera & its image path.

        Args:
            camera:
                Camera model to create TrafficImage from.
            image_path:
                Path to the retrieved captured image from the Camera.
        Returns:
            Constructed TrafficImage
        """
        return cls(
            image=str(image_path),
            camera_id=camera.id,
            longitude=camera.location.longitude,
            latitude=camera.location.latitude,
        )

    def set_processed(self, congestion_rating: float, model_id: str):
        self.processed = True
        self.congestion_rating = congestion_rating
        self.processed_on = datetime_sgt()
        self.model_id = model_id


class Rating(BaseModel):
    """Traffic Congestion rating performed by a model"""

    rated_on: datetime
    model_id: str
    value: float

    @classmethod
    def from_traffic_image(cls, image: TrafficImage) -> "Rating":
        if (
            image.processed_on is None
            or image.congestion_rating is None
            or image.model_id is None
        ):
            __import__("pprint").pprint(image.__dict__)
            raise ValueError(
                "Invalid TrafficImage: Either 'processed_on' or 'congestion_rating' or 'model_id' is None."
            )

        return cls(
            rated_on=image.processed_on,
            value=image.congestion_rating,
            model_id=image.model_id,
        )

    def equal(self, other: object) -> bool | NotImplementedType:
        if not isinstance(other, Rating):
            return NotImplemented
        other = cast(Rating, other)
        return (
            self.model_id == other.model_id
            and math.isclose(self.value, other.value)
            and self.rated_on == other.rated_on
        )


class Congestion(BaseModel):
    """Traffic Congestion data."""

    camera: Camera
    rating: Rating
    updated_on: datetime

    @classmethod
    def from_traffic_image(
        cls, image: TrafficImage, camera: Camera, updated_on: datetime
    ) -> "Congestion":
        return cls(
            camera=camera,
            rating=Rating.from_traffic_image(image),
            updated_on=updated_on,
        )


def to_json_dict(model: BaseModel):
    """Convert given pydantic model into the its JSON dict representation"""
    return json.loads(model.model_dump_json())
