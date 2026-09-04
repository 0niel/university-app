import 'package:promo_repository/promo_repository.dart';
import 'package:test/test.dart';

void main() {
  const rawBanner = {
    'id': '8e8ddc55-48e2-4f0a-b11b-1c11bc8a0ad7',
    'slug': 'yandex-eda-courier',
    'placements': ['home', 'schedule'],
    'homeSlot': 'after_today',
    'priority': 100,
    'version': 2,
    'style': 'solid',
    'accentColor': '#FC3F1D',
    'emoji': '🛵',
    'kicker': 'Подработка',
    'title': 'Курьер Яндекс Еды',
    'subtitle': 'Выплаты каждый день',
    'ctaLabel': 'Как заработать',
    'ctaUrl': 'https://reg.eda.yandex.ru/?user_invite_code=abc',
    'registerLabel': 'Зарегистрироваться',
    'contactTelegram': 'i_am_oniel',
    'allowSnooze': true,
    'snoozeHours': 48,
    'allowHideForever': false,
    'details': {
      'hero': {
        'badge': 'Партнёрская программа',
        'title': 'Подработка между парами',
        'tags': ['Без опыта', 'Гибкий график'],
      },
      'sections': [
        {
          'type': 'facts',
          'title': 'Из чего складывается доход',
          'items': [
            {'emoji': '📍', 'label': 'За километр', 'value': 'по маршруту'},
          ],
        },
        {
          'type': 'steps',
          'title': 'Как начать',
          'items': [
            {'title': 'Зарегистрируйся', 'text': '15 минут'},
          ],
        },
        {
          'type': 'checklist',
          'items': ['Паспорт', 'СНИЛС'],
        },
        {
          'type': 'faq',
          'items': [
            {'q': 'Сколько заработаю?', 'a': 'Зависит от города'},
          ],
        },
        {'type': 'text', 'title': 'Важно', 'body': 'Текст'},
        {
          'type': 'links',
          'items': [
            {'label': 'Калькулятор', 'url': 'https://eda.yandex.ru'},
          ],
        },
        {'type': 'hologram', 'items': <Object?>[]},
      ],
      'contact': {'title': 'Вопросы?'},
      'footnote': 'Доход не фиксирован',
    },
  };

  test('parses a banner returned by the public RPC', () {
    final banner = PromoBanner.fromJson(rawBanner);

    expect(banner.slug, 'yandex-eda-courier');
    expect(banner.placements, [PromoPlacement.home, PromoPlacement.schedule]);
    expect(banner.homeSlot, PromoHomeSlot.afterToday);
    expect(banner.style, PromoStyle.solid);
    expect(banner.dismissKey, '${banner.id}:2');
    expect(banner.snoozeDuration, const Duration(hours: 48));
    expect(banner.allowHideForever, isFalse);
    expect(banner.dismissible, isTrue);
    expect(banner.showsOn(PromoPlacement.schedule), isTrue);
    expect(banner.contactTelegram, 'i_am_oniel');
  });

  test('parses details sections and drops unknown section types', () {
    final details = PromoBanner.fromJson(rawBanner).details;

    expect(details.hero?.tags, ['Без опыта', 'Гибкий график']);
    expect(details.sections, hasLength(6));
    expect(details.sections.first, isA<PromoFactsSection>());
    expect(details.sections[1], isA<PromoStepsSection>());
    expect(details.sections[2], isA<PromoChecklistSection>());
    expect(details.sections[3], isA<PromoFaqSection>());
    expect(details.sections[4], isA<PromoTextSection>());
    expect(details.sections.last, isA<PromoLinksSection>());
    expect(details.contact?.title, 'Вопросы?');
    expect(details.footnote, 'Доход не фиксирован');
  });

  test('round-trips through json for the offline cache', () {
    final banner = PromoBanner.fromJson(rawBanner);
    final restored = PromoBanner.fromJson(banner.toJson());

    expect(restored, banner);
  });

  test('falls back to defaults for unknown enum values and missing fields', () {
    final banner = PromoBanner.fromJson({
      'id': 'x',
      'slug': 'x',
      'title': 'x',
      'ctaUrl': 'https://example.com',
      'homeSlot': 'sideways',
      'style': 'neon',
      'placements': ['home', 'moon'],
    });

    expect(banner.homeSlot, PromoHomeSlot.afterToday);
    expect(banner.style, PromoStyle.solid);
    expect(banner.placements, [PromoPlacement.home]);
    expect(banner.details.sections, isEmpty);
    expect(banner.snoozeHours, 72);
  });

  test('section emptiness reflects its content', () {
    expect(const PromoSection.text(body: '  ').isEmpty, isTrue);
    expect(const PromoSection.checklist(items: ['a']).isEmpty, isFalse);
  });
}
