@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promo_repository/promo_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/widgets/app_bottom_navigation_bar.dart';

import 'gallery_fonts.dart';
import 'home_dashboard_fixture.dart';

const _banner = PromoBanner(
  id: 'gallery',
  slug: 'yandex-eda-courier',
  title: 'Курьер Яндекс Еды: сам выбираешь, когда работать',
  subtitle: 'Гибкий график между парами, выплаты каждый день',
  kicker: 'Подработка',
  emoji: '🛵',
  ctaLabel: 'Как заработать',
  ctaUrl: 'https://example.com',
  placements: [PromoPlacement.home, PromoPlacement.schedule],
);

void main() {
  setUpAll(loadGalleryFonts);
  for (final dark in [false, true]) {
    testWidgets('home dashboard with promo banner ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(390, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          ),
          home: Builder(
            builder: (context) => Scaffold(
              backgroundColor: context.colors.canvas,
              extendBody: true,
              body: AppBottomBarViewport(
                bottomInset: AppBottomBar.extentOf(context),
                child: homeDashboardFixture(
                  controller: controller,
                  promoBanners: const [_banner],
                ),
              ),
              bottomNavigationBar: AppBottomNavigationBar(
                currentIndex: 0,
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      controller.jumpTo(controller.position.maxScrollExtent * .55);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(AppPromoCard), findsOneWidget);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/home_dashboard_promo_${dark ? 'dark' : 'light'}.png',
        ),
      );
    });

    testWidgets('compact promo banner ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(390, 200)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: Builder(
            builder: (context) => Scaffold(
              backgroundColor: context.colors.canvas,
              body: Padding(
                padding: const EdgeInsets.all(AppSpacing.screen),
                child: Column(
                  children: [
                    AppPromoCard(
                      title: _banner.title,
                      emoji: _banner.emoji,
                      accent: const Color(0xFFFC3F1D),
                      compact: true,
                      onTap: () {},
                      onClose: () {},
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppPromoCard(
                      title: _banner.title,
                      emoji: _banner.emoji,
                      accent: const Color(0xFFFC3F1D),
                      compact: true,
                      solid: false,
                      onTap: () {},
                      onClose: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/promo_banner_compact_${dark ? 'dark' : 'light'}.png',
        ),
      );
    });
  }
}
