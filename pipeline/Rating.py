class Rating:
    def __init__(self, rated_on=None, rated_by=None, rating_value=None):
        self.rated_on = rated_on
        self.rated_by = rated_by
        self.rating_value = rating_value

    def add_rating_datetime(self, rated_on):
        self.rated_on = rated_on
    
    def add_rater(self, rated_by):
        self.rated_by = rated_by

    def add_rating_value(self, rating):
        self.rating_value = rating