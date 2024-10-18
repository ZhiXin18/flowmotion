from ultralytics import YOLO

# Load a pretrained segmentation model
model = YOLO("yolov8n-seg.pt")

# Training settings and augmentations
model.train(
    data="config.yaml",  # Path to your data configuration file
    epochs=50,  # Increase epochs for better learning
    imgsz=960,  # Increase image size for better segmentation resolution
    optimizer="AdamW",  # Using AdamW optimizer for better convergence
    lr0=0.001,  # Lower starting learning rate for smoother learning
    lrf=0.01,  # Final learning rate using cosine annealing
    momentum=0.9,
    weight_decay=0.0005,
    cos_lr=True,  # Use cosine learning rate decay
    patience=100,  # Increase patience for early stopping
    batch=16,  # Adjust batch size
    hsv_h=0.015,
    hsv_s=0.7,
    hsv_v=0.4,
    translate=0.2,  # Increased translation augmentation
    scale=0.5,  # Scaling for augmentation
    shear=0.2,  # Introduce shearing
    save=True,
    project="runs/segment",
    name="train_finetuned",
)
