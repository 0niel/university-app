"""Pydantic models for the social media fetcher service."""

from datetime import datetime
from typing import Any, Dict, List, Optional, Union

from pydantic import BaseModel, Field, validator


class TelegramChannelInfo(BaseModel):
    """Information about a Telegram channel."""

    id: int
    username: str
    title: str
    description: Optional[str] = None
    participants_count: Optional[int] = None
    photo_url: Optional[str] = None
    is_verified: bool = False
    is_scam: bool = False
    is_fake: bool = False
    is_restricted: bool = False


class TelegramMedia(BaseModel):
    """Telegram media attachment with improved structure."""

    type: str
    file_id: str
    file_unique_id: str
    width: Optional[int] = None
    height: Optional[int] = None
    duration: Optional[int] = None
    file_size: Optional[int] = None
    mime_type: Optional[str] = None
    file_name: Optional[str] = None
    caption: Optional[str] = None
    url: Optional[str] = None
    thumbnail_url: Optional[str] = None


class TelegramEntity(BaseModel):
    """Telegram message entity (formatting, links, etc.)."""

    type: str
    offset: int
    length: int
    url: Optional[str] = None
    user_id: Optional[int] = None
    language: Optional[str] = None


class TelegramMessage(BaseModel):
    """Improved Telegram message model."""

    id: int
    date: datetime
    text: str

    views: Optional[int] = None
    forwards: Optional[int] = None
    replies: Optional[int] = None

    edit_date: Optional[datetime] = None
    from_id: Optional[int] = None
    chat_id: Optional[int] = None

    media: List[TelegramMedia] = []
    entities: List[TelegramEntity] = []

    reply_to_message_id: Optional[int] = None


class VKGroupInfo(BaseModel):
    """Information about a VK group."""

    id: int
    name: str
    screen_name: str
    description: Optional[str] = None
    members_count: Optional[int] = None
    photo_url: Optional[str] = None
    is_closed: bool = False
    is_verified: bool = False
    activity: Optional[str] = None


class VKAttachment(BaseModel):
    """VK post attachment."""

    type: str
    url: Optional[str] = None
    width: Optional[int] = None
    height: Optional[int] = None
    title: Optional[str] = None
    description: Optional[str] = None
    duration: Optional[int] = None
    file_size: Optional[int] = None


class VKPost(BaseModel):
    """VK post model."""

    id: int
    owner_id: int
    from_id: int
    date: datetime
    text: str
    attachments: List[VKAttachment] = []
    likes_count: Optional[int] = None
    comments_count: Optional[int] = None
    reposts_count: Optional[int] = None
    views_count: Optional[int] = None
    is_pinned: bool = False
    is_marked_as_ads: bool = False
    post_type: Optional[str] = None
    copy_history: List[Dict[str, Any]] = []


class AddSourceRequest(BaseModel):
    """Request model for adding a new source."""

    source_type: str = Field(..., description="Source type (telegram, vk)")
    source_id: str = Field(
        ..., description="Source identifier (channel username, group ID)"
    )
    source_name: str = Field(..., description="Display name of the source")
    source_url: Optional[str] = Field(default="", description="URL to the source")
    category: Optional[str] = Field(default="", description="Source category")
    description: Optional[str] = Field(default="", description="Source description")

    @validator("source_type")
    def validate_source_type(cls, v):
        if v not in ["telegram", "vk"]:
            raise ValueError('source_type must be either "telegram" or "vk"')
        return v


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
    by_source: List[Dict[str, Any]]
    last_updated: datetime


class SocialMediaPost(BaseModel):
    """Unified model for social media posts from any platform."""

    id: str
    source_type: str
    source_id: str
    source_name: str
    title: str
    content: str
    published_at: datetime
    original_url: str

    image_urls: List[str] = []
    video_urls: List[str] = []

    tags: List[str] = []

    likes_count: Optional[int] = None
    comments_count: Optional[int] = None
    shares_count: Optional[int] = None
    views_count: Optional[int] = None

    author_name: Optional[str] = None
    author_url: Optional[str] = None
