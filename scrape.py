import json 
import requests

url = "https://api.data.gov.sg/v1/transport/traffic-images"
response = requests.get(url)

print(type(response.json()))
with open('metadata.json', 'w') as json_file:
    json.dump(response.json(), json_file)