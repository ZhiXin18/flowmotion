from api import APIClient
from rating_validator import RatingValidator
from TrafficImage import TrafficImage

from model import Model

if __name__ == "__main__":
    apiclient = APIClient("https://api.data.gov.sg/v1/transport/traffic-images")
    active_cameraIDs = apiclient.camera_id_array
    current_traffic_camera_objects = []  # array of TrafficImage objects

    # populating array of TrafficImage objects
    for camera_id in active_cameraIDs:
        image_url = apiclient.extract_image(camera_id)
        longitude, latitude = apiclient.extract_latlon(camera_id)
        traffic_camera_obj = TrafficImage(
            camera_id=camera_id, image=image_url, longitude=longitude, latitude=latitude
        )
        current_traffic_camera_objects.append(traffic_camera_obj)

    # run model
    active_model = Model()
    active_model.predict(current_traffic_camera_objects)

    # validate model output
    for object in current_traffic_camera_objects:
        validator = RatingValidator(object)
        validator.validate()

    # iterate through current_traffic_camera_objects and populate json for firebase storage
