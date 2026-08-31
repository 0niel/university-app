import asyncio
import hashlib
from datetime import UTC, datetime
from typing import Any
from uuid import UUID

from loguru import logger

from src.clients.telegram import TelegramFetcher, TelegramStoriesFetcher
from src.config import Settings
from src.ingest_client import (
    IngestClient,
    IngestItem,
    IngestRejectedError,
    IngestSource,
)
from src.news_blocks.adapters.registry import adapter_registry


def _timestamp(raw: dict[str, Any]) -> datetime:
    value = raw.get("date")
    if not isinstance(value, int):
        raise ValueError("Telegram item has no Unix timestamp")
    return datetime.fromtimestamp(value, tz=UTC)


def _item(
    raw: dict[str, Any],
    *,
    source_name: str,
    source_type: str,
) -> IngestItem:
    normalized = {**raw}
    normalized.setdefault("chat", {"username": source_name, "title": source_name})
    if source_type == "telegram_stories":
        normalized["media_files"] = _story_media_files(normalized.get("media_files"))
        normalized["text"] = normalized.get("text") or f"История @{source_name}"
    blocks = adapter_registry.adapt_data(source_type, normalized)
    text = str(normalized.get("text", "")).strip()
    title = text.splitlines()[0][:100] if text else f"Публикация @{source_name}"
    metadata = normalized.get("metadata")
    return IngestItem(
        external_id=str(normalized["id"]),
        title=title,
        summary=text[:500] or None,
        published_at=_timestamp(normalized).isoformat(),
        original_url=str(normalized["url"]),
        news_blocks=[block.model_dump(by_alias=True, mode="json") for block in blocks],
        raw_data=normalized,
        metadata=metadata if isinstance(metadata, dict) else {},
    )


def _story_media_files(value: object) -> dict[str, list[str]]:
    media = value if isinstance(value, dict) else {}
    return {kind: _https_urls(media.get(kind)) for kind in ("photos", "videos")}


def _https_urls(value: object) -> list[str]:
    if not isinstance(value, list):
        return []
    return [url for url in value if isinstance(url, str) and url.startswith("https://")]


async def _prepare_story(
    raw: dict[str, Any],
    *,
    settings: Settings,
    ingest: IngestClient,
    fetcher: TelegramStoriesFetcher,
    channel: str,
) -> dict[str, Any]:
    prepared = {**raw, "media_files": {"photos": [], "videos": []}}
    try:
        media = await fetcher.download_story_media(
            channel,
            str(raw["id"]),
            max_byte_size=settings.MAX_FILE_SIZE_MB * 1024 * 1024,
        )
        if media is None:
            return prepared
        digest = hashlib.sha256(media.data).hexdigest()
        story_id = int(str(raw["id"]).removeprefix("story-"))
        ticket = await ingest.create_story_media_upload(
            organization_id=settings.APP_ORGANIZATION_ID,
            channel=channel,
            story_id=story_id,
            content_type=media.content_type,
            byte_size=len(media.data),
            sha256=digest,
        )
        public_url = await ingest.upload_story_media(
            ticket,
            data=media.data,
            content_type=media.content_type,
        )
        key = "photos" if media.media_type == "image" else "videos"
        media_files = {"photos": [], "videos": []}
        media_files[key] = [public_url]
        prepared["media_files"] = media_files
        prepared["metadata"] = {
            **_metadata(raw),
            "media_bucket": ticket.bucket,
            "media_path": ticket.path,
            "media_sha256": digest,
        }
    except Exception:
        logger.exception("Telegram story media upload failed for @{}", channel)
        raise
    return prepared


def _metadata(raw: dict[str, Any]) -> dict[str, Any]:
    value = raw.get("metadata")
    return value if isinstance(value, dict) else {}


async def _sync_sources(
    *,
    settings: Settings,
    ingest: IngestClient,
    fetcher: TelegramFetcher,
    channels: list[str],
) -> None:
    if not channels:
        return
    await fetcher.initialize()
    failures: list[Exception] = []
    try:
        for channel in channels:
            try:
                if isinstance(fetcher, TelegramStoriesFetcher):
                    await _sync_story_snapshot(
                        settings=settings,
                        ingest=ingest,
                        fetcher=fetcher,
                        channel=channel,
                    )
                else:
                    await _drain_message_source(
                        settings=settings,
                        ingest=ingest,
                        fetcher=fetcher,
                        channel=channel,
                    )
            except Exception as error:
                failures.append(error)
                logger.exception("Telegram synchronization failed for @{}", channel)
    finally:
        await fetcher.close()
    if failures:
        raise ExceptionGroup("Telegram source synchronization failed", failures)


async def _drain_message_source(
    *,
    settings: Settings,
    ingest: IngestClient,
    fetcher: TelegramFetcher,
    channel: str,
) -> None:
    processed = 0
    while processed < settings.TELEGRAM_MAX_ITEMS_PER_CYCLE:
        run = await ingest.start_sync(
            settings.APP_ORGANIZATION_ID,
            source=f"telegram:{channel}",
            source_type="telegram",
            metadata={"channel": channel},
        )
        try:
            after_id = _message_checkpoint(run.checkpoint)
            bootstrap = after_id is None
            limit = min(
                settings.TELEGRAM_BOOTSTRAP_LIMIT
                if bootstrap
                else settings.TELEGRAM_BATCH_SIZE,
                settings.TELEGRAM_MAX_ITEMS_PER_CYCLE - processed,
            )
            raw_items = await _fetch_message_batch(
                fetcher,
                channel,
                limit=limit,
                after_id=after_id,
            )
            next_id = max(
                (_message_cursor(item) for item in raw_items),
                default=after_id or 0,
            )
            checkpoint = {
                "version": 1,
                "cursor_type": "telegram_message_id",
                "last_message_id": next_id,
            }
            await _ingest_observed_batch(
                settings=settings,
                ingest=ingest,
                run_id=run.sync_run_id,
                source_type="telegram",
                channel=channel,
                raw_items=raw_items,
                checkpoint=checkpoint,
                metadata={"mode": "bootstrap" if bootstrap else "incremental"},
            )
        except Exception as error:
            await _record_sync_failure(
                settings,
                ingest,
                run.sync_run_id,
                channel=channel,
                error=error,
            )
            raise
        processed += len(raw_items)
        if bootstrap or len(raw_items) < limit:
            break

    await _reconcile_messages(
        settings=settings,
        ingest=ingest,
        fetcher=fetcher,
        channel=channel,
    )


async def _fetch_message_batch(
    fetcher: TelegramFetcher,
    channel: str,
    *,
    limit: int,
    after_id: int | None,
) -> list[dict[str, Any]]:
    items = await fetcher.fetch_raw_data(
        channel,
        limit,
        min_id=after_id or 0,
        reverse=after_id is not None,
    )
    return sorted(items, key=_message_cursor)


async def _reconcile_messages(
    *,
    settings: Settings,
    ingest: IngestClient,
    fetcher: TelegramFetcher,
    channel: str,
) -> None:
    run = await ingest.start_sync(
        settings.APP_ORGANIZATION_ID,
        source=f"telegram:{channel}",
        source_type="telegram",
        metadata={"channel": channel, "mode": "reconcile"},
    )
    try:
        raw_items = await fetcher.fetch_raw_data(
            channel,
            settings.TELEGRAM_RECONCILE_MESSAGES,
        )
        await _ingest_observed_batch(
            settings=settings,
            ingest=ingest,
            run_id=run.sync_run_id,
            source_type="telegram",
            channel=channel,
            raw_items=raw_items,
            checkpoint=run.checkpoint,
            metadata={"mode": "reconcile"},
        )
    except Exception as error:
        await _record_sync_failure(
            settings,
            ingest,
            run.sync_run_id,
            channel=channel,
            error=error,
        )
        raise


async def _sync_story_snapshot(
    *,
    settings: Settings,
    ingest: IngestClient,
    fetcher: TelegramStoriesFetcher,
    channel: str,
) -> None:
    run = await ingest.start_sync(
        settings.APP_ORGANIZATION_ID,
        source=f"telegram_stories:{channel}",
        source_type="telegram_stories",
        metadata={"channel": channel, "mode": "snapshot"},
    )
    try:
        raw_items = await fetcher.fetch_raw_data(
            channel,
            settings.MAX_MESSAGES_PER_REQUEST,
        )
        prepared = [
            await _prepare_story(
                item,
                settings=settings,
                ingest=ingest,
                fetcher=fetcher,
                channel=channel,
            )
            for item in raw_items
        ]
        last_story_id = max((_story_cursor(item) for item in raw_items), default=0)
        await _ingest_observed_batch(
            settings=settings,
            ingest=ingest,
            run_id=run.sync_run_id,
            source_type="telegram_stories",
            channel=channel,
            raw_items=prepared,
            checkpoint={
                "version": 1,
                "cursor_type": "telegram_story_snapshot",
                "last_story_id": last_story_id,
            },
            metadata={"mode": "snapshot"},
        )
    except Exception as error:
        await _record_sync_failure(
            settings,
            ingest,
            run.sync_run_id,
            channel=channel,
            error=error,
        )
        raise


async def _ingest_observed_batch(
    *,
    settings: Settings,
    ingest: IngestClient,
    run_id: UUID,
    source_type: str,
    channel: str,
    raw_items: list[dict[str, Any]],
    checkpoint: dict[str, Any],
    metadata: dict[str, Any],
) -> None:
    try:
        await ingest.ingest_news(
            settings.APP_ORGANIZATION_ID,
            _source(channel, source_type),
            [
                _item(item, source_name=channel, source_type=source_type)
                for item in raw_items
            ],
            sync_run_id=run_id,
        )
    except IngestRejectedError:
        await _rollback_story_media(settings, ingest, raw_items, channel)
        raise
    await ingest.finish_sync(
        settings.APP_ORGANIZATION_ID,
        run_id,
        status="succeeded",
        checkpoint=checkpoint,
        metadata=metadata,
    )


async def _record_sync_failure(
    settings: Settings,
    ingest: IngestClient,
    run_id: UUID,
    *,
    channel: str,
    error: Exception,
    metadata: dict[str, Any] | None = None,
) -> None:
    try:
        await ingest.finish_sync(
            settings.APP_ORGANIZATION_ID,
            run_id,
            status="failed",
            error_message=str(error),
            metadata=metadata or {"channel": channel},
        )
    except Exception:
        logger.exception("Failed to record Telegram sync failure for @{}", channel)


async def _rollback_story_media(
    settings: Settings,
    ingest: IngestClient,
    raw_items: list[dict[str, Any]],
    channel: str,
) -> None:
    paths = [
        path
        for item in raw_items
        if isinstance(item.get("metadata"), dict)
        and isinstance(path := item["metadata"].get("media_path"), str)
    ]
    if not paths:
        return
    try:
        await ingest.delete_story_media(settings.APP_ORGANIZATION_ID, paths)
    except Exception:
        logger.exception("Telegram story media rollback failed for @{}", channel)


def _source(channel: str, source_type: str) -> IngestSource:
    return IngestSource(
        source_type=source_type,
        source_external_id=channel,
        source_name=f"@{channel}",
        source_url=f"https://t.me/{channel}",
        category="telegram",
    )


def _message_checkpoint(checkpoint: dict[str, Any]) -> int | None:
    if not checkpoint:
        return None
    if checkpoint.get("version") != 1 or checkpoint.get("cursor_type") != (
        "telegram_message_id"
    ):
        raise ValueError("Unsupported Telegram checkpoint")
    value = checkpoint.get("last_message_id")
    if not isinstance(value, int) or value < 0:
        raise ValueError("Invalid Telegram message checkpoint")
    return value


def _message_cursor(item: dict[str, Any]) -> int:
    grouped = item.get("grouped_message_ids")
    ids = grouped if isinstance(grouped, list) else [item.get("id")]
    valid_ids = [value for value in ids if isinstance(value, int) and value > 0]
    if not valid_ids:
        raise ValueError("Telegram item has no message cursor")
    return max(valid_ids)


def _story_cursor(item: dict[str, Any]) -> int:
    value = item.get("story_id")
    if not isinstance(value, int) or value <= 0:
        raise ValueError("Telegram story has no numeric cursor")
    return value


async def sync() -> None:
    settings = Settings()
    if not settings.ingest_configured:
        raise RuntimeError("SUPABASE_URL and SUPABASE_INGEST_KEY are required")
    if not settings.telegram_configured:
        return
    ingest = IngestClient(
        settings.SUPABASE_URL or "",
        settings.SUPABASE_INGEST_KEY or "",
    )
    try:
        results = await asyncio.gather(
            _sync_sources(
                settings=settings,
                ingest=ingest,
                fetcher=TelegramFetcher(settings),
                channels=settings.telegram_channels,
            ),
            _sync_sources(
                settings=settings,
                ingest=ingest,
                fetcher=TelegramStoriesFetcher(settings),
                channels=settings.telegram_story_channels,
            ),
            return_exceptions=True,
        )
        failures = [result for result in results if isinstance(result, Exception)]
        try:
            await ingest.cleanup_story_media(settings.APP_ORGANIZATION_ID)
        except Exception:
            logger.warning("Expired Telegram story media cleanup failed")
        if failures:
            raise ExceptionGroup("Telegram synchronization failed", failures)
    finally:
        await ingest.close()


if __name__ == "__main__":
    asyncio.run(sync())
