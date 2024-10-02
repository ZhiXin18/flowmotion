#
# Flowmotion
# Pipeline
# Traffic Images API Client
#

import asyncio

import httpx

from model import Camera, Location


class TrafficImageAPI:
    """Data.gov.sg Traffic Images API Client."""

    API_URL = "https://api.data.gov.sg/v1/transport/traffic-images"

    def __init__(self):
        self._sync = httpx.Client()
        self._async = httpx.AsyncClient()

    def get_cameras(self) -> list[Camera]:
        """Get Traffic Camera metadata from traffic images API endpoint.

        Returns:
            Parsed traffic camera metadata.
        """
        # fetch traffic-images api endpoint
        response = self._sync.get(TrafficImageAPI.API_URL)
        response.raise_for_status()
        meta = response.json()
        return parse_cameras(meta)

        # parse traffic camera metadata

    def get_images(self, cameras: list[Camera]) -> list[bytes]:
        """Get Traffic Camera images from given Traffic Cameras.

        Args:
            cameras:
                List of traffic cameras to retrieve traffic images from.
        Returns:
            List of JPEG image bytes camera captured by each given Camera.
        """

        async def fetch():
            responses = [self._async.get(camera.image_url) for camera in cameras]
            images = [(await r).aread() for r in responses]
            return await asyncio.gather(*images)

        return asyncio.run(fetch())


def parse_cameras(meta: dict) -> list[Camera]:
    meta = meta["items"][0]
    retrieved_on = meta["timestamp"]
    return [
        Camera(
            id=c["camera_id"],
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
