import argparse
import asyncio
import json
import os
import sys
from pathlib import Path

import httpx

from src.community_metadata import inspect_community


def _read_targets(path: Path) -> list:
    if str(path) == "-":
        return json.load(sys.stdin)
    return json.loads(path.read_text(encoding="utf-8-sig"))


def _write_report(path: Path, report: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")


async def run(
    *, input_path: Path | None, output_path: Path | None, apply: bool
) -> dict:
    organization = os.environ.get("APP_ORGANIZATION_ID", "mirea")
    endpoint = f"{os.environ.get('SUPABASE_URL', '').rstrip('/')}/functions/v1/ingest"
    headers = {"x-ingest-key": os.environ.get("SUPABASE_INGEST_KEY", "")}
    async with httpx.AsyncClient(
        timeout=20, headers={"User-Agent": "Mozilla/5.0", "Accept-Language": "ru,en"}
    ) as client:
        if input_path:
            targets = await asyncio.to_thread(_read_targets, input_path)
        else:
            response = await client.post(
                endpoint,
                headers=headers,
                json={
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
            response = await client.post(
                endpoint,
                headers=headers,
                json={
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
