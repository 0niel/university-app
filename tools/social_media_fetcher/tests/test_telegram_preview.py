import pytest

from src.clients.telegram.preview import parse_message_media
from src.news_blocks.adapters.telegram_adapter import TelegramToNewsBlocksAdapter


def test_public_preview_resolves_real_media_urls_and_entities():
    media = parse_message_media(
        '<div data-post="example_news/42"><a class="tgme_widget_message_photo_wrap" style="background-image:url(\'https://cdn.example/photo.jpg?a=1&amp;b=2\')"></a><video src="https://cdn.example/video.mp4"></video></div>',
        "example_news",
        42,
    )
    assert media == {
        "photos": ["https://cdn.example/photo.jpg?a=1&b=2"],
        "videos": ["https://cdn.example/video.mp4"],
    }


def test_public_preview_requires_the_exact_message_identity():
    with pytest.raises(ValueError, match="requested public message"):
        parse_message_media('<div data-post="another/42"></div>', "example_news", 42)


def test_video_is_never_used_as_an_image_cover():
    blocks = TelegramToNewsBlocksAdapter().adapt_post_data(
        {
            "id": "42",
            "text": "Video story",
            "date": 1782000000,
            "chat": {"username": "example_news", "title": "News"},
            "media_files": {"photos": [], "videos": ["https://cdn.example/story.mp4"]},
        }
    )
    serialized = [block.model_dump(by_alias=True, mode="json") for block in blocks]
    assert serialized[0].get("image_url") is None
    assert any(
        block.get("video_url") == "https://cdn.example/story.mp4"
        for block in serialized
    )


def test_internal_telegram_file_ids_are_not_image_urls():
    blocks = TelegramToNewsBlocksAdapter().adapt_post_data(
        {
            "id": "42",
            "text": "Photo",
            "date": 1782000000,
            "media_files": {"photos": ["1234567"], "videos": []},
        }
    )
    assert blocks[0].model_dump(by_alias=True).get("image_url") is None
