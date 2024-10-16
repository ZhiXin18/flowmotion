#
# Flowmotion
# ML Pipeline
# Entrypoint
#


from pathlib import Path
from tempfile import mkdtemp
from typing import cast
from api import TrafficImageAPI
from data import Congestion, Rating
from db import DatabaseClient
from model import Model
from rating_validator import RatingValidator
from TrafficImage import TrafficImage
from datetime import datetime, timezone
from zoneinfo import ZoneInfo


def datetime_sgt() -> datetime:
    """Get the current timestamp in the SGT timezone."""
    return datetime.now(ZoneInfo("Asia/Singapore"))


if __name__ == "__main__":
    # fetch camera metadata & images from traffic image api
    api = TrafficImageAPI()
    cameras = api.get_cameras()
    image_dir = Path(mkdtemp())
    image_paths = api.get_images(cameras, image_dir)

    # populating array of TrafficImage objects
    traffic_images = []  # type: list[TrafficImage]
    for camera, image_path in zip(cameras, image_paths):
        traffic_images.append(
            TrafficImage(
                image=str(image_path),
                camera_id=camera.id,
                longitude=camera.location.longitude,
                latitude=camera.location.latitude,
            )
        )

    # perform inference on model for traffic congestion rating
    active_model = Model()
    active_model.predict(traffic_images)
    rated_on = datetime_sgt()
    # validate model output
    for traffic_image in traffic_images:
        RatingValidator(traffic_image).validate()

    # construct congestion with model's traffic congestion rating
    congestions = []  # type: list[Congestion]
    updated_on = datetime_sgt()
    for camera, traffic_image in zip(cameras, traffic_images):
        congestions.append(
            Congestion(
                camera=camera,
                rating=Rating(
                    model_id=Model.MODEL_ID,
                    rated_on=rated_on,
                    value=cast(float, traffic_image.congestion_rating),
                ),
                updated_on=updated_on,
            ),
        )

    # write congestions to the database
    db = DatabaseClient()
    for congestion in congestions:
        db.insert("congestions", congestion)
