from collections.abc import Callable
from typing import Any, Protocol

from loguru import logger

from src.config import Settings
from src.ingest_client import IngestClient, IngestItem, IngestSource
from src.news_blocks.models import ArticleIntroductionBlock, HtmlBlock

from .json_feed import JsonFeedProvider
from .models import ContentSource, NormalizedContent
from .rss import RssProvider


class ContentProvider(Protocol):
    async def close(self) -> None: ...

    async def fetch(self, source: ContentSource) -> list[NormalizedContent]: ...


ProviderFactory = Callable[[], ContentProvider]
_PROVIDERS: dict[str, ProviderFactory] = {
    "json": JsonFeedProvider,
    "rss": RssProvider,
}


async def sync_sources(settings: Settings) -> None:
    sources = [
        ContentSource.model_validate(value) for value in settings.content_sources
    ]
    if not sources:
        return
    if not settings.ingest_configured:
        raise RuntimeError("SUPABASE_URL and SUPABASE_INGEST_KEY are required")
    ingest = IngestClient(
        settings.SUPABASE_URL or "", settings.SUPABASE_INGEST_KEY or ""
    )
    failures: list[Exception] = []
    try:
        for source in sources:
            try:
                await _sync_source(settings, ingest, source)
            except Exception as error:
                failures.append(error)
                logger.exception("Content synchronization failed for {}", source.id)
    finally:
        await ingest.close()
    if failures:
        raise ExceptionGroup("Content source synchronization failed", failures)


async def _sync_source(
    settings: Settings,
    ingest: IngestClient,
    source: ContentSource,
) -> None:
    factory = _PROVIDERS.get(source.provider)
    if factory is None:
        raise ValueError(f"Unknown content provider '{source.provider}'")
    provider = factory()
    run = await ingest.start_sync(
        settings.APP_ORGANIZATION_ID,
        source=f"{source.provider}:{source.id}",
        source_type=source.provider,
        metadata={"source_id": source.id},
    )
    try:
        items = await provider.fetch(source)
        await ingest.ingest_news(
            settings.APP_ORGANIZATION_ID,
            _ingest_source(source),
            [_ingest_item(item, source) for item in items],
            sync_run_id=run.sync_run_id,
        )
        await ingest.finish_sync(
            settings.APP_ORGANIZATION_ID,
            run.sync_run_id,
            status="succeeded",
            checkpoint={
                "version": 1,
                "last_item_id": items[0].external_id if items else None,
            },
            metadata={"items": len(items), "source_id": source.id},
        )
    except Exception as error:
        await ingest.finish_sync(
            settings.APP_ORGANIZATION_ID,
            run.sync_run_id,
            status="failed",
            error_message=str(error),
            metadata={"source_id": source.id},
        )
        raise
    finally:
        await provider.close()


def _ingest_source(source: ContentSource) -> IngestSource:
    return IngestSource(
        source_type=source.provider,
        source_external_id=source.id,
        source_name=source.name,
        source_url=source.source_url,
        category=source.category,
        metadata=source.metadata,
    )


def _ingest_item(item: NormalizedContent, source: ContentSource) -> IngestItem:
    blocks: list[dict[str, Any]] = [
        ArticleIntroductionBlock(
            type=ArticleIntroductionBlock.IDENTIFIER,
            category_id=source.category,
            author=source.name,
            published_at=item.published_at,
            title=item.title,
        ).model_dump(by_alias=True, mode="json"),
    ]
    if item.html:
        blocks.append(
            HtmlBlock(
                type=HtmlBlock.IDENTIFIER,
                content=item.html,
            ).model_dump(by_alias=True, mode="json")
        )
    return IngestItem(
        external_id=item.external_id,
        title=item.title,
        summary=item.summary,
        published_at=item.published_at.isoformat(),
        original_url=item.original_url,
        news_blocks=blocks,
        raw_data=item.raw_data,
        metadata=item.metadata,
    )
