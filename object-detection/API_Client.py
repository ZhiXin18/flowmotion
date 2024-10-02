import asyncio
import httpx
from model import Camera, Location

class TrafficImageAPI:

    API_URL = "https://api.data.gov.sg/v1/transport/traffic-images"

    def __init__(self):
        self._sync = httpx.Client()
        self._async = httpx.AsyncClient()

    def get_cameras(self) -> list[Camera]:

        response = self._sync.get(TrafficImageAPI.API_URL)
        response.raise_for_status()
        meta = response.json()
        return self.parse_cameras(meta)

    def get_images_sync(self, cameras: list[Camera]) -> list[tuple]:

      images_with_info = []
      for camera in cameras:
        response = self._sync.get(camera.image_url)
        image_bytes = response.content
        images_with_info.append((image_bytes, camera.captured_on, camera.location))

      return images_with_info

    async def fetch_async(self, cameras: list[Camera]):

        responses = [self._async.get(camera.image_url) for camera in cameras]
        return await asyncio.gather(*responses)

    def get_images_async(self, cameras: list[Camera]) -> list[tuple]:

        async def fetch():
            responses = await self.fetch_async(cameras)
            images_with_info = []
            for idx, response in enumerate(responses):
                image_bytes = response.content
                camera = cameras[idx]
                images_with_info.append((image_bytes, camera.captured_on, camera.location))
            return images_with_info

        return asyncio.run(fetch())

    def parse_cameras(self, meta: dict) -> list[Camera]:

        meta = meta["items"][0]  
        retrieved_on = meta["timestamp"]  
        return [
            Camera(
                camera_id=c["camera_id"],
                retrieved_on=retrieved_on,
                captured_on=c["timestamp"],
                image_url=c["image"],
                location=Location(
                    longitude=c["location"]["longitude"],
                    latitude=c["location"]["latitude"],
                ),
            )
            for c in meta["cameras"]
        ]