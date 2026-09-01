import json
from uuid import UUID

import httpx
import pytest

from src.ingest_client import (
    IngestClient,
    IngestItem,
    IngestRejectedError,
    IngestSource,
    StoryMediaUploadTicket,
)


async def test_ingest_client_uses_edge_function_contract() -> None:
    captured: httpx.Request | None = None

    def handler(request: httpx.Request) -> httpx.Response:
        nonlocal captured
        captured = request
        return httpx.Response(
            200,
            json={
                "ok": True,
                "result": {
                    "organization_id": "university",
                    "source_type": "website",
                    "source_external_id": "official",
                    "items_received": 1,
                    "items_upserted": 1,
                    "items_skipped": 0,
                },
            },
        )

    transport = httpx.MockTransport(handler)
    async with httpx.AsyncClient(transport=transport) as http_client:
        client = IngestClient(
            "https://project.supabase.co",
            "ingest-secret",
            client=http_client,
        )
        result = await client.ingest_news(
            "university",
            IngestSource(
                source_type="website",
                source_external_id="official",
                source_name="University",
                source_url="https://university.example/news",
            ),
            [
                IngestItem(
                    external_id="article",
                    title="Article",
                    published_at="2026-07-10T10:00:00Z",
                    original_url="https://university.example/news/article",
                )
            ],
        )

    assert result.items_upserted == 1
    assert captured is not None
    assert captured.url == "https://project.supabase.co/functions/v1/ingest"
    assert captured.headers["x-ingest-key"] == "ingest-secret"
    assert "service-role" not in captured.headers
    payload = json.loads(captured.content)
    assert payload["entity"] == "news_items"
    assert payload["organization_id"] == "university"
    assert payload["sync_run_id"] is None


async def test_sync_lifecycle_uses_typed_edge_contracts() -> None:
    requests: list[dict[str, object]] = []
    run_id = "10000000-0000-4000-8000-000000000001"

    def handler(request: httpx.Request) -> httpx.Response:
        payload = json.loads(request.content)
        requests.append(payload)
        if payload["entity"] == "sync_start":
            result = {
                "sync_run_id": run_id,
                "checkpoint": {"version": 1, "last_message_id": 42},
            }
        else:
            result = {
                "sync_run_id": run_id,
                "status": "succeeded",
                "checkpoint_advanced": True,
            }
        return httpx.Response(200, json={"ok": True, "result": result})

    async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as http:
        client = IngestClient(
            "https://project.supabase.co",
            "ingest-secret",
            client=http,
        )
        run = await client.start_sync(
            "university",
            source="telegram:news",
            source_type="telegram",
            metadata={"channel": "news"},
        )
        result = await client.finish_sync(
            "university",
            run.sync_run_id,
            source="telegram:news",
            source_type="telegram",
            status="succeeded",
            checkpoint={"version": 1, "last_message_id": 50},
        )

    assert run.sync_run_id == UUID(run_id)
    assert run.checkpoint["last_message_id"] == 42
    assert result.checkpoint_advanced is True
    assert requests == [
        {
            "entity": "sync_start",
            "organization_id": "university",
            "source": "telegram:news",
            "source_type": "telegram",
            "metadata": {"channel": "news"},
        },
        {
            "entity": "sync_finish",
            "organization_id": "university",
            "sync_run_id": run_id,
            "source": "telegram:news",
            "source_type": "telegram",
            "status": "succeeded",
            "checkpoint": {"version": 1, "last_message_id": 50},
            "error_message": None,
            "metadata": {},
        },
    ]


async def test_client_marks_4xx_ingest_responses_as_proven_rejections() -> None:
    async with httpx.AsyncClient(
        transport=httpx.MockTransport(
            lambda _: httpx.Response(400, json={"error": "bad request"})
        )
    ) as http:
        client = IngestClient(
            "https://project.supabase.co",
            "ingest-secret",
            client=http,
        )
        with pytest.raises(IngestRejectedError, match="400"):
            await client.ingest_news(
                "university",
                IngestSource(
                    source_type="telegram",
                    source_external_id="news",
                    source_name="News",
                    source_url="https://t.me/news",
                ),
                [],
            )


async def test_story_media_upload_keeps_secret_off_signed_request() -> None:
    requests: list[httpx.Request] = []
    signed_url = (
        "https://project.supabase.co/storage/v1/object/upload/sign/"
        "story-media/organizations/university/story.jpg?token=signed"
    )

    def handler(request: httpx.Request) -> httpx.Response:
        requests.append(request)
        if request.method == "POST":
            return httpx.Response(
                200,
                json={
                    "ok": True,
                    "upload": {
                        "signed_url": signed_url,
                        "public_url": (
                            "https://project.supabase.co/storage/v1/object/public/"
                            "story-media/organizations/university/story.jpg"
                        ),
                        "bucket": "story-media",
                        "path": "organizations/university/story.jpg",
                    },
                },
            )
        return httpx.Response(200, json={"Key": "story-media/story.jpg"})

    async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as http:
        client = IngestClient(
            "https://project.supabase.co",
            "ingest-secret",
            client=http,
        )
        ticket = await client.create_story_media_upload(
            organization_id="university",
            channel="news",
            story_id=42,
            content_type="image/jpeg",
            byte_size=3,
            sha256="a" * 64,
        )
        public_url = await client.upload_story_media(
            ticket,
            data=b"jpg",
            content_type="image/jpeg",
        )

    assert public_url.endswith("story.jpg")
    assert [request.method for request in requests] == ["POST", "PUT"]
    assert requests[0].headers["x-ingest-key"] == "ingest-secret"
    assert "x-ingest-key" not in requests[1].headers
    assert "authorization" not in requests[1].headers
    assert "apikey" not in requests[1].headers
    assert requests[1].headers["x-upsert"] == "true"
    assert requests[1].content == b"jpg"


async def test_story_media_upload_rejects_foreign_signed_url() -> None:
    path = "organizations/university/telegram-stories/news/42/digest.jpg"
    ticket = StoryMediaUploadTicket(
        signed_url=(
            "https://attacker.example/storage/v1/object/upload/sign/"
            f"story-media/{path}?token=stolen"
        ),
        public_url=(
            f"https://project.supabase.co/storage/v1/object/public/story-media/{path}"
        ),
        bucket="story-media",
        path=path,
    )
    async with httpx.AsyncClient() as http:
        client = IngestClient(
            "https://project.supabase.co",
            "ingest-secret",
            client=http,
        )
        with pytest.raises(ValueError, match="does not belong"):
            await client.upload_story_media(
                ticket,
                data=b"jpg",
                content_type="image/jpeg",
            )


async def test_story_media_cleanup_uses_protected_ingest_contract() -> None:
    captured: httpx.Request | None = None

    def handler(request: httpx.Request) -> httpx.Response:
        nonlocal captured
        captured = request
        return httpx.Response(200, json={"ok": True, "removed": 2})

    async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as http:
        client = IngestClient(
            "https://project.supabase.co",
            "ingest-secret",
            client=http,
        )
        removed = await client.cleanup_story_media("university")

    assert removed == 2
    assert captured is not None
    assert captured.headers["x-ingest-key"] == "ingest-secret"
    assert json.loads(captured.content) == {
        "entity": "story_media_cleanup",
        "organization_id": "university",
    }


async def test_story_media_delete_uses_protected_ingest_contract() -> None:
    captured: httpx.Request | None = None

    def handler(request: httpx.Request) -> httpx.Response:
        nonlocal captured
        captured = request
        return httpx.Response(200, json={"ok": True, "removed": 1})

    path = "organizations/university/telegram-stories/news/42/media"
    async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as http:
        client = IngestClient(
            "https://project.supabase.co",
            "ingest-secret",
            client=http,
        )
        removed = await client.delete_story_media("university", [path])

    assert removed == 1
    assert captured is not None
    assert captured.headers["x-ingest-key"] == "ingest-secret"
    assert json.loads(captured.content) == {
        "entity": "story_media_delete",
        "organization_id": "university",
        "paths": [path],
    }
