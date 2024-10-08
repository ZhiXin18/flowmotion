#
# Flowmotion
# Pipeline
# ML Model
#

from TrafficImage import TrafficImage


class Model:
    def __init__(self):
        """Initialise ML model for traffic congestion inference"""
        # TODO: initialise model
        pass

    def predict(self, images: list[TrafficImage]):
        """Predict the traffic congestion rating (0.0-1.0) in the given images.

        Set the predicted congestion rating for each TrafficImage using TrafficImage.set_processed()
        """
        # TODO: make prediction and TrafficImage.set_processed()
        pass
