@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/widgets/app_bottom_navigation_bar.dart';

import 'gallery_fonts.dart';
import 'home_dashboard_fixture.dart';

void main() {
  setUpAll(loadGalleryFonts);
  for (final dark in [false, true]) {
    testWidgets('scrolled home dashboard ${dark ? 'dark' : 'light'}', (
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
                child: homeDashboardFixture(controller: controller),
              ),
              bottomNavigationBar: AppBottomNavigationBar(
                currentIndex: 0,
                onSelected: (_) {},
                scheduleBadge: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (var i = 0; i < 2; i++) {
        controller.jumpTo(controller.position.maxScrollExtent);
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
      for (final type in [
        HomeStatusStrip,
        HomeQuickActions,
        HomeDeadlinesGroup,
        HomeTrendingGroup,
      ]) {
        expect(find.byType(type), findsOneWidget);
      }
      expect(find.byType(AppBottomNavigationBar), findsOneWidget);
      expect(
        tester.getBottomRight(find.byType(HomeTrendingGroup)).dy,
        lessThanOrEqualTo(
          tester.getTopLeft(find.byType(AppBottomNavigationBar)).dy,
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/home_dashboard_scrolled_${dark ? 'dark' : 'light'}.png',
        ),
      );
    });
  }
}
