import asyncio

from src.config import Settings
from src.pipeline import sync_sources

if __name__ == "__main__":
    asyncio.run(sync_sources(Settings()))
