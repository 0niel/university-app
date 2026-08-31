"""Normalization for Telegram URLs or identifiers."""


def normalize_url(url: str | None) -> str | None:
    if not url:
        return None
    return url.strip() or None
