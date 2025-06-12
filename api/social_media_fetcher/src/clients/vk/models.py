"""Pydantic models for VK client."""

from datetime import datetime
from typing import Any, Dict, List, Optional

from pydantic import BaseModel


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