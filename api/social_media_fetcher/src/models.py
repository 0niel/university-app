"""Pydantic models for the social media fetcher service."""

from datetime import datetime
from typing import Any, Dict, List, Optional, Union
from urllib.parse import urlparse

from pydantic import BaseModel, Field, validator, root_validator


class AddSourceRequest(BaseModel):
    """Request model for adding a new source."""

    source_url: str = Field(
        ..., 
        description="URL to the source (e.g., https://t.me/channel or https://vk.com/group)",
        examples=["https://t.me/example_channel", "https://vk.com/example_group"]
    )
    source_name: str = Field(
        ..., 
        description="Display name of the source",
        examples=["Example Channel", "Example VK Group"]
    )
    
    source_type: Optional[str] = Field(
        default=None, 
        description="Source type (automatically detected from URL if not provided)",
        examples=["telegram", "vk"]
    )
    source_id: Optional[str] = Field(
        default=None, 
        description="Source identifier (automatically extracted from URL if not provided)",
        examples=["example_channel", "example_group"]
    )
    category: Optional[str] = Field(
        default="", 
        description="Source category for organization",
        examples=["news", "tech", "entertainment"]
    )
    description: Optional[str] = Field(
        default="", 
        description="Optional description of the source",
        examples=["Technology news channel", "Entertainment group"]
    )
    is_active: bool = Field(
        default=True, 
        description="Whether the source should be actively monitored"
    )

    class Config:
        """Pydantic configuration."""
        json_schema_extra = {
            "example": {
                "source_url": "https://t.me/example_channel",
                "source_name": "Example Channel",
                "category": "news",
                "description": "Technology news channel",
                "is_active": True
            }
        }


class UpdateSourceRequest(BaseModel):
    """Request model for updating a source."""

    source_name: Optional[str] = None
    source_url: Optional[str] = None
    category: Optional[str] = None
    description: Optional[str] = None
    is_active: Optional[bool] = None


class SourceResponse(BaseModel):
    """Response model for source operations."""

    id: str
    source_type: str
    source_id: str
    source_name: str
    source_url: Optional[str] = None
    category: Optional[str] = None
    description: Optional[str] = None
    is_active: bool
    created_at: datetime
    updated_at: datetime
    last_fetched_at: Optional[datetime] = None


class SourcesListResponse(BaseModel):
    """Response model for listing sources."""

    sources: List[SourceResponse]
    total: int


class SchedulerConfigRequest(BaseModel):
    """Request model for scheduler configuration."""

    is_enabled: Optional[bool] = None
    sync_interval_minutes: Optional[int] = Field(None, ge=5, le=1440)


class SchedulerStatusResponse(BaseModel):
    """Response model for scheduler status."""

    is_enabled: bool
    sync_interval_minutes: int
    last_sync_at: Optional[datetime] = None
    next_sync_at: Optional[datetime] = None
    total_synced: int
    errors_count: int


class TelegramChannelRequest(BaseModel):
    """Request model for Telegram channel fetching."""

    username: str = Field(..., description="Channel username (without @)")
    limit: Optional[int] = Field(default=20, ge=1, le=100)


class VKGroupRequest(BaseModel):
    """Request model for VK group fetching."""

    group_id: str = Field(..., description="VK group ID or screen name")
    limit: Optional[int] = Field(default=20, ge=1, le=100)


class FetchRequest(BaseModel):
    """Request model for batch fetching from multiple sources."""

    telegram_channels: List[TelegramChannelRequest] = []
    vk_groups: List[VKGroupRequest] = []

    @validator("telegram_channels", "vk_groups")
    def validate_not_empty(cls, v, values):
        """Ensure at least one source is specified."""
        if not v and not any(
            values.get(field, []) for field in ["telegram_channels", "vk_groups"]
        ):
            raise ValueError("At least one source must be specified")
        return v


class FetchResponse(BaseModel):
    """Response model for fetch operations."""

    success: bool
    total_items: int
    results: List[Dict[str, Any]]
    errors: List[str] = []
    timestamp: datetime = Field(default_factory=datetime.utcnow)


class HealthResponse(BaseModel):
    """Health check response model."""

    status: str
    version: str
    telegram_available: bool
    vk_available: bool
    timestamp: datetime = Field(default_factory=datetime.utcnow)


class ErrorResponse(BaseModel):
    """Error response model."""

    error: str
    detail: Optional[str] = None
    timestamp: datetime = Field(default_factory=datetime.utcnow)


class SyncStatus(BaseModel):
    """Background sync status model."""

    enabled: bool
    last_sync: Optional[datetime] = None
    next_sync: Optional[datetime] = None
    total_synced: int = 0
    errors_count: int = 0
    active_sources: List[str] = []


class SourceConfig(BaseModel):
    """Configuration for a social media source."""

    type: str
    identifier: str
    enabled: bool = True
    sync_interval: Optional[int] = None
    last_sync: Optional[datetime] = None
    error_count: int = 0
    max_items: int = 50


class NewsItemResponse(BaseModel):
    """Response model for news items."""

    id: str
    external_id: str
    source_type: str
    source_id: str
    source_name: str
    title: str
    content: str
    original_url: str
    published_at: datetime
    image_urls: List[str] = []
    video_urls: List[str] = []
    tags: List[str] = []
    likes_count: Optional[int] = None
    comments_count: Optional[int] = None
    shares_count: Optional[int] = None
    views_count: Optional[int] = None
    category: Optional[str] = None
    description: Optional[str] = None
    created_at: datetime
    updated_at: datetime


class NewsListResponse(BaseModel):
    """Response model for news list."""

    items: List[NewsItemResponse]
    total: int
    limit: int
    offset: int
    has_more: bool


class StatisticsResponse(BaseModel):
    """Response model for statistics."""

    total_items: int
    by_source_type: Dict[str, int]
    by_source: Optional[List[Dict[str, Any]]] = []
    last_updated: datetime


class NewsBlocksResponse(BaseModel):
    """Response model for news blocks."""

    items: List[Dict[str, Any]]
    total: int
    limit: int
    offset: int
    has_more: bool


class NewsBlocksStatisticsResponse(BaseModel):
    """Response model for news blocks statistics."""

    total_items: int
    items_with_news_blocks: int
    coverage_percentage: float
    news_blocks_coverage: Dict[str, float]
    by_source_type: Dict[str, int]
    last_updated: datetime
