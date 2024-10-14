from TrafficImage import TrafficImage


class RatingValidator:
    def __init__(self, TrafficImageObject: TrafficImage = None):
        self.traffic_image_object = TrafficImageObject
        self.congestion_rating = TrafficImageObject.congestion_rating

    def validate(self) -> None:
        if self.traffic_image_object == None:
            raise Exception("No Traffic Image Parsed Through Validatior!!!")
        elif self.congestion_rating < 0 or self.congestion_rating > 1:
            raise Exception("Congestion Rating Is Invalid (< 0 or > 1)!!!")
