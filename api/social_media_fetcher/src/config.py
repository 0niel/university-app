"""Configuration settings for the social media fetcher."""

import os
from pathlib import Path
from typing import Any, Dict, List, Optional

from pydantic import Field, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):

    model_config = SettingsConfigDict(
        env_file=str((Path(__file__).resolve().parents[1] / ".env").resolve()),
        env_file_encoding="utf-8",
        extra="ignore",
    )

    HOST: str = Field(default="0.0.0.0", env="HOST")
    PORT: int = Field(default=8000, env="PORT")
    DEBUG: bool = Field(default=False, env="DEBUG")

    API_KEY: Optional[str] = Field(default=None, env="API_KEY")
    ALLOWED_ORIGINS: str = Field(default="*", env="ALLOWED_ORIGINS")

    TELEGRAM_API_ID: Optional[int] = Field(default=None, env="TELEGRAM_API_ID")
    TELEGRAM_API_HASH: Optional[str] = Field(default=None, env="TELEGRAM_API_HASH")
    TELEGRAM_SESSION_STRING: Optional[str] = Field(
        default=None, env="TELEGRAM_SESSION_STRING"
    )
    TELEGRAM_AUTO_SYNC: bool = Field(default=True, env="TELEGRAM_AUTO_SYNC")

    VK_ACCESS_TOKEN: Optional[str] = Field(default=None, env="VK_ACCESS_TOKEN")
    VK_AUTO_SYNC: bool = Field(default=True, env="VK_AUTO_SYNC")

    SUPABASE_URL: Optional[str] = Field(default=None, env="SUPABASE_URL")
    SUPABASE_SERVICE_KEY: Optional[str] = Field(
        default=None, env="SUPABASE_SERVICE_KEY"
    )
    SUPABASE_BUCKET_IMAGES: str = Field(
        default="social-media-images", env="SUPABASE_BUCKET_IMAGES"
    )
    SUPABASE_BUCKET_VIDEOS: str = Field(
        default="social-media-videos", env="SUPABASE_BUCKET_VIDEOS"
    )

    RATE_LIMIT_REQUESTS: int = Field(default=100, env="RATE_LIMIT_REQUESTS")
    RATE_LIMIT_WINDOW: int = Field(default=3600, env="RATE_LIMIT_WINDOW")

    MAX_MESSAGES_PER_REQUEST: int = Field(default=30, env="MAX_MESSAGES_PER_REQUEST")
    MAX_POSTS_PER_REQUEST: int = Field(default=30, env="MAX_POSTS_PER_REQUEST")

    ENABLE_BACKGROUND_SYNC: bool = Field(default=True, env="ENABLE_BACKGROUND_SYNC")
    SYNC_INTERVAL_MINUTES: int = Field(default=30, env="SYNC_INTERVAL_MINUTES")

    MAX_FILE_SIZE_MB: int = Field(default=50, env="MAX_FILE_SIZE_MB")
    SUPPORTED_IMAGE_FORMATS: List[str] = ["jpg", "jpeg", "png", "gif", "webp"]
    SUPPORTED_VIDEO_FORMATS: List[str] = ["mp4", "mov", "avi", "webm"]

    PROXY_URL: Optional[str] = Field(default=None, env="PROXY_URL")
    PROXY_USERNAME: Optional[str] = Field(default=None, env="PROXY_USERNAME")
    PROXY_PASSWORD: Optional[str] = Field(default=None, env="PROXY_PASSWORD")

    CLIENT_TIMEOUT: int = Field(default=30, env="CLIENT_TIMEOUT")

    @field_validator("TELEGRAM_API_ID", mode="before")
    @classmethod
    def validate_telegram_api_id(cls, v):
        if v is not None and v != "":
            try:
                return int(v)
            except (ValueError, TypeError):
                return None
        return None

    def get_client_config(self, client_type: str) -> Dict[str, Any]:
        if client_type == "telegram":
            return {
                "api_id": self.TELEGRAM_API_ID,
                "api_hash": self.TELEGRAM_API_HASH,
                "session_string": self.TELEGRAM_SESSION_STRING,
                "proxy": self.get_proxy_dict(),
                "max_messages_per_request": self.MAX_MESSAGES_PER_REQUEST,
                "auto_sync_enabled": self.TELEGRAM_AUTO_SYNC,
            }
        elif client_type == "vk":
            return {
                "access_token": self.VK_ACCESS_TOKEN,
                "proxy": self.get_proxy_dict(),
                "max_posts_per_request": self.MAX_POSTS_PER_REQUEST,
                "auto_sync_enabled": self.VK_AUTO_SYNC,
            }
        else:
            return {}

    def is_client_enabled(self, client_type: str) -> bool:
        if client_type == "telegram":
            return self.telegram_configured
        elif client_type == "vk":
            return self.vk_configured
        elif client_type == "mirea":
            return True
        else:
            return False

    def get_database_config(self) -> Dict[str, Any]:
        return {
            "url": self.SUPABASE_URL,
            "service_key": self.SUPABASE_SERVICE_KEY,
            "bucket_images": self.SUPABASE_BUCKET_IMAGES,
            "bucket_videos": self.SUPABASE_BUCKET_VIDEOS,
        }

    def get_scheduler_config(self) -> Dict[str, Any]:
        return {
            "enabled": self.ENABLE_BACKGROUND_SYNC,
            "interval_minutes": self.SYNC_INTERVAL_MINUTES,
        }

    def get_media_config(self) -> Dict[str, Any]:
        return {
            "max_file_size_mb": self.MAX_FILE_SIZE_MB,
            "supported_image_formats": self.SUPPORTED_IMAGE_FORMATS,
            "supported_video_formats": self.SUPPORTED_VIDEO_FORMATS,
        }

    def get_server_config(self) -> Dict[str, Any]:
        return {
            "host": self.HOST,
            "port": self.PORT,
            "debug": self.DEBUG,
            "api_key": self.API_KEY,
            "allowed_origins": self.ALLOWED_ORIGINS.split(","),
        }

    @property
    def telegram_configured(self) -> bool:
        return bool(self.TELEGRAM_API_ID and self.TELEGRAM_API_HASH)

    @property
    def vk_configured(self) -> bool:
        return bool(self.VK_ACCESS_TOKEN)

    @property
    def supabase_configured(self) -> bool:
        return bool(self.SUPABASE_URL and self.SUPABASE_SERVICE_KEY)

    @property
    def proxy_configured(self) -> bool:
        return bool(self.PROXY_URL)

    def get_proxy_dict(self) -> Optional[dict]:
        if not self.proxy_configured:
            return None

        proxy_dict = {"proxy_url": self.PROXY_URL}

        if self.PROXY_USERNAME and self.PROXY_PASSWORD:
            proxy_dict.update(
                {
                    "username": self.PROXY_USERNAME,
                    "password": self.PROXY_PASSWORD,
                }
            )

        return proxy_dict

    def get_available_clients(self) -> List[str]:
        clients = []
        if self.telegram_configured:
            clients.append("telegram")
        if self.vk_configured:
            clients.append("vk")
        clients.append("mirea")
        return clients
