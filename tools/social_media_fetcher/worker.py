import asyncio
from collections.abc import Awaitable, Callable, Sequence
from dataclasses import dataclass
from pathlib import Path

from loguru import logger

from src.config import Settings
from src.pipeline import sync_sources
from src.runtime_health import write_sync_health
from sync_official_news import sync as sync_official_news
from sync_telegram import sync as sync_telegram

type SyncCallable = Callable[[], Awaitable[None]]


@dataclass(frozen=True, slots=True)
class ProviderJob:
    name: str
    sync: SyncCallable


def select_provider_jobs(
    settings: Settings,
    *,
    telegram_sync: SyncCallable = sync_telegram,
    official_news_sync: SyncCallable = sync_official_news,
    source_sync: SyncCallable | None = None,
) -> tuple[ProviderJob, ...]:
    jobs: list[ProviderJob] = []
    has_telegram_sources = bool(
        settings.telegram_channels or settings.telegram_story_channels
    )
    if settings.telegram_configured and has_telegram_sources:
        jobs.append(ProviderJob(name="telegram", sync=telegram_sync))
    if settings.official_news_enabled:
        jobs.append(ProviderJob(name="official_news", sync=official_news_sync))
    if settings.content_sources:
        jobs.append(
            ProviderJob(
                name="sources",
                sync=source_sync or (lambda: sync_sources(settings)),
            )
        )
    return tuple(jobs)


async def run_sync_cycle(jobs: Sequence[ProviderJob]) -> bool:
    results = await asyncio.gather(
        *(job.sync() for job in jobs),
        return_exceptions=True,
    )
    succeeded = True
    for job, result in zip(jobs, results, strict=True):
        if isinstance(result, asyncio.CancelledError):
            raise result
        if isinstance(result, Exception):
            succeeded = False
            logger.error("{} synchronization failed: {}", job.name, result)
    return succeeded


async def run() -> None:
    settings = Settings()
    interval = max(settings.SYNC_INTERVAL_MINUTES, 1) * 60
    jobs = select_provider_jobs(settings)
    if not jobs:
        logger.warning("No content providers are enabled")
    while True:
        succeeded = await run_sync_cycle(jobs)
        if jobs:
            write_sync_health(
                Path(settings.HEALTH_STATUS_PATH),
                succeeded=succeeded,
            )
        await asyncio.sleep(interval)


if __name__ == "__main__":
    asyncio.run(run())
