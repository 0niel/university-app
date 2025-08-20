"""Media processor for news blocks - handles all media URL processing."""

from typing import Any, Dict, List, Optional, TYPE_CHECKING
from loguru import logger

from .interfaces import MediaProcessor

if TYPE_CHECKING:
    from .media_storage import MediaStorage
    from .clients.base.interfaces import SocialMediaClient


class PlatformSpecificMediaProcessor(MediaProcessor):
    """Processes platform-specific media identifiers using client hooks."""
    
    def __init__(self, client: "SocialMediaClient", storage: "MediaStorage"):
        """Initialize with client and storage."""
        self.client = client
        self.storage = storage
    
    async def process_blocks(
        self,
        blocks: List[Dict[str, Any]],
        context: Dict[str, Any]
    ) -> List[Dict[str, Any]]:
        """Process platform-specific media identifiers."""
        if not hasattr(self.client, "finalize_block_media_fields"):
            return blocks
            
        try:
            return await self.client.finalize_block_media_fields(
                blocks=blocks,
                source_type=context["source_type"],
                source_id=context["source_id"],
                external_id=context["external_id"],
                storage=self.storage,
            )
        except Exception as e:
            logger.warning(f"Platform-specific media processing failed: {e}")
            return blocks


class GenericHttpMediaProcessor(MediaProcessor):
    """Processes HTTP(S) URLs by downloading and rehosting to storage."""
    
    def __init__(self, storage: "MediaStorage"):
        """Initialize with storage."""
        self.storage = storage
    
    async def process_blocks(
        self,
        blocks: List[Dict[str, Any]],
        context: Dict[str, Any]
    ) -> List[Dict[str, Any]]:
        """Process HTTP(S) media URLs."""
        source_info = {
            "source_type": context["source_type"],
            "source_id": context["source_id"]
        }
        
        processed_blocks = []
        for block_data in blocks:
            processed_block = await self._process_block_media(
                dict(block_data), source_info
            )
            processed_blocks.append(processed_block)
        
        return processed_blocks
    
    async def _process_block_media(
        self, 
        block_data: Dict[str, Any], 
        source_info: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Process all media fields in a single block."""
        # Top-level media fields
        for field_name, media_kind in self._get_media_field_mappings():
            if field_name in block_data and block_data.get(field_name):
                new_url = await self._rehost_url(
                    block_data[field_name], media_kind, source_info
                )
                if new_url:
                    block_data[field_name] = new_url
        
        # Process slides
        if "slides" in block_data and isinstance(block_data["slides"], list):
            block_data["slides"] = await self._process_slides(
                block_data["slides"], source_info
            )
        
        # Process slideshow actions
        if "action" in block_data:
            block_data["action"] = await self._process_slideshow_action(
                block_data["action"], source_info
            )
        
        return block_data
    
    def _get_media_field_mappings(self) -> List[tuple[str, str]]:
        """Get mapping of field names to media types."""
        return [
            ("image_url", "image"),
            ("imageUrl", "image"),
            ("video_url", "video"),
            ("videoUrl", "video"),
            ("cover_image_url", "image"),
            ("coverImageUrl", "image"),
        ]
    
    async def _process_slides(
        self, 
        slides: List[Any], 
        source_info: Dict[str, Any]
    ) -> List[Any]:
        """Process media in slides."""
        processed_slides = []
        for slide in slides:
            if isinstance(slide, dict):
                slide = dict(slide)
                for field in ["image_url", "video_url"]:
                    if slide.get(field):
                        media_type = "video" if field == "video_url" else "image"
                        new_url = await self._rehost_url(
                            slide[field], media_type, source_info
                        )
                        if new_url:
                            slide[field] = new_url
            processed_slides.append(slide)
        return processed_slides
    
    async def _process_slideshow_action(
        self, 
        action: Any, 
        source_info: Dict[str, Any]
    ) -> Any:
        """Process media in slideshow actions."""
        if not isinstance(action, dict):
            return action
            
        if action.get("type") != "__navigate_to_slideshow__":
            return action
            
        slideshow = action.get("slideshow")
        if isinstance(slideshow, dict):
            slides = slideshow.get("slides")
            if isinstance(slides, list):
                slideshow["slides"] = await self._process_slides(slides, source_info)
        
        return action
    
    async def _rehost_url(
        self, 
        url: Any, 
        media_type: str, 
        source_info: Dict[str, Any]
    ) -> Optional[str]:
        """Rehost a single URL if it's an external HTTP(S) URL."""
        if not url or not isinstance(url, str):
            return None
            
        url_str = url.strip()
        if not url_str:
            return None
            
        # Skip already hosted URLs
        if self._is_supabase_storage_url(url_str):
            return None
            
        # Process HTTP(S) URLs
        if url_str.startswith(("http://", "https://", "//")):
            # Normalize protocol-relative URLs
            if url_str.startswith("//"):
                url_str = f"https:{url_str}"
            
            try:
                file_type = "video" if media_type == "video" else "image"
                return await self.storage.download_and_store_file(
                    url_str, file_type, source_info
                )
            except Exception as e:
                logger.debug(f"Failed to rehost URL {url_str}: {e}")
                
        return None
    
    def _is_supabase_storage_url(self, url: str) -> bool:
        """Check if URL is already a Supabase storage URL."""
        try:
            return "/storage/v1/object/" in url
        except Exception:
            return False


class NewsBlocksMediaProcessor:
    """Main processor that orchestrates media processing for news blocks."""
    
    def __init__(self, storage: "MediaStorage"):
        """Initialize with storage."""
        self.storage = storage
        self.processors: List[MediaProcessor] = []
    
    def add_processor(self, processor: MediaProcessor) -> None:
        """Add a media processor to the chain."""
        self.processors.append(processor)
    
    async def process_news_blocks(
        self,
        blocks: List[Dict[str, Any]],
        source_type: str,
        source_id: str,
        external_id: str,
        client: Optional["SocialMediaClient"] = None
    ) -> List[Dict[str, Any]]:
        """Process all media in news blocks through the processor chain."""
        context = {
            "source_type": source_type,
            "source_id": source_id,
            "external_id": external_id,
        }
        
        processed_blocks = blocks
        
        # First: platform-specific processing if client provided
        if client and self.storage:
            platform_processor = PlatformSpecificMediaProcessor(client, self.storage)
            processed_blocks = await platform_processor.process_blocks(
                processed_blocks, context
            )
        
        # Second: generic HTTP rehosting
        if self.storage:
            http_processor = GenericHttpMediaProcessor(self.storage)
            processed_blocks = await http_processor.process_blocks(
                processed_blocks, context
            )
        
        # Third: any additional processors
        for processor in self.processors:
            try:
                processed_blocks = await processor.process_blocks(
                    processed_blocks, context
                )
            except Exception as e:
                logger.warning(f"Media processor {type(processor).__name__} failed: {e}")
        
        return processed_blocks
