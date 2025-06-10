"""Service registry for dependency injection and service management."""

from typing import Any, Dict, Optional, Type

from loguru import logger

from .interfaces import ServiceRegistryProtocol, SocialMediaClient


class ServiceRegistry(ServiceRegistryProtocol):
    """Service registry implementation for managing clients and services."""

    def __init__(self):
        """Initialize the service registry."""
        self._clients: Dict[str, SocialMediaClient] = {}
        self._services: Dict[str, Any] = {}
        self._client_factories: Dict[str, Type[SocialMediaClient]] = {}

    def register_client_factory(
        self, client_type: str, factory: Type[SocialMediaClient]
    ) -> None:
        """Register a client factory for lazy initialization."""
        self._client_factories[client_type] = factory
        logger.debug(f"Registered client factory for type: {client_type}")

    def register_client(self, client_type: str, client: SocialMediaClient) -> None:
        """Register a social media client."""
        if not isinstance(client, SocialMediaClient):
            raise TypeError(
                f"Client must implement SocialMediaClient, got {type(client)}"
            )

        self._clients[client_type] = client
        logger.info(f"Registered client: {client}")

    def get_client(self, client_type: str) -> Optional[SocialMediaClient]:
        """Get a registered client by type."""
        if client_type in self._clients:
            return self._clients[client_type]

        if client_type in self._client_factories:
            try:
                factory = self._client_factories[client_type]
                client = factory()
                self._clients[client_type] = client
                logger.info(f"Created client from factory: {client}")
                return client
            except Exception as e:
                logger.error(f"Failed to create client {client_type} from factory: {e}")
                return None

        logger.warning(f"Client not found: {client_type}")
        return None

    def get_all_clients(self) -> Dict[str, SocialMediaClient]:
        """Get all registered clients."""
        for client_type in self._client_factories:
            if client_type not in self._clients:
                self.get_client(client_type)

        return self._clients.copy()

    def get_available_client_types(self) -> list[str]:
        """Get list of available client types."""
        all_types = set(self._clients.keys()) | set(self._client_factories.keys())
        return list(all_types)

    def register_service(self, service_name: str, service: Any) -> None:
        """Register a service."""
        self._services[service_name] = service
        logger.info(f"Registered service: {service_name}")

    def get_service(self, service_name: str) -> Optional[Any]:
        """Get a registered service."""
        service = self._services.get(service_name)
        if service is None:
            logger.warning(f"Service not found: {service_name}")
        return service

    def unregister_client(self, client_type: str) -> bool:
        """Unregister a client."""
        if client_type in self._clients:
            client = self._clients.pop(client_type)
            logger.info(f"Unregistered client: {client}")
            return True
        return False

    def unregister_service(self, service_name: str) -> bool:
        """Unregister a service."""
        if service_name in self._services:
            self._services.pop(service_name)
            logger.info(f"Unregistered service: {service_name}")
            return True
        return False

    async def initialize_all_clients(self) -> None:
        """Initialize all registered clients."""
        errors = []

        for client_type, client in self.get_all_clients().items():
            if client.is_configured:
                try:
                    await client.initialize()
                    logger.info(f"Initialized client: {client}")
                except Exception as e:
                    error_msg = f"Failed to initialize {client_type}: {e}"
                    logger.error(error_msg)
                    errors.append(error_msg)
            else:
                logger.warning(
                    f"Client {client_type} is not configured, skipping initialization"
                )

        if errors:
            logger.warning(f"Some clients failed to initialize: {errors}")

    async def close_all_clients(self) -> None:
        """Close all registered clients."""
        for client_type, client in self._clients.items():
            try:
                await client.close()
                logger.info(f"Closed client: {client}")
            except Exception as e:
                logger.error(f"Error closing client {client_type}: {e}")

    def get_status(self) -> Dict[str, Any]:
        """Get registry status."""
        client_status = {
            client_type: {
                "name": client.name,
                "initialized": client._initialized,
                "configured": client.is_configured,
            }
            for client_type, client in self._clients.items()
        }
        return {
            "clients": client_status,
            "services": list(self._services.keys()),
            "available_client_types": self.get_available_client_types(),
        }


service_registry = ServiceRegistry()
