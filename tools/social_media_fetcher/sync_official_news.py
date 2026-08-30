import asyncio
from collections.abc import Awaitable
from datetime import datetime
from typing import Any, Protocol
from uuid import UUID

from loguru import logger

from src.clients.official_news.client import OfficialNewsFetcher
from src.config import OfficialNewsSource, Settings
from src.ingest_client import IngestClient, IngestItem, IngestSource
from src.news_blocks.adapters.official_news_adapter import (
    OfficialNewsToNewsBlocksAdapter,
)


class OfficialNewsProvider(Protocol):
    def initialize(self) -> Awaitable[None]: ...

    def fetch_raw_data(
        self,
        source_id: str,
        limit: int,
    ) -> Awaitable[list[dict[str, Any]]]: ...


def _ingest_item(raw: dict[str, Any], *, source: OfficialNewsSource) -> IngestItem:
    blocks = OfficialNewsToNewsBlocksAdapter(
        source_name=source.name,
        source_url=source.url,
        category_id=source.category,
    ).adapt_post_data(raw)
    published_at = datetime.strptime(
        str(raw["DATE_ACTIVE_FROM"]),
        "%d.%m.%Y %H:%M:%S",
    )
    return IngestItem(
        external_id=str(raw["ID"]),
        title=str(raw["NAME"]),
        published_at=published_at.isoformat(),
        original_url=str(raw["url"]),
        news_blocks=[block.model_dump(by_alias=True, mode="json") for block in blocks],
        raw_data=raw,
    )


async def sync() -> None:
    settings = Settings()
    if not settings.official_news_enabled:
        return
    if not settings.ingest_configured:
        raise RuntimeError("SUPABASE_URL and SUPABASE_INGEST_KEY are required")

    source_config = settings.official_news_source
    provider = OfficialNewsFetcher(settings, source_config)
    ingest = IngestClient(
        settings.SUPABASE_URL or "", settings.SUPABASE_INGEST_KEY or ""
    )
    try:
        await _sync_source(settings, ingest, provider)
    finally:
        await provider.close()
        await ingest.close()


async def _sync_source(
    settings: Settings,
    ingest: IngestClient,
    provider: OfficialNewsProvider,
) -> None:
    source_config = settings.official_news_source
    run = await ingest.start_sync(
        settings.APP_ORGANIZATION_ID,
        source=f"website:{source_config.external_id}",
        source_type="website",
        metadata={"source_id": source_config.external_id},
    )
    try:
        await provider.initialize()
        raw_items = await provider.fetch_raw_data(
            source_config.external_id,
            settings.MAX_POSTS_PER_REQUEST,
        )
        items = [_ingest_item(item, source=source_config) for item in raw_items]
        await ingest.ingest_news(
            settings.APP_ORGANIZATION_ID,
            _source(settings),
            items,
            sync_run_id=run.sync_run_id,
        )
        await ingest.finish_sync(
            settings.APP_ORGANIZATION_ID,
            run.sync_run_id,
            status="succeeded",
            checkpoint={
                "version": 1,
                "cursor_type": "website_snapshot",
                "last_external_id": items[0].external_id if items else None,
            },
            metadata={
                "items": len(items),
                "source_id": source_config.external_id,
            },
        )
    except Exception as error:
        await _record_sync_failure(
            settings,
            ingest,
            run.sync_run_id,
            source_id=source_config.external_id,
            error=error,
        )
        raise


def _source(settings: Settings) -> IngestSource:
    source_config = settings.official_news_source
    return IngestSource(
        source_type="website",
        source_external_id=source_config.external_id,
        source_name=source_config.name,
        source_url=source_config.url,
        category=source_config.category,
    )


async def _record_sync_failure(
    settings: Settings,
    ingest: IngestClient,
    sync_run_id: UUID,
    *,
    source_id: str,
    error: Exception,
) -> None:
    try:
        await ingest.finish_sync(
            settings.APP_ORGANIZATION_ID,
            sync_run_id,
            status="failed",
            error_message=str(error),
            metadata={"source_id": source_id},
        )
    except Exception:
        logger.exception("Failed to record official news synchronization failure")


if __name__ == "__main__":
    asyncio.run(sync())
