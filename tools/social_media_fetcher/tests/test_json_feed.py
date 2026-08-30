from datetime import UTC, datetime

import httpx
import pytest
from pydantic import ValidationError

from src.pipeline.json_feed import JsonFeedProvider
from src.pipeline.models import ContentSource


@pytest.mark.asyncio
async def test_json_feed_provider_normalizes_a_public_api_response() -> None:
    async def handler(_: httpx.Request) -> httpx.Response:
        return httpx.Response(
            200,
            json={
                "data": {
                    "items": [
                        {
                            "id": 42,
                            "title": "Campus update",
                            "url": "https://university.example/news/42",
                            "published": "2026-07-15T10:00:00Z",
                            "summary": "Important information",
                        }
                    ]
                }
            },
        )

    client = httpx.AsyncClient(transport=httpx.MockTransport(handler))
    provider = JsonFeedProvider(client)
    source = ContentSource(
        id="public-api",
        provider="json",
        name="Example University",
        source_url="https://university.example/news",
        feed_url="https://api.university.example/news",
        metadata={
            "items_path": "data.items",
            "id_path": "id",
            "title_path": "title",
            "url_path": "url",
            "published_at_path": "published",
            "summary_path": "summary",
        },
    )

    items = await provider.fetch(source)
    await client.aclose()

    assert items[0].external_id == "42"
    assert items[0].published_at == datetime(2026, 7, 15, 10, tzinfo=UTC)
    assert items[0].summary == "Important information"


def test_json_source_requires_a_mapping() -> None:
    with pytest.raises(ValidationError, match="items_path"):
        ContentSource(
            id="public-api",
            provider="json",
            name="Example University",
            source_url="https://university.example/news",
            feed_url="https://api.university.example/news",
        )
