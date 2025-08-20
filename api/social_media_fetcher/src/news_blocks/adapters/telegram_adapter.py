"""Adapter for converting Telegram data to news blocks."""
from datetime import datetime
from typing import Any, Dict, List, Optional, Union

from .base import SocialMediaToNewsBlocksAdapter

from ..models import (
    NewsBlock,
    PostLargeBlock,
    PostMediumBlock,
    PostSmallBlock,
    ArticleIntroductionBlock,
    ImageBlock,
    VideoBlock,
    VideoIntroductionBlock,
    TextParagraphBlock,
    TextLeadParagraphBlock,
    SlideshowBlock,
    SlideBlock,
    SlideshowIntroductionBlock,
)


class TelegramToNewsBlocksAdapter(SocialMediaToNewsBlocksAdapter):
    def get_source_type(self) -> str:
        return "telegram"

    def adapt_post_data(self, raw_data: Dict[str, Any]) -> List[NewsBlock]:
        blocks: List[NewsBlock] = []

        message_id = str(raw_data.get("id", ""))
        chat_info = raw_data.get("chat", {})
        channel_username = chat_info.get("username", "")
        channel_title = chat_info.get("title", "")

        text = raw_data.get("text", "")
        date = raw_data.get("date")
        if isinstance(date, int):
            published_at = datetime.fromtimestamp(date)
        else:
            published_at = datetime.now()

        media_files = raw_data.get("media_files", {})
        photo_file_ids = list(media_files.get("photos", []))
        video_file_ids = list(media_files.get("videos", []))

        if not photo_file_ids and not video_file_ids:
            photo = raw_data.get("photo")
            video = raw_data.get("video")
            if photo:
                file_id = photo.get("file_id", "")
                if file_id:
                    photo_file_ids.append(file_id)
            if video:
                file_id = video.get("file_id", "")
                if file_id:
                    video_file_ids.append(file_id)

        is_circles = bool(raw_data.get("is_circles", False))
        total_media_count = int(
            raw_data.get("total_media_count", len(photo_file_ids) + len(video_file_ids))
        )
        media_group_count = int(raw_data.get("media_group_count", 1))

        title = self._extract_title(text, channel_title)

        should_create_slideshow = total_media_count > 1 or media_group_count > 1

        if should_create_slideshow:
            # Order: Article intro -> TextLead -> Slideshow intro (with action)
            cover = (
                photo_file_ids[0]
                if photo_file_ids
                else (video_file_ids[0] if video_file_ids else None)
            ) or None
            blocks.append(
                ArticleIntroductionBlock(
                    type=ArticleIntroductionBlock.get_identifier(),
                    category_id=self.get_source_type(),
                    author=channel_title or channel_username,
                    published_at=published_at,
                    title=title,
                    # Do not pass empty string to image_url
                    image_url=cover if cover else None,
                )
            )

            # Avoid duplicating title and first paragraph: if the body starts
            # with the derived title, trim it before adding TextLeadParagraph
            body = text.strip()
            if body and title and body.startswith(title):
                body = body[len(title):].lstrip("\n :")

            if body:
                blocks.append(
                    TextLeadParagraphBlock(
                        type=TextLeadParagraphBlock.get_identifier(), text=body
                    )
                )

            slideshow_blocks = self._create_slideshow_blocks(
                title=title,
                photo_file_ids=photo_file_ids,
                video_file_ids=video_file_ids,
                text=text,
                channel_title=channel_title,
                channel_username=channel_username,
                message_id=message_id,
                is_circles=is_circles,
            )
            blocks.extend(slideshow_blocks)
        else:
            if not text.strip() and video_file_ids:
                # Video-only post: use a video introduction block
                intro_block = VideoIntroductionBlock(
                    type=VideoIntroductionBlock.get_identifier(),
                    category_id=self.get_source_type(),
                    title=title,
                    video_url=video_file_ids[0] if video_file_ids else None,
                )
                blocks.append(intro_block)

                # Append remaining media without duplicating the first video
                remaining_videos = video_file_ids[1:] if len(video_file_ids) > 1 else []
                blocks.extend(self._create_media_blocks(photo_file_ids, remaining_videos))
            else:
                cover = (
                    photo_file_ids[0]
                    if photo_file_ids
                    else (video_file_ids[0] if video_file_ids else None)
                ) or None
                # Force small->large behavior by ensuring we have an image for PostLargeBlock
                intro_block = ArticleIntroductionBlock(
                    type=ArticleIntroductionBlock.get_identifier(),
                    category_id=self.get_source_type(),
                    author=channel_title or channel_username,
                    published_at=published_at,
                    title=title,
                    image_url=cover if cover else None,
                )
                blocks.append(intro_block)

                body = text.strip()
                if body and title and body.startswith(title):
                    body = body[len(title):].lstrip("\n :")

                if body:
                    blocks.append(
                        TextLeadParagraphBlock(
                            type=TextLeadParagraphBlock.get_identifier(), text=body
                        )
                    )

                blocks.extend(self._create_media_blocks(photo_file_ids, video_file_ids))

        return blocks

    def _extract_title(self, text: str, channel_title: str) -> str:
        if not text.strip():
            return channel_title or ""
        lines = [line.strip() for line in text.split("\n") if line.strip()]
        if not lines:
            return channel_title or ""
        first_line = lines[0]
        if len(first_line) < 20 and len(lines) > 1:
            combined = f"{first_line} {lines[1]}"
            if len(combined) <= 100:
                return combined
        if len(first_line) > 100:
            return first_line[:100] + "..."
        return first_line

    def _create_slideshow_blocks(
        self,
        *,
        title: str,
        photo_file_ids: List[str],
        video_file_ids: List[str],
        text: str,
        channel_title: str,
        channel_username: str,
        message_id: str,
        is_circles: bool = False,
    ) -> List[NewsBlock]:
        blocks: List[NewsBlock] = []
        cover_url = (
            photo_file_ids[0] if photo_file_ids else (video_file_ids[0] if video_file_ids else "")
        )

        # Build slides payload
        slides: List[SlideBlock] = []
        media_index = 0

        for image_url in photo_file_ids:
            slides.append(
                SlideBlock(
                    type=SlideBlock.get_identifier(),
                    caption=self._generate_slide_caption(media_index, "Фото", is_circles),
                    description="",
                    photo_credit=channel_title,
                    image_url=image_url,
                )
            )
            media_index += 1

        for video_url in video_file_ids:
            slides.append(
                SlideBlock(
                    type=SlideBlock.get_identifier(),
                    caption=self._generate_slide_caption(media_index, "Видео", is_circles),
                    description="",
                    photo_credit=channel_title,
                    image_url=video_url,
                )
            )
            media_index += 1

        slideshow = SlideshowBlock(
            type=SlideshowBlock.get_identifier(), title=title, slides=slides
        )

        # Proper NavigateToSlideshowAction payload
        action = {
            "type": "__navigate_to_slideshow__",
            "article_id": str(message_id),
            "slideshow": slideshow.model_dump(by_alias=True),
        }

        slideshow_intro = SlideshowIntroductionBlock(
            type=SlideshowIntroductionBlock.get_identifier(),
            title=title,
            cover_image_url=cover_url,
            action=action,
        )
        blocks.append(slideshow_intro)
        # Do NOT append the full slideshow block to content; intro carries it in action
        return blocks

    def _generate_slide_caption(self, index: int, media_type: str, is_circles: bool) -> str:
        return f"{media_type} {index + 1}"

    def _create_content_block(
        self,
        *,
        post_id: str,
        text: str,
        title: str,
        photo_file_ids: List[str],
        video_file_ids: List[str],
        channel_title: str,
        channel_username: str,
        published_at: datetime,
    ) -> Union[PostLargeBlock, PostMediumBlock, PostSmallBlock]:
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
                "article_id": post_id,
            },
        }

        has_media = bool(photo_file_ids or video_file_ids)
        text_length = len(text)

        if text_length > 500 or has_media:
            return PostLargeBlock(
                type=PostLargeBlock.get_identifier(),
                description=(text[:300] + "..." if len(text) > 300 else text),
                **base_params,
            )
        elif text_length > 200:
            return PostMediumBlock(
                type=PostMediumBlock.get_identifier(),
                description=(text[:200] + "..." if len(text) > 200 else text),
                **base_params,
            )
        else:
            return PostSmallBlock(
                type=PostSmallBlock.get_identifier(),
                description=text,
                **base_params,
            )

    def _create_media_blocks(self, photo_file_ids: List[str], video_file_ids: List[str]) -> List[NewsBlock]:
        blocks: List[NewsBlock] = []
        for image_url in photo_file_ids[1:]:
            if image_url:
                blocks.append(ImageBlock(type=ImageBlock.get_identifier(), image_url=image_url))
        for video_url in video_file_ids:
            if video_url:
                blocks.append(VideoBlock(type=VideoBlock.get_identifier(), video_url=video_url))
        return blocks
