from torchvision import transforms
from ultralytics import YOLO

# Configuration for data augmentation
transform = transforms.Compose(
    [
        transforms.RandomHorizontalFlip(p=0.5),
        transforms.ColorJitter(brightness=0.4, contrast=0.4, saturation=0.4, hue=0.1),
        transforms.RandomRotation(degrees=5),
        transforms.RandomResizedCrop((640, 640), scale=(0.8, 1.2)),
    ]
)


def train_model():
    # Initialize YOLO model with pretrained weights
    model = YOLO(
        "yolov8n.yaml"
    )  # You can use yolov8n.pt if you want to use the pretrained model

    # Update training settings in model
    model.train(
        data="data.yaml",
        epochs=100,  # Increase epochs to 100 for better training
        batch=8,  # Use batch size of 8 to avoid NMS time limit issues
        imgsz=512,  # Reduce image size to 512x512 for faster training
        optimizer="AdamW",  # AdamW optimizer for improved convergence
        lr0=0.0015,  # Fine-tune the learning rate for smoother learning
        lrf=0.005,  # Adjust learning rate final value for slower decay
        momentum=0.9,  # Momentum for better optimization
        weight_decay=0.0001,  # Lower weight decay to prevent over-regularization
        augment=True,  # Enable augmentation for better generalization
        mosaic=1.0,  # Mosaic augmentation to improve robustness
        mixup=0.2,  # Introduce MixUp data augmentation
        hsv_h=0.015,  # Adjust HSV for more varied color augmentation
        hsv_s=0.7,
        hsv_v=0.4,
        degrees=10,  # Increase the rotation degrees to allow more flexibility
        translate=0.2,  # Allow higher translation augmentation
        scale=0.6,  # Slightly higher scaling range for augmentation
        flipud=0.1,  # Flip images upside down 10% of the time
        fliplr=0.5,  # Left-right flip augmentationn m
        max_det=1000,  # Allow up to 1000 detections to handle crowded scenes
        patience=50,  # Early stopping patience to avoid overfitting
        project="runs/detect",
        name="train_augmented_tuned",  # Updated name to reflect fine-tuning
        workers=4,  # Keep a lower number of workers for better resource management
        amp=True,  # Re-enable mixed precision to speed up training
        verbose=True,  # Display progress logs during training
    )


if __name__ == "__main__":
    train_model()
