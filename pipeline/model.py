from tempfile import NamedTemporaryFile

import cv2
import torch
from google.cloud import storage
from ultralytics import YOLO

from TrafficImage import TrafficImage


class Model:
    # uniquely identifies versions of the model. 
    # NOTE: update this if the model changed in any way.
    MODEL_ID = "yolo_detect_segment_v1"

    def __init__(
        self,
        project_id: str = "flowmotion-4e268",
        bucket_name: str = "flowmotion-4e268.appspot.com",
        detect_path: str = "model/detect/runs/detect/train_augmented_tuned/weights/best.pt",
        segment_path: str = "model/segment/runs/segment/train_finetuned/weights/best.pt",
    ):
        """Initialize ML model for traffic congestion inference from pretrained weights.

        Args:
            project_id: ID of the GCP Project hosting the GCS bucket storing pretrained weights
            bucket_name: Name of GCS bucket to retrieve pretrained weights from.
            detect_path: Path to the object detection model's pretrained weights within bucket.
            segment_path: Path to the road segmentation model's pretrained weights within bucket.
        """
        gcs = storage.Client(project=project_id)
        bucket = gcs.bucket(bucket_name)

        # Load the YOLOv8 car detection model from download pretrained weights
        with NamedTemporaryFile(suffix=".pt") as f:
            bucket.blob(detect_path).download_to_file(f)
            f.flush()
            try:
                self.car_model = YOLO(f.name)
            except Exception as e:
                print(f"Error loading car model: {e}")

        # Load the segmentation model for road detection from download pretrained weights
        with NamedTemporaryFile(suffix=".pt") as f:
            bucket.blob(segment_path).download_to_file(f)
            f.flush()
            try:
                self.road_model = YOLO(f.name)
            except Exception as e:
                print(f"Error loading road model: {e}")

    def predict(self, images: list[TrafficImage]):
        """Predict the traffic congestion rating (0.0-1.0) in the given images."""
        for image in images:
            # Load the image as a numpy array
            img = cv2.imread(image.image)
            if img is None:
                raise ValueError(f"Failed to load image: {image.image}")

            # Detect cars
            print("Detecting cars...")
            car_results = self.car_model(img)
            if len(car_results) == 0 or len(car_results[0].boxes) == 0:
                print("No cars detected")
                image.set_processed(0.0)
                continue

            # Access car bounding boxes (x, y, w, h)
            car_boxes = car_results[
                0
            ].boxes.xywh  # Get bounding boxes in (x, y, width, height) format
            car_area = 0
            for box in car_boxes:
                # Access width and height of the bounding box
                w, h = (
                    box[2].item(),
                    box[3].item(),
                )  # Make sure to convert tensor to float with .item()
                car_area += w * h

            print(f"Total car area: {car_area}")

            # Segment the road area
            print("Segmenting road area...")
            road_results = self.road_model(img)
            if len(road_results) <= 0 or road_results[0].masks is None:
                raise ValueError("No road masks detected")

            road_mask = road_results[0].masks.data[
                0
            ]  # This contains the binary road mask
            road_area = torch.sum(
                road_mask
            ).item()  # Convert the result to a Python number with .item()
            print(f"Total road area: {road_area}")

            # Calculate congestion rating
            congestion_rating = min(car_area / road_area, 1.0) if road_area > 0 else 0.0
            print(f"Congestion rating: {congestion_rating}")

            # Set the predicted congestion rating
            image.set_processed(congestion_rating)
