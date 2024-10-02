import cv2
import numpy as np
from ultralytics import YOLO 
from API_Client import TrafficImageAPI
from tracking import CarTracker
from detection import detect_and_count_cars

def fetch_and_process_images(model, tracker, conf_threshold=0.25, iou_threshold=0.45):

    api = TrafficImageAPI()
    cameras = api.get_cameras()
    images_with_timestamps = api.get_images_sync(cameras)
    for idx, (image_bytes, timestamp, location) in enumerate(images_with_timestamps):

        nparr = np.frombuffer(image_bytes, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        detect_and_count_cars(img, model, tracker, timestamp, location, conf_threshold, iou_threshold)


model = YOLO('yolov8n.pt')  

tracker = CarTracker()
# optimise on thresholds
fetch_and_process_images(model, tracker, conf_threshold=0.25, iou_threshold=0.45)
