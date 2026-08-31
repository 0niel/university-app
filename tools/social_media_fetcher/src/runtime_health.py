import json
from datetime import UTC, datetime
from pathlib import Path


def write_sync_health(path: Path, *, succeeded: bool) -> None:
    now = datetime.now(UTC).isoformat()
    previous = _read(path)
    payload = {
        "updated_at": now,
        "last_success_at": now if succeeded else previous.get("last_success_at"),
        "status": "ok" if succeeded else "failed",
    }
    temporary = path.with_suffix(f"{path.suffix}.tmp")
    temporary.parent.mkdir(parents=True, exist_ok=True)
    temporary.write_text(json.dumps(payload), encoding="utf-8")
    temporary.replace(path)


def has_recent_success(path: Path, *, max_age_seconds: int) -> bool:
    value = _read(path).get("last_success_at")
    if not isinstance(value, str):
        return False
    try:
        timestamp = datetime.fromisoformat(value)
    except ValueError:
        return False
    if timestamp.tzinfo is None:
        return False
    age = datetime.now(UTC) - timestamp.astimezone(UTC)
    return age.total_seconds() <= max_age_seconds


def _read(path: Path) -> dict[str, object]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return {}
    return value if isinstance(value, dict) else {}
