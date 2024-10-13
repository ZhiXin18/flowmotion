import os

import cv2
import requests
import torch
from ultralytics import YOLO

from TrafficImage import TrafficImage


class Model:
    def __init__(self):
        """Initialize ML model for traffic congestion inference"""
        # Load the YOLOv8 car detection model
        try:
            self.car_model = YOLO(
                "C:/Users/Fengren/OneDrive/Documents/NTU/NTUCS/Y2S1/SC2006/SC2006ml/flowmotion/pipeline/yolov8custommodel/code1/runs/detect/train_augmented_tuned/weights/best.pt"
            )
        except Exception as e:
            print(f"Error loading car model: {e}")

        # Load the segmentation model for road detection
        try:
            self.road_model = YOLO(
                "C:/Users/Fengren/OneDrive/Documents/NTU/NTUCS/Y2S1/SC2006/SC2006ml/flowmotion/pipeline/yolov8custommodel/code2/runs/segment/train_finetuned/weights/last.pt"
            )
        except Exception as e:
            print(f"Error loading road model: {e}")

    def predict(self, images: list[TrafficImage]):
        """Predict the traffic congestion rating (0.0-1.0) in the given images."""
        for image in images:
            # Load the image as a numpy array
            img = cv2.imread(image.image)
            if img is None:
                print(f"Failed to load image: {image.image}")
                continue

            # Detect cars
            print("Detecting cars...")
            car_results = self.car_model(img)
            if len(car_results) == 0 or len(car_results[0].boxes) == 0:
                print("No cars detected")
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
            if road_results[0].masks is None:
                print("No road masks detected")
                continue

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


def download_images(api_url, save_dir):
    """Download images from the API and save them locally."""
    response = requests.get(api_url)
    if response.status_code == 200:
        data = response.json()

        # Print the response to understand the structure
        print("API Response:", data)

        image_urls = []
        locations = []

        for item in data["items"]:
            for camera in item["cameras"]:
                image_urls.append(camera["image"])
                locations.append(
                    (camera["location"]["latitude"], camera["location"]["longitude"])
                )

        if not os.path.exists(save_dir):
            os.makedirs(save_dir)

        file_paths = []
        for idx, (url, location) in enumerate(zip(image_urls, locations)):
            response = requests.get(url, stream=True)
            if response.status_code == 200:
                file_path = os.path.join(save_dir, f"image_{idx}.jpg")
                with open(file_path, "wb") as file:
                    for chunk in response.iter_content(1024):
                        file.write(chunk)
                file_paths.append((file_path, location))

        return file_paths
    else:
        raise Exception(
            f"Failed to retrieve images from API. Status code: {response.status_code}"
        )


def main():
    # API URL to fetch images
    api_url = "https://api.data.gov.sg/v1/transport/traffic-images"

    # Directory to save downloaded images
    save_dir = "cctv_images"

    # Download images from the API
    image_paths = download_images(api_url, save_dir)

    # Initialize the model
    model = Model()

    # Prepare TrafficImage objects
    traffic_images = [
        TrafficImage(image=path, camera_id=None) for path, _ in image_paths
    ]

    # Predict congestion ratings
    model.predict(traffic_images)

    # Print the results
    for traffic_image, (_, location) in zip(traffic_images, image_paths):
        print(
            f"Location: {location}, Congestion Rating: {traffic_image.congestion_rating}"
        )


if __name__ == "__main__":
    main()
