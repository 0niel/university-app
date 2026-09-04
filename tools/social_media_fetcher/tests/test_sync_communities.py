import httpx
import pytest

from sync_communities import _post_ingest


async def test_ingest_post_retries_read_timeout() -> None:
    attempts = 0

    def respond(request: httpx.Request) -> httpx.Response:
        nonlocal attempts
        attempts += 1
        if attempts < 3:
            raise httpx.ReadTimeout("timed out", request=request)
        return httpx.Response(200, json={"ok": True})

    async with httpx.AsyncClient(transport=httpx.MockTransport(respond)) as client:
        response = await _post_ingest(
            client,
            "https://project.supabase.co/functions/v1/ingest",
            headers={"x-ingest-key": "key"},
            payload={"entity": "community_catalog_targets"},
            retry_delays=(0, 0),
        )

    assert response.status_code == 200
    assert attempts == 3


async def test_ingest_post_retries_server_error() -> None:
    statuses = iter((503, 502, 200))
    requests = []

    def respond(request: httpx.Request) -> httpx.Response:
        requests.append(request)
        return httpx.Response(next(statuses), json={"ok": True})

    async with httpx.AsyncClient(transport=httpx.MockTransport(respond)) as client:
        response = await _post_ingest(
            client,
            "https://project.supabase.co/functions/v1/ingest",
            headers={"x-ingest-key": "key"},
            payload={"entity": "community_catalog_targets"},
            retry_delays=(0, 0),
        )

    assert response.status_code == 200
    assert len(requests) == 3


@pytest.mark.parametrize("status", [400, 401])
async def test_ingest_post_does_not_retry_client_error(status: int) -> None:
    requests = []

    def respond(request: httpx.Request) -> httpx.Response:
        requests.append(request)
        return httpx.Response(status, json={"ok": False})

    async with httpx.AsyncClient(transport=httpx.MockTransport(respond)) as client:
        response = await _post_ingest(
            client,
            "https://project.supabase.co/functions/v1/ingest",
            headers={"x-ingest-key": "key"},
            payload={"entity": "community_catalog_targets"},
            retry_delays=(0, 0),
        )

    assert response.status_code == status
    assert len(requests) == 1


async def test_ingest_post_retries_rate_limit() -> None:
    statuses = iter((429, 200))
    requests = []

    def respond(request: httpx.Request) -> httpx.Response:
        requests.append(request)
        return httpx.Response(
            next(statuses),
            headers={"retry-after": "0"},
            json={"ok": True},
        )

    async with httpx.AsyncClient(transport=httpx.MockTransport(respond)) as client:
        response = await _post_ingest(
            client,
            "https://project.supabase.co/functions/v1/ingest",
            headers={"x-ingest-key": "key"},
            payload={"entity": "community_catalog_targets"},
            retry_delays=(0,),
        )

    assert response.status_code == 200
    assert len(requests) == 2


async def test_ingest_post_retries_transport_error() -> None:
    attempts = 0

    def respond(request: httpx.Request) -> httpx.Response:
        nonlocal attempts
        attempts += 1
        if attempts == 1:
            raise httpx.ConnectError("unavailable", request=request)
        return httpx.Response(200, json={"ok": True})

    async with httpx.AsyncClient(transport=httpx.MockTransport(respond)) as client:
        response = await _post_ingest(
            client,
            "https://project.supabase.co/functions/v1/ingest",
            headers={"x-ingest-key": "key"},
            payload={"entity": "community_catalog_targets"},
            retry_delays=(0,),
        )

    assert response.status_code == 200
    assert attempts == 2


async def test_ingest_post_stops_after_retry_budget() -> None:
    attempts = 0

    def respond(request: httpx.Request) -> httpx.Response:
        nonlocal attempts
        attempts += 1
        raise httpx.ReadTimeout("timed out", request=request)

    async with httpx.AsyncClient(transport=httpx.MockTransport(respond)) as client:
        with pytest.raises(httpx.ReadTimeout):
            await _post_ingest(
                client,
                "https://project.supabase.co/functions/v1/ingest",
                headers={"x-ingest-key": "key"},
                payload={"entity": "community_catalog_targets"},
                retry_delays=(0, 0),
            )

    assert attempts == 3


async def test_ingest_post_returns_server_error_after_retry_budget() -> None:
    requests = []

    def respond(request: httpx.Request) -> httpx.Response:
        requests.append(request)
        return httpx.Response(503, json={"ok": False})

    async with httpx.AsyncClient(transport=httpx.MockTransport(respond)) as client:
        response = await _post_ingest(
            client,
            "https://project.supabase.co/functions/v1/ingest",
            headers={"x-ingest-key": "key"},
            payload={"entity": "community_catalog_targets"},
            retry_delays=(0, 0),
        )

    assert response.status_code == 503
    assert len(requests) == 3
