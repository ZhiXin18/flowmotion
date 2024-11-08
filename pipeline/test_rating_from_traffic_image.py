import json
from datetime import datetime

from data import Rating, TrafficImage  # Import the relevant classes


def format_firestore_output(rating: Rating):
    # Firestore-like formatted output
    firestore_output = {
        "rating": {
            "model_id": rating.model_id,  # String
            "rated_on": rating.rated_on.isoformat(),  # ISO format string
            "value": int(rating.value),  # Integer value (cast as required)
        }
    }
    return firestore_output


def test_rating_from_traffic_image():
    # Create a TrafficImage instance with the necessary properties
    traffic_image = TrafficImage(
        image="path/to/image.jpg",
        camera_id="camera_123",
        longitude=103.851959,
        latitude=1.290270,
        processed=True,
        congestion_rating=1.0,
        processed_on=datetime(2024, 10, 30, 13, 17, 2, 347778),
        model_id="yolo_detect_segment_v1",
    )

    # Generate the Rating from the TrafficImage instance
    rating = Rating.from_traffic_image(traffic_image)

    # Format output to match Firestore structure and print it
    firestore_output = format_firestore_output(rating)
    print("Formatted Firestore Output:")
    print(json.dumps(firestore_output, indent=2))


def test_rating_from_invalid_traffic_image():
    # Create a TrafficImage instance missing required fields for processing
    traffic_image = TrafficImage(
        image="path/to/image.jpg",
        camera_id="camera_123",
        longitude=103.851959,
        latitude=1.290270,
        processed=False,  # Not processed
        congestion_rating=None,  # Missing congestion rating
        processed_on=None,  # Missing processed timestamp
        model_id=None,  # Missing model ID
    )

    # Try generating a Rating, expecting a ValueError due to missing data
    try:
        Rating.from_traffic_image(traffic_image)
    except ValueError as e:
        print("Expected failure with ValueError:", e)


# Run the test functions
if __name__ == "__main__":
    print("Test with valid TrafficImage:")
    test_rating_from_traffic_image()
    print("\nTest with invalid TrafficImage (should fail):")
    test_rating_from_invalid_traffic_image()
