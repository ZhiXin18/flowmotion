from ultralytics import YOLO
import json

model = YOLO("yolov8n.pt") 

with open('metadata.json', 'r') as json_file:
    data = json.load(json_file)

path =[]
for i in range(50,55):
    path.append(data["items"][0]["cameras"][i]["image"])
print(path)

results = model(path) 
for i,result in enumerate(results):
    i+=1
    boxes = result.boxes 
    masks = result.masks  
    keypoints = result.keypoints  
    probs = result.probs  
    obb = result.obb  
    result.show() 
    result.save(filename=f"result{i}.jpg")  