"""Telegram client for fetching social media content."""

import asyncio
import re
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional, Set
from urllib.parse import urlparse

from loguru import logger
from telethon import TelegramClient
from telethon.errors import (
    ChannelPrivateError,
    FloodWaitError,
    UsernameNotOccupiedError,
)
from telethon.tl.types import Channel, Chat, Message, User, MessageMediaPhoto, MessageMediaDocument
from telethon.sessions import StringSession

from ...clients.base.interfaces import SocialMediaClient
from ...config import Settings
from .models import TelegramChannelInfo, TelegramMedia, TelegramMessage

# Import news blocks models
try:
    from ...news_blocks.models import NewsBlock
    from ...news_blocks.social_media_adapter import TelegramToNewsBlocksAdapter
    BLOCKS_AVAILABLE = True
except ImportError:
    BLOCKS_AVAILABLE = False
    NewsBlock = None
    TelegramToNewsBlocksAdapter = None


class TelegramFetcher(SocialMediaClient):
    """Telegram client for fetching channel messages."""

    def __init__(self, config: Settings):
        """Initialize the Telegram client."""
        super().__init__("Telegram Fetcher", "telegram", config.TELEGRAM_AUTO_SYNC)
        self.config = config
        self.client: Optional[TelegramClient] = None
        self.adapter = TelegramToNewsBlocksAdapter() if BLOCKS_AVAILABLE else None

    @classmethod
    def create_from_config(cls, config: Settings) -> "TelegramFetcher":
        """Create TelegramFetcher from configuration."""
        return cls(config)

    @property
    def is_configured(self) -> bool:
        """Check if Telegram is properly configured."""
        return bool(
            self.config.TELEGRAM_API_ID
            and self.config.TELEGRAM_API_HASH
            and self.config.TELEGRAM_SESSION_STRING
        )

    @classmethod
    def can_handle_url(cls, url: str) -> bool:
        """Check if this client can handle the given URL."""
        try:
            if not url.startswith(('http://', 'https://')):
                url = 'https://' + url
            
            parsed = urlparse(url)
            return parsed.netloc in ['t.me', 'telegram.me', 'telegram.org']
        except Exception:
            return False

    @classmethod
    def extract_source_id_from_url(cls, url: str) -> Optional[str]:
        """Extract channel/group username from Telegram URL."""
        try:
            if not url.startswith(('http://', 'https://')):
                url = 'https://' + url
            
            parsed = urlparse(url)
            if parsed.netloc not in ['t.me', 'telegram.me']:
                return None
            
            path = parsed.path.strip('/')
            if not path:
                return None
            
            # Handle different URL formats:
            # t.me/username
            # t.me/username/123 (with message ID)
            # t.me/s/username (public view)
            parts = path.split('/')
            
            # Skip 's' prefix for public view URLs
            if parts[0] == 's' and len(parts) > 1:
                return parts[1]
            
            return parts[0]
            
        except Exception as e:
            logger.warning(f"Failed to extract Telegram source ID from URL {url}: {e}")
            return None

    async def initialize(self) -> None:
        """Initialize the Telegram client."""
        if not self.is_configured:
            raise RuntimeError("Telegram client not properly configured")

        try:
            self.client = TelegramClient(
                StringSession(self.config.TELEGRAM_SESSION_STRING),
                self.config.TELEGRAM_API_ID,
                self.config.TELEGRAM_API_HASH,
            )

            await self.client.start()

            self._initialized = True
            logger.info("Telegram client initialized successfully")

        except Exception as e:
            logger.error(f"Failed to initialize Telegram client: {e}")
            raise

    async def close(self) -> None:
        """Close the Telegram client."""
        if self.client:
            await self.client.disconnect()
            self._initialized = False
            logger.info("Telegram client closed")

    async def fetch_news_blocks(
        self, source_id: str, limit: int = 20, **kwargs
    ) -> List[NewsBlock]:
        """Fetch posts from a Telegram channel and return as news blocks."""
        if not BLOCKS_AVAILABLE or not self.adapter:
            logger.warning("News blocks not available for Telegram")
            return []

        raw_data_list = await self.fetch_raw_data(source_id, limit, **kwargs)
        
        all_blocks = []
        for raw_data in raw_data_list:
            try:
                blocks = self.adapter.adapt_post_data(raw_data)
                all_blocks.extend(blocks)
            except Exception as e:
                logger.warning(f"Error converting Telegram data to blocks: {e}")
        
        return all_blocks

    async def fetch_raw_data(
        self, source_id: str, limit: int = 20, **kwargs
    ) -> List[Dict[str, Any]]:
        """Fetch raw data from a Telegram channel."""
        if not self._initialized or not self.client:
            logger.warning("Telegram client not initialized")
            return []

        try:
            channel_info = await self.get_channel_info(source_id)
            if not channel_info:
                logger.warning(f"Could not get info for channel: {source_id}")
                return []

            messages = await self.get_channel_messages_with_groups(
                source_id, limit, kwargs.get("offset_id", 0)
            )

            raw_data_list = []
            for message_group in messages:
                try:
                    raw_data = await self._convert_message_group_to_raw_data(message_group, channel_info)
                    if raw_data:
                        raw_data_list.append(raw_data)
                except Exception as e:
                    logger.warning(f"Error converting message group: {e}")

            return raw_data_list

        except Exception as e:
            logger.error(f"Error fetching raw data from {source_id}: {e}")
            return []

    async def get_channel_messages_with_groups(
        self, username: str, limit: int = 20, offset_id: int = 0
    ) -> List[List[TelegramMessage]]:
        """Get messages from a Telegram channel, grouping media albums."""
        if not self._initialized or not self.client:
            logger.warning("Telegram client not initialized")
            return []

        try:
            username = username.lstrip("@")
            entity = await self.client.get_entity(username)

            all_messages = []
            grouped_messages = {}  # grouped_id -> list of messages
            
            async for message in self.client.iter_messages(
                entity, limit=limit * 2, offset_id=offset_id  # Fetch more to account for grouping
            ):
                if isinstance(message, Message):
                    telegram_message = await self._convert_message(message)
                    if telegram_message:
                        all_messages.append((message, telegram_message))

            ungrouped_messages = []
            processed_ids: Set[int] = set()
            
            for original_msg, telegram_msg in all_messages:
                if telegram_msg.id in processed_ids:
                    continue
                    
                if hasattr(original_msg, 'grouped_id') and original_msg.grouped_id:
                    group_id = original_msg.grouped_id
                    
                    if group_id not in grouped_messages:
                        group_msgs = []
                        for other_orig, other_tg in all_messages:
                            if (hasattr(other_orig, 'grouped_id') and 
                                other_orig.grouped_id == group_id and
                                other_tg.id not in processed_ids):
                                group_msgs.append(other_tg)
                                processed_ids.add(other_tg.id)
                        
                        if group_msgs:
                            # Sort by message ID to maintain order
                            group_msgs.sort(key=lambda x: x.id)
                            grouped_messages[group_id] = group_msgs
                            ungrouped_messages.append(group_msgs)
                else:
                    ungrouped_messages.append([telegram_msg])
                    processed_ids.add(telegram_msg.id)

            return ungrouped_messages[:limit]

        except FloodWaitError as e:
            logger.warning(f"Rate limited, waiting {e.seconds} seconds")
            await asyncio.sleep(e.seconds)
            return []
        except (UsernameNotOccupiedError, ValueError):
            logger.warning(f"Channel not found: {username}")
            return []
        except ChannelPrivateError:
            logger.warning(f"Channel is private: {username}")
            return []
        except Exception as e:
            logger.error(f"Error getting messages from {username}: {e}")
            return []

    async def _convert_message_group_to_raw_data(
        self, message_group: List[TelegramMessage], channel_info: TelegramChannelInfo
    ) -> Optional[Dict[str, Any]]:
        """Convert a group of TelegramMessages to raw data format."""
        if not message_group:
            return None
            
        try:
            primary_message = message_group[0]
            
            photo_file_ids = []
            video_file_ids = []
            all_text_parts = []
            
            for message in message_group:
                if message.text.strip():
                    all_text_parts.append(message.text.strip())
                
                for media in message.media:
                    if media.type == "photo" and media.url:
                        photo_file_ids.append(media.url)
                    elif media.type in ["video", "animation"] and media.url:
                        video_file_ids.append(media.url)

            combined_text = '\n\n'.join(all_text_parts) if all_text_parts else ''
            
            total_media = len(photo_file_ids) + len(video_file_ids)
            is_story = total_media > 1
            is_circles = total_media >= 3  # 3+ media items could be "circles" style content
            
            raw_data = {
                'id': primary_message.id,
                'date': int(primary_message.date.timestamp()),
                'text': combined_text,
                'chat': {
                    'id': channel_info.id,
                    'title': channel_info.title,
                    'username': channel_info.username,
                    'type': 'channel',
                    'description': channel_info.description,
                    'participants_count': channel_info.participants_count,
                    'photo_url': channel_info.photo_url,
                },
                'photo': {'file_id': photo_file_ids[0]} if photo_file_ids else None,
                'video': {'file_id': video_file_ids[0]} if video_file_ids else None,
                'views': primary_message.views,
                'forwards': primary_message.forwards,
                'url': f"https://t.me/{channel_info.username}/{primary_message.id}",
                'media_files': {
                    'photos': photo_file_ids,
                    'videos': video_file_ids,
                },
                # Add metadata for better processing
                'is_story': is_story,
                'is_circles': is_circles,
                'media_group_count': len(message_group),
                'total_media_count': total_media,
                'grouped_message_ids': [msg.id for msg in message_group],
            }

            return raw_data

        except Exception as e:
            logger.warning(f"Error converting message group to raw data: {e}")
            return None

    async def _convert_message_to_raw_data(
        self, message: TelegramMessage, channel_info: TelegramChannelInfo
    ) -> Optional[Dict[str, Any]]:
        """Convert TelegramMessage to raw data format (legacy method)."""
        # Convert single message to group format and use new method
        return await self._convert_message_group_to_raw_data([message], channel_info)

    async def get_channel_info(self, username: str) -> Optional[TelegramChannelInfo]:
        """Get information about a Telegram channel."""
        if not self._initialized or not self.client:
            logger.warning("Telegram client not initialized")
            return None

        try:
            username = username.lstrip("@")
            entity = await self.client.get_entity(username)

            if isinstance(entity, Channel):
                full_info = await self.client.get_entity(entity)

                return TelegramChannelInfo(
                    id=entity.id,
                    title=entity.title,
                    username=entity.username,
                    description=getattr(full_info, "about", ""),
                    participants_count=getattr(full_info, "participants_count", 0),
                    photo_url=None,  # Would need additional API call
                    is_verified=entity.verified,
                    is_restricted=entity.restricted,
                )
            else:
                logger.warning(f"Entity {username} is not a channel")
                return None

        except (UsernameNotOccupiedError, ValueError):
            logger.warning(f"Channel not found: {username}")
            return None
        except ChannelPrivateError:
            logger.warning(f"Channel is private: {username}")
            return None
        except Exception as e:
            logger.error(f"Error getting channel info for {username}: {e}")
            return None

    async def get_channel_messages(
        self, username: str, limit: int = 20, offset_id: int = 0
    ) -> List[TelegramMessage]:
        """Get messages from a Telegram channel (legacy method)."""
        message_groups = await self.get_channel_messages_with_groups(username, limit, offset_id)
        # Flatten groups for compatibility
        messages = []
        for group in message_groups:
            messages.extend(group)
        return messages[:limit]

    async def _convert_message(self, message: Message) -> Optional[TelegramMessage]:
        """Convert Telethon Message to TelegramMessage."""
        try:
            media_list = []
            
            if message.media:
                if isinstance(message.media, MessageMediaPhoto):
                    media = await self._convert_photo_media(message)
                    if media:
                        media_list.append(media)
                
                elif isinstance(message.media, MessageMediaDocument):
                    media = await self._convert_document_media(message)
                    if media:
                        media_list.append(media)
                
                else:
                    media = await self._convert_media(message)
                    if media:
                        media_list.append(media)

            return TelegramMessage(
                id=message.id,
                text=message.message or "",
                date=message.date.replace(tzinfo=timezone.utc),
                views=getattr(message, "views", 0),
                forwards=getattr(message, "forwards", 0),
                media=media_list,
            )

        except Exception as e:
            logger.warning(f"Error converting message: {e}")
            return None

    async def _convert_photo_media(self, message: Message) -> Optional[TelegramMedia]:
        """Convert photo media specifically."""
        try:
            if not message.media or not hasattr(message.media, 'photo'):
                return None
                
            photo = message.media.photo
            if not photo:
                return None

            file_id = str(photo.id)
            file_unique_id = str(photo.access_hash)
            width = None
            height = None
            
            if photo.sizes:
                largest_size = max(photo.sizes, key=lambda s: getattr(s, 'w', 0) * getattr(s, 'h', 0))
                width = getattr(largest_size, 'w', None)
                height = getattr(largest_size, 'h', None)

            return TelegramMedia(
                type="photo",
                file_id=file_id,
                file_unique_id=file_unique_id,
                width=width,
                height=height,
                caption=message.message or "",
                url=file_id,  # Store file_id as URL for later processing
            )

        except Exception as e:
            logger.warning(f"Error converting photo media: {e}")
            return None

    async def _convert_document_media(self, message: Message) -> Optional[TelegramMedia]:
        """Convert document media (videos, gifs, etc.) specifically."""
        try:
            if not message.media or not hasattr(message.media, 'document'):
                return None
                
            document = message.media.document
            if not document:
                return None

            file_id = str(document.id)
            file_unique_id = str(document.access_hash)
            file_size = document.size
            mime_type = document.mime_type
            
            media_type = "document"
            if mime_type:
                if mime_type.startswith("video/"):
                    media_type = "video"
                elif mime_type.startswith("image/"):
                    media_type = "photo"
                elif mime_type.startswith("audio/"):
                    media_type = "audio"
                elif "gif" in mime_type.lower():
                    media_type = "animation"
            
            width = None
            height = None
            duration = None
            file_name = None
            
            for attr in document.attributes:
                if hasattr(attr, "file_name"):
                    file_name = attr.file_name
                elif hasattr(attr, "w") and hasattr(attr, "h"):
                    width = attr.w
                    height = attr.h
                elif hasattr(attr, "duration"):
                    duration = attr.duration

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
                caption=message.message or "",
                url=file_id,  # Store file_id as URL for later processing
            )

        except Exception as e:
            logger.warning(f"Error converting document media: {e}")
            return None

    async def _convert_media(self, message: Message) -> Optional[TelegramMedia]:
        """Convert message media to TelegramMedia (legacy method)."""
        try:
            if not message.media:
                return None

            media_type = "unknown"
            file_id = None
            file_unique_id = None
            width = None
            height = None
            duration = None
            file_size = None
            mime_type = None
            file_name = None
            caption = message.message or ""
            url = None
            thumbnail_url = None

            if hasattr(message.media, "photo"):
                media_type = "photo"
                photo = message.media.photo
                if photo:
                    file_id = str(photo.id)
                    file_unique_id = str(photo.access_hash)
                    if photo.sizes:
                        largest_size = max(photo.sizes, key=lambda s: getattr(s, 'w', 0) * getattr(s, 'h', 0))
                        width = getattr(largest_size, 'w', None)
                        height = getattr(largest_size, 'h', None)

            elif hasattr(message.media, "document"):
                document = message.media.document
                if document:
                    file_id = str(document.id)
                    file_unique_id = str(document.access_hash)
                    file_size = document.size
                    mime_type = document.mime_type
                    
                    if mime_type:
                        if mime_type.startswith("video/"):
                            media_type = "video"
                        elif mime_type.startswith("image/"):
                            media_type = "photo"
                        elif mime_type.startswith("audio/"):
                            media_type = "audio"
                        else:
                            media_type = "document"
                    
                    for attr in document.attributes:
                        if hasattr(attr, "file_name"):
                            file_name = attr.file_name
                        elif hasattr(attr, "w") and hasattr(attr, "h"):
                            width = attr.w
                        elif hasattr(attr, "duration"):
                            duration = attr.duration

            if not file_id or not file_unique_id:
                logger.debug(f"Skipping media conversion - missing file identifiers. file_id: {file_id}, file_unique_id: {file_unique_id}")
                return None

            # For Telegram, we store the file_id as URL for later processing
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

    async def get_source_info(self, source_id: str) -> Dict[str, Any]:
        """Get information about a Telegram channel."""
        channel_info = await self.get_channel_info(source_id)
        if not channel_info:
            return {}

        return {
            "id": str(channel_info.id),
            "name": channel_info.title,
            "username": channel_info.username,
            "description": channel_info.description,
            "subscribers_count": channel_info.participants_count,
            "photo_url": channel_info.photo_url,
            "is_verified": channel_info.is_verified,
            "is_restricted": channel_info.is_restricted,
            "url": f"https://t.me/{channel_info.username}",
        }

    async def validate_source(self, source_id: str) -> bool:
        """Validate if a Telegram channel exists and is accessible."""
        try:
            channel_info = await self.get_channel_info(source_id)
            return channel_info is not None
        except Exception:
            return False

    def _extract_title(self, text: str) -> str:
        """Extract title from message text."""
        if not text:
            return "Telegram Post"

        lines = text.split("\n")
        first_line = lines[0].strip()

        if len(first_line) > 100:
            return first_line[:100] + "..."
        elif first_line:
            return first_line
        else:
            return text[:100] + "..." if len(text) > 100 else text

    def _extract_hashtags(self, text: str) -> List[str]:
        """Extract hashtags from message text."""
        if not text:
            return []

        hashtag_pattern = r"#\w+"
        hashtags = re.findall(hashtag_pattern, text)
        return [tag.lower() for tag in hashtags]
