
import requests 

API_URL = "https://api.data.gov.sg/v1/transport/traffic-images"

class APIClient():
    def __init__(self, url="No API URL"):
        self.url = url
        self.timestamp = None
        self.api_status = "Unverified"
        self.metadata = None

        # Get API response
        response = requests.get(self.url)
        response_json = response.json()
        self.metadata = response_json

        # Get and set API status
        self.api_status = self.metadata["api_info"]["status"]

        # Get and set timestamp
        self.timestamp = self.metadata["items"][0]["timestamp"]

        print(f"The API status is: {self.api_status}")
        print(f"The API was called at: {self.timestamp}")

    def extract_image(self, camera_id):
        # Debugging step to ensure camera_id is correctly parsed
        #print(f"Searching for camera_id: {camera_id}")

        # Loop through the items and cameras to find the correct camera_id
        for item in self.metadata["items"]:
            for camera in item["cameras"]:
                # Debugging step to print the camera_id being checked
                #print(f"Checking camera_id: {camera['camera_id']}")
                
                if camera["camera_id"] == str(camera_id):
                    #print(f"Found camera_id: {camera_id}")
                    return camera["image"]  # Return the image URL if the camera ID matches

        # If camera ID is not found
        return f"Camera ID {camera_id} not found."

#Debugging
#client = APIClient(API_URL)
#image_url = client.extract_image(1111)
#print("Camera Image URL:", image_url)

 


