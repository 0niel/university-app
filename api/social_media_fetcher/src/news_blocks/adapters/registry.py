"""Registry for social media to news blocks adapters."""
from typing import Dict, List, Optional

from .base import SocialMediaToNewsBlocksAdapter
from .telegram_adapter import TelegramToNewsBlocksAdapter
from .vk_adapter import VKToNewsBlocksAdapter
from .mirea_adapter import MireaToNewsBlocksAdapter


class NewsBlocksAdapterRegistry:
    def __init__(self) -> None:
        self._adapters: Dict[str, SocialMediaToNewsBlocksAdapter] = {}
        self._register_default_adapters()

    def _register_default_adapters(self) -> None:
        self.register_adapter(TelegramToNewsBlocksAdapter())
        self.register_adapter(VKToNewsBlocksAdapter())
        self.register_adapter(MireaToNewsBlocksAdapter())

    def register_adapter(self, adapter: SocialMediaToNewsBlocksAdapter) -> None:
        self._adapters[adapter.get_source_type()] = adapter

    def get_adapter(self, source_type: str) -> Optional[SocialMediaToNewsBlocksAdapter]:
        return self._adapters.get(source_type)

    def adapt_data(self, source_type: str, raw_data):
        adapter = self.get_adapter(source_type)
        if not adapter:
            raise ValueError(f"No adapter found for source type: {source_type}")
        return adapter.adapt_post_data(raw_data)

    def get_supported_sources(self) -> List[str]:
        return list(self._adapters.keys())


# Global instance
adapter_registry = NewsBlocksAdapterRegistry()
