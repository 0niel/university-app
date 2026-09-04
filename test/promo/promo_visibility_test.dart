import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promo_repository/promo_repository.dart';
import 'package:rtu_mirea_app/promo/cubit/promo_dismissals_cubit.dart';
import 'package:rtu_mirea_app/promo/promo_links.dart';
import 'package:rtu_mirea_app/promo/promo_visibility.dart';

const home = PromoBanner(
  id: 'home',
  slug: 'home',
  title: 'Home only',
  ctaUrl: 'https://example.com',
  priority: 1,
);
const both = PromoBanner(
  id: 'both',
  slug: 'both',
  title: 'Everywhere',
  ctaUrl: 'https://example.com',
  placements: [PromoPlacement.home, PromoPlacement.schedule],
  homeSlot: PromoHomeSlot.top,
  priority: 10,
);

void main() {
  final now = DateTime(2026, 9, 4);

  test('filters by placement and home slot, highest priority first', () {
    expect(
      visiblePromoBanners(
        banners: const [home, both],
        dismissals: const PromoDismissalsState(),
        placement: PromoPlacement.home,
        now: now,
      ).map((b) => b.id),
      ['both', 'home'],
    );
    expect(
      visiblePromoBanners(
        banners: const [home, both],
        dismissals: const PromoDismissalsState(),
        placement: PromoPlacement.home,
        homeSlot: PromoHomeSlot.afterToday,
        now: now,
      ).map((b) => b.id),
      ['home'],
    );
    expect(
      visiblePromoBanners(
        banners: const [home, both],
        dismissals: const PromoDismissalsState(),
        placement: PromoPlacement.schedule,
        now: now,
      ).map((b) => b.id),
      ['both'],
    );
  });

  test('respects dismissals', () {
    final dismissals = PromoDismissalsState(
      hidden: {both.dismissKey},
      snoozedUntil: {
        home.dismissKey: now
            .add(const Duration(days: 1))
            .millisecondsSinceEpoch,
      },
    );
    expect(
      visiblePromoBanners(
        banners: const [home, both],
        dismissals: dismissals,
        placement: PromoPlacement.home,
        now: now,
      ),
      isEmpty,
    );
  });

  test('parses accent colors and telegram handles', () {
    expect(promoAccentColor('#FC3F1D', Colors.black), const Color(0xFFFC3F1D));
    expect(promoAccentColor('nope', Colors.black), Colors.black);
    expect(
      promoTelegramUri('@i_am_oniel').toString(),
      'https://t.me/i_am_oniel',
    );
    expect(promoTelegramUri(' '), isNull);
  });
}
