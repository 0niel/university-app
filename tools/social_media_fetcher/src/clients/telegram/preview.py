import re

import httpx
from bs4 import BeautifulSoup

from ...community_metadata import https_url


def parse_message_media(
    html: str, username: str, message_id: int
) -> dict[str, list[str]]:
    soup = BeautifulSoup(html, "html.parser")
    message = soup.find(attrs={"data-post": f"{username}/{message_id}"})
    if message is None:
        raise ValueError("Telegram did not return the requested public message")
    photos = []
    videos = []
    for item in message.select(".tgme_widget_message_photo_wrap"):
        style = str(item.get("style", ""))
        match = re.search(r"background-image\s*:\s*url\(['\"]?(.*?)['\"]?\)", style)
        if match and (url := https_url(match.group(1))):
            photos.append(url)
    for item in message.select("video[src]"):
        if url := https_url(item.get("src")):
            videos.append(url)
    if not photos:
        for item in message.select(".tgme_widget_message_video_thumb"):
            style = str(item.get("style", ""))
            match = re.search(r"background-image\s*:\s*url\(['\"]?(.*?)['\"]?\)", style)
            if match and (url := https_url(match.group(1))):
                photos.append(url)
    return {
        "photos": list(dict.fromkeys(photos)),
        "videos": list(dict.fromkeys(videos)),
    }


async def fetch_message_media(username: str, message_id: int) -> dict[str, list[str]]:
    if not re.fullmatch(r"[A-Za-z][A-Za-z0-9_]{3,31}", username) or message_id <= 0:
        raise ValueError("Invalid Telegram message identity")
    async with httpx.AsyncClient(
        timeout=15, headers={"User-Agent": "Mozilla/5.0"}
    ) as client:
        response = await client.get(
            f"https://t.me/{username}/{message_id}?embed=1&mode=tme"
        )
        response.raise_for_status()
        media = parse_message_media(response.text, username, message_id)
        if not media["photos"] and not media["videos"]:
            raise ValueError("Telegram media is not available from its public preview")
        return media
