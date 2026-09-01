from uuid import UUID

import pytest

from src.config import Settings
from src.ingest_client import SyncRun
from sync_official_news import _sync_source


def _settings() -> Settings:
    return Settings(
        _env_file=None,
        APP_ORGANIZATION_ID="university",
        OFFICIAL_NEWS_ENABLED=True,
        OFFICIAL_NEWS_URL="https://university.example/news/",
        OFFICIAL_NEWS_SOURCE_ID="official-news",
        OFFICIAL_NEWS_SOURCE_NAME="Example University",
    )


class FakeIngest:
    def __init__(self) -> None:
        self.started: dict[str, object] | None = None
        self.items: list[object] | None = None
        self.finish_calls: list[dict[str, object]] = []

    async def start_sync(self, _organization: str, **kwargs: object) -> SyncRun:
        self.started = kwargs
        return SyncRun(
            sync_run_id=UUID("10000000-0000-4000-8000-000000000001"),
        )

    async def ingest_news(
        self,
        _organization: str,
        _source: object,
        items: list[object],
        **_: object,
    ) -> None:
        self.items = items

    async def finish_sync(
        self,
        _organization: str,
        _sync_run_id: UUID,
        **kwargs: object,
    ) -> None:
        self.finish_calls.append(kwargs)


class FakeProvider:
    async def initialize(self) -> None:
        return None

    async def fetch_raw_data(self, *_: object) -> list[dict[str, object]]:
        return [
            {
                "ID": "welcome",
                "NAME": "Welcome",
                "DATE_ACTIVE_FROM": "10.07.2026 00:00:00",
                "url": "https://university.example/news/welcome/",
                "DETAIL_TEXT": "<p>News</p>",
                "DETAIL_PICTURE": "",
                "PROPERTY_MY_GALLERY_VALUE": [],
            }
        ]


async def test_official_news_sync_uses_checkpointed_ingest_contract() -> None:
    ingest = FakeIngest()

    await _sync_source(_settings(), ingest, FakeProvider())

    assert ingest.started == {
        "source": "website:official-news",
        "source_type": "website",
        "metadata": {"source_id": "official-news"},
    }
    assert ingest.items is not None
    assert ingest.finish_calls == [
            {
                "source": "website:official-news",
                "source_type": "website",
                "status": "succeeded",
            "checkpoint": {
                "version": 1,
                "cursor_type": "website_snapshot",
                "last_external_id": "welcome",
            },
            "metadata": {"items": 1, "source_id": "official-news"},
        }
    ]


async def test_official_news_sync_records_fetch_failure() -> None:
    class FailingProvider(FakeProvider):
        async def fetch_raw_data(self, *_: object) -> list[dict[str, object]]:
            raise RuntimeError("website unavailable")

    ingest = FakeIngest()

    with pytest.raises(RuntimeError, match="website unavailable"):
        await _sync_source(_settings(), ingest, FailingProvider())

    assert ingest.items is None
    assert ingest.finish_calls == [
            {
                "source": "website:official-news",
                "source_type": "website",
                "status": "failed",
            "error_message": "website unavailable",
            "metadata": {"source_id": "official-news"},
        }
    ]
