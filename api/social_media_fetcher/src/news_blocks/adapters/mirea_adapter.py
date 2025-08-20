"""Adapter for converting MIREA official site data to news blocks."""
from datetime import datetime
from typing import Any, Dict, List, Optional
import re

from .base import SocialMediaToNewsBlocksAdapter

from ..models import (
    NewsBlock,
    ArticleIntroductionBlock,
    ImageBlock,
    HtmlBlock,
    TextLeadParagraphBlock,
    SlideshowBlock,
    SlideBlock,
    SlideshowIntroductionBlock,
)


def _normalize_mirea_url(url: Optional[str]) -> Optional[str]:
    if not url:
        return None
    u = url.strip()
    if not u:
        return None
    if u.startswith("//"):
        u = f"https:{u}"
    if u.startswith("https://mirea.ruhttps://"):
        u = u.replace("https://mirea.ru", "", 1)
    if u.startswith("/upload") or u.startswith("/images") or u.startswith("/files"):
        u = f"https://www.mirea.ru{u}"
    return u


class MireaToNewsBlocksAdapter(SocialMediaToNewsBlocksAdapter):
    def get_source_type(self) -> str:
        return "mirea"

    def adapt_post_data(self, raw_data: Dict[str, Any]) -> List[NewsBlock]:
        blocks: List[NewsBlock] = []

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
            category_id=self.get_source_type(),
            author="РТУ МИРЭА",
            published_at=published_at,
            title=title or "РТУ МИРЭА",
            image_url=_normalize_mirea_url(cover_image),
        )
        blocks.append(intro_block)

        if content:
            # Extract first paragraph as a lead and keep remaining HTML to avoid duplication
            lead_text = ""
            remaining_html = content
            try:
                match = re.search(r"<p[\s\S]*?>[\s\S]*?</p>", content, flags=re.IGNORECASE)
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
                        type=TextLeadParagraphBlock.get_identifier(), text=lead_text[:400]
                    )
                )

            if remaining_html:
                blocks.append(
                    HtmlBlock(type=HtmlBlock.get_identifier(), content=remaining_html)
                )

        # Build slideshow if more than one image available
        normalized_cover = _normalize_mirea_url(cover_image)
        normalized_gallery = [
            _normalize_mirea_url(u) for u in images if u and _normalize_mirea_url(u)
        ]
        # Ensure uniqueness and preserve order
        ordered_media: List[str] = []
        for u in ([normalized_cover] if normalized_cover else []) + normalized_gallery:
            if u and u not in ordered_media:
                ordered_media.append(u)

        if len(ordered_media) > 1:
            slides: List[SlideBlock] = []
            for idx, media_url in enumerate(ordered_media):
                slides.append(
                    SlideBlock(
                        type=SlideBlock.get_identifier(),
                        caption=f"Фото {idx + 1}",
                        description="",
                        photo_credit="РТУ МИРЭА",
                        image_url=media_url,
                    )
                )

            slideshow = SlideshowBlock(
                type=SlideshowBlock.get_identifier(), title=title or "РТУ МИРЭА", slides=slides
            )

            slideshow_intro = SlideshowIntroductionBlock(
                type=SlideshowIntroductionBlock.get_identifier(),
                title=title or "РТУ МИРЭА",
                cover_image_url=ordered_media[0],
                action={
                    "type": "__navigate_to_slideshow__",
                    "article_id": str(raw_data.get('ID', '')),
                    "slideshow": slideshow.model_dump(by_alias=True),
                },
            )
            blocks.append(slideshow_intro)
        else:
            # Single extra images (if any) as separate blocks
            for image_url in normalized_gallery:
                if image_url and image_url != normalized_cover:
                    blocks.append(ImageBlock(type=ImageBlock.get_identifier(), image_url=image_url))

        return blocks

