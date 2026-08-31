"""Pydantic models for Telegram client."""

from datetime import datetime

from pydantic import BaseModel


class TelegramChannelInfo(BaseModel):
    """Information about a Telegram channel."""

    id: int
    username: str
    title: str
    description: str | None = None
    participants_count: int | None = None
    photo_url: str | None = None
    is_verified: bool = False
    is_scam: bool = False
    is_fake: bool = False
    is_restricted: bool = False


class TelegramMedia(BaseModel):
    """Telegram media attachment with improved structure."""

    type: str
    file_id: str
    file_unique_id: str
    width: int | None = None
    height: int | None = None
    duration: int | None = None
    file_size: int | None = None
    mime_type: str | None = None
    file_name: str | None = None
    caption: str | None = None
    url: str | None = None
    thumbnail_url: str | None = None


class TelegramEntity(BaseModel):
    """Telegram message entity (formatting, links, etc.)."""

    type: str
    offset: int
    length: int
    url: str | None = None
    user_id: int | None = None
    language: str | None = None


class TelegramMessage(BaseModel):
    """Improved Telegram message model."""

    id: int
    date: datetime
    text: str

    views: int | None = None
    forwards: int | None = None
    replies: int | None = None

    edit_date: datetime | None = None
    from_id: int | None = None
    chat_id: int | None = None

    media: list[TelegramMedia] = []
    entities: list[TelegramEntity] = []

    reply_to_message_id: int | None = None
