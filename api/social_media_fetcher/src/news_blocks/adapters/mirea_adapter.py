"""Adapter for converting MIREA official site data to news blocks."""
from datetime import datetime
from typing import Any, Dict, List, Optional

from .base import SocialMediaToNewsBlocksAdapter

from ..models import (
    NewsBlock,
    ArticleIntroductionBlock,
    ImageBlock,
    HtmlBlock,
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

        title = raw_data.get("NAME", "Новость от МИРЭА")
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
            title=title,
            image_url=_normalize_mirea_url(cover_image),
        )
        blocks.append(intro_block)

        if content:
            blocks.append(HtmlBlock(type=HtmlBlock.get_identifier(), content=content))

        for image_url in images:
            if image_url and image_url != cover_image:
                blocks.append(
                    ImageBlock(type=ImageBlock.get_identifier(), image_url=_normalize_mirea_url(image_url) or "")
                )

        return blocks
