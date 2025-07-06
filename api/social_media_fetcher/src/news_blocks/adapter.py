"""News blocks adapter for social media fetcher integration."""

from typing import List, Dict, Any, Optional
from datetime import datetime

from .models import NewsBlock, create_news_block_from_json


class NewsBlockAdapter:
    """Adapter for converting social media posts to news blocks."""
    
    @staticmethod
    def news_blocks_to_json(blocks: List[NewsBlock]) -> List[Dict[str, Any]]:
        """Convert news blocks to JSON format."""
        return [block.dict(by_alias=True) for block in blocks]
    
    @staticmethod
    def json_to_news_blocks(json_data: List[Dict[str, Any]]) -> List[NewsBlock]:
        """Convert JSON data to news blocks."""
        return [create_news_block_from_json(item) for item in json_data]