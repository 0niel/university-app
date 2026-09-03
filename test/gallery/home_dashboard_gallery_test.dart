@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/widgets/app_bottom_navigation_bar.dart';

import 'gallery_fonts.dart';
import 'home_dashboard_fixture.dart';

void main() {
  setUpAll(loadGalleryFonts);
  for (final dark in [false, true]) {
    testWidgets('full home dashboard ${dark ? 'dark' : 'light'}', (
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
      expect(tester.takeException(), isNull);
      expect(
        tester.getRect(find.byType(HomeTopRow)),
        const Rect.fromLTWH(20, 56, 350, 44),
      );
      expect(
        tester.getTopLeft(find.byType(HomeHero)).dy,
        closeTo(375.140625, 1),
      );
      expect(
        tester.getSize(find.byType(HomeHero)).height,
        closeTo(223.375, 1),
      );
      expect(find.byType(AppBottomNavigationBar), findsOneWidget);
      final route = tester.widget<Text>(find.text('Маршрут'));
      expect(route.style?.fontSize, 13.5);
      expect(route.style?.fontWeight, FontWeight.w700);
      final subject = tester.renderObject<RenderParagraph>(
        find.descendant(
          of: find.byType(HomeHero),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is RichText &&
                widget.text.toPlainText() == 'Программирование на Python',
          ),
        ),
      );
      expect(
        subject
            .getBoxesForSelection(
              const TextSelection(
                baseOffset: 0,
                extentOffset: 'Программирование'.length,
              ),
            )
            .map((box) => box.top)
            .toSet(),
        hasLength(1),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/home_dashboard_${dark ? 'dark' : 'light'}.png',
        ),
      );
    });
  }
}
