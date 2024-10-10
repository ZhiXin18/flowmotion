class TrafficImage:
    """Traffic Image to be rated for congestion.

    Attributes:
        image: URL that retrieves Traffic camera image.
        processed: Whether this TrafficImage instance has been processed.
        congestion_rating: 0-1 Congestion Rating
        camera_id: ID of the camera that captured this image
        longitude: Longitude of the camera that captured this image
        latitude: Latitude of the camera that captured this image
    """

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
