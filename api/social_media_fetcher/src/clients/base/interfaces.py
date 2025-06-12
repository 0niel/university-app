"""Abstract base classes and protocols for social media clients."""

from abc import ABC, abstractmethod
from typing import Any, Dict, List, Optional

from ...models import SocialMediaPost


class SocialMediaClient(ABC):
    """Abstract base class for social media clients."""

    def __init__(self, name: str, client_type: str, auto_sync_enabled: bool = True):
        """Initialize the client with a name and type."""
        self.name = name
        self.client_type = client_type
        self.auto_sync_enabled = auto_sync_enabled
        self._initialized = False

    @property
    @abstractmethod
    def is_configured(self) -> bool:
        """Check if the client is properly configured."""
        pass

    @abstractmethod
    async def initialize(self) -> None:
        """Initialize the client."""
        pass

    @abstractmethod
    async def close(self) -> None:
        """Close the client and cleanup resources."""
        pass

    @abstractmethod
    async def fetch_posts(
        self, source_id: str, limit: int = 20, **kwargs
    ) -> List[SocialMediaPost]:
        """Fetch posts from a source and return them in unified format."""
        pass

    @abstractmethod
    async def get_source_info(self, source_id: str) -> Dict[str, Any]:
        """Get information about a source."""
        pass

    @abstractmethod
    async def validate_source(self, source_id: str) -> bool:
        """Validate if a source exists and is accessible."""
        pass

    def __str__(self) -> str:
        """String representation of the client."""
        return f"{self.name} ({self.client_type})" 