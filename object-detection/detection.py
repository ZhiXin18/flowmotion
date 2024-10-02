import cv2
import matplotlib.pyplot as plt  

def detect_and_count_cars(image, model, tracker, timestamp, location, conf_threshold=0.25, iou_threshold=0.45):
    results = model(image, conf=conf_threshold, iou=iou_threshold)

    cars = []
    for result in results[0].boxes:
        if result.cls == 2:  # detects if the detected object is a car (class 2 in YOLOv8 COCO)
            # explore the dataset
            x1, y1, x2, y2 = result.xyxy[0]  # use bounding box area for scoring
            cars.append([x1.item(), y1.item(), x2.item(), y2.item()])

    tracker.update(cars)

    speed_info = results[0].speed if hasattr(results[0], 'speed') else {"preprocess": 0, "inference": 0, "postprocess": 0}

    location_text = f"Location: {location.latitude}, {location.longitude}"
    timestamp_text = f"Timestamp: {timestamp}"
    speed_text = f"Speed: {speed_info['preprocess']}ms preprocess, {speed_info['inference']}ms inference, {speed_info['postprocess']}ms postprocess per image"
    total_cars_text = f"Total cars detected in current sync: {tracker.total_cars_count}"

    print(f"{speed_text}\n{location_text}\n{timestamp_text}\n{total_cars_text}")

    for car in cars:
        x1, y1, x2, y2 = car
        cv2.rectangle(image, (int(x1), int(y1)), (int(x2), int(y2)), (0, 255, 0), 2)
        
    plt.figure(figsize=(8, 6))
    plt.imshow(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))  
    plt.axis('off') 
    plt.show()

