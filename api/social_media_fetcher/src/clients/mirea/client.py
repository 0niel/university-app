"""MIREA official news client for fetching news from mirea.ru."""

from typing import Any, Dict, List, Optional
import aiohttp
from loguru import logger

from ...clients.base.interfaces import SocialMediaClient
from ...config import Settings

class MireaOfficialFetcher(SocialMediaClient):
    """Client for fetching news from the official MIREA website."""

    MIREA_API_URL = "https://www.mirea.ru/api/oCoGUGuMhQzPEDJYF6Qy.php"

    def __init__(self, config: Settings):
        """Initialize the MIREA client."""
        super().__init__(
            name="MIREA Official Fetcher", 
            client_type="mirea", 
            auto_sync_enabled=True,
            auto_register_sources=True
        )
        self.config = config
        self.session: Optional[aiohttp.ClientSession] = None
    
    @classmethod
    def create_from_config(cls, config: Settings) -> "MireaOfficialFetcher":
        """Create MireaOfficialFetcher from configuration."""
        return cls(config)

    @property
    def is_configured(self) -> bool:
        """MIREA client requires no special configuration."""
        return True

    def get_default_sources(self) -> List[Dict[str, Any]]:
        """Get default sources for MIREA client."""
        return [
            {
                "source_id": "official",
                "source_name": "РТУ МИРЭА - Официальный сайт",
                "description": "Новости с официального сайта РТУ МИРЭА",
                "category": "university",
            }
        ]

    async def initialize(self) -> None:
        """Initialize the aiohttp session."""
        if not self.session or self.session.closed:
            self.session = aiohttp.ClientSession()
        self._initialized = True
        logger.info("Mirea Official client initialized successfully")

    async def close(self) -> None:
        """Close the aiohttp session."""
        if self.session:
            await self.session.close()
        self._initialized = False
        logger.info("Mirea Official client closed")

    @classmethod
    def can_handle_url(cls, url: str) -> bool:
        """This client handles MIREA URLs."""
        return "mirea.ru" in url

    @classmethod
    def extract_source_id_from_url(cls, url: str) -> Optional[str]:
        """Source ID for MIREA is always 'official'."""
        if cls.can_handle_url(url):
            return "official"
        return None

    async def validate_source(self, source_id: str) -> bool:
        """Validate if the source is the official MIREA source."""
        return source_id == "official"

    async def get_source_info(self, source_id: str) -> Dict[str, Any]:
        """Get information about the MIREA source."""
        if source_id == "official":
            return {
                "id": "official",
                "name": "РТУ МИРЭА - Официальный сайт",
                "username": "mirea_official",
                "description": "Новости с официального сайта РТУ МИРЭА",
                "url": "https://www.mirea.ru/news/",
            }
        return {}
    
    async def fetch_raw_data(
        self, source_id: str, limit: int = 20, **kwargs
    ) -> List[Dict[str, Any]]:
        """Fetch raw data from the MIREA API."""
        if source_id != "official" or not self._initialized or not self.session:
            return []

        # MIREA API uses pagination with 'iNumPage' and 'nPageSize'
        # We'll fetch a few pages to get a decent number of articles.
        # The API is a bit weird, offset is not supported, so we fetch pages.
        page = 1
        page_size = 50  # Fetch more to ensure we have enough after filtering
        
        params = {
            "method": "getNews",
            "nPageSize": str(page_size),
            "iNumPage": str(page),
        }

        category = kwargs.get("category")
        if category:
            params["tag"] = category

        try:
            async with self.session.get(self.MIREA_API_URL, params=params) as response:
                response.raise_for_status()
                # The API returns HTML with json inside, need to handle that
                body = await response.text()
                # The actual json is returned, but content-type is text/html
                data = await response.json(content_type=None)

                if data and "result" in data and isinstance(data["result"], list):
                    return data["result"]
                else:
                    logger.warning(f"Unexpected data format from MIREA API: {data}")
                    return []
        except Exception as e:
            logger.error(f"Error fetching MIREA news: {e}")
            return [] 
