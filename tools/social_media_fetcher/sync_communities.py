import argparse
import asyncio
import json
import math
import os
import sys
from datetime import UTC, datetime
from email.utils import parsedate_to_datetime
from pathlib import Path

import httpx

from src.community_metadata import inspect_community

_INGEST_RETRY_DELAYS = (1.0, 2.0, 4.0)
_MAX_RETRY_AFTER_SECONDS = 60.0


def _read_targets(path: Path) -> list:
    if str(path) == "-":
        return json.load(sys.stdin)
    return json.loads(path.read_text(encoding="utf-8-sig"))


def _write_report(path: Path, report: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")


def _retry_delay(response: httpx.Response, fallback: float) -> float:
    value = response.headers.get("retry-after", "").strip()
    if not value:
        return fallback
    try:
        seconds = float(value)
    except ValueError:
        try:
            retry_at = parsedate_to_datetime(value)
        except (TypeError, ValueError, OverflowError):
            return fallback
        if retry_at.tzinfo is None:
            retry_at = retry_at.replace(tzinfo=UTC)
        seconds = (retry_at - datetime.now(UTC)).total_seconds()
    if not math.isfinite(seconds) or seconds < 0:
        return fallback
    return min(seconds, _MAX_RETRY_AFTER_SECONDS)


async def _post_ingest(
    client: httpx.AsyncClient,
    endpoint: str,
    *,
    headers: dict[str, str],
    payload: dict,
    retry_delays: tuple[float, ...] = _INGEST_RETRY_DELAYS,
) -> httpx.Response:
    for attempt in range(len(retry_delays) + 1):
        response: httpx.Response | None = None
        try:
            response = await client.post(endpoint, headers=headers, json=payload)
        except httpx.TransportError:
            if attempt == len(retry_delays):
                raise
        else:
            retryable = response.status_code == 429 or response.status_code >= 500
            if not retryable or attempt == len(retry_delays):
                return response
        delay = retry_delays[attempt]
        if response is not None:
            delay = _retry_delay(response, delay)
        await asyncio.sleep(delay)
    raise RuntimeError("Ingest request retry loop exhausted")


async def run(
    *, input_path: Path | None, output_path: Path | None, apply: bool
) -> dict:
    organization = os.environ.get("APP_ORGANIZATION_ID", "mirea")
    supabase_url = os.environ.get("SUPABASE_URL", "").rstrip("/")
    ingest_key = os.environ.get("SUPABASE_INGEST_KEY", "")
    if (input_path is None or apply) and (not supabase_url or not ingest_key):
        raise RuntimeError("SUPABASE_URL and SUPABASE_INGEST_KEY are required")
    endpoint = f"{supabase_url}/functions/v1/ingest"
    headers = {"x-ingest-key": ingest_key}
    async with httpx.AsyncClient(
        timeout=20, headers={"User-Agent": "Mozilla/5.0", "Accept-Language": "ru,en"}
    ) as client:
        if input_path:
            targets = await asyncio.to_thread(_read_targets, input_path)
        else:
            response = await _post_ingest(
                client,
                endpoint,
                headers=headers,
                payload={
                    "entity": "community_catalog_targets",
                    "organization_id": organization,
                },
            )
            response.raise_for_status()
            body = response.json()
            if body.get("ok") is not True or not isinstance(body.get("result"), list):
                raise ValueError("Invalid community sync targets response")
            targets = body["result"]
        if not isinstance(targets, list) or not targets:
            raise ValueError("Community sync has no targets")
        semaphore = asyncio.Semaphore(4)

        async def inspect(target: dict) -> dict:
            async with semaphore:
                observation = await inspect_community(
                    client, identifier=str(target["id"]), url=target["url"]
                )
                return observation.payload()

        observations = await asyncio.gather(*(inspect(target) for target in targets))
        result = {
            "organization_id": organization,
            "counts": {
                status: sum(item["status"] == status for item in observations)
                for status in ("verified", "not_found", "unavailable")
            },
            "observations": observations,
        }
        if output_path:
            await asyncio.to_thread(_write_report, output_path, result)
        if apply:
            response = await _post_ingest(
                client,
                endpoint,
                headers=headers,
                payload={
                    "entity": "community_observations",
                    "organization_id": organization,
                    "observations": observations,
                },
            )
            response.raise_for_status()
            applied = response.json()
            if applied.get("ok") is not True:
                raise ValueError("Community observations were not accepted")
            if applied.get("result", {}).get("received") != len(observations):
                raise ValueError("Community observation count does not match")
            result["applied"] = applied["result"]
        print(
            json.dumps(
                {
                    "organization_id": organization,
                    "counts": result["counts"],
                    "applied": result.get("applied"),
                },
                ensure_ascii=False,
            )
        )
        return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input-json", type=Path)
    parser.add_argument("--output-json", type=Path)
    parser.add_argument("--apply", action="store_true")
    arguments = parser.parse_args()
    asyncio.run(
        run(
            input_path=arguments.input_json,
            output_path=arguments.output_json,
            apply=arguments.apply,
        )
    )
