from datetime import datetime
from typing import Any

from pydantic import BaseModel, ConfigDict, Field, HttpUrl, model_validator


class ContentSource(BaseModel):
    model_config = ConfigDict(extra="forbid", frozen=True)

    id: str = Field(pattern=r"^[a-z0-9][a-z0-9_-]*$")
    provider: str = Field(pattern=r"^[a-z0-9][a-z0-9_-]*$")
    name: str = Field(min_length=1, max_length=160)
    source_url: HttpUrl
    feed_url: HttpUrl | None = None
    category: str = Field(default="university", min_length=1, max_length=64)
    metadata: dict[str, Any] = Field(default_factory=dict)

    @model_validator(mode="after")
    def validate_provider_configuration(self) -> "ContentSource":
        if self.provider in {"json", "rss"} and self.feed_url is None:
            raise ValueError(f"{self.provider} source requires feed_url")
        if self.provider == "json":
            JsonFeedMapping.model_validate(self.metadata)
        return self


class JsonFeedMapping(BaseModel):
    model_config = ConfigDict(extra="forbid", frozen=True)

    items_path: str = Field(min_length=1, max_length=160)
    id_path: str | None = Field(default=None, max_length=160)
    title_path: str = Field(min_length=1, max_length=160)
    url_path: str = Field(min_length=1, max_length=160)
    published_at_path: str | None = Field(default=None, max_length=160)
    summary_path: str | None = Field(default=None, max_length=160)
    html_path: str | None = Field(default=None, max_length=160)


class NormalizedContent(BaseModel):
    model_config = ConfigDict(frozen=True)

    external_id: str = Field(min_length=1, max_length=512)
    title: str = Field(min_length=1, max_length=500)
    published_at: datetime
    original_url: HttpUrl
    summary: str | None = None
    html: str | None = None
    raw_data: dict[str, Any] = Field(default_factory=dict)
    metadata: dict[str, Any] = Field(default_factory=dict)
