"""VK client for fetching social media content."""

import asyncio
from typing import Any, Dict, List, Optional
from urllib.parse import urlparse

from loguru import logger

from ...clients.base.interfaces import SocialMediaClient
from ...config import Settings
import vk_api
from .models import VKGroupInfo as VKGroup, VKPost

# Import news blocks models
try:
    from ...news_blocks.models import NewsBlock
    from ...news_blocks.social_media_adapter import VKToNewsBlocksAdapter
    BLOCKS_AVAILABLE = True
except ImportError:
    BLOCKS_AVAILABLE = False
    NewsBlock = None
    VKToNewsBlocksAdapter = None


class VKFetcher(SocialMediaClient):
    """VK client for fetching group posts."""

    def __init__(self, config: Settings):
        """Initialize the VK client."""
        super().__init__("VK Fetcher", "vk", config.VK_AUTO_SYNC)
        self.config = config
        self.vk: Optional[vk_api.VkApi] = None
        self.api = None
        self.adapter = VKToNewsBlocksAdapter() if BLOCKS_AVAILABLE else None

    @classmethod
    def create_from_config(cls, config: Settings) -> "VKFetcher":
        """Create VKFetcher from configuration."""
        return cls(config)

    @property
    def is_configured(self) -> bool:
        """Check if VK is properly configured."""
        return bool(self.config.VK_ACCESS_TOKEN)

    @classmethod
    def can_handle_url(cls, url: str) -> bool:
        """Check if this client can handle the given URL."""
        try:
            # Handle URLs with or without protocol
            if not url.startswith(('http://', 'https://')):
                url = 'https://' + url
            
            parsed = urlparse(url)
            return parsed.netloc in ['vk.com', 'vkontakte.ru', 'm.vk.com']
        except Exception:
            return False

    @classmethod
    def extract_source_id_from_url(cls, url: str) -> Optional[str]:
        """Extract group/user ID from VK URL."""
        try:
            # Handle URLs with or without protocol
            if not url.startswith(('http://', 'https://')):
                url = 'https://' + url
            
            parsed = urlparse(url)
            if parsed.netloc not in ['vk.com', 'vkontakte.ru', 'm.vk.com']:
                return None
            
            # Extract ID from path
            path = parsed.path.strip('/')
            if not path:
                return None
            
            # Handle different URL formats:
            # vk.com/groupname
            # vk.com/public123456
            # vk.com/club123456
            # vk.com/id123456
            parts = path.split('/')
            
            # Get the first part of the path
            source_id = parts[0]
            
            # Remove common prefixes
            if source_id.startswith('public'):
                source_id = source_id[6:]  # Remove 'public' prefix
            elif source_id.startswith('club'):
                source_id = source_id[4:]  # Remove 'club' prefix
            
            return source_id
            
        except Exception as e:
            logger.warning(f"Failed to extract VK source ID from URL {url}: {e}")
            return None

    async def initialize(self) -> None:
        """Initialize the VK client."""
        if not self.is_configured:
            raise RuntimeError("VK client not properly configured")

        try:
            self.vk = vk_api.VkApi(token=self.config.VK_ACCESS_TOKEN)
            self.api = self.vk.get_api()
            self._initialized = True
            logger.info("VK client initialized successfully")

        except Exception as e:
            logger.error(f"Failed to initialize VK client: {e}")
            raise

    async def close(self) -> None:
        """Close the VK client."""
        if self.vk:
            # VK API doesn't have a close method
            self.vk = None
            self.api = None
            self._initialized = False
            logger.info("VK client closed")

    async def fetch_news_blocks(
        self, source_id: str, limit: int = 20, **kwargs
    ) -> List[NewsBlock]:
        """Fetch posts from a VK group and return as news blocks."""
        if not BLOCKS_AVAILABLE or not self.adapter:
            logger.warning("News blocks not available for VK")
            return []

        raw_data_list = await self.fetch_raw_data(source_id, limit, **kwargs)
        
        all_blocks = []
        for raw_data in raw_data_list:
            try:
                blocks = self.adapter.adapt_post_data(raw_data)
                all_blocks.extend(blocks)
            except Exception as e:
                logger.warning(f"Error converting VK data to blocks: {e}")
        
        return all_blocks

    async def fetch_raw_data(
        self, source_id: str, limit: int = 20, **kwargs
    ) -> List[Dict[str, Any]]:
        """Fetch raw data from a VK group."""
        if not self._initialized or not self.vk:
            logger.warning("VK client not initialized")
            return []

        try:
            # Get group info
            group_info = await self.get_group_info(source_id)
            if not group_info:
                logger.warning(f"Could not get info for group: {source_id}")
                return []

            # Fetch posts
            posts = await self.get_group_posts(
                source_id, limit, kwargs.get("offset", 0)
            )

            raw_data_list = []
            for post in posts:
                try:
                    # Convert to raw data format
                    raw_data = self._convert_post_to_raw_data(post, group_info)
                    if raw_data:
                        raw_data_list.append(raw_data)
                except Exception as e:
                    logger.warning(f"Error converting post {post.id}: {e}")

            return raw_data_list

        except Exception as e:
            logger.error(f"Error fetching raw data from {source_id}: {e}")
            return []

    def _convert_post_to_raw_data(
        self, post: VKPost, group_info: VKGroup
    ) -> Optional[Dict[str, Any]]:
        """Convert VKPost to raw data format."""
        try:
            # Collect media URLs
            image_urls = []
            video_urls = []
            
            for attachment in post.attachments:
                if attachment.get('type') == 'photo':
                    photo = attachment.get('photo', {})
                    sizes = photo.get('sizes', [])
                    if sizes:
                        # Get largest size
                        largest = max(sizes, key=lambda x: x.get('width', 0) * x.get('height', 0))
                        image_urls.append(largest.get('url', ''))
                
                elif attachment.get('type') == 'video':
                    video = attachment.get('video', {})
                    # VK video URLs need special handling
                    video_urls.append(f"vk_video_{video.get('owner_id', '')}_{video.get('id', '')}")

            raw_data = {
                'id': post.id,
                'owner_id': post.owner_id,
                'date': post.date,
                'text': post.text,
                'attachments': post.attachments,
                'likes': {'count': post.likes_count},
                'reposts': {'count': post.reposts_count},
                'views': {'count': post.views_count},
                'comments': {'count': post.comments_count},
                'group_name': group_info.name,
                'group_screen_name': group_info.screen_name,
                'url': f"https://vk.com/wall{post.owner_id}_{post.id}",
                'media_files': {
                    'images': image_urls,
                    'videos': video_urls,
                }
            }

            return raw_data

        except Exception as e:
            logger.warning(f"Error converting post to raw data: {e}")
            return None

    async def get_group_info(self, group_id: str) -> Optional[VKGroup]:
        """Get information about a VK group."""
        if not self._initialized or not self.api:
            logger.warning("VK client not initialized")
            return None

        try:
            # Convert group_id to proper format
            if group_id.isdigit():
                group_id = f"-{group_id}"  # Numeric IDs need minus prefix
            
            # Get group info
            response = self.api.groups.getById(
                group_ids=group_id,
                fields='description,members_count,verified,status'
            )
            
            if not response:
                return None
            
            group = response[0]
            
            return VKGroup(
                id=group['id'],
                name=group['name'],
                screen_name=group.get('screen_name', ''),
                description=group.get('description', ''),
                members_count=group.get('members_count', 0),
                photo_url=group.get('photo_200', ''),
                is_verified=group.get('verified', 0) == 1,
                is_closed=group.get('is_closed', False)
            )
            
        except Exception as e:
            logger.error(f"Error getting group info for {group_id}: {e}")
            return None

    async def get_group_posts(
        self, group_id: str, count: int = 20, offset: int = 0
    ) -> List[VKPost]:
        """Get posts from a VK group."""
        if not self._initialized or not self.api:
            logger.warning("VK client not initialized")
            return []

        try:
            # Convert group_id to proper format for wall.get
            if not group_id.startswith('-') and group_id.isdigit():
                owner_id = f"-{group_id}"
            elif group_id.startswith('club'):
                owner_id = f"-{group_id[4:]}"
            elif group_id.startswith('public'):
                owner_id = f"-{group_id[6:]}"
            else:
                # Try to get group info first
                group_info = await self.get_group_info(group_id)
                if group_info:
                    owner_id = f"-{group_info.id}"
                else:
                    return []
            
            # Get posts
            response = self.api.wall.get(
                owner_id=owner_id,
                count=count,
                offset=offset,
                extended=0
            )
            
            if not response or 'items' not in response:
                return []
            
            posts = []
            for item in response['items']:
                try:
                    post = VKPost(
                        id=item['id'],
                        owner_id=item['owner_id'],
                        date=item['date'],
                        text=item.get('text', ''),
                        attachments=item.get('attachments', []),
                        likes_count=item.get('likes', {}).get('count', 0),
                        reposts_count=item.get('reposts', {}).get('count', 0),
                        views_count=item.get('views', {}).get('count', 0),
                        comments_count=item.get('comments', {}).get('count', 0)
                    )
                    posts.append(post)
                except Exception as e:
                    logger.warning(f"Error parsing post: {e}")
            
            return posts
            
        except Exception as e:
            logger.error(f"Error getting posts from {group_id}: {e}")
            return []

    async def get_source_info(self, source_id: str) -> Dict[str, Any]:
        """Get information about a VK group."""
        group_info = await self.get_group_info(source_id)
        if not group_info:
            return {}

        return {
            "id": str(group_info.id),
            "name": group_info.name,
            "screen_name": group_info.screen_name,
            "description": group_info.description,
            "members_count": group_info.members_count,
            "photo_url": group_info.photo_url,
            "is_verified": group_info.is_verified,
            "is_closed": group_info.is_closed,
            "url": f"https://vk.com/{group_info.screen_name}",
        }

    async def validate_source(self, source_id: str) -> bool:
        """Validate if a VK group exists and is accessible."""
        try:
            group_info = await self.get_group_info(source_id)
            return group_info is not None
        except Exception:
            return False
