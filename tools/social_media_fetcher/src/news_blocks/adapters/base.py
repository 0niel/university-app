"""Base adapter for converting social media data to news blocks."""

from abc import ABC, abstractmethod
from typing import Any

from ..models import NewsBlock


class SocialMediaToNewsBlocksAdapter(ABC):
    """Abstract adapter for converting social media data directly to news blocks."""

    @abstractmethod
    def adapt_post_data(self, raw_data: dict[str, Any]) -> list[NewsBlock]:
        """Convert raw social media data to news blocks."""
        raise NotImplementedError

    @abstractmethod
    def get_source_type(self) -> str:
        """Get the source type identifier (for example, telegram or website)."""
        raise NotImplementedError
