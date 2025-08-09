"""Normalization for MIREA site URLs."""
from typing import Optional


def normalize_url(url: Optional[str]) -> Optional[str]:
    if not url:
        return None
    u = url.strip()
    if not u:
        return None
    if u.startswith("//"):
        u = f"https:{u}"
    if u.startswith("https://mirea.ruhttps://"):
        u = u.replace("https://mirea.ru", "", 1)
    if u.startswith("/upload") or u.startswith("/images") or u.startswith("/files"):
        u = f"https://www.mirea.ru{u}"
    return u
