"""Media file storage and processing for social media content."""

import asyncio
import hashlib
import io
import os
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional, Tuple
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
        self._bucket_id_cache: Dict[str, str] = {}

    async def initialize(self) -> None:
        """Initialize the storage and HTTP session.
        
        Raises:
            RuntimeError: If initialization fails
        """
        try:
            timeout = aiohttp.ClientTimeout(total=self.settings.CLIENT_TIMEOUT)
            self.session = aiohttp.ClientSession(timeout=timeout)

            await self._populate_bucket_cache()
            logger.info("Media storage initialized")
        except Exception as e:
            logger.error(f"Failed to initialize media storage: {e}")
            if self.session:
                await self.session.close()
                self.session = None
            raise RuntimeError(f"Media storage initialization failed: {e}") from e

    async def close(self) -> None:
        """Close the HTTP session and cleanup resources."""
        if self.session:
            try:
                await self.session.close()
                logger.info("Media storage closed")
            except Exception as e:
                logger.warning(f"Error closing media storage session: {e}")
            finally:
                self.session = None

    async def _populate_bucket_cache(self) -> None:
        """Fetch all buckets and cache their names and IDs.
        
        Raises:
            RuntimeError: If bucket population fails critically
        """
        if not (hasattr(self.supabase, 'storage') and self.supabase.storage):
            logger.warning("Supabase storage not available, skipping bucket cache.")
            return
        
        try:
            buckets = self.supabase.storage.list_buckets()
            if not buckets:
                logger.warning("No buckets found in Supabase storage")
                return

            self._bucket_id_cache = {b.name: b.name for b in buckets}
            logger.info(f"Successfully cached {len(self._bucket_id_cache)} buckets: {list(self._bucket_id_cache.keys())}")
            
            required_buckets = [self.images_bucket_name, self.videos_bucket_name]
            missing_buckets = [bucket for bucket in required_buckets if bucket not in self._bucket_id_cache]
            
            if missing_buckets:
                logger.warning(f"Required buckets not found: {missing_buckets}. Available buckets: {list(self._bucket_id_cache.keys())}")
                    
        except Exception as e:
            logger.error(
                f"Could not list storage buckets to populate cache: {e}. "
                f"Please ensure the service key has 'storage.buckets.list' permissions."
            )

    def _get_bucket_id(self, bucket_name: str) -> str:
        """Get bucket identifier. We use bucket names directly with Supabase SDK.
        
        Args:
            bucket_name: Name of the bucket
            
        Returns:
            The bucket identifier (same as name for Supabase)
        """
        return bucket_name

    def _get_bucket_name_for_type(self, file_type: str) -> Optional[str]:
        """Get the appropriate bucket name for file type.
        
        Returns None if the file type is not supported or bucket is not available.
        """
        if file_type == "image":
            bucket_name = self.images_bucket_name
        elif file_type == "video":
            bucket_name = self.videos_bucket_name
        else:
            return None
            
        if bucket_name not in self._bucket_id_cache:
            logger.warning(f"Bucket '{bucket_name}' not available for file type '{file_type}'")
            return None
            
        return bucket_name

    def _get_allowed_mime_types(self, bucket_name: str) -> List[str]:
        """Get allowed MIME types for a bucket."""
        if bucket_name == self.images_bucket_name:
            return ["image/*"]
        elif bucket_name == self.videos_bucket_name:
            return ["video/*"]
        return ["*/*"]

    async def upload_data(
        self,
        *,
        data: bytes,
        content_type: str,
        file_type: str,
        source_info: Optional[Dict[str, Any]] = None,
        name_hint: Optional[str] = None,
    ) -> Optional[str]:
        """Upload raw data to storage and return public URL.
        
        Args:
            data: Raw file data
            content_type: MIME content type
            file_type: Type of file (image, video)
            source_info: Optional source information for organization
            name_hint: Optional name hint for path generation
            
        Returns:
            Public URL of uploaded file or None if failed
        """
        try:
            if not data:
                logger.debug("Empty data provided for upload")
                return None
                
            if not content_type or not file_type:
                logger.debug("Missing content_type or file_type")
                return None

            if file_type not in ("image", "video"):
                logger.debug(f"Skipping upload for unsupported file type: {file_type}")
                return None

            content_type_clean = content_type.split(';')[0].strip().lower()
            if not (content_type_clean.startswith("image/") or content_type_clean.startswith("video/")):
                logger.debug(f"Skipping upload due to unsupported content-type: {content_type_clean}")
                return None
                
            max_file_size = self.settings.MAX_FILE_SIZE_MB * 1024 * 1024
            if len(data) > max_file_size:
                logger.warning(f"Data too large: {len(data)} bytes (max: {max_file_size})")
                return None

            bucket_name = self._get_bucket_name_for_type(file_type)
            if bucket_name is None:
                logger.debug(f"No bucket available for file type: {file_type}")
                return None
                
            bucket_id = self._get_bucket_id(bucket_name)
                
            seed = name_hint or content_type
            hash_input = (seed or "") + str(len(data))
            url_like = f"{hashlib.md5(hash_input.encode()).hexdigest()}"
            file_path_storage = self._generate_file_path(
                url_like, file_type, content_type, source_info
            )

            processed_data = await self._process_file(
                data, content_type, file_type
            )

            result = self.supabase.storage.from_(bucket_id).upload(
                file_path_storage,
                processed_data,
                file_options={
                    "content-type": content_type,
                    "cache-control": "3600",
                    "upsert": "true",
                },
            )

            if isinstance(result, Exception):
                logger.error(
                    f"Failed to upload data {file_path_storage}: {result}"
                )
                return None

            public_url = self.supabase.storage.from_(bucket_id).get_public_url(
                file_path_storage
            )
            logger.info(f"Successfully stored file: {file_path_storage} ({len(data)} bytes)")
            return public_url

        except Exception as e:
            logger.error(f"Error uploading data: {e}")
            return None

    async def download_and_store_file(
        self,
        url: str,
        file_type: str = "image",
        source_info: Optional[Dict[str, Any]] = None,
    ) -> Optional[str]:
        """
        Download a file from a URL and store it in Supabase Storage.

        Args:
            url: Direct HTTP(S) URL of the file
            file_type: Type of file ("image" or "video")
            source_info: Optional source metadata used to organize storage paths

        Returns:
            Public URL of the stored file, or None if failed
        """
        if not self.session:
            logger.error("Media storage not initialized")
            return None

        try:
            file_data, content_type, file_size = await self._download_file(url)
            if not file_data:
                return None

            if file_type not in ("image", "video"):
                logger.debug(f"Skipping download/store for unsupported file type: {file_type}")
                return None

            if not (content_type and (content_type.startswith("image/") or content_type.startswith("video/"))):
                logger.debug(f"Skipping download/store due to unsupported content-type: {content_type}")
                return None

            bucket_name = self._get_bucket_name_for_type(file_type)
            if bucket_name is None:
                logger.debug(f"No bucket available for file type: {file_type}")
                return None
                
            bucket_id = self._get_bucket_id(bucket_name)

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
        """Download file from URL and return data, content type, and size.
        
        Args:
            url: URL to download from
            
        Returns:
            Tuple of (file_data, content_type, file_size)
        """
        try:
            if not url or not url.strip():
                logger.warning("Empty or invalid URL provided")
                return None, None, 0
                
            async with self.session.get(url, allow_redirects=True) as response:
                if response.status != 200:
                    logger.warning(f"Failed to download {url}: HTTP {response.status}")
                    return None, None, 0

                content_type = response.headers.get(
                    "content-type", "application/octet-stream"
                ).split(';')[0].strip()  # Remove charset info
                
                content_length = int(response.headers.get("content-length", 0))

                max_file_size = self.settings.MAX_FILE_SIZE_MB * 1024 * 1024
                if content_length > 0 and content_length > max_file_size:
                    logger.warning(f"File too large: {content_length} bytes (max: {max_file_size})")
                    return None, None, 0

                data = await response.read()
                
                if len(data) > max_file_size:
                    logger.warning(f"Downloaded file too large: {len(data)} bytes (max: {max_file_size})")
                    return None, None, 0
                    
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
        """Generate a unique file path for storage.
        
        Args:
            url: Source URL or identifier
            file_type: Type of file (image, video)
            content_type: MIME content type
            source_info: Optional source information for organization
            
        Returns:
            Unique storage path
        """
        url_hash = hashlib.md5(url.encode('utf-8')).hexdigest()[:12]  # Shorter hash

        ext = self._get_file_extension(url, content_type)

        now = datetime.now(timezone.utc)
        date_folder = now.strftime("%Y/%m/%d")

        source_folder = ""
        if source_info:
            source_type = str(source_info.get("source_type", "unknown")).replace("/", "-")
            source_id = str(source_info.get("source_id", "unknown")).replace("/", "-")
            source_folder = f"{source_type}/{source_id}/"

        return f"{source_folder}{date_folder}/{file_type}_{url_hash}{ext}"

    def _get_file_extension(self, url: str, content_type: str) -> str:
        """Get file extension from URL or content type.
        
        Args:
            url: Source URL
            content_type: MIME content type
            
        Returns:
            File extension including the dot (e.g., '.jpg')
        """
        try:
            parsed = urlparse(url)
            path = parsed.path
            if "." in path:
                ext = os.path.splitext(path)[1].lower()
                if ext in {
                    ".jpg", ".jpeg", ".png", ".gif", ".webp",
                    ".mp4", ".avi", ".mov", ".webm",
                }:
                    return ext
        except Exception as e:
            logger.debug(f"Failed to parse URL extension from {url}: {e}")

        content_type_map = {
            "image/jpeg": ".jpg",
            "image/jpg": ".jpg",  # Non-standard but sometimes used
            "image/png": ".png",
            "image/gif": ".gif",
            "image/webp": ".webp",
            "video/mp4": ".mp4",
            "video/avi": ".avi",
            "video/quicktime": ".mov",
            "video/webm": ".webm",
        }

        return content_type_map.get(content_type.lower() if content_type else "", ".bin")

    async def _process_file(
        self, data: bytes, content_type: str, file_type: str
    ) -> bytes:
        """Process file data (resize images, etc.)."""
        if file_type == "image" and content_type.startswith("image/"):
            return await self._process_image(data)

        return data

    async def _process_image(self, data: bytes) -> bytes:
        """Process image data (resize if too large).
        
        Args:
            data: Raw image data
            
        Returns:
            Processed image data
        """
        if not data:
            logger.warning("Empty image data provided")
            return data
            
        try:
            return await asyncio.get_event_loop().run_in_executor(
                None, self._resize_image, data
            )
        except Exception as e:
            logger.warning(f"Image processing failed: {e}")
            return data

    def _resize_image(self, data: bytes) -> bytes:
        """Resize image if it's too large.
        
        Args:
            data: Raw image data
            
        Returns:
            Resized image data or original data if resize fails
        """
        try:
            with Image.open(io.BytesIO(data)) as image:
                MAX_WIDTH = 1920
                MAX_HEIGHT = 1080
                QUALITY = 85

                if image.width <= MAX_WIDTH and image.height <= MAX_HEIGHT:
                    return data

                ratio = min(MAX_WIDTH / image.width, MAX_HEIGHT / image.height)
                new_size = (int(image.width * ratio), int(image.height * ratio))

                resized_image = image.resize(new_size, Image.Resampling.LANCZOS)

                if resized_image.mode in ('RGBA', 'LA', 'P'):
                    rgb_image = Image.new('RGB', resized_image.size, (255, 255, 255))
                    if resized_image.mode == 'P':
                        resized_image = resized_image.convert('RGBA')
                    rgb_image.paste(resized_image, mask=resized_image.split()[-1] if resized_image.mode == 'RGBA' else None)
                    resized_image = rgb_image

                output = io.BytesIO()
                format_name = image.format if image.format in ('JPEG', 'PNG', 'WEBP') else 'JPEG'
                resized_image.save(output, format=format_name, quality=QUALITY, optimize=True)

                result_data = output.getvalue()
                logger.debug(f"Image resized from {len(data)} to {len(result_data)} bytes ({image.width}x{image.height} -> {new_size[0]}x{new_size[1]})")
                return result_data

        except Exception as e:
            logger.warning(f"Image resize failed: {e}")
            return data

    async def process_media_urls(
        self,
        media_urls: List[str],
        file_type: str,
        source_info: Optional[Dict[str, Any]] = None,
    ) -> List[str]:
        """
        Process a list of media URLs and return storage URLs.

        Args:
            media_urls: List of original URLs or media identifiers
            file_type: Type of media (image, video)
            source_info: Source information for organization

        Returns:
            List of successfully processed storage URLs
        """
        if not media_urls:
            return []
            
        if file_type not in ("image", "video"):
            logger.debug(f"Unsupported file type for batch processing: {file_type}")
            return []

        processed_urls: List[str] = []
        
        semaphore = asyncio.Semaphore(3)  # Reduced from 5 for better stability

        async def process_url(url: str) -> Optional[str]:
            """Process a single URL with semaphore protection."""
            if not url or not url.strip():
                return None
                
            async with semaphore:
                try:
                    return await self.download_and_store_file(url, file_type, source_info)
                except Exception as e:
                    logger.warning(f"Failed to process URL {url}: {e}")
                    return None
            
        tasks = [process_url(url) for url in media_urls if url]
        if not tasks:
            return []
            
        results = await asyncio.gather(*tasks, return_exceptions=True)

        for i, result in enumerate(results):
            if isinstance(result, str):
                processed_urls.append(result)
            elif isinstance(result, Exception):
                logger.warning(f"Failed to process media URL {media_urls[i] if i < len(media_urls) else 'unknown'}: {result}")

        logger.info(f"Processed {len(processed_urls)}/{len(media_urls)} media URLs successfully")
        return processed_urls
