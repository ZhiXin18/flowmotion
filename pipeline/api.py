#
# Flowmotion
# Pipeline
# Traffic Images API Client
#

import asyncio
from pathlib import Path

import httpx

from data import Camera, Location


class TrafficImageAPI:
    """Data.gov.sg Traffic Images API Client."""

    API_URL = "https://api.data.gov.sg/v1/transport/traffic-images"

    def __init__(self, api_url: str = API_URL):
        self.api_url = api_url
        self._sync = httpx.Client()
        self._async = httpx.AsyncClient()

    def get_cameras(self) -> list[Camera]:
        """Get Traffic Camera metadata from traffic images API endpoint.

        Returns:
            Parsed traffic camera metadata.
        """
        # fetch traffic-images api endpoint
        response = self._sync.get(self.API_URL)
        response.raise_for_status()
        meta = response.json()
        return parse_cameras(meta)

    def get_images(self, cameras: list[Camera], image_dir: Path) -> list[Path]:
        """Save Traffic Camera images from given Cameras into image_dir.
        Creates image_dir if it does not already exist.

        Args:
            cameras:
                List of traffic cameras to retrieve traffic images from.
            image_dir:
                Path the image directory to write retrieved images.
        Returns:
            List of JPEG paths to images captured by each given Camera.
        """
        # ensure image directory exists
        image_dir.mkdir(parents=True, exist_ok=True)

        async def fetch(camera: Camera) -> Path:
            response = await self._async.get(camera.image_url)
            # write image bytes to image file on disk
            image_path = image_dir / f"{camera.id}.jpg"
            with open(image_path, "wb") as f:
                for chunk in response.iter_bytes():
                    f.write(chunk)

            return image_path

        async def fetch_all() -> list[Path]:
            # perform all image fetches asynchronously
            return await asyncio.gather(*[fetch(camera) for camera in cameras])

        return asyncio.run(fetch_all())


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
