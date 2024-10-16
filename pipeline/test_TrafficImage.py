#
# Flowmotion
# TrafficImage model
# Unit Tests
#


from pathlib import Path
from TrafficImage import TrafficImage
from data import Camera


def test_trafficimage_from_camera(camera: Camera):
    image_path = Path("image.jpg")
    traffic_image = TrafficImage.from_camera(camera, image_path)
    assert traffic_image.__dict__ == {
        "image": str(image_path),
        "camera_id": camera.id,
        "longitude": camera.location.longitude,
        "latitude": camera.location.latitude,
        "processed": False,
        "congestion_rating": None,
    }
