"""Background scheduler for automatic social media fetching."""

import asyncio
import contextlib
import traceback
from datetime import datetime, timedelta, timezone
from typing import Dict, List, Optional

from loguru import logger

from .config import Settings
from .services import DatabaseService, MediaStorageService, ClientRegistry


class BackgroundScheduler:
    """Background scheduler for automatic social media content fetching."""

    def __init__(
        self, 
        database: DatabaseService,
        media_storage: MediaStorageService,
        client_registry: ClientRegistry,
        settings: Settings
    ):
        """Initialize the scheduler."""
        self.database = database
        self.media_storage = media_storage
        self.client_registry = client_registry
        self.settings = settings
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
                config = await self.database.get_scheduler_config()

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
                await self.database.update_scheduler_config(
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
        """Sync all active sources using auto-sync enabled clients."""
        try:
            sources = await self.database.get_active_sources()

            if not sources:
                logger.info("No active sources found")
                return {"total_items": 0, "errors": []}

            # Get only clients that have auto sync enabled
            auto_sync_clients = self.client_registry.get_auto_sync_clients()
            
            if not auto_sync_clients:
                logger.info("No auto-sync clients available")
                return {"total_items": 0, "errors": []}

            total_items = 0
            errors = []

            for source in sources:
                try:
                    source_type = source["source_type"]
                    source_id = source["source_id"]
                    source_name = source["source_name"]

                    # Check if we have a client for this source type
                    client = auto_sync_clients.get(source_type)
                    if not client:
                        logger.debug(f"No auto-sync client available for {source_type}")
                        continue

                    logger.info(f"Syncing {source_type} source: {source_id}")

                    items_count = await self._sync_source_with_client(
                        client, source_id, source_name
                    )
                    total_items += items_count

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

    async def _sync_source_with_client(
        self, client, source_id: str, source_name: str
    ) -> int:
        """Universal method to sync a source with any client."""
        try:
            # Get source info
            source_info = await client.get_source_info(source_id)
            
            # Fetch raw data using the correct method
            raw_data_list = await client.fetch_raw_data(source_id, limit=50)

            stored_count = 0
            for raw_data in raw_data_list:
                try:
                    # Process media URLs if any
                    source_info_for_media = {
                        "source_type": client.client_type,
                        "source_id": source_id,
                    }

                    # Save raw data as news blocks using the enhanced Supabase client
                    if await self.database.save_raw_data_as_news_blocks(
                        raw_data=raw_data,
                        source_type=client.client_type,
                        source_id=source_id,
                        source_name=source_name,
                        social_media_client=client
                    ):
                        stored_count += 1

                except Exception as e:
                    logger.warning(f"Error processing raw data: {e}")

            # Save source info
            await self.database.save_source_info(
                client.client_type,
                source_id,
                source_name,
                f"https://{'t.me' if client.client_type == 'telegram' else 'vk.com'}/{source_id}",
            )

            logger.info(
                f"Synced {client.client_type} source {source_id}: {stored_count}/{len(raw_data_list)} items stored"
            )
            return stored_count

        except Exception as e:
            logger.error(f"Error syncing {client.client_type} source {source_id}: {e}")
            raise


