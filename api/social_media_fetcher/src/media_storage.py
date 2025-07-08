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
from supabase import Client

from .config import Settings


class MediaStorage:
    """Handler for downloading and storing media files in Supabase Storage."""

    def __init__(self, settings: Settings, supabase_client: Client):
        """Initialize the media storage handler."""
        self.settings = settings
        self.supabase = supabase_client
        self.session: Optional[aiohttp.ClientSession] = None

        self.images_bucket_name = settings.SUPABASE_BUCKET_IMAGES
        self.videos_bucket_name = settings.SUPABASE_BUCKET_VIDEOS
        self.documents_bucket_name = settings.SUPABASE_BUCKET_DOCUMENTS
        self._bucket_id_cache: Dict[str, str] = {}

    async def initialize(self):
        """Initialize the storage and HTTP session."""
        timeout = aiohttp.ClientTimeout(total=self.settings.CLIENT_TIMEOUT)
        self.session = aiohttp.ClientSession(timeout=timeout)

        await self._populate_bucket_cache()
        logger.info("Media storage initialized")

    async def close(self):
        """Close the HTTP session."""
        if self.session:
            await self.session.close()
            logger.info("Media storage closed")

    async def _populate_bucket_cache(self):
        """Fetch all buckets and cache their names and IDs."""
        if not (hasattr(self.supabase, 'storage') and self.supabase.storage):
            logger.warning("Supabase storage not available, skipping bucket cache.")
            return
        
        try:
            buckets = self.supabase.storage.list_buckets()
            self._bucket_id_cache = {b.name: b.id for b in buckets}
            logger.info(f"Successfully cached bucket IDs: {list(self._bucket_id_cache.keys())}")
            
            # Verify that required buckets are in the cache
            required_buckets = [self.images_bucket_name, self.videos_bucket_name, self.documents_bucket_name]
            for bucket_name in required_buckets:
                if bucket_name not in self._bucket_id_cache:
                    logger.warning(f"Required bucket '{bucket_name}' not found in accessible buckets.")
                    
        except Exception as e:
            logger.error(
                f"Could not list storage buckets to populate cache: {e}. "
                f"Please ensure the service key has 'storage.buckets.list' permissions."
            )

    def _get_bucket_id(self, bucket_name: str) -> Optional[str]:
        """Get bucket ID from cache by its name."""
        return self._bucket_id_cache.get(bucket_name)

    def _get_bucket_name_for_type(self, file_type: str) -> str:
        """Get the appropriate bucket name for file type."""
        if file_type == "image":
            return self.images_bucket_name
        elif file_type == "video":
            return self.videos_bucket_name
        else:
            return self.documents_bucket_name

    def _get_allowed_mime_types(self, bucket_name: str) -> list:
        """Get allowed MIME types for a bucket."""
        if bucket_name == self.images_bucket_name:
            return ["image/*"]
        elif bucket_name == self.videos_bucket_name:
            return ["video/*"]
        elif bucket_name == self.documents_bucket_name:
            return ["application/*", "text/*"]
        return ["*/*"]

    async def download_telegram_file(
        self,
        media_object: Any,
        telegram_client,
        source_info: Optional[Dict[str, Any]] = None,
    ) -> Optional[str]:
        """
        Download a Telegram file using its media object and store it in Supabase Storage.

        Args:
            media_object: Telegram media object (e.g., message.media)
            telegram_client: Telegram client instance
            source_info: Additional info about the source

        Returns:
            Public URL of the stored file, or None if failed
        """
        file_path = None
        try:
            if not telegram_client or not telegram_client._initialized:
                logger.warning("Telegram client not initialized")
                return None

            file_id = getattr(media_object, 'id', 'unknown_id')
            logger.debug(f"Starting download for Telegram file: {file_id}")
            
            file_path = await telegram_client.client.download_media(media_object)
            if not file_path:
                logger.warning(f"Could not download Telegram file from media object: {file_id}")
                return None
            
            logger.debug(f"Downloaded Telegram file to: {os.path.basename(file_path)}")

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

            bucket_name = self._get_bucket_name_for_type(file_type)
            bucket_id = self._get_bucket_id(bucket_name)

            if not bucket_id:
                logger.error(f"Bucket '{bucket_name}' not found or is not accessible. Cannot upload file.")
                return None

            file_path_storage = self._generate_file_path(
                file_path, file_type, content_type, source_info
            )

            processed_data = await self._process_file(
                file_data, content_type, file_type
            )
            
            logger.info(f"Bucket ID: {bucket_id}")
            
            result = self.supabase.storage.from_(bucket_id).upload(
                file_path_storage,
                processed_data,
                file_options={
                    "content-type": content_type,
                    "cache-control": "3600",
                    "upsert": "true",
                },
            )
            
            logger.info(f"Upload result: {result}")

            if isinstance(result, Exception):
                logger.error(
                    f"Failed to upload Telegram file {file_path_storage}: {result}"
                )
                return None

            public_url = self.supabase.storage.from_(bucket_id).get_public_url(
                file_path_storage
            )
            
            logger.info(f"Successfully stored Telegram file: {file_path_storage}")
            return public_url

        except Exception as e:
            file_id = getattr(media_object, 'id', 'unknown_id')
            logger.error(f"Error downloading/storing Telegram file {file_id}: {e}")
            return None
        finally:

            if file_path:
                try:
                    if os.path.exists(file_path):
                        file_size = os.path.getsize(file_path)
                        os.unlink(file_path)
                        logger.debug(f"Cleaned up temporary file: {os.path.basename(file_path)} ({file_size} bytes)")
                    else:
                        logger.debug(f"Temporary file already removed: {os.path.basename(file_path)}")
                except Exception as e:
                    logger.warning(f"Could not clean up temporary file {os.path.basename(file_path)}: {e}")
              
                    try:
                        await asyncio.sleep(0.1)
                        if os.path.exists(file_path):
                            os.unlink(file_path)
                            logger.debug(f"Cleaned up temporary file on retry: {os.path.basename(file_path)}")
                    except Exception as e2:
                        logger.error(f"Failed to clean up temporary file even on retry: {e2}")

    async def download_and_store_file(
        self,
        url_or_media_object: Any,
        file_type: str = "image",
        source_info: Optional[Dict[str, Any]] = None,
        telegram_client=None,
    ) -> Optional[str]:
        """
        Download a file from URL or Telegram media object and store it.
        Args:
            url_or_media_object: URL of the file or a Telegram media object
            file_type: Type of file (image, video, document)
            source_info: Additional info about the source (for organizing files)
            telegram_client: Telegram client for downloading Telegram files

        Returns:
            Public URL of the stored file, or None if failed
        """
        if telegram_client and not isinstance(url_or_media_object, str):
            return await self.download_telegram_file(url_or_media_object, telegram_client, source_info)

        if not self.session:
            logger.error("Media storage not initialized")
            return None

        url = str(url_or_media_object)

        try:
            file_data, content_type, file_size = await self._download_file(url)
            if not file_data:
                return None

            bucket_name = self._get_bucket_name_for_type(file_type)
            bucket_id = self._get_bucket_id(bucket_name)

            if not bucket_id:
                logger.error(f"Bucket '{bucket_name}' not found or is not accessible. Cannot upload file.")
                return None

            file_path = self._generate_file_path(
                url, file_type, content_type, source_info
            )

            processed_data = await self._process_file(
                file_data, content_type, file_type
            )

            result = self.supabase.storage.from_(bucket_id).upload(
                file_path,
                processed_data,
                file_options={
                    "content-type": content_type,
                    "cache-control": "3600",
                    "upsert": "true",
                },
            )

            if isinstance(result, Exception):
                logger.error(f"Failed to upload file {file_path}: {result}")
                return None

            public_url = self.supabase.storage.from_(bucket_id).get_public_url(
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
