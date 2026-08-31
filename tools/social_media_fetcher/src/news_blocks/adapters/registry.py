"""Registry for social media to news blocks adapters."""

from .base import SocialMediaToNewsBlocksAdapter
from .telegram_adapter import TelegramToNewsBlocksAdapter


class NewsBlocksAdapterRegistry:
    def __init__(self) -> None:
        self._adapters: dict[str, SocialMediaToNewsBlocksAdapter] = {}
        self._register_default_adapters()

    def _register_default_adapters(self) -> None:
        self.register_adapter(TelegramToNewsBlocksAdapter())

    def register_adapter(self, adapter: SocialMediaToNewsBlocksAdapter) -> None:
        self._adapters[adapter.get_source_type()] = adapter

    def get_adapter(self, source_type: str) -> SocialMediaToNewsBlocksAdapter | None:
        if source_type == "telegram_stories":
            source_type = "telegram"
        return self._adapters.get(source_type)

    def adapt_data(self, source_type: str, raw_data):
        adapter = self.get_adapter(source_type)
        if not adapter:
            raise ValueError(f"No adapter found for source type: {source_type}")
        return adapter.adapt_post_data(raw_data)

    def get_supported_sources(self) -> list[str]:
        return list(self._adapters.keys())


# Global instance
adapter_registry = NewsBlocksAdapterRegistry()
