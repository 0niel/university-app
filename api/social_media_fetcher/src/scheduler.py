"""Background scheduler for automatic social media fetching."""

import asyncio
import contextlib
import traceback
from datetime import datetime, timedelta, timezone
from typing import Dict, List, Optional

from loguru import logger

from .config import Settings
from .media_storage import MediaStorage
from .supabase_client import SupabaseNewsClient
from .telegram_client import TelegramFetcher
from .vk_client import VKFetcher


class BackgroundScheduler:
    """Background scheduler for automatic social media content fetching."""

    def __init__(
        self,
        settings: Settings,
        telegram_fetcher: TelegramFetcher,
        vk_fetcher: VKFetcher,
        supabase_client: SupabaseNewsClient,
        media_storage: MediaStorage,
    ):
        """Initialize the scheduler."""
        self.settings = settings
        self.telegram_fetcher = telegram_fetcher
        self.vk_fetcher = vk_fetcher
        self.supabase_client = supabase_client
        self.media_storage = media_storage

        self.running = False
        self.task: Optional[asyncio.Task] = None

    async def start(self):
        """Start the background scheduler."""
        if self.running:
            logger.warning("Scheduler already running")
            return

        self.running = True
        self.task = asyncio.create_task(self._scheduler_loop())
        logger.info("Background scheduler started")

    async def stop(self):
        """Stop the background scheduler."""
        if not self.running:
            return

        self.running = False
        if self.task:
            self.task.cancel()
            with contextlib.suppress(asyncio.CancelledError):
                await self.task
        logger.info("Background scheduler stopped")

    async def _scheduler_loop(self):
        """Main scheduler loop."""
        logger.info("Starting scheduler loop")

        while self.running:
            try:
                config = await self.supabase_client.get_scheduler_config()

                if not config.get("is_enabled", False):
                    logger.debug("Scheduler disabled, sleeping...")
                    await asyncio.sleep(60)
                    continue

                interval_minutes = config.get("sync_interval_minutes", 30)
                next_sync_at = config.get("next_sync_at")

                now = datetime.now(timezone.utc)
                if next_sync_at:
                    next_sync = datetime.fromisoformat(
                        next_sync_at.replace("Z", "+00:00")
                    )
                    if now < next_sync:
                        sleep_seconds = min((next_sync - now).total_seconds(), 60)
                        await asyncio.sleep(sleep_seconds)
                        continue

                logger.info("Starting scheduled sync...")
                sync_results = await self._sync_all_sources()

                next_sync_time = now + timedelta(minutes=interval_minutes)
                await self.supabase_client.update_scheduler_config(
                    last_sync_at=now.isoformat(),
                    next_sync_at=next_sync_time.isoformat(),
                    total_synced=config.get("total_synced", 0)
                    + sync_results.get("total_items", 0),
                    errors_count=config.get("errors_count", 0)
                    + len(sync_results.get("errors", [])),
                )

                logger.info(
                    f"Scheduled sync completed: {sync_results.get('total_items', 0)} items, "
                    f"{len(sync_results.get('errors', []))} errors. Next sync at {next_sync_time}"
                )

                await asyncio.sleep(60)

            except Exception as e:
                logger.error(f"Error in scheduler loop: {e}")
                logger.error(traceback.format_exc())
                await asyncio.sleep(60)

    async def _sync_all_sources(self) -> Dict:
        """Sync all active sources."""
        try:
            sources = await self.supabase_client.get_active_sources()

            if not sources:
                logger.info("No active sources found")
                return {"total_items": 0, "errors": []}

            total_items = 0
            errors = []

            for source in sources:
                try:
                    source_type = source["source_type"]
                    source_id = source["source_id"]
                    source_name = source["source_name"]

                    logger.info(f"Syncing {source_type} source: {source_id}")

                    if source_type == "telegram":
                        items_count = await self._sync_telegram_source(
                            source_id,
                            source_name,
                            self.supabase_client,
                            self.media_storage,
                        )
                        total_items += items_count

                    elif source_type == "vk":
                        items_count = await self._sync_vk_source(
                            source_id,
                            source_name,
                            self.supabase_client,
                            self.media_storage,
                        )
                        total_items += items_count

                    else:
                        logger.warning(f"Unknown source type: {source_type}")

                except Exception as e:
                    error_msg = f"Error syncing {source.get('source_type', 'unknown')} source {source.get('source_id', 'unknown')}: {str(e)}"
                    logger.error(error_msg)
                    errors.append(error_msg)

            return {
                "total_items": total_items,
                "errors": errors,
                "sources_processed": len(sources),
            }

        except Exception as e:
            logger.error(f"Error in sync all sources: {e}")
            return {"total_items": 0, "errors": [str(e)]}

    async def _sync_telegram_source(
        self, channel_username: str, channel_name: str, supabase_client, media_storage
    ) -> int:
        """Sync a Telegram channel."""
        try:
            channel_info = await self.telegram_fetcher.get_channel_info(
                channel_username
            )

            messages = await self.telegram_fetcher.get_channel_messages(
                channel_username=channel_username,
                limit=self.settings.MAX_MESSAGES_PER_REQUEST,
            )

            stored_count = 0
            for message in messages:
                try:
                    social_post = self.telegram_fetcher.convert_to_social_media_post(
                        message, channel_info
                    )

                    source_info = {
                        "source_type": "telegram",
                        "source_id": channel_username,
                    }

                    if social_post.image_urls:
                        processed_images = await media_storage.process_media_urls(
                            social_post.image_urls,
                            "image",
                            source_info,
                            self.telegram_fetcher,
                        )
                        social_post.image_urls = processed_images

                    if social_post.video_urls:
                        processed_videos = await media_storage.process_media_urls(
                            social_post.video_urls,
                            "video",
                            source_info,
                            self.telegram_fetcher,
                        )
                        social_post.video_urls = processed_videos

                    if await supabase_client.save_social_news_item(social_post):
                        stored_count += 1

                except Exception as e:
                    logger.warning(
                        f"Error processing Telegram message {message.id}: {e}"
                    )

            await supabase_client.save_source_info(
                "telegram",
                channel_username,
                channel_info.title,
                f"https://t.me/{channel_username}",
            )

            logger.info(
                f"Synced Telegram channel @{channel_username}: {stored_count}/{len(messages)} messages stored"
            )
            return stored_count

        except Exception as e:
            logger.error(f"Error syncing Telegram channel @{channel_username}: {e}")
            raise

    async def _sync_vk_source(
        self, group_id: str, group_name: str, supabase_client, media_storage
    ) -> int:
        """Sync a VK group."""
        try:
            group_info = await self.vk_fetcher.get_group_info(group_id)

            posts = await self.vk_fetcher.get_group_posts(
                group_id=group_id, count=self.settings.MAX_POSTS_PER_REQUEST
            )

            stored_count = 0
            for post in posts:
                try:
                    social_post = self.vk_fetcher.convert_to_social_media_post(
                        post, group_info
                    )

                    source_info = {"source_type": "vk", "source_id": group_id}

                    if social_post.image_urls:
                        processed_images = await media_storage.process_media_urls(
                            social_post.image_urls, "image", source_info
                        )
                        social_post.image_urls = processed_images

                    if social_post.video_urls:
                        processed_videos = await media_storage.process_media_urls(
                            social_post.video_urls, "video", source_info
                        )
                        social_post.video_urls = processed_videos

                    if await supabase_client.save_social_news_item(social_post):
                        stored_count += 1

                except Exception as e:
                    logger.warning(f"Error processing VK post {post.id}: {e}")

            await supabase_client.save_source_info(
                "vk",
                group_id,
                group_info.name,
                f"https://vk.com/{group_info.screen_name}",
            )

            logger.info(
                f"Synced VK group {group_id}: {stored_count}/{len(posts)} posts stored"
            )
            return stored_count

        except Exception as e:
            logger.error(f"Error syncing VK group {group_id}: {e}")
            raise
