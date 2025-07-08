"""Direct adapter for converting social media data to news blocks without intermediate models."""

from typing import List, Dict, Any, Optional, Union
from datetime import datetime
from abc import ABC, abstractmethod

# Import generated models (will be available after generation)
try:
    from .models import (
        NewsBlock, PostLargeBlock, PostMediumBlock, PostSmallBlock,
        ArticleIntroductionBlock, ImageBlock, VideoBlock, TextParagraphBlock,
        SlideshowBlock, SlideBlock, SlideshowIntroductionBlock, HtmlBlock,
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
        
        # Enhanced media processing - use media_files for comprehensive data
        media_files = raw_data.get('media_files', {})
        photo_file_ids = media_files.get('photos', [])
        video_file_ids = media_files.get('videos', [])
        
        # Fallback to legacy format if media_files is empty
        if not photo_file_ids and not video_file_ids:
            photo = raw_data.get('photo')
            video = raw_data.get('video')
            
            if photo:
                file_id = photo.get('file_id', '')
                if file_id:
                    photo_file_ids.append(file_id)
            
            if video:
                file_id = video.get('file_id', '')
                if file_id:
                    video_file_ids.append(file_id)
        
        # Get metadata for enhanced processing
        is_story = raw_data.get('is_story', False)
        is_circles = raw_data.get('is_circles', False)
        total_media_count = raw_data.get('total_media_count', len(photo_file_ids) + len(video_file_ids))
        media_group_count = raw_data.get('media_group_count', 1)
        
        # Create title from text (first 100 chars)
        title = self._extract_title(text, channel_title)
        
        # Enhanced slideshow detection
        should_create_slideshow = self._should_create_slideshow(
            total_media_count, is_story, is_circles, media_group_count
        )

        if should_create_slideshow:
            # Create slideshow for stories, circles, or multiple media
            slideshow_blocks = self._create_slideshow_blocks(
                title=title,
                photo_file_ids=photo_file_ids,
                video_file_ids=video_file_ids,
                text=text,
                channel_title=channel_title,
                channel_username=channel_username,
                message_id=message_id,
                is_circles=is_circles
            )
            blocks.extend(slideshow_blocks)

        else:
            # Regular single post handling
            # Article introduction block
            intro_block = ArticleIntroductionBlock(
                type=ArticleIntroductionBlock.get_identifier(),
                category_id=self.get_source_type(),
                author=channel_title or channel_username,
                published_at=published_at,
                title=title,
                image_url=photo_file_ids[0] if photo_file_ids else ""
            )
            blocks.append(intro_block)
            
            # Content block based on content length and media
            post_id = f"telegram_{channel_username}_{message_id}"
            
            content_block = self._create_content_block(
                post_id=post_id,
                text=text,
                title=title,
                photo_file_ids=photo_file_ids,
                video_file_ids=video_file_ids,
                channel_title=channel_title,
                channel_username=channel_username,
                published_at=published_at
            )
            blocks.append(content_block)
            
            # Add full text as paragraph if content was truncated
            if len(text) > 300:
                text_block = TextParagraphBlock(
                    type=TextParagraphBlock.get_identifier(),
                    text=text
                )
                blocks.append(text_block)
            
            # Add additional media blocks for comprehensive content
            blocks.extend(self._create_media_blocks(photo_file_ids, video_file_ids))
        
        return blocks

    def _extract_title(self, text: str, channel_title: str) -> str:
        """Extract a meaningful title from text."""
        if not text.strip():
            return f"Пост от {channel_title}"
        
        # Try to find the first meaningful line
        lines = [line.strip() for line in text.split('\n') if line.strip()]
        if not lines:
            return f"Пост от {channel_title}"
        
        first_line = lines[0]
        
        # If first line is too short, try to combine with second line
        if len(first_line) < 20 and len(lines) > 1:
            combined = f"{first_line} {lines[1]}"
            if len(combined) <= 100:
                return combined
        
        # Truncate if too long
        if len(first_line) > 100:
            return first_line[:100] + "..."
        
        return first_line

    def _should_create_slideshow(
        self, total_media_count: int, is_story: bool, is_circles: bool, media_group_count: int
    ) -> bool:
        """Determine if content should be displayed as a slideshow."""
        # Always create slideshow for multiple media
        if total_media_count > 1:
            return True
        
        # Create slideshow for explicitly marked stories/circles
        if is_story or is_circles:
            return True
        
        # Create slideshow for grouped messages even with single media
        if media_group_count > 1:
            return True
        
        return False

    def _create_slideshow_blocks(
        self,
        title: str,
        photo_file_ids: List[str],
        video_file_ids: List[str],
        text: str,
        channel_title: str,
        channel_username: str,
        message_id: str,
        is_circles: bool = False
    ) -> List[NewsBlock]:
        """Create slideshow blocks for stories and multiple media."""
        blocks = []
        
        # Determine slideshow type
        slideshow_type = "circles" if is_circles else "story"
        cover_url = photo_file_ids[0] if photo_file_ids else (video_file_ids[0] if video_file_ids else "")
        
        # Create slideshow introduction block
        slideshow_intro = SlideshowIntroductionBlock(
            type=SlideshowIntroductionBlock.get_identifier(),
            title=title,
            cover_image_url=cover_url,
            action={
                "type": "__navigate_to_slideshow__",
                "action_type": "navigation",
                "slideshow_id": f"telegram_{slideshow_type}_{channel_username}_{message_id}"
            }
        )
        blocks.append(slideshow_intro)

        # Create slides for each media item
        slides = []
        media_index = 0
        
        # Add image slides
        for image_url in photo_file_ids:
            slide = SlideBlock(
                type=SlideBlock.get_identifier(),
                caption=self._generate_slide_caption(media_index, "фото", is_circles),
                description=text if media_index == 0 else "",  # Only add text to first slide
                photo_credit=channel_title,
                image_url=image_url or ""
            )
            slides.append(slide)
            media_index += 1
        
        # Add video slides (represented as images with video URLs)
        for video_url in video_file_ids:
            slide = SlideBlock(
                type=SlideBlock.get_identifier(),
                caption=self._generate_slide_caption(media_index, "видео", is_circles),
                description=text if media_index == 0 and not photo_file_ids else "",
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
        
        return blocks

    def _generate_slide_caption(self, index: int, media_type: str, is_circles: bool) -> str:
        """Generate appropriate caption for slide."""
        if is_circles:
            return f"Кружок {index + 1}"
        else:
            return f"{media_type.title()} {index + 1}"

    def _create_content_block(
        self,
        post_id: str,
        text: str,
        title: str,
        photo_file_ids: List[str],
        video_file_ids: List[str],
        channel_title: str,
        channel_username: str,
        published_at: datetime
    ) -> Union[PostLargeBlock, PostMediumBlock, PostSmallBlock]:
        """Create appropriate content block based on content."""
        base_params = {
            "id": post_id,
            "category_id": self.get_source_type(),
            "author": channel_title or channel_username,
            "published_at": published_at,
            "title": title,
            "image_url": photo_file_ids[0] if photo_file_ids else "",
            "action": {
                "type": "__navigate_to_article__",
                "action_type": "navigation",
                "article_id": post_id
            }
        }
        
        # Determine block size based on content
        has_media = bool(photo_file_ids or video_file_ids)
        text_length = len(text)
        
        if text_length > 500 or has_media:
            return PostLargeBlock(
                type=PostLargeBlock.get_identifier(),
                description=self._truncate_text(text, 300),
                **base_params
            )
        elif text_length > 200:
            return PostMediumBlock(
                type=PostMediumBlock.get_identifier(),
                description=self._truncate_text(text, 200),
                **base_params
            )
        else:
            return PostSmallBlock(
                type=PostSmallBlock.get_identifier(),
                description=text,
                **base_params
            )

    def _truncate_text(self, text: str, max_length: int) -> str:
        """Truncate text to specified length."""
        if len(text) <= max_length:
            return text
        return text[:max_length] + "..."

    def _create_media_blocks(
        self, photo_file_ids: List[str], video_file_ids: List[str]
    ) -> List[NewsBlock]:
        """Create individual media blocks for additional images/videos."""
        blocks = []
        
        # Add additional images as image blocks (skip first one as it's used in content block)
        for image_url in photo_file_ids[1:]:
            image_block = ImageBlock(
                type=ImageBlock.get_identifier(),
                image_url=image_url or ""
            )
            blocks.append(image_block)
        
        # Add videos as video blocks
        for video_url in video_file_ids:
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
                    "action_type": "navigation",
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
                        "action_type": "navigation",
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
                        "action_type": "navigation",
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
                        "action_type": "navigation",
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


class MireaToNewsBlocksAdapter(SocialMediaToNewsBlocksAdapter):
    """Adapter for converting official MIREA news to news blocks."""

    def get_source_type(self) -> str:
        return "mirea"

    def adapt_post_data(self, raw_data: Dict[str, Any]) -> List[NewsBlock]:
        """Convert MIREA news item to news blocks."""
        if not MODELS_AVAILABLE:
            raise RuntimeError("News blocks models not generated yet")

        blocks = []

        title = raw_data.get("NAME", "Новость от МИРЭА")
        content = raw_data.get("DETAIL_TEXT", "")
        date_str = raw_data.get("DATE_ACTIVE_FROM", "")
        images = raw_data.get("PROPERTY_MY_GALLERY_VALUE", [])
        cover_image = raw_data.get("DETAIL_PICTURE", "")
        detail_page_url = raw_data.get("DETAIL_PAGE_URL", "")

        try:
            # Date format is DD.MM.YYYY HH:MI:SS
            date_parts = date_str.split(" ")[0].split(".")
            time_parts = date_str.split(" ")[1].split(":")
            published_at = datetime(
                int(date_parts[2]),
                int(date_parts[1]),
                int(date_parts[0]),
                int(time_parts[0]),
                int(time_parts[1]),
                int(time_parts[2]),
            )
        except (IndexError, ValueError):
            published_at = datetime.now()

        # Article Introduction Block
        intro_block = ArticleIntroductionBlock(
            type=ArticleIntroductionBlock.get_identifier(),
            category_id=self.get_source_type(),
            author="РТУ МИРЭА",
            published_at=published_at,
            title=title,
            image_url=f"https://mirea.ru{cover_image}" if cover_image else None,
        )
        blocks.append(intro_block)

        if content:
            blocks.append(
                HtmlBlock(type=HtmlBlock.get_identifier(), content=content)
            )

        # Add additional images
        for image_url in images:
            if image_url and image_url != cover_image:
                blocks.append(
                    ImageBlock(
                        type=ImageBlock.get_identifier(),
                        image_url=f"https://mirea.ru{image_url}",
                    )
                )

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
        self.register_adapter(MireaToNewsBlocksAdapter())
    
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
