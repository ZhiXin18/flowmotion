import APIClient
import Rating

class Congestion:
    def __init__(self, congestion_rating=None, captured_on=None):
        self.congestion_rating = congestion_rating
        self.captured_on = captured_on
        
    
    def add_datetime(self, apiclient_instance):
        self.captured_on = apiclient_instance.timestamp

    def add_congestion_rating(self, rating):
        self.congestion_rating = rating

    def is_heavy_traffic(self):
        if self.congestion_rating == None:
            return "Error: No congestion rating has been set!"
        elif self.congestion_rating < 0.5:
            return False
        else:
            return True
    


