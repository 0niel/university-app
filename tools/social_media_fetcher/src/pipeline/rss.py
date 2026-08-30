import re
from calendar import timegm
from datetime import UTC, datetime
from hashlib import sha256
from typing import Any

import feedparser
import httpx
from bs4 import BeautifulSoup

from .models import ContentSource, NormalizedContent


class RssProvider:
    def __init__(self, client: httpx.AsyncClient | None = None) -> None:
        self._client = client or httpx.AsyncClient(timeout=30, follow_redirects=True)
        self._owns_client = client is None

    async def close(self) -> None:
        if self._owns_client:
            await self._client.aclose()

    async def fetch(self, source: ContentSource) -> list[NormalizedContent]:
        if source.feed_url is None:
            raise ValueError(f"RSS source '{source.id}' requires feed_url")
        response = await self._client.get(str(source.feed_url))
        response.raise_for_status()
        parsed = feedparser.parse(response.content)
        if parsed.bozo and not parsed.entries:
            raise ValueError(f"RSS source '{source.id}' returned an invalid feed")
        return [self._entry(source, entry) for entry in parsed.entries]

    def _entry(self, source: ContentSource, entry: Any) -> NormalizedContent:
        link = _string(entry, "link")
        title = _text(_string(entry, "title"))
        if not link or not title:
            raise ValueError(
                f"RSS source '{source.id}' has an entry without title or URL"
            )
        published_at = _published_at(entry)
        summary_html = _string(entry, "summary") or _string(entry, "description")
        content_html = _content_html(entry) or summary_html
        external_id = _string(entry, "id") or sha256(link.encode()).hexdigest()
        return NormalizedContent(
            external_id=external_id,
            title=title,
            published_at=published_at,
            original_url=link,
            summary=_text(summary_html) or None,
            html=content_html or None,
            raw_data={"id": external_id, "link": link, "title": title},
        )


def _string(entry: Any, key: str) -> str:
    value = entry.get(key, "")
    return value.strip() if isinstance(value, str) else ""


def _content_html(entry: Any) -> str:
    value = entry.get("content", [])
    if not isinstance(value, list) or not value:
        return ""
    first = value[0]
    return first.get("value", "").strip() if isinstance(first, dict) else ""


def _text(value: str) -> str:
    text = BeautifulSoup(value, "html.parser").get_text(" ", strip=True)
    return re.sub(r"\s+([,.;:!?])", r"\1", text)


def _published_at(entry: Any) -> datetime:
    parsed = entry.get("published_parsed") or entry.get("updated_parsed")
    if parsed is None:
        return datetime.now(UTC)
    return datetime.fromtimestamp(timegm(parsed), tz=UTC)
