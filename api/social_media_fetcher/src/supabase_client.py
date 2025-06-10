"""Supabase client for storing social media news."""

import os
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional

from loguru import logger
from supabase import AsyncClient, create_async_client

from .config import Settings
from .models import SocialMediaPost


class SupabaseNewsClient:
    """Client for storing social media news in Supabase."""

    def __init__(self, settings: Settings):
        """Initialize the Supabase client."""
        self.settings = settings
        self.client: Optional[AsyncClient] = None

        self.supabase_url = os.getenv("SUPABASE_URL")
        self.supabase_key = os.getenv("SUPABASE_SERVICE_KEY")

        if not self.supabase_url or not self.supabase_key:
            logger.warning("Supabase credentials not found in environment")

    async def initialize(self):
        """Initialize the Supabase client."""
        if not self.supabase_url or not self.supabase_key:
            raise RuntimeError("Supabase credentials not configured")

        try:
            self.client = await create_async_client(
                self.supabase_url, self.supabase_key
            )
            logger.info("Supabase client initialized")
        except Exception as e:
            logger.error(f"Failed to initialize Supabase client: {e}")
            raise

    async def close(self):
        """Close the Supabase client."""
        if self.client:
            await self.client.close()
            logger.info("Supabase client closed")

    async def save_social_news_item(self, post: SocialMediaPost) -> bool:
        """
        Save a social media post as a news item in Supabase.

        Args:
            post: The social media post to save

        Returns:
            True if saved successfully, False otherwise
        """
        if not self.client:
            logger.error("Supabase client not initialized")
            return False

        try:
            news_item = {
                "external_id": post.id.split("_")[-1],
                "source_type": post.source_type,
                "source_id": post.source_id,
                "source_name": post.source_name,
                "title": post.title,
                "content": post.content,
                "original_url": post.original_url,
                "published_at": post.published_at.isoformat(),
                "image_urls": post.image_urls,
                "video_urls": post.video_urls,
                "tags": post.tags,
                "likes_count": post.likes_count,
                "comments_count": post.comments_count,
                "shares_count": post.shares_count,
                "views_count": post.views_count,
                "raw_data": {
                    "author_name": post.author_name,
                    "author_url": post.author_url,
                },
                "processed_at": datetime.now(timezone.utc).isoformat(),
            }

            result = (
                await self.client.table("social_news_items")
                .upsert(news_item, on_conflict="source_type,source_id,external_id")
                .execute()
            )

            if result.data:
                logger.debug(f"Saved news item: {post.id}")
                return True
            else:
                logger.error(f"Failed to save news item: {post.id}")
                return False

        except Exception as e:
            logger.error(f"Error saving news item {post.id}: {e}")
            return False

    async def save_source_info(
        self, source_type: str, source_id: str, source_name: str, source_url: str
    ) -> bool:
        """
        Save or update social media source information.

        Args:
            source_type: Type of source (vk, telegram)
            source_id: Source identifier
            source_name: Display name of the source
            source_url: URL to the source

        Returns:
            True if saved successfully, False otherwise
        """
        if not self.client:
            logger.error("Supabase client not initialized")
            return False

        try:
            source_info = {
                "source_type": source_type,
                "source_id": source_id,
                "source_name": source_name,
                "source_url": source_url,
                "is_active": True,
                "last_fetched_at": datetime.now(timezone.utc).isoformat(),
            }

            result = (
                await self.client.table("social_news_sources")
                .upsert(source_info, on_conflict="source_type,source_id")
                .execute()
            )

            if result.data:
                logger.debug(f"Saved source info: {source_type}:{source_id}")
                return True
            else:
                logger.error(f"Failed to save source info: {source_type}:{source_id}")
                return False

        except Exception as e:
            logger.error(f"Error saving source info {source_type}:{source_id}: {e}")
            return False

    async def get_active_sources(self) -> List[Dict[str, Any]]:
        """
        Get list of active social media sources.

        Returns:
            List of active sources
        """
        if not self.client:
            logger.error("Supabase client not initialized")
            return []

        try:
            result = (
                await self.client.table("social_news_sources")
                .select("*")
                .eq("is_active", True)
                .execute()
            )

            return result.data if result.data else []
        except Exception as e:
            logger.error(f"Error getting active sources: {e}")
            return []

    async def get_latest_news(
        self,
        limit: int = 20,
        offset: int = 0,
        source_type: Optional[str] = None,
        source_id: Optional[str] = None,
    ) -> List[Dict[str, Any]]:
        """
        Get latest social media news items.

        Args:
            limit: Number of items to fetch
            offset: Offset for pagination
            source_type: Filter by source type
            source_id: Filter by source ID

        Returns:
            List of news items
        """
        if not self.client:
            logger.error("Supabase client not initialized")
            return []

        try:
            query = self.client.table("social_news_items").select("*")

            if source_type:
                query = query.eq("source_type", source_type)

            if source_id:
                query = query.eq("source_id", source_id)

            result = (
                await query.order("published_at", desc=True)
                .range(offset, offset + limit - 1)
                .execute()
            )

            return result.data if result.data else []
        except Exception as e:
            logger.error(f"Error getting latest news: {e}")
            return []

    async def get_statistics(self) -> Dict[str, Any]:
        """
        Get statistics about social media news.

        Returns:
            Dictionary with statistics
        """
        if not self.client:
            logger.error("Supabase client not initialized")
            return {}

        try:
            total_result = (
                await self.client.table("social_news_items")
                .select("id", count="exact")
                .execute()
            )
            total_count = total_result.count or 0

            stats_result = (
                await self.client.table("social_news_statistics").select("*").execute()
            )

            statistics = {
                "total_items": total_count,
                "by_source_type": {},
                "by_source": [],
                "last_updated": datetime.now(timezone.utc).isoformat(),
            }

            if stats_result.data:
                for stat in stats_result.data:
                    source_type = stat["source_type"]
                    if source_type not in statistics["by_source_type"]:
                        statistics["by_source_type"][source_type] = 0
                    statistics["by_source_type"][source_type] += stat["total_items"]

                    statistics["by_source"].append(
                        {
                            "source_type": source_type,
                            "source_id": stat["source_id"],
                            "source_name": stat["source_name"],
                            "total_items": stat["total_items"],
                            "latest_published_at": stat["latest_published_at"],
                        }
                    )
            return statistics

        except Exception as e:
            logger.error(f"Error getting statistics: {e}")
            return {}

    async def cleanup_old_cache(self, days: int = 7) -> int:
        """
        Clean up old cache entries.

        Args:
            days: Number of days to keep cache entries

        Returns:
            Number of deleted entries
        """
        if not self.client:
            logger.error("Supabase client not initialized")
            return 0

        try:
            result = await self.client.rpc("clean_expired_cache").execute()

            if result.data is not None:
                deleted_count = result.data
                logger.info(f"Cleaned up {deleted_count} expired cache entries")
                return deleted_count
            else:
                logger.warning("Cache cleanup function returned no data")
                return 0

        except Exception as e:
            logger.error(f"Error cleaning up cache: {e}")
            return 0
