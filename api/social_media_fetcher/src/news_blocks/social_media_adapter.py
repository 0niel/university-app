"""Direct adapter for converting social media data to news blocks without intermediate models."""

from typing import List, Dict, Any, Optional, Union
from datetime import datetime
from abc import ABC, abstractmethod

# Import generated models (will be available after generation)
try:
    from .models import (
        NewsBlock, PostLargeBlock, PostMediumBlock, PostSmallBlock,
        ArticleIntroductionBlock, ImageBlock, VideoBlock, TextParagraphBlock,
        SlideshowBlock, SlideBlock, SlideshowIntroductionBlock,
        create_news_block_from_json
    )
    MODELS_AVAILABLE = True
except ImportError:
    MODELS_AVAILABLE = False


class SocialMediaToNewsBlocksAdapter(ABC):
    """Abstract adapter for converting social media data directly to news blocks."""
    
    @abstractmethod
    def adapt_post_data(self, raw_data: Dict[str, Any]) -> List[NewsBlock]:
        """Convert raw social media data to news blocks."""
        pass
    
    @abstractmethod
    def get_source_type(self) -> str:
        """Get the source type identifier."""
        pass


class TelegramToNewsBlocksAdapter(SocialMediaToNewsBlocksAdapter):
    """Adapter for converting Telegram data to news blocks."""
    
    def get_source_type(self) -> str:
        return "telegram"
    
    def adapt_post_data(self, raw_data: Dict[str, Any]) -> List[NewsBlock]:
        """Convert Telegram message data to news blocks."""
        if not MODELS_AVAILABLE:
            raise RuntimeError("News blocks models not generated yet")
        
        blocks = []
        
        # Extract basic info
        message_id = str(raw_data.get('id', ''))
        chat_info = raw_data.get('chat', {})
        channel_username = chat_info.get('username', '')
        channel_title = chat_info.get('title', '')
        
        # Message content
        text = raw_data.get('text', '')
        date = raw_data.get('date')
        if isinstance(date, int):
            published_at = datetime.fromtimestamp(date)
        else:
            published_at = datetime.now()
        
        # Media processing
        photo = raw_data.get('photo')
        video = raw_data.get('video')
        document = raw_data.get('document')
        
        image_urls = []
        video_urls = []
        
        if photo:
            # Extract photo file_id for later processing
            file_id = photo.get('file_id', '')
            if file_id:
                image_urls.append(file_id)  # Will be processed by media storage
        
        if video:
            file_id = video.get('file_id', '')
            if file_id:
                video_urls.append(file_id)
        
        # Create title from text (first 100 chars)
        title = text[:100] + "..." if len(text) > 100 else text
        if not title.strip():
            title = f"Post from {channel_title}"
        
        # Check if we should create a slideshow (multiple media items = story/circles)
        total_media_count = len(image_urls) + len(video_urls)
        should_create_slideshow = total_media_count > 1

        if should_create_slideshow:
            # Create slideshow introduction block
            slideshow_intro = SlideshowIntroductionBlock(
                type=SlideshowIntroductionBlock.get_identifier(),
                title=title,
                cover_image_url=image_urls[0] if image_urls else (video_urls[0] if video_urls else ""),
                action={
                    "type": "__navigate_to_slideshow__",
                    "slideshow_id": f"telegram_story_{channel_username}_{message_id}"
                }
            )
            blocks.append(slideshow_intro)

            # Create slides for each media item
            slides = []
            media_index = 0
            
            # Add image slides
            for image_url in image_urls:
                slide = SlideBlock(
                    type=SlideBlock.get_identifier(),
                    caption=f"Image {media_index + 1}",
                    description=text if media_index == 0 else "",  # Only add text to first slide
                    photo_credit=channel_title,
                    image_url=image_url or ""
                )
                slides.append(slide)
                media_index += 1
            
            # Add video slides (represented as images with video URLs)
            for video_url in video_urls:
                slide = SlideBlock(
                    type=SlideBlock.get_identifier(),
                    caption=f"Video {media_index + 1}",
                    description=text if media_index == 0 and not image_urls else "",
                    photo_credit=channel_title,
                    image_url=video_url or ""  # For videos, we use the video URL as image URL
                )
                slides.append(slide)
                media_index += 1

            # Create slideshow block
            slideshow = SlideshowBlock(
                type=SlideshowBlock.get_identifier(),
                title=title,
                slides=slides
            )
            blocks.append(slideshow)

        else:
            # Regular single post handling
            # Article introduction block
            intro_block = ArticleIntroductionBlock(
                type=ArticleIntroductionBlock.get_identifier(),
                category_id=self.get_source_type(),
                author=channel_title or channel_username,
                published_at=published_at,
                title=title,
                image_url=image_urls[0] if image_urls else ""
            )
            blocks.append(intro_block)
            
            # Content block based on content length and media
            post_id = f"telegram_{channel_username}_{message_id}"
            
            if len(text) > 500 or image_urls or video_urls:
                content_block = PostLargeBlock(
                    type=PostLargeBlock.get_identifier(),
                    id=post_id,
                    category_id=self.get_source_type(),
                    author=channel_title or channel_username,
                    published_at=published_at,
                    title=title,
                    image_url=image_urls[0] if image_urls else "",
                    description=text[:300] + "..." if len(text) > 300 else text,
                    action={
                        "type": "__navigate_to_article__",
                        "article_id": post_id
                    }
                )
            elif len(text) > 200:
                content_block = PostMediumBlock(
                    type=PostMediumBlock.get_identifier(),
                    id=post_id,
                    category_id=self.get_source_type(),
                    author=channel_title or channel_username,
                    published_at=published_at,
                    title=title,
                    image_url=image_urls[0] if image_urls else "",
                    description=text[:200] + "..." if len(text) > 200 else text,
                    action={
                        "type": "__navigate_to_article__",
                        "article_id": post_id
                    }
                )
            else:
                content_block = PostSmallBlock(
                    type=PostSmallBlock.get_identifier(),
                    id=post_id,
                    category_id=self.get_source_type(),
                    author=channel_title or channel_username,
                    published_at=published_at,
                    title=title,
                    image_url=image_urls[0] if image_urls else "",
                    description=text,
                    action={
                        "type": "__navigate_to_article__",
                        "article_id": post_id
                    }
                )
            
            blocks.append(content_block)
            
            # Add full text as paragraph if content was truncated
            if len(text) > 300:
                text_block = TextParagraphBlock(
                    type=TextParagraphBlock.get_identifier(),
                    text=text
                )
                blocks.append(text_block)
            
            # Add additional images as image blocks (only for single posts)
            for image_url in image_urls[1:]:
                image_block = ImageBlock(
                    type=ImageBlock.get_identifier(),
                    image_url=image_url or ""
                )
                blocks.append(image_block)
            
            # Add videos as video blocks (only for single posts)
            for video_url in video_urls:
                video_block = VideoBlock(
                    type=VideoBlock.get_identifier(),
                    video_url=video_url or ""
                )
                blocks.append(video_block)
        
        return blocks


class VKToNewsBlocksAdapter(SocialMediaToNewsBlocksAdapter):
    """Adapter for converting VK data to news blocks."""
    
    def get_source_type(self) -> str:
        return "vk"
    
    def adapt_post_data(self, raw_data: Dict[str, Any]) -> List[NewsBlock]:
        """Convert VK post data to news blocks."""
        if not MODELS_AVAILABLE:
            raise RuntimeError("News blocks models not generated yet")
        
        blocks = []
        
        # Extract basic info
        post_id = str(raw_data.get('id', ''))
        owner_id = str(raw_data.get('owner_id', ''))
        text = raw_data.get('text', '')
        date = raw_data.get('date', 0)
        
        if isinstance(date, int):
            published_at = datetime.fromtimestamp(date)
        else:
            published_at = datetime.now()
        
        # Get group/user info (should be provided in context)
        group_name = raw_data.get('group_name', f'VK Group {owner_id}')
        
        # Process attachments
        attachments = raw_data.get('attachments', [])
        image_urls = []
        video_urls = []
        
        for attachment in attachments:
            if attachment.get('type') == 'photo':
                photo = attachment.get('photo', {})
                sizes = photo.get('sizes', [])
                if sizes:
                    # Get largest size
                    largest = max(sizes, key=lambda x: x.get('width', 0) * x.get('height', 0))
                    image_urls.append(largest.get('url', ''))
            
            elif attachment.get('type') == 'video':
                video = attachment.get('video', {})
                # VK video URLs need special handling
                video_urls.append(f"vk_video_{video.get('owner_id', '')}_{video.get('id', '')}")
        
        # Create title
        title = text[:100] + "..." if len(text) > 100 else text
        if not title.strip():
            title = f"Post from {group_name}"
        
        # Check if we should create a slideshow (multiple media items = story/album)
        total_media_count = len(image_urls) + len(video_urls)
        should_create_slideshow = total_media_count > 1

        if should_create_slideshow:
            # Create slideshow introduction block
            slideshow_intro = SlideshowIntroductionBlock(
                type=SlideshowIntroductionBlock.get_identifier(),
                title=title,
                cover_image_url=image_urls[0] if image_urls else (video_urls[0] if video_urls else ""),
                action={
                    "type": "__navigate_to_slideshow__",
                    "slideshow_id": f"vk_album_{owner_id}_{post_id}"
                }
            )
            blocks.append(slideshow_intro)

            # Create slides for each media item
            slides = []
            media_index = 0
            
            # Add image slides
            for image_url in image_urls:
                slide = SlideBlock(
                    type=SlideBlock.get_identifier(),
                    caption=f"Image {media_index + 1}",
                    description=text if media_index == 0 else "",  # Only add text to first slide
                    photo_credit=group_name,
                    image_url=image_url or ""
                )
                slides.append(slide)
                media_index += 1
            
            # Add video slides
            for video_url in video_urls:
                slide = SlideBlock(
                    type=SlideBlock.get_identifier(),
                    caption=f"Video {media_index + 1}",
                    description=text if media_index == 0 and not image_urls else "",
                    photo_credit=group_name,
                    image_url=video_url or ""  # For videos, we use the video URL as image URL
                )
                slides.append(slide)
                media_index += 1

            # Create slideshow block
            slideshow = SlideshowBlock(
                type=SlideshowBlock.get_identifier(),
                title=title,
                slides=slides
            )
            blocks.append(slideshow)

        else:
            # Regular single post handling
            # Article introduction block
            intro_block = ArticleIntroductionBlock(
                type=ArticleIntroductionBlock.get_identifier(),
                category_id=self.get_source_type(),
                author=group_name,
                published_at=published_at,
                title=title,
                image_url=image_urls[0] if image_urls else ""
            )
            blocks.append(intro_block)
            
            # Content block
            full_post_id = f"vk_{owner_id}_{post_id}"
            
            if len(text) > 500 or image_urls or video_urls:
                content_block = PostLargeBlock(
                    type=PostLargeBlock.get_identifier(),
                    id=full_post_id,
                    category_id=self.get_source_type(),
                    author=group_name,
                    published_at=published_at,
                    title=title,
                    image_url=image_urls[0] if image_urls else "",
                    description=text[:300] + "..." if len(text) > 300 else text,
                    action={
                        "type": "__navigate_to_article__",
                        "article_id": full_post_id
                    }
                )
            elif len(text) > 200:
                content_block = PostMediumBlock(
                    type=PostMediumBlock.get_identifier(),
                    id=full_post_id,
                    category_id=self.get_source_type(),
                    author=group_name,
                    published_at=published_at,
                    title=title,
                    image_url=image_urls[0] if image_urls else "",
                    description=text[:200] + "..." if len(text) > 200 else text,
                    action={
                        "type": "__navigate_to_article__",
                        "article_id": full_post_id
                    }
                )
            else:
                content_block = PostSmallBlock(
                    type=PostSmallBlock.get_identifier(),
                    id=full_post_id,
                    category_id=self.get_source_type(),
                    author=group_name,
                    published_at=published_at,
                    title=title,
                    image_url=image_urls[0] if image_urls else "",
                    description=text,
                    action={
                        "type": "__navigate_to_article__",
                        "article_id": full_post_id
                    }
                )
            
            blocks.append(content_block)
            
            # Add full text if truncated
            if len(text) > 300:
                text_block = TextParagraphBlock(
                    type=TextParagraphBlock.get_identifier(),
                    text=text
                )
                blocks.append(text_block)
            
            # Add media blocks (only for single posts)
            for image_url in image_urls[1:]:
                image_block = ImageBlock(
                    type=ImageBlock.get_identifier(),
                    image_url=image_url or ""
                )
                blocks.append(image_block)
            
            for video_url in video_urls:
                video_block = VideoBlock(
                    type=VideoBlock.get_identifier(),
                    video_url=video_url or ""
                )
                blocks.append(video_block)
        
        return blocks


class NewsBlocksAdapterRegistry:
    """Registry for social media to news blocks adapters."""
    
    def __init__(self):
        """Initialize registry."""
        self._adapters: Dict[str, SocialMediaToNewsBlocksAdapter] = {}
        self._register_default_adapters()
    
    def _register_default_adapters(self):
        """Register default adapters."""
        self.register_adapter(TelegramToNewsBlocksAdapter())
        self.register_adapter(VKToNewsBlocksAdapter())
    
    def register_adapter(self, adapter: SocialMediaToNewsBlocksAdapter):
        """Register an adapter."""
        self._adapters[adapter.get_source_type()] = adapter
    
    def get_adapter(self, source_type: str) -> Optional[SocialMediaToNewsBlocksAdapter]:
        """Get adapter for source type."""
        return self._adapters.get(source_type)
    
    def adapt_data(self, source_type: str, raw_data: Dict[str, Any]) -> List[NewsBlock]:
        """Adapt raw data to news blocks."""
        adapter = self.get_adapter(source_type)
        if not adapter:
            raise ValueError(f"No adapter found for source type: {source_type}")
        
        return adapter.adapt_post_data(raw_data)
    
    def get_supported_sources(self) -> List[str]:
        """Get list of supported source types."""
        return list(self._adapters.keys())


# Global registry instance
adapter_registry = NewsBlocksAdapterRegistry() 