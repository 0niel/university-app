import json
from datetime import UTC, datetime

import httpx
import pytest

from src.config import Settings
from src.pipeline.models import ContentSource, NormalizedContent
from src.pipeline.rss import RssProvider
from src.pipeline.runner import _ingest_item, sync_sources


def test_content_sources_are_tenant_configuration() -> None:
    settings = Settings(
        _env_file=None,
        CONTENT_SOURCES=(
            '[{"id":"official-feed","provider":"rss","name":"Example University",'
            '"source_url":"https://university.example/news",'
            '"feed_url":"https://university.example/news.xml"}]'
        ),
    )

    assert settings.content_sources[0]["id"] == "official-feed"


def test_rss_source_requires_a_feed_url() -> None:
    with pytest.raises(ValueError, match="rss source requires feed_url"):
        ContentSource(
            id="official-feed",
            provider="rss",
            name="Example University",
            source_url="https://university.example/news",
        )


@pytest.mark.asyncio
async def test_rss_provider_normalizes_feed_entries() -> None:
    feed = """<?xml version="1.0"?>
    <rss version="2.0"><channel><item>
    <guid>announcement-1</guid><title>Campus &amp; update</title>
    <link>https://university.example/news/announcement-1</link>
    <pubDate>Tue, 14 Jul 2026 10:00:00 GMT</pubDate>
    <description><![CDATA[<p>Important <strong>information</strong>.</p>]]></description>
    </item></channel></rss>"""

    async def handler(_: httpx.Request) -> httpx.Response:
        return httpx.Response(200, content=feed)

    client = httpx.AsyncClient(transport=httpx.MockTransport(handler))
    provider = RssProvider(client)
    source = ContentSource(
        id="official-feed",
        provider="rss",
        name="Example University",
        source_url="https://university.example/news",
        feed_url="https://university.example/news.xml",
    )

    items = await provider.fetch(source)
    await client.aclose()

    assert items[0].external_id == "announcement-1"
    assert items[0].title == "Campus & update"
    assert items[0].summary == "Important information."
    assert items[0].published_at == datetime(2026, 7, 14, 10, tzinfo=UTC)


def test_normalized_content_has_app_renderable_blocks() -> None:
    source = ContentSource(
        id="official-feed",
        provider="rss",
        name="Example University",
        source_url="https://university.example/news",
        feed_url="https://university.example/news.xml",
    )
    item = NormalizedContent(
        external_id="announcement-1",
        title="Campus update",
        published_at=datetime(2026, 7, 14, 10, tzinfo=UTC),
        original_url="https://university.example/news/announcement-1",
        html="<p>Important information.</p>",
    )

    ingested = _ingest_item(item, source)

    assert [block["type"] for block in ingested.news_blocks] == [
        "__article_introduction__",
        "__html__",
    ]


@pytest.mark.asyncio
async def test_pipeline_attempts_other_sources_after_a_source_fails(
    monkeypatch,
) -> None:
    source_a = ContentSource(
        id="first",
        provider="rss",
        name="First",
        source_url="https://first.example/news",
        feed_url="https://first.example/feed.xml",
    )
    source_b = ContentSource(
        id="second",
        provider="rss",
        name="Second",
        source_url="https://second.example/news",
        feed_url="https://second.example/feed.xml",
    )
    attempted: list[str] = []

    class StubIngest:
        async def close(self) -> None:
            pass

    async def fake_sync_source(
        _: Settings,
        __: StubIngest,
        source: ContentSource,
    ) -> None:
        attempted.append(source.id)
        if source.id == "first":
            raise RuntimeError("unavailable")

    monkeypatch.setattr("src.pipeline.runner.IngestClient", lambda *_: StubIngest())
    monkeypatch.setattr("src.pipeline.runner._sync_source", fake_sync_source)
    settings = Settings(
        _env_file=None,
        SUPABASE_URL="https://project.supabase.co",
        SUPABASE_INGEST_KEY="key",
        CONTENT_SOURCES=json.dumps(
            [source_a.model_dump(mode="json"), source_b.model_dump(mode="json")]
        ),
    )

    with pytest.raises(ExceptionGroup):
        await sync_sources(settings)

    assert attempted == ["first", "second"]
