class TrafficImage:
    def __init__(
        self,
        image=None,
        processed=False,
        congestion_rating=None,
        camera_id=None,
        longitude=None,
        latitude=None,
    ):
        self.image = image
        self.processed = processed
        self.congestion_rating = congestion_rating
        self.camera_id = camera_id
        self.longitude = longitude
        self.latitude = latitude

    def set_processed(self, congestion_rating):
        self.processed = True
        self.congestion_rating = congestion_rating
