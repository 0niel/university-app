"""Base classes for news blocks."""

from abc import ABC, abstractmethod
from datetime import datetime
from typing import Any, Dict, List, Optional, ClassVar
from enum import Enum

from pydantic import BaseModel, Field, ConfigDict


class NewsBlock(BaseModel, ABC):
    """Base class for all news blocks."""
    
    model_config = ConfigDict(
        populate_by_name=True,
        use_enum_values=True
    )
    
    type: str = Field(..., description="Block type identifier")
    
    @classmethod
    @abstractmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        pass


class PostBlock(NewsBlock, ABC):
    """Base class for post blocks."""
    
    id: str = Field(..., description="Post ID")
    category_id: str = Field(..., alias="category_id", description="Category ID")
    author: str = Field(..., description="Author name")
    published_at: datetime = Field(..., alias="published_at", description="Publication date")
    title: str = Field(..., description="Post title")
    image_url: Optional[str] = Field(None, alias="image_url", description="Image URL")
    description: Optional[str] = Field(None, description="Post description")
    action: Optional[Dict[str, Any]] = Field(None, description="Block action")
    is_content_overlaid: bool = Field(False, alias="is_content_overlaid", description="Content overlay flag")


# Enums from Dart
class BannerSize(str, Enum):
    """Banner size enumeration."""
    NORMAL = "normal"
    LARGE = "large"
    EXTRA_LARGE = "extraLarge"
    ANCHORED_ADAPTIVE = "anchoredAdaptive"


class Spacing(str, Enum):
    """Spacing enumeration."""
    EXTRA_SMALL = "extraSmall"
    SMALL = "small"
    MEDIUM = "medium"
    LARGE = "large"
    VERY_LARGE = "veryLarge"
    EXTRA_LARGE = "extraLarge"


class TextCaptionColor(str, Enum):
    """Text caption color enumeration."""
    NORMAL = "normal"
    LIGHT = "light"


class BlockActionType(str, Enum):
    """Block action type enumeration."""
    NAVIGATION = "navigation"
    UNKNOWN = "unknown"


# Block action classes
class BlockAction(BaseModel, ABC):
    """Base class for block actions."""
    
    model_config = ConfigDict(populate_by_name=True)
    
    type: str = Field(..., description="Action type")
    action_type: BlockActionType = Field(..., description="Action type enum")


class UnknownBlock(NewsBlock):
    """Unknown block type."""
    
    IDENTIFIER: ClassVar[str] = "__unknown__"
    
    type: str = Field(default="__unknown__", description="Block type")
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER