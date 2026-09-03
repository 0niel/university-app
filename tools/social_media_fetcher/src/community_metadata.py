import re
from dataclasses import asdict, dataclass
from datetime import UTC, datetime
from typing import Literal
from urllib.parse import urlparse

import httpx
from bs4 import BeautifulSoup

type ObservationStatus = Literal["verified", "not_found", "unavailable"]

ALLOWED_HOSTS = {
    "t.me",
    "telegram.me",
    "vk.com",
    "vk.ru",
    "m.vk.com",
    "m.vk.ru",
    "discord.gg",
    "discord.com",
}
MEMBER_PATTERN = re.compile(
    r"([\d][\d\s\u00a0\u202f.,]*\s*(?:[kKmM]|тыс\.?|млн\.?)?)\s*"
    r"(?:subscribers?|members?|participants?|подписчик[а-я]*|участник[а-я]*)",
    re.IGNORECASE,
)


@dataclass(frozen=True, slots=True)
class CommunityObservation:
    id: str
    url: str
    status: ObservationStatus
    checked_at: str
    evidence: str
    http_status: int | None = None
    member_count: int | None = None
    title: str | None = None
    description: str | None = None
    logo_url: str | None = None

    def payload(self) -> dict:
        return asdict(self)


def member_count(text: str) -> int | None:
    match = MEMBER_PATTERN.search(text)
    if match is None:
        return None
    raw = re.sub(r"[\s\u00a0\u202f]", "", match.group(1)).lower()
    multiplier = 1
    for suffix, factor in (
        ("тыс.", 1000),
        ("тыс", 1000),
        ("млн.", 1000000),
        ("млн", 1000000),
        ("k", 1000),
        ("m", 1000000),
    ):
        if raw.endswith(suffix):
            raw = raw.removesuffix(suffix)
            multiplier = factor
            break
    if multiplier == 1:
        raw = raw.replace(",", "").replace(".", "")
    else:
        raw = raw.replace(",", ".")
    try:
        count = round(float(raw) * multiplier)
        return count if 0 <= count <= 2_147_483_647 else None
    except (ValueError, OverflowError):
        return None


def https_url(value: object) -> str | None:
    if not isinstance(value, str):
        return None
    try:
        uri = urlparse(value.strip())
        valid = (
            uri.scheme == "https"
            and uri.hostname
            and not uri.username
            and not uri.password
        )
    except ValueError:
        return None
    return value.strip() if valid else None


def parse_community_page(
    html: str, *, identifier: str, url: str, http_status: int = 200
) -> CommunityObservation:
    base = {
        "id": identifier,
        "url": url,
        "checked_at": datetime.now(UTC).isoformat(),
        "http_status": http_status,
    }
    if http_status in (404, 410):
        return CommunityObservation(
            **base, status="not_found", evidence=f"HTTP {http_status}"
        )
    if http_status != 200:
        return CommunityObservation(
            **base, status="unavailable", evidence=f"HTTP {http_status}"
        )
    soup = BeautifulSoup(html, "html.parser")
    host = urlparse(url).hostname
    if host in {"t.me", "telegram.me"}:
        title = soup.select_one(".tgme_page_title")
        extra = soup.select_one(".tgme_page_extra")
        count = member_count(extra.get_text(" ", strip=True)) if extra else None
        if title is None or count is None:
            return CommunityObservation(
                **base,
                status="unavailable",
                evidence="Telegram preview does not expose a public group or channel",
            )
        description = soup.select_one(".tgme_page_description")
        photo = soup.select_one(".tgme_page_photo_image")
        return CommunityObservation(
            **base,
            status="verified",
            evidence=extra.get_text(" ", strip=True)[:300],
            member_count=count,
            title=title.get_text(" ", strip=True)[:160] or None,
            description=description.get_text(" ", strip=True)[:1000]
            if description
            else None,
            logo_url=https_url(photo.get("src")) if photo else None,
        )
    if host in {"vk.com", "vk.ru", "m.vk.com", "m.vk.ru"}:
        visible = soup.get_text(" ", strip=True)
        title = soup.select_one('meta[property="og:title"]')
        name = str(title.get("content", "")).strip() if title else ""
        if name in {"", "ВКонтакте", "ВКонтакте | ВКонтакте", "VK", "VK | VK"}:
            return CommunityObservation(
                **base,
                status="unavailable",
                evidence="VK returned an access or generic page",
            )
        if re.fullmatch(r"(?:Сообщество|Страница) удален[ао]", name, re.IGNORECASE):
            return CommunityObservation(
                **base, status="not_found", evidence=name.capitalize()
            )
        count = member_count(visible)
        photo = soup.select_one('meta[property="og:image"]')
        description = soup.select_one('meta[property="og:description"]')
        return CommunityObservation(
            **base,
            status="verified",
            evidence=f"Public VK metadata: {name}"[:300],
            member_count=count,
            title=name[:160],
            description=str(description.get("content", ""))[:1000] or None
            if description
            else None,
            logo_url=https_url(photo.get("content")) if photo else None,
        )
    return CommunityObservation(
        **base, status="unavailable", evidence="No supported public metadata parser"
    )


async def inspect_community(
    client: httpx.AsyncClient, *, identifier: str, url: str
) -> CommunityObservation:
    try:
        uri = urlparse(url)
        if (
            https_url(url) is None
            or uri.hostname not in ALLOWED_HOSTS
            or uri.port not in (None, 443)
        ):
            raise ValueError("Unsupported community URL")
        current = url
        for _ in range(5):
            response = await client.get(current, follow_redirects=False)
            if response.is_redirect:
                current = str(response.url.join(response.headers.get("location", "")))
                redirect = urlparse(current)
                if (
                    https_url(current) is None
                    or redirect.hostname not in ALLOWED_HOSTS
                    or redirect.port not in (None, 443)
                ):
                    raise ValueError(
                        "Community redirected outside supported public hosts"
                    )
                continue
            return parse_community_page(
                response.text,
                identifier=identifier,
                url=url,
                http_status=response.status_code,
            )
        raise ValueError("Too many community redirects")
    except (httpx.HTTPError, ValueError) as error:
        return CommunityObservation(
            identifier,
            url,
            "unavailable",
            datetime.now(UTC).isoformat(),
            f"{type(error).__name__}: metadata request unavailable",
        )
