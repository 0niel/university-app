import httpx
import pytest

from src.community_metadata import inspect_community, member_count, parse_community_page


@pytest.mark.parametrize(
    ("text", "expected"),
    [
        ("12 345 members, 1 234 online", 12345),
        ("114 subscribers", 114),
        ("25.8K subscribers", 25800),
        ("1,2 тыс. участников", 1200),
        ("1,234 members", 1234),
        ("Нет данных", None),
        ("0 members", 0),
        ("9" * 400 + " members", None),
    ],
)
def test_member_count(text, expected):
    assert member_count(text) == expected


def test_telegram_only_uses_member_count_not_online():
    result = parse_community_page(
        '<div class="tgme_page_title">Клуб</div><div class="tgme_page_extra">12 345 members, 999 online</div><img class="tgme_page_photo_image" src="https://cdn.example/avatar.jpg"><div class="tgme_page_description">Реальные данные</div>',
        identifier="id",
        url="https://t.me/club",
    )
    assert result.status == "verified"
    assert result.member_count == 12345
    assert result.logo_url == "https://cdn.example/avatar.jpg"


@pytest.mark.parametrize("status", [403, 429, 500])
def test_transient_or_private_responses_are_not_deleted(status):
    result = parse_community_page(
        "", identifier="id", url="https://t.me/club", http_status=status
    )
    assert result.status == "unavailable"


def test_generic_telegram_contact_page_is_not_evidence_of_deletion():
    result = parse_community_page(
        "<title>Telegram: Contact @unknown</title>",
        identifier="id",
        url="https://t.me/unknown",
    )
    assert result.status == "unavailable"


@pytest.mark.parametrize("status", [404, 410])
def test_explicit_http_missing_is_recorded(status):
    result = parse_community_page(
        "", identifier="id", url="https://t.me/club", http_status=status
    )
    assert result.status == "not_found"


async def test_redirect_cannot_probe_an_internal_address():
    requests = []

    def respond(request):
        requests.append(request)
        return httpx.Response(302, headers={"location": "http://127.0.0.1/private"})

    async with httpx.AsyncClient(transport=httpx.MockTransport(respond)) as client:
        result = await inspect_community(
            client, identifier="id", url="https://t.me/club"
        )
    assert result.status == "unavailable"
    assert len(requests) == 1


@pytest.mark.parametrize("url", ["https://[broken", "https://t.me:invalid/club"])
async def test_malformed_urls_do_not_abort_catalog_sync(url):
    async with httpx.AsyncClient() as client:
        result = await inspect_community(client, identifier="id", url=url)
    assert result.status == "unavailable"


def test_deleted_vk_title_is_normalized_to_explicit_evidence():
    result = parse_community_page(
        '<meta property="og:title" content="СООБЩЕСТВО УДАЛЕНО">',
        identifier="id",
        url="https://vk.com/club",
    )
    assert result.status == "not_found"
    assert result.evidence == "Сообщество удалено"
