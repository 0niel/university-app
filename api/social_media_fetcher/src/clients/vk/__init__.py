"""VK client implementation."""

from .client import VKFetcher
from .models import VKGroupInfo, VKPost, VKAttachment

__all__ = [
    "VKFetcher",
    "VKGroupInfo",
    "VKPost", 
    "VKAttachment",
] 