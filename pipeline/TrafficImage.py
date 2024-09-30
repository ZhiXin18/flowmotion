import APIClient

class TrafficImage:
    def __init__(self, image=None,processed=False, congestion_rating=None, camera_id="Not Set!", longitude="Longitude not set", latitude="Latitude not set"):
        self.image = image #numpy array
        self.processed = processed
        self.conestion_rating = congestion_rating
        self.camera_id = camera_id
        self.longitude = longitude
        self.latitude = latitude

    #def processed(self, congestion_rating):
       # self.processed = True
        #self.conestion_rating = congestion_rating


