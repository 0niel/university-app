from abc import ABC, abstractmethod
from typing import Any


class SocialMediaClient(ABC):
    def __init__(
        self,
        name: str,
        client_type: str,
        auto_sync_enabled: bool = True,
        auto_register_sources: bool = False,
    ) -> None:
        self.name = name
        self.client_type = client_type
        self.auto_sync_enabled = auto_sync_enabled
        self.auto_register_sources = auto_register_sources
        self._initialized = False

    @property
    @abstractmethod
    def is_configured(self) -> bool: ...

    @property
    def is_initialized(self) -> bool:
        return self._initialized

    @abstractmethod
    async def initialize(self) -> None: ...

    @abstractmethod
    async def close(self) -> None: ...

    @classmethod
    @abstractmethod
    def can_handle_url(cls, url: str) -> bool: ...

    @classmethod
    @abstractmethod
    def extract_source_id_from_url(cls, url: str) -> str | None: ...

    @abstractmethod
    async def fetch_raw_data(
        self,
        source_id: str,
        limit: int = 20,
        **kwargs: Any,
    ) -> list[dict[str, Any]]: ...

    @abstractmethod
    async def get_source_info(self, source_id: str) -> dict[str, Any]: ...

    @abstractmethod
    async def validate_source(self, source_id: str) -> bool: ...

    def __str__(self) -> str:
        return f"{self.name} ({self.client_type})"

    def __repr__(self) -> str:
        return (
            f"{self.__class__.__name__}("
            f"name='{self.name}', "
            f"client_type='{self.client_type}', "
            f"auto_sync_enabled={self.auto_sync_enabled}, "
            f"auto_register_sources={self.auto_register_sources}, "
            f"initialized={self._initialized})"
        )
