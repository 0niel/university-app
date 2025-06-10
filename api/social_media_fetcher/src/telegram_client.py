"""Telegram client implementation using Pyrogram."""

import asyncio
import os
from datetime import datetime
from typing import Any, Dict, List, Optional

from loguru import logger
from pyrogram import Client, enums, filters
from pyrogram.errors import FloodWait, RPCError
from pyrogram.types import Message

from .config import Settings
from .interfaces import SocialMediaClient
from .models import (
    SocialMediaPost,
    TelegramChannelInfo,
    TelegramEntity,
    TelegramMedia,
    TelegramMessage,
)


class TelegramFetcher(SocialMediaClient):
    """Telegram client for fetching channel information and messages."""

    def __init__(self, config: Optional[Settings] = None):
        """Initialize the Telegram fetcher."""
        super().__init__(name="Telegram Fetcher", client_type="telegram")

        self.config = config or Settings()
        self.client: Optional[Client] = None
        self.session_dir = "./sessions"

        # Ensure session directory exists
        os.makedirs(self.session_dir, exist_ok=True)

    @property
    def is_configured(self) -> bool:
        """Check if Telegram is properly configured."""
        return self.config.telegram_configured

    async def initialize(self) -> None:
        """Initialize the Telegram client."""
        if not self.is_configured:
            logger.warning("Telegram not configured - skipping initialization")
            return

        try:
            client_config = self.config.get_client_config("telegram")

            self.client = Client(
                name="social_fetcher",
                api_id=client_config["api_id"],
                api_hash=client_config["api_hash"],
                bot_token=client_config.get("bot_token"),
                session_string=client_config.get("session_string"),
                workdir=self.session_dir,
                proxy=client_config.get("proxy"),
            )

            await self.client.start()
            self._initialized = True
            logger.info(f"{self.name} initialized successfully")

        except Exception as e:
            logger.error(f"Failed to initialize {self.name}: {e}")
            raise

    async def close(self) -> None:
        """Close the Telegram client."""
        if self.client:
            try:
                await self.client.stop()
                logger.info(f"{self.name} closed successfully")
            except Exception as e:
                logger.error(f"Error closing {self.name}: {e}")

        self._initialized = False

    async def fetch_posts(
        self, source_id: str, limit: int = 20, **kwargs
    ) -> List[SocialMediaPost]:
        """Fetch posts from a Telegram channel in unified format."""
        if not self._initialized:
            raise RuntimeError(f"{self.name} not initialized")

        try:
            # Get channel info
            channel_info = await self._get_channel_info_internal(source_id)

            # Get messages
            messages = await self._get_channel_messages_internal(
                source_id, limit, kwargs.get("offset_id")
            )

            # Convert to unified format
            posts = []
            for message in messages:
                try:
                    post = self._convert_to_social_media_post(message, channel_info)
                    posts.append(post)
                except Exception as e:
                    logger.warning(f"Error converting message {message.id}: {e}")

            return posts

        except Exception as e:
            logger.error(f"Error fetching posts from @{source_id}: {e}")
            raise

    async def get_source_info(self, source_id: str) -> Dict[str, Any]:
        """Get information about a Telegram channel."""
        if not self._initialized:
            raise RuntimeError(f"{self.name} not initialized")

        try:
            channel_info = await self._get_channel_info_internal(source_id)
            return {
                "id": channel_info.id,
                "username": channel_info.username,
                "title": channel_info.title,
                "description": channel_info.description,
                "participants_count": channel_info.participants_count,
                "photo_url": channel_info.photo_url,
                "is_verified": channel_info.is_verified,
                "type": "telegram_channel",
            }
        except Exception as e:
            logger.error(f"Error getting channel info for @{source_id}: {e}")
            raise

    async def validate_source(self, source_id: str) -> bool:
        """Validate if a Telegram channel exists and is accessible."""
        if not self._initialized:
            return False

        try:
            await self._get_channel_info_internal(source_id)
            return True
        except Exception as e:
            logger.debug(f"Channel validation failed for @{source_id}: {e}")
            return False

    # Legacy methods for backward compatibility
    async def get_channel_info(self, channel_username: str) -> TelegramChannelInfo:
        """Get information about a Telegram channel."""
        return await self._get_channel_info_internal(channel_username)

    async def get_channel_messages(
        self,
        channel_username: str,
        limit: int = 20,
        offset_id: Optional[int] = None,
    ) -> List[TelegramMessage]:
        """Get messages from a Telegram channel."""
        return await self._get_channel_messages_internal(
            channel_username, limit, offset_id
        )

    def convert_to_social_media_post(
        self, message: TelegramMessage, channel_info: TelegramChannelInfo
    ) -> SocialMediaPost:
        """Convert TelegramMessage to unified SocialMediaPost format."""
        return self._convert_to_social_media_post(message, channel_info)

    # Internal implementation methods
    async def _get_channel_info_internal(
        self, channel_username: str
    ) -> TelegramChannelInfo:
        """Internal method to get channel information."""
        if not self.client:
            raise RuntimeError("Telegram client not initialized")

        try:
            # Clean username
            clean_username = channel_username.lstrip("@")

            # Get channel
            channel = await self.client.get_chat(clean_username)

            # Get photo URL if available
            photo_url = None
            if channel.photo:
                try:
                    photo = await self.client.download_media(
                        channel.photo.big_file_id, in_memory=True
                    )
                    # For now, just use a placeholder URL
                    photo_url = f"telegram_photo_{channel.id}"
                except Exception as e:
                    logger.debug(f"Could not download channel photo: {e}")

            return TelegramChannelInfo(
                id=channel.id,
                username=clean_username,
                title=channel.title or "",
                description=channel.description,
                participants_count=getattr(channel, "members_count", None),
                photo_url=photo_url,
                is_verified=getattr(channel, "is_verified", False),
                is_scam=getattr(channel, "is_scam", False),
                is_fake=getattr(channel, "is_fake", False),
                is_restricted=getattr(channel, "is_restricted", False),
            )

        except Exception as e:
            logger.error(f"Error getting channel info for @{channel_username}: {e}")
            raise

    async def _get_channel_messages_internal(
        self,
        channel_username: str,
        limit: int = 20,
        offset_id: Optional[int] = None,
    ) -> List[TelegramMessage]:
        """Internal method to get channel messages."""
        if not self.client:
            raise RuntimeError("Telegram client not initialized")

        try:
            clean_username = channel_username.lstrip("@")
            messages = []

            async for message in self.client.get_chat_history(
                clean_username, limit=limit, offset_id=offset_id
            ):
                try:
                    telegram_message = await self._convert_message(message)
                    if telegram_message:
                        messages.append(telegram_message)
                except Exception as e:
                    logger.warning(f"Error converting message {message.id}: {e}")

            return messages

        except FloodWait as e:
            logger.warning(f"Rate limited, waiting {e.value} seconds")
            await asyncio.sleep(e.value)
            raise
        except Exception as e:
            logger.error(f"Error getting messages from @{channel_username}: {e}")
            raise

    async def _convert_message(self, message: Message) -> Optional[TelegramMessage]:
        """Convert Pyrogram Message to TelegramMessage model."""
        try:
            # Convert media
            media_list = []
            if message.media:
                media = await self._convert_media(message)
                if media:
                    media_list.append(media)

            # Convert entities
            entities = []
            if message.entities:
                entities.extend(
                    TelegramEntity(
                        type=entity.type.name.lower(),
                        offset=entity.offset,
                        length=entity.length,
                        url=getattr(entity, "url", None),
                        user_id=(
                            getattr(entity, "user", {}).get("id")
                            if hasattr(entity, "user") and entity.user
                            else None
                        ),
                    )
                    for entity in message.entities
                )
            return TelegramMessage(
                id=message.id,
                date=message.date,
                text=message.text or message.caption or "",
                views=getattr(message, "views", None),
                forwards=getattr(message, "forwards", None),
                replies=(
                    getattr(message, "replies", {}).get("replies")
                    if hasattr(message, "replies") and message.replies
                    else None
                ),
                edit_date=message.edit_date,
                from_id=message.from_user.id if message.from_user else None,
                chat_id=message.chat.id,
                media=media_list,
                entities=entities,
                reply_to_message_id=message.reply_to_message_id,
            )

        except Exception as e:
            logger.warning(f"Error converting message {message.id}: {e}")
            return None

    async def _convert_media(self, message: Message) -> Optional[TelegramMedia]:
        """Convert Pyrogram media to TelegramMedia model."""
        try:
            if not message.media:
                return None

            media_type = "unknown"
            file_id = ""
            file_unique_id = ""
            width = None
            height = None
            duration = None
            file_size = None
            mime_type = None
            file_name = None
            caption = message.caption
            url = None
            thumbnail_url = None

            if message.photo:
                media_type = "photo"
                file_id = message.photo.file_id
                file_unique_id = message.photo.file_unique_id
                width = message.photo.width
                height = message.photo.height
                file_size = message.photo.file_size
                # Store file_id as URL for processing by media storage
                url = file_id

            elif message.video:
                media_type = "video"
                file_id = message.video.file_id
                file_unique_id = message.video.file_unique_id
                width = message.video.width
                height = message.video.height
                duration = message.video.duration
                file_size = message.video.file_size
                mime_type = message.video.mime_type
                file_name = message.video.file_name
                url = file_id

            elif message.animation:
                media_type = "animation"
                file_id = message.animation.file_id
                file_unique_id = message.animation.file_unique_id
                width = message.animation.width
                height = message.animation.height
                duration = message.animation.duration
                file_size = message.animation.file_size
                mime_type = message.animation.mime_type
                file_name = message.animation.file_name
                url = file_id

            elif message.document:
                media_type = "document"
                file_id = message.document.file_id
                file_unique_id = message.document.file_unique_id
                file_size = message.document.file_size
                mime_type = message.document.mime_type
                file_name = message.document.file_name
                url = file_id

            elif message.voice:
                media_type = "voice"
                file_id = message.voice.file_id
                file_unique_id = message.voice.file_unique_id
                duration = message.voice.duration
                file_size = message.voice.file_size
                mime_type = message.voice.mime_type
                url = file_id

            elif message.audio:
                media_type = "audio"
                file_id = message.audio.file_id
                file_unique_id = message.audio.file_unique_id
                duration = message.audio.duration
                file_size = message.audio.file_size
                mime_type = message.audio.mime_type
                file_name = message.audio.file_name
                url = file_id

            return TelegramMedia(
                type=media_type,
                file_id=file_id,
                file_unique_id=file_unique_id,
                width=width,
                height=height,
                duration=duration,
                file_size=file_size,
                mime_type=mime_type,
                file_name=file_name,
                caption=caption,
                url=url,
                thumbnail_url=thumbnail_url,
            )

        except Exception as e:
            logger.warning(f"Error converting media: {e}")
            return None

    def _convert_to_social_media_post(
        self, message: TelegramMessage, channel_info: TelegramChannelInfo
    ) -> SocialMediaPost:
        """Convert TelegramMessage to unified SocialMediaPost format."""
        # Extract title from text (first line or first 100 chars)
        title = self._extract_title(message.text)

        # Extract hashtags
        tags = self._extract_hashtags(message.text)

        # Collect media URLs
        image_urls = []
        video_urls = []

        for media in message.media:
            if media.type == "photo" and media.url:
                # Store file_id for processing by media storage system
                image_urls.append(media.url)
            elif media.type in ["video", "animation"] and media.url:
                video_urls.append(media.url)

        # Create message URL
        original_url = f"https://t.me/{channel_info.username}/{message.id}"

        return SocialMediaPost(
            id=f"telegram_{channel_info.username}_{message.id}",
            source_type="telegram",
            source_id=channel_info.username,
            source_name=channel_info.title,
            title=title,
            content=message.text,
            published_at=message.date,
            original_url=original_url,
            image_urls=image_urls,
            video_urls=video_urls,
            tags=tags,
            likes_count=None,  # Telegram doesn't have likes
            comments_count=message.replies,
            shares_count=message.forwards,
            views_count=message.views,
            author_name=channel_info.title,
            author_url=f"https://t.me/{channel_info.username}",
        )

    def _extract_title(self, text: str) -> str:
        """Extract title from message text."""
        if not text:
            return "Без заголовка"

        # Try to get first line
        lines = text.split("\n")
        first_line = lines[0].strip()

        if first_line and len(first_line) <= 100:
            return first_line

        # If first line is too long or empty, take first 100 characters
        truncated = f"{text[:97]}..." if len(text) > 100 else text
        return truncated.replace("\n", " ").strip()

    def _extract_hashtags(self, text: str) -> List[str]:
        """Extract hashtags from text."""
        import re

        return [] if not text else re.findall(r"#(\w+)", text)

    # Factory method for service registry
    @classmethod
    def create_from_config(cls, config: Settings) -> "TelegramFetcher":
        """Factory method to create TelegramFetcher from configuration."""
        return cls(config)
