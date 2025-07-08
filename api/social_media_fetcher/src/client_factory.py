"""Client factory for creating and registering social media clients."""

from typing import Type, Optional, Tuple

from loguru import logger

from .config import Settings
from .clients.base.interfaces import SocialMediaClient
from .clients.telegram import TelegramFetcher
from .clients.vk import VKFetcher
from .clients.mirea import MireaOfficialFetcher
from .registry import ServiceRegistry


class ClientFactory:
    """Factory for creating and registering social media clients."""

    def __init__(self, config: Settings, registry: ServiceRegistry):
        """Initialize the client factory."""
        self.config = config
        self.registry = registry
        self._client_classes = {
            "telegram": TelegramFetcher,
            "vk": VKFetcher,
            "mirea": MireaOfficialFetcher,
        }

    def register_all_available_clients(self) -> None:
        """Register all available clients based on configuration."""
        for client_type, client_class in self._client_classes.items():
            if self.config.is_client_enabled(client_type):
                self._register_client_factory(client_type, client_class)
            else:
                logger.debug(f"Client {client_type} not enabled in configuration: {client_type}")

    def register_client_type(
        self, client_type: str, client_class: Type[SocialMediaClient]
    ) -> None:
        """Register a new client type."""
        self._client_classes[client_type] = client_class

        if self.config.is_client_enabled(client_type):
            self._register_client_factory(client_type, client_class)
            logger.info(f"Registered custom client type: {client_type}")

    def create_client(self, client_type: str) -> SocialMediaClient:
        """Create a client instance directly."""
        if client_type not in self._client_classes:
            raise ValueError(f"Unknown client type: {client_type}")

        client_class = self._client_classes[client_type]

        if hasattr(client_class, "create_from_config"):
            return client_class.create_from_config(self.config)
        else:
            return client_class(self.config)

    def get_available_client_types(self) -> list[str]:
        """Get list of available client types."""
        return list(self._client_classes.keys())

    def get_enabled_client_types(self) -> list[str]:
        """Get list of enabled client types based on configuration."""
        return [
            client_type
            for client_type in self._client_classes.keys()
            if self.config.is_client_enabled(client_type)
        ]

    def detect_source_type_from_url(self, url: str) -> Optional[str]:
        """
        Detect source type from URL by checking all registered clients.
        
        Args:
            url: The URL to check
            
        Returns:
            The source type that can handle this URL, or None if no client can handle it
        """
        for client_type, client_class in self._client_classes.items():
            if hasattr(client_class, 'can_handle_url') and client_class.can_handle_url(url):
                return client_type
        return None

    def extract_source_info_from_url(self, url: str) -> Tuple[Optional[str], Optional[str]]:
        """
        Extract source type and source ID from URL.
        
        Args:
            url: The URL to process
            
        Returns:
            Tuple of (source_type, source_id) or (None, None) if extraction failed
        """
        source_type = self.detect_source_type_from_url(url)
        if not source_type:
            return None, None
        
        client_class = self._client_classes.get(source_type)
        if not client_class or not hasattr(client_class, 'extract_source_id_from_url'):
            return source_type, None
        
        source_id = client_class.extract_source_id_from_url(url)
        return source_type, source_id

    def _register_client_factory(
        self, client_type: str, client_class: Type[SocialMediaClient]
    ) -> None:
        """Register a client factory in the service registry."""

        def factory() -> SocialMediaClient:
            """Factory function for lazy client creation."""
            return self.create_client(client_type)

        factory.__name__ = f"{client_class.__name__}Factory"
        factory.client_class = client_class

        self.registry.register_client_factory(client_type, factory)
        logger.debug(f"Registered factory for client type: {client_type}")


def setup_clients(config: Settings, registry: ServiceRegistry) -> ClientFactory:
    """Setup and register all available clients."""
    factory = ClientFactory(config, registry)
    factory.register_all_available_clients()

    logger.info(
        f"Setup complete. Available clients: {factory.get_available_client_types()}"
    )
    logger.info(f"Enabled clients: {factory.get_enabled_client_types()}")

    return factory
