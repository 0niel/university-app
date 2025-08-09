"""Normalization for VK URLs."""
from typing import Optional


def normalize_url(url: Optional[str]) -> Optional[str]:
    if not url:
        return None
    v = url.strip()
    if not v:
        return None
    if v.startswith("//"):
        return f"https:{v}"
    return v
