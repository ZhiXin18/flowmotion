from TrafficImage import TrafficImage

class RatingValidator:
    def __init__(self, TrafficImageObject: TrafficImage = None):
        self.traffic_image_object = TrafficImageObject
        # Only assign congestion_rating and processed if TrafficImageObject is not None
        if TrafficImageObject is not None:
            self.congestion_rating = TrafficImageObject.congestion_rating
            self.processed = TrafficImageObject.processed
        else:
            self.congestion_rating = None
            self.processed = None

    def validate(self) -> None:
        if self.traffic_image_object is None:
            raise Exception("No Traffic Image Parsed Through Validatior!!!")
        elif self.congestion_rating < 0 or self.congestion_rating > 1:
            raise Exception("Congestion Rating Is Invalid (< 0 or > 1)!!!")
        elif self.processed is False:
            raise Exception("This camera has not been processed through the ML model!!!")
