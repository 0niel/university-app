import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Self
from urllib.parse import urlparse

from pydantic import field_validator, model_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


@dataclass(frozen=True, slots=True)
class OfficialNewsSource:
    external_id: str
    name: str
    url: str
    category: str
    link_selector: str
    article_selectors: tuple[str, ...]


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=str(Path(__file__).resolve().parents[1] / ".env"),
        env_file_encoding="utf-8",
        extra="ignore",
    )

    TELEGRAM_API_ID: int | None = None
    TELEGRAM_API_HASH: str | None = None
    TELEGRAM_SESSION_STRING: str | None = None
    TELEGRAM_AUTO_SYNC: bool = True
    TELEGRAM_CHANNELS: str = ""
    TELEGRAM_STORY_CHANNELS: str = ""
    CONTENT_SOURCES: str = ""

    SUPABASE_URL: str | None = None
    SUPABASE_INGEST_KEY: str | None = None
    APP_ORGANIZATION_ID: str = "example-university"
    MIREA_ENABLED: bool = False
    OFFICIAL_NEWS_ENABLED: bool = False
    OFFICIAL_NEWS_URL: str = ""
    OFFICIAL_NEWS_SOURCE_ID: str = "official"
    OFFICIAL_NEWS_SOURCE_NAME: str = ""
    OFFICIAL_NEWS_CATEGORY: str = "university"
    OFFICIAL_NEWS_LINK_SELECTOR: str = 'a[href*="/news/"]'
    OFFICIAL_NEWS_ARTICLE_SELECTORS: str = (
        "article,.news-detail,.detail-text,main [class*='content'],main"
    )

    MAX_MESSAGES_PER_REQUEST: int = 30
    TELEGRAM_BATCH_SIZE: int = 30
    TELEGRAM_BOOTSTRAP_LIMIT: int = 30
    TELEGRAM_MAX_ITEMS_PER_CYCLE: int = 300
    TELEGRAM_RECONCILE_MESSAGES: int = 10
    MAX_POSTS_PER_REQUEST: int = 30
    SYNC_INTERVAL_MINUTES: int = 30

    MAX_FILE_SIZE_MB: int = 50

    PROXY_URL: str | None = None
    CLIENT_TIMEOUT: int = 30
    HEALTH_STATUS_PATH: str = "/tmp/content-fetcher-health.json"
    HEALTH_MAX_AGE_SECONDS: int = 3660

    @field_validator("TELEGRAM_API_ID", mode="before")
    @classmethod
    def validate_telegram_api_id(cls, value: Any) -> int | None:
        if value in (None, ""):
            return None
        try:
            return int(value)
        except (TypeError, ValueError):
            return None

    @field_validator("APP_ORGANIZATION_ID")
    @classmethod
    def validate_organization_id(cls, value: str) -> str:
        organization_id = value.strip()
        if not organization_id:
            raise ValueError("APP_ORGANIZATION_ID must not be empty")
        return organization_id

    @field_validator(
        "TELEGRAM_BATCH_SIZE",
        "TELEGRAM_BOOTSTRAP_LIMIT",
        "TELEGRAM_MAX_ITEMS_PER_CYCLE",
        "TELEGRAM_RECONCILE_MESSAGES",
    )
    @classmethod
    def validate_positive_limit(cls, value: int) -> int:
        if value <= 0:
            raise ValueError("Telegram synchronization limits must be positive")
        return value

    @model_validator(mode="after")
    def validate_official_news_provider_scope(self) -> Self:
        if self.MIREA_ENABLED and self.APP_ORGANIZATION_ID != "mirea":
            raise ValueError(
                "MIREA_ENABLED can only be used with APP_ORGANIZATION_ID=mirea"
            )
        if self.MIREA_ENABLED and self.OFFICIAL_NEWS_ENABLED:
            raise ValueError(
                "MIREA_ENABLED and OFFICIAL_NEWS_ENABLED cannot be used together"
            )
        if self.OFFICIAL_NEWS_ENABLED:
            self._validate_official_news_source()
        return self

    @property
    def telegram_channels(self) -> list[str]:
        return self._csv(self.TELEGRAM_CHANNELS)

    @property
    def telegram_story_channels(self) -> list[str]:
        return self._csv(self.TELEGRAM_STORY_CHANNELS)

    @property
    def content_sources(self) -> list[dict[str, Any]]:
        if not self.CONTENT_SOURCES.strip():
            return []
        try:
            value = json.loads(self.CONTENT_SOURCES)
        except json.JSONDecodeError as error:
            raise ValueError("CONTENT_SOURCES must contain a JSON array") from error
        if not isinstance(value, list) or not all(
            isinstance(item, dict) for item in value
        ):
            raise ValueError("CONTENT_SOURCES must contain a JSON array of objects")
        return value

    @staticmethod
    def _csv(value: str) -> list[str]:
        return [item.strip().lstrip("@") for item in value.split(",") if item.strip()]

    @property
    def telegram_configured(self) -> bool:
        return bool(
            self.TELEGRAM_API_ID
            and self.TELEGRAM_API_HASH
            and self.TELEGRAM_SESSION_STRING
        )

    @property
    def ingest_configured(self) -> bool:
        return bool(self.SUPABASE_URL and self.SUPABASE_INGEST_KEY)

    @property
    def official_news_enabled(self) -> bool:
        return self.MIREA_ENABLED or self.OFFICIAL_NEWS_ENABLED

    @property
    def official_news_source(self) -> OfficialNewsSource:
        if self.MIREA_ENABLED:
            return OfficialNewsSource(
                external_id="mirea-official",
                name="РТУ МИРЭА",
                url="https://www.mirea.ru/news/",
                category="university",
                link_selector='a[href*="/news/"]',
                article_selectors=(
                    "article",
                    ".news-detail",
                    ".detail-text",
                    "main [class*='content']",
                    "main",
                ),
            )
        return OfficialNewsSource(
            external_id=self.OFFICIAL_NEWS_SOURCE_ID.strip(),
            name=self.OFFICIAL_NEWS_SOURCE_NAME.strip(),
            url=self.OFFICIAL_NEWS_URL.strip(),
            category=self.OFFICIAL_NEWS_CATEGORY.strip(),
            link_selector=self.OFFICIAL_NEWS_LINK_SELECTOR.strip(),
            article_selectors=tuple(self._csv(self.OFFICIAL_NEWS_ARTICLE_SELECTORS)),
        )

    def _validate_official_news_source(self) -> None:
        source = self.official_news_source
        parsed = urlparse(source.url)
        if (
            parsed.scheme != "https"
            or not parsed.netloc
            or parsed.username is not None
            or parsed.password is not None
        ):
            raise ValueError("OFFICIAL_NEWS_URL must be an HTTPS URL")
        if not source.name:
            raise ValueError("OFFICIAL_NEWS_SOURCE_NAME must not be empty")
        if not source.link_selector:
            raise ValueError("OFFICIAL_NEWS_LINK_SELECTOR must not be empty")
        if not source.article_selectors:
            raise ValueError("OFFICIAL_NEWS_ARTICLE_SELECTORS must not be empty")
        for value, name in (
            (source.external_id, "OFFICIAL_NEWS_SOURCE_ID"),
            (source.category, "OFFICIAL_NEWS_CATEGORY"),
        ):
            if not value or not value.replace("_", "").replace("-", "").isalnum():
                raise ValueError(
                    f"{name} must contain only letters, digits, '-' or '_'"
                )
