from pathlib import Path

from src.clients.official_news.client import (
    OfficialNewsFetcher,
    parse_article_html,
    parse_news_html,
)
from src.config import OfficialNewsSource, Settings
from src.news_blocks.adapters.official_news_adapter import (
    OfficialNewsToNewsBlocksAdapter,
)


def test_official_news_fetcher_is_instantiable() -> None:
    fetcher = OfficialNewsFetcher(
        Settings(_env_file=None),
        OfficialNewsSource(
            external_id="official",
            name="Example University",
            url="https://university.example/news",
            category="university",
            link_selector="a.news-card",
            article_selectors=("article",),
        ),
    )

    assert fetcher.is_configured


def test_parse_news_html_maps_official_cards() -> None:
    fixture = Path(__file__).parent / "fixtures" / "mirea_news.html"

    items = parse_news_html(
        fixture.read_text(encoding="utf-8"),
        limit=10,
        news_url="https://www.mirea.ru/news/",
    )

    assert [item["ID"] for item in items] == ["first-article", "second-article"]
    assert items[0]["NAME"] == "Первая университетская новость"
    assert items[0]["DATE_ACTIVE_FROM"] == "10.07.2026 00:00:00"
    assert items[0]["DETAIL_PICTURE"] == ("https://www.mirea.ru/upload/news/first.webp")
    assert items[0]["url"] == "https://www.mirea.ru/news/first-article/"


def test_parse_news_html_honors_limit_and_ignores_index_links() -> None:
    html = """
    <a href="/news/">Новости</a>
    <a href="/news/one/"><h3>One</h3><time>10.07.2026</time></a>
    <a href="/news/two/"><h3>Two</h3><time>09.07.2026</time></a>
    """

    items = parse_news_html(
        html,
        limit=1,
        news_url="https://www.mirea.ru/news/",
    )

    assert [item["ID"] for item in items] == ["one"]


def test_parse_article_html_extracts_content_and_absolute_images() -> None:
    fixture = Path(__file__).parent / "fixtures" / "mirea_article.html"

    content, images = parse_article_html(
        fixture.read_text(encoding="utf-8"),
        "https://www.mirea.ru/news/first-article/",
    )

    assert "Полный текст университетской новости" in content
    assert "window.tracking" not in content
    assert images == ["https://www.mirea.ru/upload/news/detail.webp"]


def test_generic_news_source_uses_its_own_url_and_branding() -> None:
    html = """
    <a class="news-card" href="/announcements/welcome/">
      <h3>Welcome</h3><time>10.07.2026</time>
    </a>
    """

    item = parse_news_html(
        html,
        limit=10,
        news_url="https://university.example/announcements/",
        link_selector="a.news-card",
    )[0]
    blocks = OfficialNewsToNewsBlocksAdapter(
        source_name="Example University",
        source_url="https://university.example/announcements/",
    ).adapt_post_data(item)

    assert item["ID"] == "welcome"
    assert item["url"] == "https://university.example/announcements/welcome/"
    assert blocks[0].author == "Example University"
    assert blocks[0].categoryId == "website"


def test_official_news_adapter_uses_tenant_category_and_media_origin() -> None:
    blocks = OfficialNewsToNewsBlocksAdapter(
        source_name="Example University",
        source_url="https://university.example/news/",
        category_id="student_life",
    ).adapt_post_data(
        {
            "ID": "welcome",
            "NAME": "Welcome",
            "DATE_ACTIVE_FROM": "10.07.2026 00:00:00",
            "DETAIL_PICTURE": "/media/cover.jpg",
            "PROPERTY_MY_GALLERY_VALUE": ["/media/gallery.jpg"],
        }
    )

    assert blocks[0].categoryId == "student_life"
    assert blocks[0].imageUrl == "https://university.example/media/cover.jpg"
