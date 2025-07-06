"""Abstract base classes and protocols for social media clients."""

from abc import ABC, abstractmethod
from typing import Any, Dict, List, Optional

# Import news blocks models
try:
    from ...news_blocks.models import NewsBlock
    BLOCKS_AVAILABLE = True
except ImportError:
    BLOCKS_AVAILABLE = False
    NewsBlock = None


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

    @property
    def is_initialized(self) -> bool:
        """Check if the client is initialized."""
        return self._initialized

    @abstractmethod
    async def initialize(self) -> None:
        """Initialize the client."""
        pass

    @abstractmethod
    async def close(self) -> None:
        """Close the client and clean up resources."""
        pass

    @classmethod
    @abstractmethod
    def can_handle_url(cls, url: str) -> bool:
        """
        Check if this client can handle the given URL.
        
        Args:
            url: The URL to check
            
        Returns:
            True if this client can handle the URL, False otherwise
        """
        pass

    @classmethod
    @abstractmethod
    def extract_source_id_from_url(cls, url: str) -> Optional[str]:
        """
        Extract source ID from URL.
        
        Args:
            url: The URL to extract source ID from
            
        Returns:
            The extracted source ID or None if extraction failed
        """
        pass

    @abstractmethod
    async def fetch_raw_data(
        self, source_id: str, limit: int = 20, **kwargs
    ) -> List[Dict[str, Any]]:
        """
        Fetch raw data from a social media source.

        Args:
            source_id: The identifier of the source (channel, group, etc.)
            limit: Maximum number of items to fetch
            **kwargs: Additional parameters specific to the client

        Returns:
            List of raw data dictionaries
        """
        pass

    async def fetch_news_blocks(
        self, source_id: str, limit: int = 20, **kwargs
    ) -> List["NewsBlock"]:
        """
        Fetch data from a social media source and return as news blocks.

        Args:
            source_id: The identifier of the source (channel, group, etc.)
            limit: Maximum number of items to fetch
            **kwargs: Additional parameters specific to the client

        Returns:
            List of NewsBlock objects
        """
        if not BLOCKS_AVAILABLE:
            return []
        
        # Default implementation: fetch raw data and convert to blocks
        # Subclasses can override this for more efficient implementations
        raw_data_list = await self.fetch_raw_data(source_id, limit, **kwargs)
        
        # This would need to be implemented by each client with their specific adapter
        return []

    @abstractmethod
    async def get_source_info(self, source_id: str) -> Dict[str, Any]:
        """
        Get information about a social media source.

        Args:
            source_id: The identifier of the source

        Returns:
            Dictionary with source information
        """
        pass

    @abstractmethod
    async def validate_source(self, source_id: str) -> bool:
        """
        Validate if a source exists and is accessible.

        Args:
            source_id: The identifier of the source

        Returns:
            True if the source is valid and accessible, False otherwise
        """
        pass

    def __str__(self) -> str:
        """String representation of the client."""
        return f"{self.name} ({self.client_type})"

    def __repr__(self) -> str:
        """Detailed string representation of the client."""
        return (
            f"{self.__class__.__name__}("
            f"name='{self.name}', "
            f"client_type='{self.client_type}', "
            f"auto_sync_enabled={self.auto_sync_enabled}, "
            f"initialized={self._initialized})"
        ) 
