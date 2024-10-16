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
        image,
        camera_id,
        longitude,
        latitude,
        processed=False,
        congestion_rating=None,
    ):
        self.image = image
        self.processed = processed
        self.congestion_rating = congestion_rating
        self.camera_id = camera_id
        self.longitude = longitude
        self.latitude = latitude
        self.processed_on = processed_on

    @classmethod
    def from_camera(cls, camera: Camera, image_path: Path) -> "TrafficImage":
        """Create TrafficImage from camera & its image path.

        Args:
            camera:
                Camera model to create TrafficImage from.
            image_path:
                Path to the retrieved captured image from the Camera.
        Returns:
            Constructed TrafficImage
        """
        return cls(
            image=str(image_path),
            camera_id=camera.id,
            longitude=camera.location.longitude,
            latitude=camera.location.latitude,
        )

    def set_processed(self, congestion_rating):
        self.processed = True
        self.congestion_rating = congestion_rating
