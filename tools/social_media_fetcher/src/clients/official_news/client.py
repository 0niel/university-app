import asyncio
import re
from datetime import datetime
from typing import Any
from urllib.parse import urljoin, urlparse

import aiohttp
from bs4 import BeautifulSoup
from loguru import logger

from ...clients.base.interfaces import SocialMediaClient
from ...config import OfficialNewsSource, Settings

DEFAULT_LINK_SELECTOR = 'a[href*="/news/"]'
DEFAULT_ARTICLE_SELECTORS = (
    "article",
    ".news-detail",
    ".detail-text",
    "main [class*='content']",
    "main",
)
_DATE_PATTERN = re.compile(r"\b(\d{2}\.\d{2}\.\d{4})\b")


def parse_news_html(
    html: str,
    limit: int,
    *,
    news_url: str,
    link_selector: str = DEFAULT_LINK_SELECTOR,
) -> list[dict[str, Any]]:
    soup = BeautifulSoup(html, "html.parser")
    items: list[dict[str, Any]] = []
    seen: set[str] = set()
    for link in soup.select(link_selector):
        url = urljoin(news_url, str(link.get("href", "")))
        external_id = _external_id(url)
        if not external_id or external_id in seen:
            continue
        date = _extract_date(link.get_text(" ", strip=True))
        title = _extract_title(link)
        if not title or date is None:
            continue
        seen.add(external_id)
        items.append(_raw_item(link, external_id, title, date, url, news_url))
        if len(items) >= max(0, limit):
            break
    return items


def parse_article_html(
    html: str,
    page_url: str,
    *,
    article_selectors: tuple[str, ...] = DEFAULT_ARTICLE_SELECTORS,
) -> tuple[str, list[str]]:
    soup = BeautifulSoup(html, "html.parser")
    content = next(
        (
            node
            for selector in article_selectors
            if (node := soup.select_one(selector)) is not None
        ),
        None,
    )
    if content is None:
        raise ValueError("Official article page did not contain article content")
    for node in content.select("script, style, nav, form"):
        node.decompose()
    images = [
        urljoin(page_url, str(image.get("src") or image.get("data-src")))
        for image in content.select("img")
        if image.get("src") or image.get("data-src")
    ]
    return content.decode_contents().strip(), images


def _external_id(url: str) -> str:
    parts = [part for part in urlparse(url).path.split("/") if part]
    return parts[-1] if parts else ""


def _extract_date(text: str) -> datetime | None:
    match = _DATE_PATTERN.search(text)
    if match is None:
        return None
    try:
        return datetime.strptime(match.group(1), "%d.%m.%Y")
    except ValueError:
        return None


def _extract_title(link: Any) -> str:
    selectors = (
        "[class*='title']",
        "h2",
        "h3",
        "h4",
        ".events-block-body",
    )
    for selector in selectors:
        node = link.select_one(selector)
        if node is not None:
            title = node.get_text(" ", strip=True)
            if title:
                return title
    attribute_title = str(link.get("title") or "").strip()
    if attribute_title:
        return attribute_title
    text = link.get_text(" ", strip=True)
    text = _DATE_PATTERN.sub("", text)
    text = re.sub(r"(?:^|\s)#[^\s#]+", " ", text)
    return " ".join(text.split())


def _raw_item(
    link: Any,
    external_id: str,
    title: str,
    published_at: datetime,
    url: str,
    news_url: str,
) -> dict[str, Any]:
    image = link.select_one("img")
    image_url = ""
    if image is not None:
        image_url = urljoin(
            news_url, str(image.get("src") or image.get("data-src") or "")
        )
    return {
        "ID": external_id,
        "NAME": title,
        "DATE_ACTIVE_FROM": published_at.strftime("%d.%m.%Y 00:00:00"),
        "DETAIL_TEXT": "",
        "DETAIL_PICTURE": image_url,
        "PROPERTY_MY_GALLERY_VALUE": [],
        "DETAIL_PAGE_URL": url,
        "url": url,
    }


class OfficialNewsFetcher(SocialMediaClient):
    def __init__(self, config: Settings, source: OfficialNewsSource):
        super().__init__(
            name=f"{source.name} Official News Fetcher",
            client_type="official_news",
            auto_sync_enabled=True,
            auto_register_sources=True,
        )
        self.config = config
        self.source = source
        self.session: aiohttp.ClientSession | None = None

    @classmethod
    def create_from_config(
        cls,
        config: Settings,
        source: OfficialNewsSource,
    ) -> "OfficialNewsFetcher":
        return cls(config, source)

    @property
    def is_configured(self) -> bool:
        return True

    def get_default_sources(self) -> list[dict[str, Any]]:
        return [
            {
                "source_id": self.source.external_id,
                "source_name": self.source.name,
                "description": f"Новости официального сайта {self.source.name}",
                "category": self.source.category,
            }
        ]

    async def initialize(self) -> None:
        if self.session is None or self.session.closed:
            timeout = aiohttp.ClientTimeout(total=self.config.CLIENT_TIMEOUT)
            self.session = aiohttp.ClientSession(
                timeout=timeout,
                headers={"User-Agent": "university-content-fetcher/1.0"},
            )
        self._initialized = True

    async def close(self) -> None:
        if self.session is not None:
            await self.session.close()
        self._initialized = False

    @classmethod
    def can_handle_url(cls, url: str) -> bool:
        parsed = urlparse(url)
        return parsed.scheme in {"http", "https"} and parsed.hostname is not None

    @classmethod
    def extract_source_id_from_url(cls, url: str) -> str | None:
        return None

    async def validate_source(self, source_id: str) -> bool:
        return source_id == self.source.external_id

    async def get_source_info(self, source_id: str) -> dict[str, Any]:
        if not await self.validate_source(source_id):
            return {}
        return {
            "id": self.source.external_id,
            "name": self.source.name,
            "description": f"Новости официального сайта {self.source.name}",
            "url": self.source.url,
        }

    async def fetch_raw_data(
        self,
        source_id: str,
        limit: int = 20,
        **_: Any,
    ) -> list[dict[str, Any]]:
        if source_id != self.source.external_id or self.session is None:
            return []
        try:
            async with self.session.get(
                self.source.url,
                proxy=self.config.PROXY_URL,
            ) as response:
                response.raise_for_status()
                items = parse_news_html(
                    await response.text(),
                    limit,
                    news_url=self.source.url,
                    link_selector=self.source.link_selector,
                )
                if not items:
                    raise ValueError("Official news page did not contain news cards")
            return await asyncio.gather(*(self._enrich_item(item) for item in items))
        except (aiohttp.ClientError, TimeoutError) as error:
            logger.error("Failed to fetch official news: {}", error)
            raise

    async def _enrich_item(self, item: dict[str, Any]) -> dict[str, Any]:
        if self.session is None:
            raise RuntimeError("Official news client is not initialized")
        async with self.session.get(
            str(item["url"]),
            proxy=self.config.PROXY_URL,
        ) as response:
            response.raise_for_status()
            content, images = parse_article_html(
                await response.text(),
                str(item["url"]),
                article_selectors=self.source.article_selectors,
            )
        return {
            **item,
            "DETAIL_TEXT": content,
            "PROPERTY_MY_GALLERY_VALUE": images,
        }
