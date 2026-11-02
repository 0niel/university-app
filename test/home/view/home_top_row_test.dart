import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/glass/app_glass_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart' as renderer;
import 'package:rtu_mirea_app/home/view/widgets/home_top_row.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

import '../../gallery/gallery_fonts.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(loadGalleryFonts);
  for (final width in [375.0, 384.0, 390.0]) {
    testWidgets('header retains reference row at $width logical pixels', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screen),
              child: HomeTopRow(
                userName: 'Студент',
                now: DateTime(2026, 9, 2, 20, 56),
                dotColor: AppColors.light.muted2,
                searchKey: GlobalKey(),
                level: 1,
              ),
            ),
          ),
        ),
        size: Size(width, 844),
      );
      final avatar = tester.getRect(find.byType(AppAvatar));
      final clock = tester.getRect(find.byType(HomeClockPill));
      expect(clock.center.dy, closeTo(avatar.center.dy, .1));
      expect(tester.getSize(find.byType(HomeTopRow)).height, 44);
      for (final button in tester.widgetList<AppHeaderCircleButton>(
        find.byType(AppHeaderCircleButton),
      )) {
        expect(tester.getSize(find.byWidget(button)), const Size(44, 44));
      }
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('header adapts without overflow at 320px and 200 percent', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screen),
            child: HomeTopRow(
              userName: 'Студент',
              now: DateTime(2026, 9, 2, 20, 56),
              dotColor: AppColors.light.muted2,
              searchKey: GlobalKey(),
            ),
          ),
        ),
      ),
      size: const Size(320, 844),
      textScaler: const TextScaler.linear(2),
    );
    expect(tester.takeException(), isNull);
    expect(
      tester.getRect(find.byType(HomeClockPill)).top,
      greaterThan(tester.getRect(find.byType(AppAvatar)).bottom),
    );
  });

  for (final compact in [false, true]) {
    testWidgets('header controls share one glass layer compact=$compact', (
      tester,
    ) async {
      final searchKey = GlobalKey();
      final theme = AppTheme.lightTheme;
      await tester.pumpApp(
        Theme(
          data: theme.copyWith(
            extensions: [...theme.extensions.values, const AppGlassTheme()],
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screen),
                child: HomeTopRow(
                  userName: 'Студент',
                  now: DateTime(2026, 9, 2, 20, 56),
                  dotColor: AppColors.light.muted2,
                  searchKey: searchKey,
                  level: 1,
                  unreadCount: 123,
                ),
              ),
            ),
          ),
        ),
        size: Size(compact ? 320 : 390, 844),
        textScaler: TextScaler.linear(compact ? 2 : 1),
      );
      await tester.pumpAndSettle();
      final lenses = find.byType(AppGlassRenderer);
      final layer = find.byType(renderer.LiquidGlassLayer);
      expect(lenses, findsNWidgets(2));
      expect(layer, findsOneWidget);
      final backdropKey = tester
          .widget<renderer.LiquidGlassLayer>(layer)
          .backdropKey;
      expect(backdropKey, isNotNull);
      for (final lens in lenses.evaluate()) {
        expect(AppGlassRendererScope.of(lens), same(backdropKey));
        expect(AppGlassRendererScope.sharesLayerOf(lens), isTrue);
      }
      for (final content in [
        find.byType(AppAvatar),
        find.byType(HomeClockPill),
      ]) {
        expect(AppGlassRendererScope.of(tester.element(content)), isNull);
      }
      final buttons = find.byType(AppHeaderCircleButton);
      expect(buttons, findsNWidgets(2));
      expect(tester.getSize(buttons.first), const Size(44, 44));
      expect(tester.getSize(buttons.last), const Size(44, 44));
      expect(
        tester.getRect(buttons.first).overlaps(tester.getRect(buttons.last)),
        isFalse,
      );
      expect(
        tester.widget<AppTourAnchor>(find.byType(AppTourAnchor)).target,
        AppTourTarget.homeSearch,
      );
      expect(searchKey.currentContext, isNotNull);
      expect(
        find.descendant(of: find.byKey(searchKey), matching: buttons),
        findsOneWidget,
      );
      final l10n = tester.element(find.byType(HomeTopRow)).l10n;
      expect(find.bySemanticsLabel(l10n.homeSearchLabel), findsOneWidget);
      expect(find.bySemanticsLabel(l10n.notifications), findsOneWidget);
      expect(find.bySemanticsLabel('Студент'), findsOneWidget);
      expect(find.text('99+'), findsOneWidget);
      expect(find.text('20:56'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
