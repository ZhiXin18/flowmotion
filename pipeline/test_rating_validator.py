import pytest
from TrafficImage import TrafficImage
from rating_validator import RatingValidator

# Fixture for TrafficImage instance
@pytest.fixture
def traffic_image():
    return TrafficImage(
        image="some_image_url",
        processed=True,
        congestion_rating=0.5,
        camera_id="camera_123",
        longitude=103.851959,
        latitude=1.290270
    )

# Fixture for RatingValidator instance
@pytest.fixture
def validator(traffic_image):
    return RatingValidator(TrafficImageObject=traffic_image)

def test_validate_with_valid_data(validator):
    # Should not raise an exception with valid data
    try:
        validator.validate()
    except Exception as e:
        pytest.fail(f"validate() raised an exception unexpectedly: {e}")

def test_validate_with_no_traffic_image():
    # Test without a TrafficImage object
    validator = RatingValidator(TrafficImageObject=None)
    with pytest.raises(Exception, match="No Traffic Image Parsed Through Validatior!!!"):
        validator.validate()

def test_validate_with_invalid_congestion_rating_low(traffic_image):
    # Test with invalid congestion rating (low)
    traffic_image.congestion_rating = -0.1
    validator = RatingValidator(TrafficImageObject=traffic_image)
    with pytest.raises(Exception, match="Congestion Rating Is Invalid"):
        validator.validate()

def test_validate_with_invalid_congestion_rating_high(traffic_image):
    # Test with invalid congestion rating (high)
    traffic_image.congestion_rating = 1.1
    validator = RatingValidator(TrafficImageObject=traffic_image)
    with pytest.raises(Exception, match="Congestion Rating Is Invalid"):
        validator.validate()

def test_validate_with_unprocessed_image(traffic_image):
    # Test with unprocessed TrafficImage
    traffic_image.processed = False
    validator = RatingValidator(TrafficImageObject=traffic_image)
    with pytest.raises(Exception, match="This camera has not been processed through the ML model"):
        validator.validate()
