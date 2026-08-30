from datetime import UTC, datetime
from hashlib import sha256
from typing import Any

import httpx

from .models import ContentSource, JsonFeedMapping, NormalizedContent


class JsonFeedProvider:
    def __init__(self, client: httpx.AsyncClient | None = None) -> None:
        self._client = client or httpx.AsyncClient(timeout=30, follow_redirects=True)
        self._owns_client = client is None

    async def close(self) -> None:
        if self._owns_client:
            await self._client.aclose()

    async def fetch(self, source: ContentSource) -> list[NormalizedContent]:
        if source.feed_url is None:
            raise ValueError(f"JSON source '{source.id}' requires feed_url")
        mapping = JsonFeedMapping.model_validate(source.metadata)
        response = await self._client.get(str(source.feed_url))
        response.raise_for_status()
        payload = response.json()
        items = _items_at_path(payload, mapping.items_path, source.id)
        return [self._item(source, mapping, value) for value in items]

    def _item(
        self,
        source: ContentSource,
        mapping: JsonFeedMapping,
        value: dict[str, Any],
    ) -> NormalizedContent:
        title = _required_text(value, mapping.title_path, source.id)
        url = _required_text(value, mapping.url_path, source.id)
        external_id = (
            _text_at_path(value, mapping.id_path) or sha256(url.encode()).hexdigest()
        )
        return NormalizedContent(
            external_id=external_id,
            title=title,
            published_at=_published_at(value, mapping.published_at_path),
            original_url=url,
            summary=_text_at_path(value, mapping.summary_path) or None,
            html=_text_at_path(value, mapping.html_path) or None,
            raw_data=value,
        )


def _items_at_path(value: object, path: str, source_id: str) -> list[dict[str, Any]]:
    items = _at_path(value, path)
    if not isinstance(items, list) or not all(isinstance(item, dict) for item in items):
        raise ValueError(
            f"JSON source '{source_id}' items_path must resolve to objects"
        )
    return items


def _required_text(value: dict[str, Any], path: str, source_id: str) -> str:
    result = _text_at_path(value, path)
    if not result:
        raise ValueError(f"JSON source '{source_id}' item has no value at '{path}'")
    return result


def _text_at_path(value: object, path: str | None) -> str:
    if path is None:
        return ""
    result = _at_path(value, path)
    return result.strip() if isinstance(result, str) else str(result) if result else ""


def _at_path(value: object, path: str) -> object:
    current = value
    for key in path.split("."):
        if not key or not isinstance(current, dict):
            return None
        current = current.get(key)
    return current


def _published_at(value: dict[str, Any], path: str | None) -> datetime:
    timestamp = _at_path(value, path) if path else None
    if isinstance(timestamp, (int, float)):
        return datetime.fromtimestamp(timestamp, tz=UTC)
    if isinstance(timestamp, str) and timestamp.strip():
        normalized = timestamp.strip().replace("Z", "+00:00")
        try:
            parsed = datetime.fromisoformat(normalized)
        except ValueError as error:
            raise ValueError(
                f"Invalid JSON feed publication date '{timestamp}'"
            ) from error
        return (
            parsed.replace(tzinfo=UTC)
            if parsed.tzinfo is None
            else parsed.astimezone(UTC)
        )
    return datetime.now(UTC)
