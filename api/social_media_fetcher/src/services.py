"""Typed services for dependency injection."""

from typing import Dict, Optional, Protocol

from .clients.base.interfaces import SocialMediaClient
from .interfaces import DatabaseClient, MediaProcessor
from .media_storage import MediaStorage
from .supabase_client import SupabaseNewsClient


class DatabaseService(Protocol):
    """Protocol for database service."""

    async def initialize(self) -> None: ...
    async def close(self) -> None: ...
    async def save_social_news_item(self, post) -> bool: ...
    async def get_active_sources(self) -> list: ...
    async def add_source(self, **kwargs) -> dict: ...
    async def get_sources(self, **kwargs) -> list: ...
    async def update_source(self, source_id: int, **kwargs) -> dict: ...
    async def delete_source(self, source_id: int) -> bool: ...
    async def get_latest_news(self, **kwargs) -> list: ...
    async def get_statistics(self) -> dict: ...
    async def get_scheduler_config(self) -> dict: ...
    async def update_scheduler_config(self, **kwargs) -> bool: ...
    async def get_status(self) -> dict: ...


class MediaStorageService(Protocol):
    """Protocol for media storage service."""

    async def initialize(self) -> None: ...
    async def close(self) -> None: ...
    async def process_media_urls(self, urls: list, file_type: str, **kwargs) -> list: ...
    async def download_and_store_file(self, url: str, **kwargs) -> Optional[str]: ...


class ClientRegistry:
    """Typed registry for social media clients."""

    def __init__(self):
        self._clients: Dict[str, SocialMediaClient] = {}

    def register_client(self, client: SocialMediaClient) -> None:
        """Register a social media client."""
        self._clients[client.client_type] = client

    def get_client(self, client_type: str) -> Optional[SocialMediaClient]:
        """Get a client by type."""
        return self._clients.get(client_type)

    def get_all_clients(self) -> Dict[str, SocialMediaClient]:
        """Get all registered clients."""
        return self._clients.copy()

    def get_enabled_clients(self) -> Dict[str, SocialMediaClient]:
        """Get all enabled clients."""
        return {
            client_type: client
            for client_type, client in self._clients.items()
            if client.is_configured
        }

    def get_auto_sync_clients(self) -> Dict[str, SocialMediaClient]:
        """Get clients that have auto sync enabled."""
        return {
            client_type: client
            for client_type, client in self._clients.items()
            if client.is_configured and client.auto_sync_enabled
        }


class ServiceContainer:
    """Container for all services with typed access."""

    def __init__(self):
        self.database: Optional[DatabaseService] = None
        self.media_storage: Optional[MediaStorageService] = None
        self.client_registry = ClientRegistry()

    async def initialize_all(self) -> None:
        """Initialize all services."""
        if self.database:
            await self.database.initialize()

        if self.media_storage:
            await self.media_storage.initialize()

        # Initialize all clients
        for client in self.client_registry.get_all_clients().values():
            if client.is_configured and not client._initialized:
                try:
                    await client.initialize()
                except Exception as e:
                    from loguru import logger
                    logger.warning(f"Failed to initialize {client}: {e}")

    async def close_all(self) -> None:
        """Close all services."""
        if self.database:
            await self.database.close()

        if self.media_storage:
            await self.media_storage.close()

        # Close all clients
        for client in self.client_registry.get_all_clients().values():
            if client._initialized:
                await client.close() 
