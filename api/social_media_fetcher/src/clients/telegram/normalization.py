"""Normalization for Telegram URLs or identifiers."""
from typing import Optional


def normalize_url(url: Optional[str]) -> Optional[str]:
    if not url:
        return None
    return url.strip() or None
