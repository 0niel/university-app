"""Adapter for converting VK data to news blocks."""
from datetime import datetime
from typing import Any, Dict, List

from .base import SocialMediaToNewsBlocksAdapter

from ..models import (
    NewsBlock,
    ArticleIntroductionBlock,
    ImageBlock,
    VideoBlock,
    TextLeadParagraphBlock,
    SlideshowBlock,
    SlideBlock,
    SlideshowIntroductionBlock,
)


class VKToNewsBlocksAdapter(SocialMediaToNewsBlocksAdapter):
    def get_source_type(self) -> str:
        return "vk"

    def adapt_post_data(self, raw_data: Dict[str, Any]) -> List[NewsBlock]:
        blocks: List[NewsBlock] = []

        post_id = str(raw_data.get("id", ""))
        owner_id = str(raw_data.get("owner_id", ""))
        text = raw_data.get("text", "")
        date = raw_data.get("date", 0)
        published_at = datetime.fromtimestamp(date) if isinstance(date, int) else datetime.now()

        group_name = raw_data.get("group_name", f"VK Group {owner_id}")

        attachments = raw_data.get("attachments", [])
        image_urls: List[str] = []
        video_urls: List[str] = []

        for attachment in attachments:
            if attachment.get("type") == "photo":
                photo = attachment.get("photo", {})
                sizes = photo.get("sizes", [])
                if sizes:
                    largest = max(sizes, key=lambda x: x.get("width", 0) * x.get("height", 0))
                    image_urls.append(largest.get("url", ""))
            elif attachment.get("type") == "video":
                video = attachment.get("video", {})
                video_urls.append(f"vk_video_{video.get('owner_id', '')}_{video.get('id', '')}")

        title = text[:100] + "..." if len(text) > 100 else text
        if not title.strip():
            title = group_name

        total_media_count = len(image_urls) + len(video_urls)
        should_create_slideshow = total_media_count > 1

        if should_create_slideshow:
            slideshow_intro = SlideshowIntroductionBlock(
                type=SlideshowIntroductionBlock.get_identifier(),
                title=title,
                cover_image_url=image_urls[0] if image_urls else (video_urls[0] if video_urls else ""),
                action={
                    "type": "__navigate_to_slideshow__",
                    "action_type": "navigation",
                    "slideshow_id": f"vk_album_{owner_id}_{post_id}",
                },
            )
            blocks.append(slideshow_intro)

            slides: List[SlideBlock] = []
            media_index = 0

            for image_url in image_urls:
                slide = SlideBlock(
                    type=SlideBlock.get_identifier(),
                    caption=f"Image {media_index + 1}",
                    description=text if media_index == 0 else "",
                    photo_credit=group_name,
                    image_url=image_url,
                )
                slides.append(slide)
                media_index += 1

            for video_url in video_urls:
                slide = SlideBlock(
                    type=SlideBlock.get_identifier(),
                    caption=f"Video {media_index + 1}",
                    description=text if media_index == 0 and not image_urls else "",
                    photo_credit=group_name,
                    image_url=video_url,
                )
                slides.append(slide)
                media_index += 1

            slideshow = SlideshowBlock(type=SlideshowBlock.get_identifier(), title=title, slides=slides)
            blocks.append(slideshow)
        else:
            cover = image_urls[0] if image_urls else (video_urls[0] if video_urls else None)
            intro_block = ArticleIntroductionBlock(
                type=ArticleIntroductionBlock.get_identifier(),
                category_id=self.get_source_type(),
                author=group_name,
                published_at=published_at,
                title=title,
                image_url=cover,
            )
            blocks.append(intro_block)

            if text.strip():
                blocks.append(
                    TextLeadParagraphBlock(
                        type=TextLeadParagraphBlock.get_identifier(), text=text
                    )
                )

            for image_url in image_urls[1:]:
                if image_url:
                    blocks.append(ImageBlock(type=ImageBlock.get_identifier(), image_url=image_url))
            for video_url in video_urls:
                if video_url:
                    blocks.append(VideoBlock(type=VideoBlock.get_identifier(), video_url=video_url))

        return blocks
