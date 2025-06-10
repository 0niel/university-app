"""Media file storage and processing for social media content."""

import asyncio
import hashlib
import io
import os
from datetime import datetime, timezone
from typing import Any, Dict, Optional, Tuple
from urllib.parse import urlparse

import aiohttp
from loguru import logger
from PIL import Image
from supabase import AsyncClient

from .config import Settings


class MediaStorage:
    """Handler for downloading and storing media files in Supabase Storage."""

    def __init__(self, settings: Settings, supabase_client: AsyncClient):
        """Initialize the media storage handler."""
        self.settings = settings
        self.supabase = supabase_client
        self.session: Optional[aiohttp.ClientSession] = None

        self.images_bucket = "social-media-images"
        self.videos_bucket = "social-media-videos"
        self.documents_bucket = "social-media-documents"

    async def initialize(self):
        """Initialize the storage and HTTP session."""
        timeout = aiohttp.ClientTimeout(total=self.settings.CLIENT_TIMEOUT)
        self.session = aiohttp.ClientSession(timeout=timeout)

        await self._ensure_buckets_exist()
        logger.info("Media storage initialized")

    async def close(self):
        """Close the HTTP session."""
        if self.session:
            await self.session.close()
            logger.info("Media storage closed")

    async def _ensure_buckets_exist(self):
        """Ensure required storage buckets exist."""
        buckets = [self.images_bucket, self.videos_bucket, self.documents_bucket]

        for bucket_name in buckets:
            try:
                await self.supabase.storage.get_bucket(bucket_name)
                logger.debug(f"Bucket {bucket_name} exists")
            except Exception:
                try:
                    await self.supabase.storage.create_bucket(
                        bucket_name,
                        options={
                            "public": True,
                            "file_size_limit": 50 * 1024 * 1024,
                            "allowed_mime_types": self._get_allowed_mime_types(
                                bucket_name
                            ),
                        },
                    )
                    logger.info(f"Created bucket: {bucket_name}")
                except Exception as e:
                    logger.warning(f"Could not create bucket {bucket_name}: {e}")

    def _get_allowed_mime_types(self, bucket_name: str) -> list:
        """Get allowed MIME types for a bucket."""
        if bucket_name == self.images_bucket:
            return ["image/*"]
        elif bucket_name == self.videos_bucket:
            return ["video/*"]
        elif bucket_name == self.documents_bucket:
            return ["application/*", "text/*"]
        return ["*/*"]

    async def download_telegram_file(
        self,
        file_id: str,
        telegram_client,
        source_info: Optional[Dict[str, Any]] = None,
    ) -> Optional[str]:
        """
        Download a Telegram file using file_id and store it in Supabase Storage.

        Args:
            file_id: Telegram file ID
            telegram_client: Telegram client instance
            source_info: Additional info about the source

        Returns:
            Public URL of the stored file, or None if failed
        """
        try:
            if not telegram_client or not telegram_client._initialized:
                logger.warning("Telegram client not initialized")
                return None

            file_path = await telegram_client.client.download_media(file_id)
            if not file_path:
                logger.warning(f"Could not download Telegram file: {file_id}")
                return None

            with open(file_path, "rb") as f:
                file_data = f.read()

            import mimetypes

            content_type, _ = mimetypes.guess_type(file_path)
            if not content_type:
                content_type = "application/octet-stream"

            if content_type.startswith("image/"):
                file_type = "image"
            elif content_type.startswith("video/"):
                file_type = "video"
            else:
                file_type = "document"

            file_path_storage = self._generate_file_path(
                f"telegram_file_{file_id}", file_type, content_type, source_info
            )
            bucket_name = self._get_bucket_for_type(file_type)

            processed_data = await self._process_file(
                file_data, content_type, file_type
            )

            result = await self.supabase.storage.from_(bucket_name).upload(
                file_path_storage,
                processed_data,
                file_options={
                    "content-type": content_type,
                    "cache-control": "3600",
                    "upsert": True,
                },
            )

            if result.error:
                logger.error(
                    f"Failed to upload Telegram file {file_path_storage}: {result.error}"
                )
                return None

            public_url = self.supabase.storage.from_(bucket_name).get_public_url(
                file_path_storage
            )

            try:
                import os

                os.unlink(file_path)
            except Exception as e:
                logger.warning(f"Could not clean up temporary file {file_path}: {e}")

            logger.info(f"Successfully stored Telegram file: {file_path_storage}")
            return public_url

        except Exception as e:
            logger.error(f"Error downloading/storing Telegram file {file_id}: {e}")
            return None

    async def download_and_store_file(
        self,
        url: str,
        file_type: str = "image",
        source_info: Optional[Dict[str, Any]] = None,
        telegram_client=None,
    ) -> Optional[str]:
        """
        Download a file from URL or Telegram file_id and store it in Supabase Storage.

        Args:
            url: URL of the file to download or Telegram file_id
            file_type: Type of file (image, video, document)
            source_info: Additional info about the source (for organizing files)
            telegram_client: Telegram client for downloading Telegram files

        Returns:
            Public URL of the stored file, or None if failed
        """
        if not url.startswith("http") and telegram_client:
            return await self.download_telegram_file(url, telegram_client, source_info)

        if not self.session:
            logger.error("Media storage not initialized")
            return None

        try:
            file_data, content_type, file_size = await self._download_file(url)
            if not file_data:
                return None

            file_path = self._generate_file_path(
                url, file_type, content_type, source_info
            )
            bucket_name = self._get_bucket_for_type(file_type)

            processed_data = await self._process_file(
                file_data, content_type, file_type
            )

            result = await self.supabase.storage.from_(bucket_name).upload(
                file_path,
                processed_data,
                file_options={
                    "content-type": content_type,
                    "cache-control": "3600",
                    "upsert": True,
                },
            )

            if result.error:
                logger.error(f"Failed to upload file {file_path}: {result.error}")
                return None

            public_url = self.supabase.storage.from_(bucket_name).get_public_url(
                file_path
            )

            logger.info(f"Successfully stored file: {file_path} ({file_size} bytes)")
            return public_url

        except Exception as e:
            logger.error(f"Error downloading/storing file from {url}: {e}")
            return None

    async def _download_file(
        self, url: str
    ) -> Tuple[Optional[bytes], Optional[str], int]:
        """Download file from URL and return data, content type, and size."""
        try:
            async with self.session.get(url) as response:
                if response.status != 200:
                    logger.warning(f"Failed to download {url}: HTTP {response.status}")
                    return None, None, 0

                content_type = response.headers.get(
                    "content-type", "application/octet-stream"
                )
                content_length = int(response.headers.get("content-length", 0))

                if content_length > 50 * 1024 * 1024:
                    logger.warning(f"File too large: {content_length} bytes")
                    return None, None, 0

                data = await response.read()
                return data, content_type, len(data)

        except Exception as e:
            logger.error(f"Error downloading file from {url}: {e}")
            return None, None, 0

    def _generate_file_path(
        self,
        url: str,
        file_type: str,
        content_type: str,
        source_info: Optional[Dict[str, Any]] = None,
    ) -> str:
        """Generate a unique file path for storage."""
        url_hash = hashlib.md5(url.encode()).hexdigest()

        ext = self._get_file_extension(url, content_type)

        now = datetime.now(timezone.utc)
        date_folder = now.strftime("%Y/%m/%d")

        source_folder = ""
        if source_info:
            source_type = source_info.get("source_type", "unknown")
            source_id = source_info.get("source_id", "unknown")
            source_folder = f"{source_type}/{source_id}/"

        return f"{source_folder}{date_folder}/{url_hash}{ext}"

    def _get_file_extension(self, url: str, content_type: str) -> str:
        """Get file extension from URL or content type."""
        parsed = urlparse(url)
        path = parsed.path
        if "." in path:
            ext = os.path.splitext(path)[1].lower()
            if ext in [
                ".jpg",
                ".jpeg",
                ".png",
                ".gif",
                ".webp",
                ".mp4",
                ".avi",
                ".mov",
                ".pdf",
                ".doc",
                ".txt",
            ]:
                return ext

        content_type_map = {
            "image/jpeg": ".jpg",
            "image/png": ".png",
            "image/gif": ".gif",
            "image/webp": ".webp",
            "video/mp4": ".mp4",
            "video/avi": ".avi",
            "video/quicktime": ".mov",
            "application/pdf": ".pdf",
            "text/plain": ".txt",
        }

        return content_type_map.get(content_type, ".bin")

    def _get_bucket_for_type(self, file_type: str) -> str:
        """Get the appropriate bucket name for file type."""
        if file_type == "image":
            return self.images_bucket
        elif file_type == "video":
            return self.videos_bucket
        else:
            return self.documents_bucket

    async def _process_file(
        self, data: bytes, content_type: str, file_type: str
    ) -> bytes:
        """Process file data (resize images, etc.)."""
        if file_type == "image" and content_type.startswith("image/"):
            return await self._process_image(data)

        return data

    async def _process_image(self, data: bytes) -> bytes:
        """Process image data (resize if too large)."""
        try:
            return await asyncio.get_event_loop().run_in_executor(
                None, self._resize_image, data
            )
        except Exception as e:
            logger.warning(f"Image processing failed: {e}")
            return data

    def _resize_image(self, data: bytes) -> bytes:
        """Resize image if it's too large."""
        try:
            image = Image.open(io.BytesIO(data))

            max_width = 1920
            max_height = 1080

            if image.width <= max_width and image.height <= max_height:
                return data

            ratio = min(max_width / image.width, max_height / image.height)
            new_size = (int(image.width * ratio), int(image.height * ratio))

            resized_image = image.resize(new_size, Image.Resampling.LANCZOS)

            output = io.BytesIO()
            format_name = image.format or "JPEG"
            resized_image.save(output, format=format_name, quality=85, optimize=True)

            return output.getvalue()

        except Exception as e:
            logger.warning(f"Image resize failed: {e}")
            return data

    async def process_media_urls(
        self,
        media_urls: list,
        file_type: str,
        source_info: Optional[Dict[str, Any]] = None,
        telegram_client=None,
    ) -> list:
        """
        Process a list of media URLs and return storage URLs.

        Args:
            media_urls: List of original URLs or Telegram file_ids
            file_type: Type of media (image, video, document)
            source_info: Source information for organization
            telegram_client: Telegram client for downloading Telegram files

        Returns:
            List of processed storage URLs
        """
        if not media_urls:
            return []

        processed_urls = []

        semaphore = asyncio.Semaphore(5)

        async def process_url(url: str) -> Optional[str]:
            async with semaphore:
                return await self.download_and_store_file(
                    url, file_type, source_info, telegram_client
                )

        tasks = [process_url(url) for url in media_urls]
        results = await asyncio.gather(*tasks, return_exceptions=True)

        for result in results:
            if isinstance(result, str):
                processed_urls.append(result)
            elif isinstance(result, Exception):
                logger.warning(f"Failed to process media URL: {result}")

        return processed_urls
