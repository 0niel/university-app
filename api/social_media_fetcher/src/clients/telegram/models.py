"""Pydantic models for Telegram client."""

from datetime import datetime
from typing import Any, Dict, List, Optional

from pydantic import BaseModel


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