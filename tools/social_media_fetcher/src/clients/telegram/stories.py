from dataclasses import dataclass
from datetime import UTC, datetime
from typing import Any, Literal

from telethon.tl.functions.stories import (
    GetPeerStoriesRequest,
    GetStoriesByIDRequest,
)
from telethon.tl.types import MessageMediaDocument, MessageMediaPhoto, StoryItem

from .client import TelegramFetcher

type StoryMediaType = Literal["image", "video"]


@dataclass(frozen=True, slots=True)
class DownloadedStoryMedia:
    data: bytes
    content_type: Literal["image/jpeg", "video/mp4"]
    media_type: StoryMediaType


def normalize_story(story: StoryItem, username: str) -> dict[str, Any]:
    media_type = _media_type(story)
    identifier = f"story:{story.id}"
    media_files = {"photos": [], "videos": []}
    if media_type == "image":
        media_files["photos"].append(identifier)
    elif media_type == "video":
        media_files["videos"].append(identifier)
    return {
        "id": f"story-{story.id}",
        "date": int(_required_date(story.date, "date").timestamp()),
        "text": story.caption or "",
        "url": f"https://t.me/{username}/s/{story.id}",
        "is_story": True,
        "story_id": story.id,
        "expires_at": _required_date(story.expire_date, "expire_date").isoformat(),
        "media_type": media_type,
        "media_files": media_files,
        "metadata": {
            "content_kind": "story",
            "expires_at": story.expire_date.isoformat(),
        },
    }


def _required_date(value: datetime | None, field: str) -> datetime:
    if value is None:
        raise ValueError(f"Telegram story has no {field}")
    return value.replace(tzinfo=UTC) if value.tzinfo is None else value.astimezone(UTC)


def _media_type(story: StoryItem) -> str:
    if isinstance(story.media, MessageMediaPhoto):
        return "image"
    if isinstance(story.media, MessageMediaDocument):
        document = story.media.document
        mime_type = getattr(document, "mime_type", "") or ""
        return "video" if mime_type.startswith("video/") else "document"
    return "unknown"


class TelegramStoriesFetcher(TelegramFetcher):
    def __init__(self, config: Any):
        super().__init__(config)
        self.name = "Telegram Stories Fetcher"
        self.client_type = "telegram_stories"

    async def fetch_raw_data(
        self,
        source_id: str,
        limit: int = 20,
        **_: Any,
    ) -> list[dict[str, Any]]:
        if not self.is_initialized or self.client is None:
            raise RuntimeError("Telegram stories client is not initialized")
        username = source_id.lstrip("@")
        entity = await self.client.get_input_entity(username)
        response = await self.client(GetPeerStoriesRequest(peer=entity))
        stories = response.stories.stories
        now = datetime.now(UTC)
        return [
            normalize_story(story, username)
            for story in stories
            if isinstance(story, StoryItem)
            and _required_date(story.expire_date, "expire_date") > now
            and _media_type(story) in {"image", "video"}
        ][: max(0, limit)]

    async def download_story_media(
        self,
        source_id: str,
        external_id: str,
        *,
        max_byte_size: int,
    ) -> DownloadedStoryMedia | None:
        if not self.is_initialized or self.client is None:
            return None
        story_id = int(external_id.removeprefix("story-"))
        peer = await self.client.get_input_entity(source_id.lstrip("@"))
        response = await self.client(GetStoriesByIDRequest(peer=peer, id=[story_id]))
        story = next(
            (item for item in response.stories if isinstance(item, StoryItem)),
            None,
        )
        media = _downloadable_media(story, max_byte_size=max_byte_size)
        if story is None or media is None:
            return None
        content_type, media_type = media
        data = await self.client.download_media(story.media, file=bytes)
        if not isinstance(data, bytes) or not 0 < len(data) <= max_byte_size:
            return None
        return DownloadedStoryMedia(
            data=data,
            content_type=content_type,
            media_type=media_type,
        )


def _downloadable_media(
    story: StoryItem | None,
    *,
    max_byte_size: int,
) -> tuple[Literal["image/jpeg", "video/mp4"], StoryMediaType] | None:
    if story is None:
        return None
    if isinstance(story.media, MessageMediaPhoto):
        return "image/jpeg", "image"
    if isinstance(story.media, MessageMediaDocument):
        document = story.media.document
        mime_type = getattr(document, "mime_type", None)
        byte_size = getattr(document, "size", None)
        if (
            mime_type == "video/mp4"
            and isinstance(byte_size, int)
            and 0 < byte_size <= max_byte_size
        ):
            return "video/mp4", "video"
    return None
