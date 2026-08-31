import re
from datetime import datetime
from typing import Any
from urllib.parse import urljoin

from ..models import (
    ArticleIntroductionBlock,
    HtmlBlock,
    ImageBlock,
    NewsBlock,
    SlideBlock,
    SlideshowBlock,
    SlideshowIntroductionBlock,
    TextLeadParagraphBlock,
)
from .base import SocialMediaToNewsBlocksAdapter


def _normalize_media_url(url: str | None, *, source_url: str) -> str | None:
    if not url:
        return None
    value = url.strip()
    if not value:
        return None
    if value.count("https://") > 1:
        value = value[value.rfind("https://") :]
    return urljoin(source_url, value)


class OfficialNewsToNewsBlocksAdapter(SocialMediaToNewsBlocksAdapter):
    def __init__(
        self,
        *,
        source_name: str,
        source_url: str,
        category_id: str = "website",
    ) -> None:
        self._source_name = source_name
        self._source_url = source_url
        self._category_id = category_id

    def get_source_type(self) -> str:
        return "website"

    def adapt_post_data(self, raw_data: dict[str, Any]) -> list[NewsBlock]:
        blocks: list[NewsBlock] = []

        title = raw_data.get("NAME", "")
        content = raw_data.get("DETAIL_TEXT", "")
        date_str = raw_data.get("DATE_ACTIVE_FROM", "")
        images = raw_data.get("PROPERTY_MY_GALLERY_VALUE", [])
        cover_image = raw_data.get("DETAIL_PICTURE", "")

        try:
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

        intro_block = ArticleIntroductionBlock(
            type=ArticleIntroductionBlock.get_identifier(),
            category_id=self._category_id,
            author=self._source_name,
            published_at=published_at,
            title=title or self._source_name,
            image_url=_normalize_media_url(cover_image, source_url=self._source_url),
        )
        blocks.append(intro_block)

        if content:
            # Extract first paragraph as a lead and keep remaining HTML to avoid duplication
            lead_text = ""
            remaining_html = content
            try:
                match = re.search(
                    r"<p[\s\S]*?>[\s\S]*?</p>", content, flags=re.IGNORECASE
                )
                if match:
                    first_p_html = match.group(0)
                    # Strip HTML tags for lead
                    lead_text = re.sub(r"<[^>]+>", "", first_p_html).strip()
                    # Remove the first paragraph from HTML content
                    remaining_html = content.replace(first_p_html, "", 1).strip()
            except Exception:
                pass

            if lead_text:
                blocks.append(
                    TextLeadParagraphBlock(
                        type=TextLeadParagraphBlock.get_identifier(),
                        text=lead_text[:400],
                    )
                )

            if remaining_html:
                blocks.append(
                    HtmlBlock(type=HtmlBlock.get_identifier(), content=remaining_html)
                )

        # Build slideshow if more than one image available
        normalized_cover = _normalize_media_url(
            cover_image,
            source_url=self._source_url,
        )
        normalized_gallery = [
            normalized
            for image in images
            if (normalized := _normalize_media_url(image, source_url=self._source_url))
        ]
        # Ensure uniqueness and preserve order
        ordered_media: list[str] = []
        for u in ([normalized_cover] if normalized_cover else []) + normalized_gallery:
            if u and u not in ordered_media:
                ordered_media.append(u)

        if len(ordered_media) > 1:
            slides: list[SlideBlock] = []
            for idx, media_url in enumerate(ordered_media):
                slides.append(
                    SlideBlock(
                        type=SlideBlock.get_identifier(),
                        caption=f"Фото {idx + 1}",
                        description="",
                        photo_credit=self._source_name,
                        image_url=media_url,
                    )
                )

            slideshow = SlideshowBlock(
                type=SlideshowBlock.get_identifier(),
                title=title or self._source_name,
                slides=slides,
            )

            slideshow_intro = SlideshowIntroductionBlock(
                type=SlideshowIntroductionBlock.get_identifier(),
                title=title or self._source_name,
                cover_image_url=ordered_media[0],
                action={
                    "type": "__navigate_to_slideshow__",
                    "article_id": str(raw_data.get("ID", "")),
                    "slideshow": slideshow.model_dump(by_alias=True),
                },
            )
            blocks.append(slideshow_intro)
        else:
            # Single extra images (if any) as separate blocks
            for image_url in normalized_gallery:
                if image_url and image_url != normalized_cover:
                    blocks.append(
                        ImageBlock(
                            type=ImageBlock.get_identifier(), image_url=image_url
                        )
                    )

        return blocks
