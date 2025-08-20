"""Abstract base classes and protocols for social media clients."""

from abc import ABC, abstractmethod
from typing import Any, Dict, List, Optional, TYPE_CHECKING

if TYPE_CHECKING:
    from ...media_storage import MediaStorage

# Import news blocks models
try:
    from ...news_blocks.models import NewsBlock
    BLOCKS_AVAILABLE = True
except ImportError:
    BLOCKS_AVAILABLE = False
    NewsBlock = None


class SocialMediaClient(ABC):
    """Abstract base class for social media clients."""

    def __init__(self, name: str, client_type: str, auto_sync_enabled: bool = True, auto_register_sources: bool = False):
        """Initialize the client with a name and type."""
        self.name = name
        self.client_type = client_type
        self.auto_sync_enabled = auto_sync_enabled
        self.auto_register_sources = auto_register_sources
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

    def get_default_sources(self) -> List[Dict[str, Any]]:
        """
        Get default sources that should be automatically registered for this client.
        
        Override this method in subclasses that need automatic source registration.
        
        Returns:
            List of source dictionaries with keys: source_id, source_name, description, category
        """
        return []

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
    ) -> List[Any]:
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

    async def upload_platform_media(
        self,
        *,
        source_id: str,
        external_id: str,
        media_identifier: str,
        media_type: str,
        storage: "MediaStorage",
        source_info: Dict[str, Any],
    ) -> Optional[str]:
        """Upload platform-specific media and return a public URL.

        Default implementation returns None. Clients that support platform media
        resolution (e.g., Telegram) should override this.
        """
        return None

    async def finalize_block_media_fields(
        self,
        *,
        blocks: List[Dict[str, Any]],
        source_type: str,
        source_id: str,
        external_id: str,
        storage: "MediaStorage",
    ) -> List[Dict[str, Any]]:
        """Client-specific hook to resolve media fields in news blocks.

        The default implementation is a no-op. Clients can override to transform
        platform-specific media identifiers into final public URLs by using
        `upload_platform_media` or their own logic.
        """
        return blocks

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
            f"auto_register_sources={self.auto_register_sources}, "
            f"initialized={self._initialized})"
        ) 
