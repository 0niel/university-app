"""Base adapter for converting social media data to news blocks."""

from abc import ABC, abstractmethod
from typing import Any, Dict, List

# Import generated models lazily-safe
try:
    from ..models import NewsBlock
    MODELS_AVAILABLE = True
except Exception:
    MODELS_AVAILABLE = False
    NewsBlock = object  # type: ignore


class SocialMediaToNewsBlocksAdapter(ABC):
    """Abstract adapter for converting social media data directly to news blocks."""

    @abstractmethod
    def adapt_post_data(self, raw_data: Dict[str, Any]) -> List[NewsBlock]:
        """Convert raw social media data to news blocks."""
        raise NotImplementedError

    @abstractmethod
    def get_source_type(self) -> str:
        """Get the source type identifier (e.g., telegram, vk, mirea)."""
        raise NotImplementedError
