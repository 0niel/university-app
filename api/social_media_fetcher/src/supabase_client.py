"""Supabase client for storing social media news."""

import os
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional

from loguru import logger
from supabase import create_client, Client

from .config import Settings
from .media_storage import MediaStorage


try:
    from .news_blocks.models import NewsBlock
    from .news_blocks.adapters.registry import adapter_registry
    BLOCKS_AVAILABLE = True
except Exception:
    BLOCKS_AVAILABLE = False
    NewsBlock = None
    adapter_registry = None


def serialize_for_json(obj):
    if isinstance(obj, dict):
        return {k: serialize_for_json(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [serialize_for_json(i) for i in obj]
    elif isinstance(obj, datetime):
        return obj.isoformat()
    else:
        return obj


def fix_block_strings(block_data):
    for k, v in block_data.items():
        if v is None:
            if any(
                s in k
                for s in [
                    "url",
                    "title",
                    "description",
                    "caption",
                    "text",
                    "author",
                    "content",
                    "photo_credit",
                    "cover_image_url",
                    "image_url",
                    "video_url",
                    "category_id",
                    "type",
                ]
            ):
                block_data[k] = ""
    return block_data


class SupabaseNewsClient:
    """Client for storing social media news in Supabase."""

    def __init__(self, settings: Settings):
        """Initialize the Supabase client."""
        self.settings = settings
        self.client: Optional[Client] = None
        self.media_storage: Optional[MediaStorage] = None

        # Prefer settings (loaded from .env via pydantic-settings),
        # fall back to OS env vars if not set there
        self.supabase_url = (
            self.settings.SUPABASE_URL or os.getenv("SUPABASE_URL")
        )
        self.supabase_key = (
            self.settings.SUPABASE_SERVICE_KEY or os.getenv("SUPABASE_SERVICE_KEY")
        )

        if not self.supabase_url or not self.supabase_key:
            logger.warning("Supabase credentials not found (settings/env)")

    async def initialize(self):
        """Initialize the Supabase client."""
        if not self.supabase_url or not self.supabase_key:
            raise RuntimeError("Supabase credentials not configured")

        try:
            self.client = create_client(self.supabase_url, self.supabase_key)
            self.media_storage = MediaStorage(self.settings, self.client)
            await self.media_storage.initialize()
            logger.info("Supabase client and Media Storage initialized")
        except Exception as e:
            logger.error(f"Failed to initialize Supabase client: {e}")
            raise

    async def close(self):
        """Close the Supabase client."""
        if self.media_storage:
            await self.media_storage.close()
        if self.client:
            # Supabase client doesn't have close method, just set to None
            self.client = None
            logger.info("Supabase client closed")

    async def save_news_blocks(
        self,
        news_blocks: List[NewsBlock],
        source_type: str,
        source_id: str,
        source_name: str,
        external_id: str,
        original_url: str,
        published_at: datetime,
        raw_data: Optional[Dict[str, Any]] = None,
        social_media_client: Optional[Any] = None,
    ) -> bool:
        """
        Save news blocks directly to the database.

        Args:
            news_blocks: List of news blocks to save
            source_type: Type of source (telegram, vk)
            source_id: Source identifier
            source_name: Source display name
            external_id: External post ID
            original_url: Original post URL
            published_at: Publication date
            raw_data: Raw data from the source
            social_media_client: The client instance for handling media downloads.

        Returns:
            True if saved successfully, False otherwise
        """
        if not self.client:
            logger.error("Supabase client not initialized")
            return False

        if not news_blocks:
            logger.warning("News blocks not available or empty")
            return False

        try:
            media_map = {}
            if social_media_client and source_type == "telegram":
                try:
                    message = await social_media_client.client.get_messages(
                        source_id, ids=int(external_id)
                    )
                    messages_to_process = [message]
                    if (
                        message
                        and hasattr(message, "grouped_id")
                        and message.grouped_id
                    ):
                        album_messages = await social_media_client.client.get_messages(
                            source_id,
                            limit=None,
                            min_id=message.id - 100,
                            max_id=message.id + 100,
                        )  # Heuristic
                        messages_to_process = [
                            m
                            for m in album_messages
                            if m and m.grouped_id == message.grouped_id
                        ]

                    # Create a map from photo/doc ID to the media object
                    for msg in messages_to_process:
                        if msg and msg.media:
                            if hasattr(msg.media, "photo"):
                                media_map[str(msg.media.photo.id)] = msg.media
                            elif hasattr(msg.media, "document"):
                                media_map[str(msg.media.document.id)] = msg.media
                except Exception as e:
                    logger.warning(
                        f"Could not pre-fetch telegram media for {source_id}/{external_id}: {e}"
                    )

            # Convert news blocks to JSON, ensuring all values are JSON serialisable
            news_blocks_json: List[Dict[str, Any]] = []

            for block in news_blocks:
                if hasattr(block, "model_dump"):
                    block_data = block.model_dump(by_alias=True, mode="json")
                else:
                    block_data = block.dict(by_alias=True)
                    for k, v in list(block_data.items()):
                        if isinstance(v, datetime):
                            block_data[k] = v.isoformat()
                block_data = fix_block_strings(block_data)

                # Upload Telegram media by file_id and also upload external HTTP media into Supabase
                for media_field, media_type in [
                    ("image_url", "image"),
                    ("imageUrl", "image"),
                    ("video_url", "video"),
                    ("videoUrl", "video"),
                ]:
                    url_val = block_data.get(media_field)
                    if not url_val:
                        continue

                    url_str = str(url_val)
                    is_http = url_str.startswith("http://") or url_str.startswith("https://") or url_str.startswith("//")

                    if not is_http and social_media_client:
                        # Delegate platform media resolution to the platform client
                        uploaded = await social_media_client.upload_platform_media(
                            source_id=source_id,
                            external_id=external_id,
                            media_identifier=url_str,
                            media_type=media_type,
                            storage=self.media_storage,
                            source_info={"source_type": source_type, "source_id": source_id},
                        )
                        if uploaded:
                            block_data[media_field] = uploaded
                    else:
                        # External HTTP(S) URL -> download and re-host in Supabase
                        stored = await self.media_storage.download_and_store_file(
                            url_str,
                            media_type,
                            {"source_type": source_type, "source_id": source_id},
                        )
                        if stored:
                            block_data[media_field] = stored

                news_blocks_json.append(block_data)

            first_block = news_blocks[0] if news_blocks else None
            title = getattr(first_block, "title", f"Post from {source_name}")

            news_item = {
                "external_id": external_id,
                "source_type": source_type,
                "source_id": source_id,
                "source_name": source_name,
                "title": title,
                "original_url": original_url,
                "published_at": published_at.isoformat(),
                "raw_data": raw_data or {},
                "news_blocks": news_blocks_json,
                "news_blocks_version": "1.0.0",
                "processed_at": datetime.now(timezone.utc).isoformat(),
            }

            news_item_serialized = serialize_for_json(news_item)

            result = (
                self.client.table("social_news_items")
                .upsert(
                    news_item_serialized,
                    on_conflict="source_type,source_id,external_id",
                )
                .execute()
            )

            if result.data:
                logger.debug(
                    f"Saved news blocks for: {source_type}:{source_id}:{external_id}"
                )
                return True
            else:
                logger.error(
                    f"Failed to save news blocks: {source_type}:{source_id}:{external_id}"
                )
                return False

        except Exception as e:
            logger.error(
                f"Error saving news blocks {source_type}:{source_id}:{external_id}: {e}"
            )
            return False

    async def save_raw_data_as_news_blocks(
        self,
        raw_data: Dict[str, Any],
        source_type: str,
        source_id: str,
        source_name: str,
        social_media_client: Optional[Any] = None,
    ) -> bool:
        """
        Convert raw social media data to news blocks and save.

        Args:
            raw_data: Raw data from social media platform
            source_type: Type of source (telegram, vk)
            source_id: Source identifier
            source_name: Source display name
            social_media_client: The client instance for handling media downloads.

        Returns:
            True if saved successfully, False otherwise
        """
        if not BLOCKS_AVAILABLE or not adapter_registry:
            logger.warning("News blocks adapter not available")
            return False

        try:
            # Extract metadata from raw data
            external_id = self._extract_external_id(raw_data, source_type)
            
            if await self._item_exists(source_type, source_id, external_id):
                logger.debug(f"Item already exists, skipping: {source_type}:{source_id}:{external_id}")
                return True

            news_blocks = adapter_registry.adapt_data(source_type, raw_data)

            if not news_blocks:
                logger.warning(
                    f"No news blocks generated from raw data: {source_type}:{source_id}"
                )
                return False

            original_url = raw_data.get(
                "url", f"https://example.com/{source_id}/{external_id}"
            )

            published_at = datetime.now(timezone.utc)
            if "date" in raw_data:
                if isinstance(raw_data["date"], int):
                    published_at = datetime.fromtimestamp(
                        raw_data["date"], tz=timezone.utc
                    )
                elif isinstance(raw_data["date"], str):
                    try:
                        published_at = datetime.fromisoformat(
                            raw_data["date"].replace("Z", "+00:00")
                        )
                    except ValueError:
                        pass

            return await self.save_news_blocks(
                news_blocks=news_blocks,
                source_type=source_type,
                source_id=source_id,
                source_name=source_name,
                external_id=external_id,
                original_url=original_url,
                published_at=published_at,
                raw_data=raw_data,
                social_media_client=social_media_client,
            )

        except Exception as e:
            logger.error(f"Error converting and saving raw data: {e}")
            return False

    def _extract_external_id(self, raw_data: Dict[str, Any], source_type: str) -> str:
        """
        Extract external ID from raw data based on source type.

        Args:
            raw_data: Raw data from social media platform
            source_type: Type of source (telegram, vk, mirea, etc.)

        Returns:
            External ID as string
        """
        if source_type == "mirea":
            # MIREA uses uppercase "ID" field
            return str(raw_data.get("ID", ""))
        elif source_type in ["telegram", "vk"]:
            # Telegram and VK use lowercase "id" field
            return str(raw_data.get("id", ""))
        else:
            # Default fallback - try both cases
            return str(raw_data.get("id", raw_data.get("ID", "")))

    async def _item_exists(self, source_type: str, source_id: str, external_id: str) -> bool:
        """
        Check if an item already exists in the database.

        Args:
            source_type: Type of source (telegram, vk, etc.)
            source_id: Source identifier
            external_id: External identifier of the item

        Returns:
            True if item exists, False otherwise
        """
        if not self.client:
            return False

        try:
            result = (
                self.client.table("social_news_items")
                .select("id")
                .eq("source_type", source_type)
                .eq("source_id", source_id)
                .eq("external_id", external_id)
                .limit(1)
                .execute()
            )

            return bool(result.data)

        except Exception as e:
            logger.error(f"Error checking item existence: {e}")
            return False

    async def get_news_as_blocks(
        self,
        limit: int = 20,
        offset: int = 0,
        source_type: Optional[str] = None,
    ) -> List[Dict[str, Any]]:
        """
        Get news items in news blocks format.

        Args:
            limit: Number of items to fetch
            offset: Offset for pagination
            source_type: Filter by source type

        Returns:
            List of news items with news blocks
        """
        if not self.client:
            logger.error("Supabase client not initialized")
            return []

        try:
            result = self.client.rpc(
                "get_news_as_blocks",
                {
                    "source_type_filter": source_type,
                    "limit_count": limit,
                    "offset_count": offset,
                },
            ).execute()

            return result.data if result.data else []

        except Exception as e:
            logger.error(f"Error getting news as blocks: {e}")
            return []

    async def get_news_blocks_by_type(
        self,
        block_type: str,
        limit: int = 20,
        offset: int = 0,
    ) -> List[Dict[str, Any]]:
        """
        Get news items that contain specific block types.

        Args:
            block_type: Type of news block to filter by
            limit: Number of items to fetch
            offset: Offset for pagination

        Returns:
            List of news items containing the specified block type
        """
        if not self.client:
            logger.error("Supabase client not initialized")
            return []

        try:
            result = self.client.rpc(
                "get_news_blocks_by_type",
                {
                    "block_type": block_type,
                    "limit_count": limit,
                    "offset_count": offset,
                },
            ).execute()

            return result.data if result.data else []

        except Exception as e:
            logger.error(f"Error getting news blocks by type {block_type}: {e}")
            return []

    async def regenerate_news_blocks_for_item(self, item_id: str) -> bool:
        """
        Regenerate news blocks for a specific item using database function.

        Args:
            item_id: UUID of the item to regenerate

        Returns:
            True if regenerated successfully, False otherwise
        """
        if not self.client:
            logger.error("Supabase client not initialized")
            return False

        try:
            result = self.client.rpc(
                "regenerate_news_blocks_for_item", {"item_id": item_id}
            ).execute()

            success = result.data if result.data is not None else False
            if success:
                logger.info(f"Regenerated news blocks for item {item_id}")
            else:
                logger.warning(f"Failed to regenerate news blocks for item {item_id}")

            return success

        except Exception as e:
            logger.error(f"Error regenerating news blocks for item {item_id}: {e}")
            return False

    async def regenerate_all_news_blocks(self) -> int:
        """
        Regenerate news blocks for all items that don't have them.

        Returns:
            Number of items processed
        """
        if not self.client:
            logger.error("Supabase client not initialized")
            return 0

        try:
            result = self.client.rpc("regenerate_all_news_blocks").execute()

            processed_count = result.data if result.data is not None else 0
            logger.info(f"Regenerated news blocks for {processed_count} items")

            return processed_count

        except Exception as e:
            logger.error(f"Error regenerating all news blocks: {e}")
            return 0

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
                self.client.table("social_news_sources")
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
                self.client.table("social_news_sources")
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
        category: Optional[str] = None,
        only_blocks: bool = True,
    ) -> Any:
        """
        Get latest social media news items.

        Args:
            limit: Number of items to fetch
            offset: Offset for pagination
            source_type: Filter by source type
            source_id: Filter by source ID
            category: Filter by category
            only_blocks: If True, return only news_blocks (default)

        Returns:
            If only_blocks=True: List of news_blocks (flattened)
            Else: dict with items and total
        """
        if not self.client:
            logger.error("Supabase client not initialized")
            return [] if only_blocks else {"items": [], "total": 0}

        try:
            query = self.client.table("social_news_items").select("*", count="exact")

            if source_type:
                query = query.eq("source_type", source_type)

            if source_id:
                query = query.eq("source_id", source_id)

            result = (
                query.order("published_at", desc=True)
                .range(offset, offset + limit - 1)
                .execute()
            )
            items = result.data if result.data else []
            total_count = result.count if result.count is not None else 0

            if only_blocks:
                all_blocks = []
                for item in items:
                    blocks = item.get("news_blocks")
                    if isinstance(blocks, list):
                        all_blocks.extend(blocks)
                return all_blocks
            else:
                return {"items": items, "total": total_count}
        except Exception as e:
            logger.error(f"Error getting latest news: {e}")
            return [] if only_blocks else {"items": [], "total": 0}

    async def get_statistics(self) -> Dict[str, Any]:
        """
        Get statistics about social media news including news blocks coverage.

        Returns:
            Dictionary with statistics
        """
        if not self.client:
            logger.error("Supabase client not initialized")
            return {}

        try:
            result = self.client.rpc("get_social_news_aggregated_stats").execute()

            if result.data:
                return result.data
            else:
                total_result = (
                    self.client.table("social_news_items")
                    .select("id", count="exact")
                    .execute()
                )
                total_count = total_result.count or 0

                return {
                    "total_items": total_count,
                    "by_source_type": {},
                    "by_source": [],
                    "items_with_news_blocks": 0,
                    "news_blocks_coverage": {},
                    "last_updated": datetime.now(timezone.utc).isoformat(),
                }

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
            result = self.client.rpc("clean_expired_cache").execute()

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

    async def add_source(
        self,
        source_type: str,
        source_id: str,
        source_name: str,
        category: Optional[str] = None,
        description: Optional[str] = None,
        is_active: bool = True,
    ) -> Dict[str, Any]:
        """Add a new social media source."""
        if not self.client:
            logger.error("Supabase client not initialized")
            raise RuntimeError("Database not available")

        try:
            source_data = {
                "source_type": source_type,
                "source_id": source_id,
                "source_name": source_name,
                "source_url": f"https://{'t.me' if source_type == 'telegram' else 'vk.com'}/{source_id}",
                "category": category or "",
                "description": description or "",
                "is_active": is_active,
                "created_at": datetime.now(timezone.utc).isoformat(),
                "updated_at": datetime.now(timezone.utc).isoformat(),
            }

            result = (
                self.client.table("social_news_sources").insert(source_data).execute()
            )

            if result.data:
                return result.data[0]
            else:
                raise RuntimeError("Failed to add source")

        except Exception as e:
            logger.error(f"Error adding source: {e}")
            raise

    async def get_sources(
        self,
        source_type: Optional[str] = None,
        category: Optional[str] = None,
        active_only: bool = True,
    ) -> List[Dict[str, Any]]:
        """Get sources with optional filtering."""
        if not self.client:
            logger.error("Supabase client not initialized")
            return []

        try:
            query = self.client.table("social_news_sources").select("*")

            if source_type:
                query = query.eq("source_type", source_type)

            if category:
                query = query.eq("category", category)

            if active_only:
                query = query.eq("is_active", True)

            result = query.order("created_at", desc=True).execute()

            return result.data if result.data else []

        except Exception as e:
            logger.error(f"Error getting sources: {e}")
            return []

    async def update_source(self, source_id: str, **kwargs) -> Dict[str, Any]:
        """Update a source."""
        if not self.client:
            logger.error("Supabase client not initialized")
            raise RuntimeError("Database not available")

        try:
            update_data = {
                **kwargs,
                "updated_at": datetime.now(timezone.utc).isoformat(),
            }

            result = (
                self.client.table("social_news_sources")
                .update(update_data)
                .eq("id", source_id)
                .execute()
            )

            if result.data:
                return result.data[0]
            else:
                raise RuntimeError("Source not found")

        except Exception as e:
            logger.error(f"Error updating source: {e}")
            raise

    async def delete_source(self, source_id: str) -> bool:
        """Delete a source."""
        if not self.client:
            logger.error("Supabase client not initialized")
            raise RuntimeError("Database not available")

        try:
            result = (
                self.client.table("social_news_sources")
                .delete()
                .eq("id", source_id)
                .execute()
            )

            return bool(result.data)

        except Exception as e:
            logger.error(f"Error deleting source: {e}")
            raise

    async def get_source(self, source_id: str) -> Optional[Dict[str, Any]]:
        """Get a single source by its database ID."""
        if not self.client:
            logger.error("Supabase client not initialized")
            return None

        try:
            result = (
                self.client.table("social_news_sources")
                .select("*")
                .eq("id", source_id)
                .single()
                .execute()
            )
            return result.data if result.data else None
        except Exception as e:
            logger.error(f"Error getting source {source_id}: {e}")
            return None

    async def get_scheduler_config(self) -> Dict[str, Any]:
        """Get scheduler configuration."""
        return {
            "is_enabled": True,
            "sync_interval_minutes": 30,
            "next_sync_at": None,
            "last_sync_at": None,
            "total_synced": 0,
            "errors_count": 0,
        }

    async def update_scheduler_config(self, **kwargs) -> bool:
        """Update scheduler configuration."""
        # For now, just log the update since we don't have a scheduler config table
        logger.info(f"Scheduler config updated: {kwargs}")
        return True

    async def get_status(self) -> Dict[str, Any]:
        """Get scheduler status."""
        config = await self.get_scheduler_config()
        return {
            "is_enabled": config.get("is_enabled", False),
            "sync_interval_minutes": config.get("sync_interval_minutes", 30),
            "last_sync_at": config.get("last_sync_at"),
            "next_sync_at": config.get("next_sync_at"),
            "total_synced": config.get("total_synced", 0),
            "errors_count": config.get("errors_count", 0),
        }
