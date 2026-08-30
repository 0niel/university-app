import json
from datetime import UTC, datetime, timedelta
from pathlib import Path

import pytest
from pydantic import ValidationError

from healthcheck import worker_is_running
from src.config import Settings
from src.runtime_health import has_recent_success, write_sync_health
from worker import ProviderJob, run_sync_cycle, select_provider_jobs


def settings(**overrides: object) -> Settings:
    values: dict[str, object] = {
        "_env_file": None,
        "APP_ORGANIZATION_ID": "example-university",
        "MIREA_ENABLED": False,
        "OFFICIAL_NEWS_ENABLED": False,
    }
    values.update(overrides)
    return Settings(**values)


@pytest.mark.asyncio
async def test_example_tenant_never_runs_mirea() -> None:
    calls: list[str] = []

    async def sync_telegram() -> None:
        calls.append("telegram")

    async def sync_official_news() -> None:
        calls.append("official_news")

    jobs = select_provider_jobs(
        settings(
            TELEGRAM_API_ID=1,
            TELEGRAM_API_HASH="hash",
            TELEGRAM_SESSION_STRING="session",
            TELEGRAM_CHANNELS="example_news",
        ),
        telegram_sync=sync_telegram,
        official_news_sync=sync_official_news,
    )

    await run_sync_cycle(jobs)

    assert [job.name for job in jobs] == ["telegram"]
    assert calls == ["telegram"]


@pytest.mark.asyncio
async def test_failed_provider_marks_the_cycle_unsuccessful() -> None:
    async def fail() -> None:
        raise RuntimeError("unavailable")

    result = await run_sync_cycle((ProviderJob(name="telegram", sync=fail),))

    assert result is False


@pytest.mark.asyncio
async def test_legacy_mirea_profile_runs_as_official_news() -> None:
    calls: list[str] = []

    async def sync_official_news() -> None:
        calls.append("official_news")

    jobs = select_provider_jobs(
        settings(APP_ORGANIZATION_ID="mirea", MIREA_ENABLED=True),
        official_news_sync=sync_official_news,
    )

    await run_sync_cycle(jobs)

    assert [job.name for job in jobs] == ["official_news"]
    assert calls == ["official_news"]


def test_mirea_profile_is_disabled_by_default() -> None:
    config = settings()

    assert config.APP_ORGANIZATION_ID == "example-university"
    assert not config.MIREA_ENABLED
    assert not config.official_news_enabled


def test_telegram_requires_a_session_string() -> None:
    config = settings(TELEGRAM_API_ID=1, TELEGRAM_API_HASH="hash")

    assert not config.telegram_configured


def test_deployment_defaults_target_the_example_tenant() -> None:
    fields = Settings.model_fields

    assert fields["APP_ORGANIZATION_ID"].default == "example-university"
    assert fields["MIREA_ENABLED"].default is False
    assert fields["OFFICIAL_NEWS_ENABLED"].default is False


def test_example_tenant_rejects_mirea_provider() -> None:
    with pytest.raises(ValidationError, match="APP_ORGANIZATION_ID=mirea"):
        settings(MIREA_ENABLED=True)


@pytest.mark.asyncio
async def test_generic_official_news_profile_runs_for_any_tenant() -> None:
    calls: list[str] = []

    async def sync_official_news() -> None:
        calls.append("official_news")

    jobs = select_provider_jobs(
        settings(
            OFFICIAL_NEWS_ENABLED=True,
            OFFICIAL_NEWS_URL="https://university.example/news/",
            OFFICIAL_NEWS_SOURCE_NAME="Example University",
        ),
        official_news_sync=sync_official_news,
    )

    await run_sync_cycle(jobs)

    assert [job.name for job in jobs] == ["official_news"]
    assert calls == ["official_news"]


async def test_configured_content_sources_run_as_a_single_pipeline_job() -> None:
    calls: list[str] = []

    async def sync_sources() -> None:
        calls.append("sources")

    jobs = select_provider_jobs(
        settings(
            CONTENT_SOURCES=(
                '[{"id":"official-feed","provider":"rss",'
                '"name":"Example University",'
                '"source_url":"https://university.example/news",'
                '"feed_url":"https://university.example/news.xml"}]'
            ),
        ),
        source_sync=sync_sources,
    )

    await run_sync_cycle(jobs)

    assert [job.name for job in jobs] == ["sources"]
    assert calls == ["sources"]


def test_healthcheck_recognizes_worker_process(tmp_path: Path) -> None:
    command = tmp_path / "cmdline"
    command.write_bytes(b"python\x00worker.py\x00")

    assert worker_is_running(command)


def test_healthcheck_rejects_other_or_missing_process(tmp_path: Path) -> None:
    command = tmp_path / "cmdline"
    command.write_bytes(b"python\x00main.py\x00")

    assert not worker_is_running(command)
    assert not worker_is_running(tmp_path / "missing")


def test_runtime_health_requires_a_recent_success(tmp_path: Path) -> None:
    health = tmp_path / "health.json"
    write_sync_health(health, succeeded=True)

    assert has_recent_success(health, max_age_seconds=60)

    health.write_text(
        json.dumps(
            {
                "last_success_at": (
                    datetime.now(UTC) - timedelta(minutes=2)
                ).isoformat(),
            }
        ),
        encoding="utf-8",
    )
    assert not has_recent_success(health, max_age_seconds=60)
