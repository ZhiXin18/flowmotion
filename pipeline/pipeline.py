#
# Flowmotion
# ML Pipeline
# Congestion Rating
#


from pathlib import Path
from tempfile import mkdtemp

from api import TrafficImageAPI
from data import Congestion
from db import DatabaseClient
from model import Model
from rating_validator import RatingValidator
from timetools import datetime_sgt

CONGESTION_COLLECTION = "congestions"

if __name__ == "__main__":
    # fetch camera metadata & images from traffic image api
    api = TrafficImageAPI()
    cameras = api.get_cameras()
    image_dir = Path(mkdtemp())
    traffic_images = api.get_traffic_images(cameras, image_dir)

    # perform inference on model for traffic congestion rating
    active_model = Model()
    active_model.predict(traffic_images)
    # validate model output
    for traffic_image in traffic_images:
        RatingValidator(traffic_image).validate()

    # construct congestion with model's traffic congestion rating
    congestions = []  # type: list[Congestion]
    updated_on = datetime_sgt()
    for camera, traffic_image in zip(cameras, traffic_images):
        congestions.append(
            Congestion.from_traffic_image(traffic_image, camera, updated_on)
        )

    # write congestions to the database
    db = DatabaseClient()
    for congestion in congestions:
        db.insert(CONGESTION_COLLECTION, congestion)
