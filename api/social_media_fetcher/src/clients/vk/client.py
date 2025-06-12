"""VK client implementation using vk-api."""

import asyncio
from datetime import datetime
from typing import Any, Dict, List, Optional

import vk_api
from loguru import logger

from ...config import Settings
from ...models import SocialMediaPost
from ..base.interfaces import SocialMediaClient
from .models import VKAttachment, VKGroupInfo, VKPost


class VKFetcher(SocialMediaClient):
    """VK client for fetching group information and posts."""

    def __init__(self, config: Optional[Settings] = None):
        """Initialize the VK fetcher."""
        self.config = config or Settings()
        client_config = self.config.get_client_config("vk")
        auto_sync_enabled = client_config.get("auto_sync_enabled", True)
        
        super().__init__(
            name="VK Fetcher", 
            client_type="vk",
            auto_sync_enabled=auto_sync_enabled
        )

        self.vk_session = None
        self.vk = None

    @property
    def is_configured(self) -> bool:
        """Check if VK is properly configured."""
        return self.config.vk_configured

    async def initialize(self) -> None:
        """Initialize the VK client."""
        if not self.is_configured:
            logger.warning("VK not configured - skipping initialization")
            return

        try:
            client_config = self.config.get_client_config("vk")

            self.vk_session = vk_api.VkApi(token=client_config["access_token"])
            self.vk = self.vk_session.get_api()
            self._initialized = True
            logger.info(f"{self.name} initialized successfully")

        except Exception as e:
            logger.error(f"Failed to initialize {self.name}: {e}")
            raise

    async def close(self) -> None:
        """Close the VK client."""
        if self._initialized:
            self._initialized = False
            logger.info(f"{self.name} closed successfully")

    def _ensure_initialized(self):
        """Ensure the client is initialized."""
        if not self._initialized:
            raise RuntimeError(f"{self.name} not initialized")

    async def fetch_posts(
        self, source_id: str, limit: int = 20, **kwargs
    ) -> List[SocialMediaPost]:
        """Fetch posts from a VK group in unified format."""
        if not self._initialized or not self.vk:
            logger.warning(f"{self.name} not initialized properly")
            return []

        try:
            group_info = await self.get_group_info(source_id)

            posts = await self.get_group_posts(
                source_id, limit, kwargs.get("offset", 0)
            )

            social_posts = []
            for post in posts:
                try:
                    social_post = self.convert_to_social_media_post(post, group_info)
                    social_posts.append(social_post)
                except Exception as e:
                    logger.warning(f"Error converting post {post.id}: {e}")

            return social_posts

        except Exception as e:
            logger.error(f"Error fetching posts from {source_id}: {e}")
            return []

    async def get_source_info(self, source_id: str) -> Dict[str, Any]:
        """Get information about a VK group."""
        if not self._initialized or not self.vk:
            logger.warning(f"{self.name} not initialized properly")
            return {
                "id": source_id,
                "screen_name": source_id,
                "name": source_id,
                "type": "vk_group",
            }

        try:
            group_info = await self.get_group_info(source_id)
            return {
                "id": group_info.id,
                "screen_name": group_info.screen_name,
                "name": group_info.name,
                "description": group_info.description,
                "members_count": group_info.members_count,
                "photo_url": group_info.photo_url,
                "is_verified": group_info.is_verified,
                "type": "vk_group",
            }
        except Exception as e:
            logger.error(f"Error getting group info for {source_id}: {e}")
            return {
                "id": source_id,
                "screen_name": source_id,
                "name": source_id,
                "type": "vk_group",
            }

    async def validate_source(self, source_id: str) -> bool:
        """Validate if a VK group exists and is accessible."""
        if not self._initialized or not self.vk:
            return False

        try:
            await self.get_group_info(source_id)
            return True
        except Exception as e:
            logger.debug(f"Group validation failed for {source_id}: {e}")
            return False

    async def get_group_info(self, group_id: str) -> VKGroupInfo:
        """Get information about a VK group."""
        self._ensure_initialized()

        try:
            clean_group_id = group_id.lstrip("-")

            response = await asyncio.get_event_loop().run_in_executor(
                None,
                lambda: self.vk.groups.getById(
                    group_ids=clean_group_id,
                    fields=["description", "members_count", "activity", "verified"],
                ),
            )

            if not response:
                raise ValueError(f"Group {group_id} not found")

            group_data = response[0]

            photo_url = None
            if "photo_200" in group_data:
                photo_url = group_data["photo_200"]
            elif "photo_100" in group_data:
                photo_url = group_data["photo_100"]
            elif "photo_50" in group_data:
                photo_url = group_data["photo_50"]

            return VKGroupInfo(
                id=group_data["id"],
                name=group_data["name"],
                screen_name=group_data["screen_name"],
                description=group_data.get("description"),
                members_count=group_data.get("members_count"),
                photo_url=photo_url,
                is_closed=group_data.get("is_closed", 0) == 1,
                is_verified=group_data.get("verified", 0) == 1,
                activity=group_data.get("activity"),
            )

        except vk_api.exceptions.ApiError as e:
            if e.code == 100:
                raise ValueError(f"Invalid group ID: {group_id}")
            elif e.code == 15:
                raise ValueError(f"Access denied to group {group_id}")
            else:
                logger.error(f"VK API error getting group info: {e}")
                raise
        except Exception as e:
            logger.error(f"Error getting VK group info for {group_id}: {e}")
            raise

    async def get_group_posts(
        self, group_id: str, count: int = 20, offset: int = 0
    ) -> List[VKPost]:
        """Get posts from a VK group."""
        self._ensure_initialized()

        try:
            clean_group_id = group_id.lstrip("-")
            owner_id = f"-{clean_group_id}"

            client_config = self.config.get_client_config("vk")
            count = min(count, client_config.get("max_posts_per_request", 50))

            response = await asyncio.get_event_loop().run_in_executor(
                None,
                lambda: self.vk.wall.get(
                    owner_id=owner_id,
                    count=count,
                    offset=offset,
                    extended=1,
                    filter="owner",
                ),
            )

            posts = []
            for post_data in response["items"]:
                vk_post = await self._convert_post(post_data)
                if vk_post:
                    posts.append(vk_post)

            return posts

        except vk_api.exceptions.ApiError as e:
            if e.code == 100:
                raise ValueError(f"Invalid group ID: {group_id}")
            elif e.code == 15:
                raise ValueError(f"Access denied to group {group_id}")
            else:
                logger.error(f"VK API error getting posts: {e}")
                raise
        except Exception as e:
            logger.error(f"Error getting VK posts from {group_id}: {e}")
            raise

    async def search_group_posts(
        self, group_id: str, query: str, count: int = 20
    ) -> List[VKPost]:
        """Search for posts in a VK group."""
        self._ensure_initialized()

        try:
            clean_group_id = group_id.lstrip("-")
            owner_id = f"-{clean_group_id}"

            client_config = self.config.get_client_config("vk")
            count = min(count, client_config.get("max_posts_per_request", 50))

            response = await asyncio.get_event_loop().run_in_executor(
                None,
                lambda: self.vk.wall.search(
                    owner_id=owner_id, query=query, count=count, extended=1
                ),
            )

            posts = []
            for post_data in response["items"]:
                vk_post = await self._convert_post(post_data)
                if vk_post:
                    posts.append(vk_post)

            return posts

        except vk_api.exceptions.ApiError as e:
            if e.code == 100:
                raise ValueError(f"Invalid group ID: {group_id}")
            elif e.code == 15:
                raise ValueError(f"Access denied to group {group_id}")
            else:
                logger.error(f"VK API error searching posts: {e}")
                raise
        except Exception as e:
            logger.error(f"Error searching VK posts in {group_id}: {e}")
            raise

    async def _convert_post(self, post_data: Dict[str, Any]) -> Optional[VKPost]:
        """Convert VK API post data to VKPost model."""
        try:
            attachments = []
            if "attachments" in post_data:
                for attachment_data in post_data["attachments"]:
                    if attachment := self._convert_attachment(attachment_data):
                        attachments.append(attachment)

            copy_history = post_data.get("copy_history", [])
            return VKPost(
                id=post_data["id"],
                owner_id=post_data["owner_id"],
                from_id=post_data["from_id"],
                date=datetime.fromtimestamp(post_data["date"]),
                text=post_data.get("text", ""),
                attachments=attachments,
                likes_count=post_data.get("likes", {}).get("count"),
                comments_count=post_data.get("comments", {}).get("count"),
                reposts_count=post_data.get("reposts", {}).get("count"),
                views_count=post_data.get("views", {}).get("count"),
                is_pinned=post_data.get("is_pinned", 0) == 1,
                is_marked_as_ads=post_data.get("marked_as_ads", 0) == 1,
                post_type=post_data.get("post_type"),
                copy_history=copy_history,
            )

        except Exception as e:
            logger.warning(f"Error converting VK post {post_data.get('id')}: {e}")
            return None

    def _convert_attachment(
        self, attachment_data: Dict[str, Any]
    ) -> Optional[VKAttachment]:
        """Convert VK attachment data to VKAttachment model."""
        try:
            attachment_type = attachment_data["type"]
            attachment_obj = attachment_data.get(attachment_type, {})

            url = None
            width = None
            height = None
            title = None
            description = None
            duration = None
            file_size = None

            if attachment_type == "photo":
                if sizes := attachment_obj.get("sizes", []):
                    largest = max(
                        sizes, key=lambda x: x.get("width", 0) * x.get("height", 0)
                    )
                    url = largest.get("url")
                    width = largest.get("width")
                    height = largest.get("height")
                else:
                    for size in [
                        "photo_2560",
                        "photo_1280",
                        "photo_807",
                        "photo_604",
                        "photo_130",
                        "photo_75",
                    ]:
                        if size in attachment_obj:
                            url = attachment_obj[size]
                            break

            elif attachment_type == "video":
                title = attachment_obj.get("title")
                description = attachment_obj.get("description")
                duration = attachment_obj.get("duration")
                width = attachment_obj.get("width")
                height = attachment_obj.get("height")

                if "image" in attachment_obj:
                    images = attachment_obj["image"]
                    if images:
                        largest_image = max(
                            images, key=lambda x: x.get("width", 0) * x.get("height", 0)
                        )
                        url = largest_image.get("url")

            elif attachment_type == "doc":
                title = attachment_obj.get("title")
                file_size = attachment_obj.get("size")
                url = attachment_obj.get("url")

            elif attachment_type == "link":
                url = attachment_obj.get("url")
                title = attachment_obj.get("title")
                description = attachment_obj.get("description")

            elif attachment_type == "audio":
                title = f"{attachment_obj.get('artist', '')} - {attachment_obj.get('title', '')}"
                duration = attachment_obj.get("duration")
                url = attachment_obj.get("url")

            return VKAttachment(
                type=attachment_type,
                url=url,
                width=width,
                height=height,
                title=title,
                description=description,
                duration=duration,
                file_size=file_size,
            )

        except Exception as e:
            logger.warning(f"Error converting VK attachment: {e}")
            return None

    def convert_to_social_media_post(
        self, post: VKPost, group_info: VKGroupInfo
    ) -> SocialMediaPost:
        """Convert VKPost to unified SocialMediaPost format."""
        title = self._extract_title(post.text)

        tags = self._extract_hashtags(post.text)

        image_urls = []
        video_urls = []

        for attachment in post.attachments:
            if attachment.type == "photo" and attachment.url:
                image_urls.append(attachment.url)
            elif attachment.type == "video" and attachment.url:
                video_urls.append(attachment.url)

        original_url = f"https://vk.com/wall{post.owner_id}_{post.id}"

        return SocialMediaPost(
            id=f"vk_{group_info.screen_name}_{post.id}",
            source_type="vk",
            source_id=group_info.screen_name,
            source_name=group_info.name,
            title=title,
            content=post.text,
            published_at=post.date,
            original_url=original_url,
            image_urls=image_urls,
            video_urls=video_urls,
            tags=tags,
            likes_count=post.likes_count,
            comments_count=post.comments_count,
            shares_count=post.reposts_count,
            views_count=post.views_count,
            author_name=group_info.name,
            author_url=f"https://vk.com/{group_info.screen_name}",
        )

    def _extract_title(self, text: str) -> str:
        """Extract title from post text."""
        if not text:
            return "Без заголовка"

        lines = text.split("\n")
        first_line = lines[0].strip()

        if first_line and len(first_line) <= 100:
            return first_line

        truncated = text[:97] + "..." if len(text) > 100 else text
        return truncated.replace("\n", " ").strip()

    def _extract_hashtags(self, text: str) -> List[str]:
        """Extract hashtags from text."""
        import re

        if not text:
            return []

        hashtag_pattern = r"#(\w+)"
        matches = re.findall(hashtag_pattern, text)
        return matches

    @classmethod
    def create_from_config(cls, config: Settings) -> "VKFetcher":
        """Factory method to create VKFetcher from configuration."""
        return cls(config)
