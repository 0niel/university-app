from uuid import UUID

import pytest

from src.clients.telegram import TelegramFetcher
from src.config import Settings
from src.ingest_client import IngestRejectedError, SyncRun
from sync_telegram import (
    _drain_message_source,
    _ingest_observed_batch,
    _message_cursor,
    _sync_sources,
)


def _raw(message_id: int, *, grouped: list[int] | None = None) -> dict[str, object]:
    return {
        "id": message_id,
        "date": 1_782_000_000 + message_id,
        "text": f"Message {message_id}",
        "url": f"https://t.me/news/{message_id}",
        "grouped_message_ids": grouped or [message_id],
    }


class FakeIngest:
    def __init__(self, checkpoint: dict[str, object]) -> None:
        self.checkpoint = checkpoint
        self.finishes: list[tuple[str, dict[str, object] | None]] = []
        self.ingested: list[list[str]] = []
        self._run = 0

    async def start_sync(self, *_: object, **__: object) -> SyncRun:
        self._run += 1
        return SyncRun(
            sync_run_id=UUID(f"10000000-0000-4000-8000-{self._run:012d}"),
            checkpoint=self.checkpoint,
        )

    async def ingest_news(self, _organization: str, _source: object, items, **_):
        self.ingested.append([item.external_id for item in items])

    async def finish_sync(
        self,
        _organization: str,
        _run_id: UUID,
        *,
        status: str,
        checkpoint: dict[str, object] | None = None,
        **_: object,
    ) -> None:
        self.finishes.append((status, checkpoint))
        if status == "succeeded" and checkpoint is not None:
            self.checkpoint = checkpoint

    async def delete_story_media(self, *_: object, **__: object) -> int:
        return 0


class FakeFetcher:
    def __init__(self, messages: list[dict[str, object]]) -> None:
        self.messages = messages
        self.incremental_pages: list[list[int]] = []

    async def fetch_raw_data(
        self,
        _channel: str,
        limit: int,
        **kwargs: object,
    ) -> list[dict[str, object]]:
        if kwargs.get("reverse") is True:
            after = int(kwargs.get("min_id", 0))
            page = [item for item in self.messages if int(item["id"]) > after][:limit]
            self.incremental_pages.append([int(item["id"]) for item in page])
            return page
        return self.messages[-limit:]


async def test_incremental_batches_resume_without_losing_overflow() -> None:
    settings = Settings(
        _env_file=None,
        APP_ORGANIZATION_ID="university",
        TELEGRAM_BATCH_SIZE=2,
        TELEGRAM_BOOTSTRAP_LIMIT=2,
        TELEGRAM_MAX_ITEMS_PER_CYCLE=5,
        TELEGRAM_RECONCILE_MESSAGES=1,
    )
    ingest = FakeIngest(
        {
            "version": 1,
            "cursor_type": "telegram_message_id",
            "last_message_id": 2,
        }
    )
    fetcher = FakeFetcher([_raw(value) for value in range(3, 9)])

    await _drain_message_source(
        settings=settings,
        ingest=ingest,
        fetcher=fetcher,
        channel="news",
    )
    assert fetcher.incremental_pages == [[3, 4], [5, 6], [7]]
    assert ingest.checkpoint["last_message_id"] == 7

    await _drain_message_source(
        settings=settings,
        ingest=ingest,
        fetcher=fetcher,
        channel="news",
    )
    assert fetcher.incremental_pages[-1] == [8]
    assert ingest.checkpoint["last_message_id"] == 8


async def test_fetch_failure_records_failure_without_advancing_checkpoint() -> None:
    class FailingFetcher(FakeFetcher):
        async def fetch_raw_data(self, *_: object, **__: object):
            raise RuntimeError("telegram unavailable")

    checkpoint = {
        "version": 1,
        "cursor_type": "telegram_message_id",
        "last_message_id": 42,
    }
    ingest = FakeIngest(checkpoint)
    settings = Settings(_env_file=None, APP_ORGANIZATION_ID="university")

    with pytest.raises(RuntimeError, match="unavailable"):
        await _drain_message_source(
            settings=settings,
            ingest=ingest,
            fetcher=FailingFetcher([]),
            channel="news",
        )

    assert ingest.checkpoint == checkpoint
    assert ingest.finishes == [("failed", None)]


def test_album_checkpoint_uses_the_highest_message_id() -> None:
    assert _message_cursor(_raw(10, grouped=[10, 11, 12])) == 12


async def test_uninitialized_telegram_client_is_not_an_empty_success() -> None:
    fetcher = TelegramFetcher(Settings(_env_file=None))

    with pytest.raises(RuntimeError, match="not initialized"):
        await fetcher.fetch_raw_data("news")


async def test_lost_finish_response_does_not_delete_committed_story_media() -> None:
    class FinishFailureIngest:
        def __init__(self) -> None:
            self.deleted = False

        async def ingest_news(self, *_: object, **__: object) -> None:
            return None

        async def finish_sync(self, *_: object, **__: object) -> None:
            raise RuntimeError("response lost")

        async def delete_story_media(self, *_: object, **__: object) -> int:
            self.deleted = True
            return 1

    ingest = FinishFailureIngest()
    settings = Settings(_env_file=None, APP_ORGANIZATION_ID="university")
    raw = _raw(42)
    raw["metadata"] = {"media_path": "organizations/university/story.jpg"}

    with pytest.raises(RuntimeError, match="response lost"):
        await _ingest_observed_batch(
            settings=settings,
            ingest=ingest,
            run_id=UUID("10000000-0000-4000-8000-000000000001"),
            source_type="telegram_stories",
            channel="news",
            raw_items=[raw],
            checkpoint={"version": 1, "cursor_type": "snapshot"},
            metadata={},
        )

    assert ingest.deleted is False


async def test_proven_ingest_rejection_rolls_back_uploaded_story_media() -> None:
    class RejectedIngest:
        def __init__(self) -> None:
            self.deleted = False

        async def ingest_news(self, *_: object, **__: object) -> None:
            raise IngestRejectedError("invalid payload")

        async def delete_story_media(self, *_: object, **__: object) -> int:
            self.deleted = True
            return 1

    ingest = RejectedIngest()
    settings = Settings(_env_file=None, APP_ORGANIZATION_ID="university")
    raw = _raw(42)
    raw["metadata"] = {"media_path": "organizations/university/story.jpg"}

    with pytest.raises(IngestRejectedError):
        await _ingest_observed_batch(
            settings=settings,
            ingest=ingest,
            run_id=UUID("10000000-0000-4000-8000-000000000001"),
            source_type="telegram_stories",
            channel="news",
            raw_items=[raw],
            checkpoint={"version": 1, "cursor_type": "snapshot"},
            metadata={},
        )

    assert ingest.deleted is True


async def test_one_failed_channel_does_not_skip_later_channels() -> None:
    class IsolatedFetcher(FakeFetcher):
        def __init__(self) -> None:
            super().__init__([_raw(1)])
            self.channels: list[str] = []

        async def initialize(self) -> None:
            return None

        async def close(self) -> None:
            return None

        async def fetch_raw_data(self, channel: str, *args: object, **kwargs: object):
            self.channels.append(channel)
            if channel == "broken":
                raise RuntimeError("channel unavailable")
            return await super().fetch_raw_data(channel, *args, **kwargs)

    settings = Settings(
        _env_file=None,
        APP_ORGANIZATION_ID="university",
        TELEGRAM_BATCH_SIZE=1,
        TELEGRAM_BOOTSTRAP_LIMIT=1,
        TELEGRAM_MAX_ITEMS_PER_CYCLE=1,
        TELEGRAM_RECONCILE_MESSAGES=1,
    )
    fetcher = IsolatedFetcher()

    with pytest.raises(ExceptionGroup):
        await _sync_sources(
            settings=settings,
            ingest=FakeIngest({}),
            fetcher=fetcher,
            channels=["broken", "healthy"],
        )

    assert "healthy" in fetcher.channels
