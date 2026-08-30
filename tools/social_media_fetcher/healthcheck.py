import os
from pathlib import Path

from src.runtime_health import has_recent_success


def worker_is_running(cmdline_path: Path = Path("/proc/1/cmdline")) -> bool:
    try:
        command = cmdline_path.read_bytes().replace(b"\x00", b" ")
    except OSError:
        return False
    return b"worker.py" in command


def main() -> int:
    health_path = Path(
        os.getenv("HEALTH_STATUS_PATH", "/tmp/content-fetcher-health.json")
    )
    max_age = int(os.getenv("HEALTH_MAX_AGE_SECONDS", "3660"))
    return int(
        not (
            worker_is_running()
            and has_recent_success(health_path, max_age_seconds=max_age)
        )
    )


if __name__ == "__main__":
    raise SystemExit(main())
