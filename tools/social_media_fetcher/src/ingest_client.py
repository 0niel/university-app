from typing import Any, Literal
from urllib.parse import urlparse
from uuid import UUID

import httpx
from pydantic import BaseModel, ConfigDict, Field, HttpUrl


class IngestSource(BaseModel):
    model_config = ConfigDict(frozen=True)

    source_type: str
    source_external_id: str
    source_name: str
    source_url: HttpUrl
    category: str | None = None
    is_active: bool = True
    metadata: dict[str, Any] = Field(default_factory=dict)


class IngestItem(BaseModel):
    model_config = ConfigDict(frozen=True)

    external_id: str
    title: str
    published_at: str
    original_url: HttpUrl
    summary: str | None = None
    news_blocks: list[dict[str, Any]] = Field(default_factory=list)
    news_blocks_version: str = "1.0.0"
    raw_data: dict[str, Any] = Field(default_factory=dict)
    metadata: dict[str, Any] = Field(default_factory=dict)


class StoryMediaUploadTicket(BaseModel):
    model_config = ConfigDict(frozen=True)

    signed_url: HttpUrl
    public_url: HttpUrl
    bucket: str
    path: str


class SyncRun(BaseModel):
    model_config = ConfigDict(frozen=True)

    sync_run_id: UUID
    checkpoint: dict[str, Any] = Field(default_factory=dict)


class SyncFinishResult(BaseModel):
    model_config = ConfigDict(frozen=True)

    sync_run_id: UUID
    status: Literal["succeeded", "failed", "partial"]
    checkpoint_advanced: bool


class IngestNewsResult(BaseModel):
    model_config = ConfigDict(frozen=True)

    organization_id: str
    source_type: str
    source_external_id: str
    items_received: int = Field(ge=0)
    items_upserted: int = Field(ge=0)
    items_skipped: int = Field(ge=0)


class IngestRejectedError(ValueError):
    pass


class IngestClient:
    def __init__(
        self,
        supabase_url: str,
        ingest_key: str,
        *,
        client: httpx.AsyncClient | None = None,
    ) -> None:
        self._supabase_url = supabase_url.rstrip("/")
        self._endpoint = f"{self._supabase_url}/functions/v1/ingest"
        self._ingest_key = ingest_key
        self._client = client or httpx.AsyncClient(timeout=30)
        self._owns_client = client is None

    async def close(self) -> None:
        if self._owns_client:
            await self._client.aclose()

    async def ingest_news(
        self,
        organization_id: str,
        source: IngestSource,
        items: list[IngestItem],
        *,
        sync_run_id: UUID | None = None,
    ) -> IngestNewsResult:
        payload = {
            "entity": "news_items",
            "organization_id": organization_id,
            "source": source.model_dump(mode="json"),
            "items": [item.model_dump(mode="json") for item in items],
            "sync_run_id": str(sync_run_id) if sync_run_id is not None else None,
        }
        response = await self._client.post(
            self._endpoint,
            headers={"x-ingest-key": self._ingest_key},
            json=payload,
        )
        if 400 <= response.status_code < 500:
            raise IngestRejectedError(
                f"Ingest endpoint rejected the batch with {response.status_code}"
            )
        response.raise_for_status()
        result = response.json()
        if not isinstance(result, dict) or result.get("ok") is not True:
            raise ValueError("Ingest endpoint returned an invalid response")
        parsed = IngestNewsResult.model_validate(result.get("result"))
        if (
            parsed.items_received != len(items)
            or parsed.items_upserted != len(items)
            or parsed.items_skipped != 0
        ):
            raise ValueError("Ingest endpoint did not accept the complete batch")
        return parsed

    async def start_sync(
        self,
        organization_id: str,
        *,
        source: str,
        source_type: str,
        metadata: dict[str, Any] | None = None,
    ) -> SyncRun:
        response = await self._client.post(
            self._endpoint,
            headers={"x-ingest-key": self._ingest_key},
            json={
                "entity": "sync_start",
                "organization_id": organization_id,
                "source": source,
                "source_type": source_type,
                "metadata": metadata or {},
            },
        )
        response.raise_for_status()
        body = response.json()
        if not isinstance(body, dict) or body.get("ok") is not True:
            raise ValueError("Ingest endpoint returned an invalid sync run")
        return SyncRun.model_validate(body.get("result"))

    async def finish_sync(
        self,
        organization_id: str,
        sync_run_id: UUID,
        *,
        source: str,
        source_type: str,
        status: Literal["succeeded", "failed", "partial"],
        checkpoint: dict[str, Any] | None = None,
        error_message: str | None = None,
        metadata: dict[str, Any] | None = None,
    ) -> SyncFinishResult:
        response = await self._client.post(
            self._endpoint,
            headers={"x-ingest-key": self._ingest_key},
            json={
                "entity": "sync_finish",
                "organization_id": organization_id,
                "sync_run_id": str(sync_run_id),
                "source": source,
                "source_type": source_type,
                "status": status,
                "checkpoint": checkpoint,
                "error_message": error_message,
                "metadata": metadata or {},
            },
        )
        response.raise_for_status()
        body = response.json()
        if not isinstance(body, dict) or body.get("ok") is not True:
            raise ValueError("Ingest endpoint returned an invalid sync result")
        return SyncFinishResult.model_validate(body.get("result"))

    async def create_story_media_upload(
        self,
        *,
        organization_id: str,
        channel: str,
        story_id: int,
        content_type: str,
        byte_size: int,
        sha256: str,
    ) -> StoryMediaUploadTicket:
        response = await self._client.post(
            self._endpoint,
            headers={"x-ingest-key": self._ingest_key},
            json={
                "entity": "story_media_upload",
                "organization_id": organization_id,
                "channel": channel,
                "story_id": story_id,
                "content_type": content_type,
                "byte_size": byte_size,
                "sha256": sha256,
            },
        )
        response.raise_for_status()
        body = response.json()
        if not isinstance(body, dict) or body.get("ok") is not True:
            raise ValueError("Ingest endpoint returned an invalid upload ticket")
        return StoryMediaUploadTicket.model_validate(body.get("upload"))

    async def upload_story_media(
        self,
        ticket: StoryMediaUploadTicket,
        *,
        data: bytes,
        content_type: str,
    ) -> str:
        signed_url = str(ticket.signed_url)
        self._validate_story_media_ticket(ticket)
        response = await self._client.put(
            signed_url,
            content=data,
            headers={
                "content-type": content_type,
                "cache-control": "3600",
                "x-upsert": "true",
            },
        )
        response.raise_for_status()
        return str(ticket.public_url)

    async def delete_story_media(self, organization_id: str, paths: list[str]) -> int:
        response = await self._client.post(
            self._endpoint,
            headers={"x-ingest-key": self._ingest_key},
            json={
                "entity": "story_media_delete",
                "organization_id": organization_id,
                "paths": paths,
            },
        )
        response.raise_for_status()
        body = response.json()
        removed = body.get("removed") if isinstance(body, dict) else None
        if body.get("ok") is not True or not isinstance(removed, int):
            raise ValueError("Ingest endpoint returned an invalid delete result")
        return removed

    async def cleanup_story_media(self, organization_id: str) -> int:
        response = await self._client.post(
            self._endpoint,
            headers={"x-ingest-key": self._ingest_key},
            json={
                "entity": "story_media_cleanup",
                "organization_id": organization_id,
            },
        )
        response.raise_for_status()
        body = response.json()
        removed = body.get("removed") if isinstance(body, dict) else None
        if (
            not isinstance(body, dict)
            or body.get("ok") is not True
            or not isinstance(removed, int)
        ):
            raise ValueError("Ingest endpoint returned an invalid cleanup result")
        return removed

    def _validate_story_media_ticket(self, ticket: StoryMediaUploadTicket) -> None:
        if ticket.bucket != "story-media" or not ticket.path.startswith(
            "organizations/"
        ):
            raise ValueError("Story media ticket has an unexpected object path")
        self._validate_storage_url(
            str(ticket.signed_url),
            f"/storage/v1/object/upload/sign/story-media/{ticket.path}",
        )
        self._validate_storage_url(
            str(ticket.public_url),
            f"/storage/v1/object/public/story-media/{ticket.path}",
        )

    def _validate_storage_url(self, url: str, expected_path: str) -> None:
        expected = urlparse(self._supabase_url)
        actual = urlparse(url)
        if actual.scheme != expected.scheme or actual.netloc != expected.netloc:
            raise ValueError("Storage URL does not belong to Supabase")
        if actual.path != expected_path:
            raise ValueError("Storage URL has an unexpected object path")
