from datetime import UTC, datetime
from typing import Any

import pytest
from telethon.tl.types import MessageMediaPhoto, PhotoEmpty, StoryItem

from src.clients.telegram.stories import DownloadedStoryMedia, normalize_story
from src.config import Settings
from src.ingest_client import StoryMediaUploadTicket
from sync_telegram import _item, _prepare_story


def test_normalize_story_keeps_expiry_and_real_story_identity() -> None:
    published_at = datetime(2026, 7, 10, 10, tzinfo=UTC)
    expires_at = datetime(2026, 7, 11, 10, tzinfo=UTC)
    story = StoryItem(
        id=42,
        date=published_at,
        expire_date=expires_at,
        media=MessageMediaPhoto(photo=PhotoEmpty(id=7)),
        caption="Story caption",
    )

    raw = normalize_story(story, "university")

    assert raw["id"] == "story-42"
    assert raw["is_story"] is True
    assert raw["expires_at"] == "2026-07-11T10:00:00+00:00"
    assert raw["media_files"]["photos"] == ["story:42"]
    assert raw["media_files"]["videos"] == []
    assert raw["url"] == "https://t.me/university/s/42"


def test_story_ingest_item_keeps_expiry_without_broken_media_urls() -> None:
    raw = {
        "id": "story-42",
        "date": 1_782_000_000,
        "text": "",
        "url": "https://t.me/university/s/42",
        "media_files": {"photos": ["story:42"], "videos": []},
        "metadata": {
            "content_kind": "story",
            "expires_at": "2026-07-11T10:00:00+00:00",
        },
    }

    item = _item(
        raw,
        source_name="university",
        source_type="telegram_stories",
    )

    assert item.title == "История @university"
    assert item.metadata["expires_at"] == "2026-07-11T10:00:00+00:00"
    assert all("story:42" not in str(block) for block in item.news_blocks)


async def test_uploaded_story_media_reaches_news_blocks() -> None:
    class Fetcher:
        async def download_story_media(
            self, *_: Any, **__: Any
        ) -> DownloadedStoryMedia:
            return DownloadedStoryMedia(
                data=b"jpeg",
                content_type="image/jpeg",
                media_type="image",
            )

    class Ingest:
        async def create_story_media_upload(self, **_: Any) -> StoryMediaUploadTicket:
            return StoryMediaUploadTicket(
                signed_url=(
                    "https://project.supabase.co/storage/v1/object/upload/sign/"
                    "story-media/story.jpg?token=signed"
                ),
                public_url=(
                    "https://project.supabase.co/storage/v1/object/public/"
                    "story-media/story.jpg"
                ),
                bucket="story-media",
                path="story.jpg",
            )

        async def upload_story_media(self, *_: Any, **__: Any) -> str:
            return (
                "https://project.supabase.co/storage/v1/object/public/"
                "story-media/story.jpg"
            )

    raw = {
        "id": "story-42",
        "date": 1_782_000_000,
        "text": "Campus story",
        "url": "https://t.me/university/s/42",
        "media_files": {"photos": ["story:42"], "videos": []},
        "metadata": {"content_kind": "story"},
    }
    prepared = await _prepare_story(
        raw,
        settings=Settings(_env_file=None, APP_ORGANIZATION_ID="university"),
        ingest=Ingest(),
        fetcher=Fetcher(),
        channel="university",
    )
    item = _item(
        prepared,
        source_name="university",
        source_type="telegram_stories",
    )

    assert "story.jpg" in str(item.news_blocks)
    assert item.metadata["media_bucket"] == "story-media"
    assert item.metadata["media_sha256"]


async def test_story_media_failure_fails_the_snapshot_for_a_safe_retry() -> None:
    class Fetcher:
        async def download_story_media(self, *_: Any, **__: Any) -> None:
            raise RuntimeError("storage unavailable")

    raw = {
        "id": "story-42",
        "date": 1_782_000_000,
        "text": "Campus story",
        "url": "https://t.me/university/s/42",
        "media_files": {"photos": ["story:42"], "videos": []},
    }

    with pytest.raises(RuntimeError, match="storage unavailable"):
        await _prepare_story(
            raw,
            settings=Settings(_env_file=None, APP_ORGANIZATION_ID="university"),
            ingest=object(),
            fetcher=Fetcher(),
            channel="university",
        )


async def test_missing_story_media_does_not_publish_an_empty_story() -> None:
    class Fetcher:
        async def download_story_media(self, *_: Any, **__: Any) -> None:
            return None

    with pytest.raises(ValueError, match="media is unavailable"):
        await _prepare_story(
            {"id": "story-42"},
            settings=Settings(_env_file=None, APP_ORGANIZATION_ID="university"),
            ingest=object(),
            fetcher=Fetcher(),
            channel="university",
        )
