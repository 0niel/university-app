"""Abstract base classes and protocols for social media clients and services."""

from abc import ABC, abstractmethod
from datetime import datetime
from typing import Any, Dict, List, Optional, Protocol

from .models import SocialMediaPost


class SocialMediaClient(ABC):
    """Abstract base class for social media clients."""

    def __init__(self, name: str, client_type: str):
        """Initialize the client with a name and type."""
        self.name = name
        self.client_type = client_type
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


class MediaProcessor(ABC):
    """Abstract base class for media processors."""

    @abstractmethod
    async def process_media_urls(
        self,
        media_urls: List[str],
        media_type: str,
        source_info: Dict[str, Any],
        client: Optional[SocialMediaClient] = None,
    ) -> List[str]:
        """Process media URLs and return storage URLs."""
        pass

    @abstractmethod
    async def download_and_store_file(
        self,
        url: str,
        file_type: str = "image",
        source_info: Optional[Dict[str, Any]] = None,
        client: Optional[SocialMediaClient] = None,
    ) -> Optional[str]:
        """Download and store a single file."""
        pass


class DatabaseClient(ABC):
    """Abstract base class for database clients."""

    @abstractmethod
    async def initialize(self) -> None:
        """Initialize the database client."""
        pass

    @abstractmethod
    async def close(self) -> None:
        """Close the database client."""
        pass

    @abstractmethod
    async def save_social_news_item(self, post: SocialMediaPost) -> bool:
        """Save a social media post to the database."""
        pass

    @abstractmethod
    async def get_latest_news(
        self,
        limit: int = 20,
        offset: int = 0,
        source_type: Optional[str] = None,
        source_id: Optional[str] = None,
        category: Optional[str] = None,
    ) -> List[Dict[str, Any]]:
        """Get latest news from the database."""
        pass

    @abstractmethod
    async def add_source(
        self, source_type: str, source_id: str, source_name: str, **kwargs
    ) -> Dict[str, Any]:
        """Add a new source to the database."""
        pass

    @abstractmethod
    async def get_active_sources(self) -> List[Dict[str, Any]]:
        """Get all active sources from the database."""
        pass


class Scheduler(ABC):
    """Abstract base class for schedulers."""

    @abstractmethod
    async def start(self) -> None:
        """Start the scheduler."""
        pass

    @abstractmethod
    async def stop(self) -> None:
        """Stop the scheduler."""
        pass

    @abstractmethod
    async def get_status(self) -> Dict[str, Any]:
        """Get scheduler status."""
        pass


class ServiceRegistryProtocol(Protocol):
    """Protocol for service registry."""

    def register_client(self, client_type: str, client: SocialMediaClient) -> None:
        """Register a social media client."""
        ...

    def get_client(self, client_type: str) -> Optional[SocialMediaClient]:
        """Get a registered client by type."""
        ...

    def get_all_clients(self) -> Dict[str, SocialMediaClient]:
        """Get all registered clients."""
        ...

    def register_service(self, service_name: str, service: Any) -> None:
        """Register a service."""
        ...

    def get_service(self, service_name: str) -> Optional[Any]:
        """Get a registered service."""
        ...


class Configuration(ABC):
    """Abstract base class for configuration."""

    @abstractmethod
    def get_client_config(self, client_type: str) -> Dict[str, Any]:
        """Get configuration for a specific client type."""
        pass

    @abstractmethod
    def is_client_enabled(self, client_type: str) -> bool:
        """Check if a client type is enabled."""
        pass

    @abstractmethod
    def get_database_config(self) -> Dict[str, Any]:
        """Get database configuration."""
        pass

    @abstractmethod
    def get_scheduler_config(self) -> Dict[str, Any]:
        """Get scheduler configuration."""
        pass
