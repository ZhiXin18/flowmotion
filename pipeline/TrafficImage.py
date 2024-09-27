import APIClient

class TrafficImage:
    def __init__(self, image_url,processed=False, congestion_rating=None):
        self.image_url = image_url
        self.processed = processed
        self.conestion_rating = congestion_rating

    def is_processed(self):
        self.processed = True

    def add_congestion_rating(self, congestion_rating):
        self.conestion_rating = congestion_rating
