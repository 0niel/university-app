import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rtu_mirea_app/design_preview/design_preview_app.dart';
import 'package:rtu_mirea_app/design_preview/pages/preview_home_page.dart';
import 'package:rtu_mirea_app/design_preview/pages/preview_profile_page.dart';
import 'package:rtu_mirea_app/design_preview/pages/preview_schedule_page.dart';
import 'package:rtu_mirea_app/design_preview/pages/preview_services_page.dart';

import 'package:rtu_mirea_app/l10n/l10n.dart';

import '../helpers/pump_app.dart';

void main() {
  setUpAll(() => initializeDateFormatting('ru'));

  for (final screen in ['home', 'schedule', 'services']) {
    testWidgets('preview $screen rail reaches both page edges at 200% text', (
      tester,
    ) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      final page = switch (screen) {
        'home' => PreviewHomePage(onTab: (_) {}),
        'schedule' => const PreviewSchedulePage(),
        _ => PreviewServicesPage(onTab: (_) {}),
      };
      await tester.pumpApp(
        Scaffold(body: page),
        size: const Size(320, 900),
        textScaler: const TextScaler.linear(2),
      );
      final rail = screen == 'services'
          ? find.byKey(const ValueKey('preview-services-categories'))
          : find.byType(PageView);
      await tester.scrollUntilVisible(
        rail,
        240,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      final viewport = tester.getRect(rail);
      expect(viewport.left, 0);
      expect(viewport.right, 320);
      final scroll = tester.state<ScrollableState>(
        screen == 'services'
            ? find.descendant(of: rail, matching: find.byType(Scrollable))
            : find
                  .descendant(of: rail, matching: find.byType(Scrollable))
                  .first,
      );
      final previous = scroll.position.pixels;
      await tester.flingFrom(
        Offset(318, viewport.center.dy),
        const Offset(-240, 0),
        800,
      );
      await tester.pumpAndSettle();
      expect(scroll.position.pixels, greaterThan(previous));
      expect(tester.takeException(), isNull);
    });
  }

  for (final size in [const Size(390, 844), const Size(844, 390)]) {
    testWidgets('offline preview navigates every destination at $size', (
      tester,
    ) async {
      tester.view
        ..physicalSize = size
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await tester.pumpWidget(const DesignPreviewApp());
      await tester.pumpAndSettle();
      final l10n = await AppLocalizations.delegate.load(const Locale('ru'));
      final labels = [
        l10n.navHome,
        l10n.navSchedule,
        l10n.navMap,
        l10n.navServices,
        l10n.navProfile,
      ];
      for (final label in labels) {
        final navigation = size.width >= 720
            ? find.byType(NinjaNavigationRail)
            : find.byType(NinjaBottomBar);
        final destination = find.descendant(
          of: navigation,
          matching: find.bySemanticsLabel(label),
        );
        await tester.ensureVisible(destination);
        await tester.pumpAndSettle();
        await tester.tap(destination);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: label);
        expect(destination.hitTestable(), findsOneWidget);
      }
      final profile = find.byType(PreviewProfilePage);
      final profileElement = tester.element(profile);
      final profileScroll = tester.state<ScrollableState>(
        find.descendant(of: profile, matching: find.byType(Scrollable)).first,
      );
      profileScroll.position.jumpTo(
        profileScroll.position.maxScrollExtent.clamp(0, 120),
      );
      await tester.pumpAndSettle();
      final savedOffset = profileScroll.position.pixels;
      final lenses = find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString() == 'LiquidGlassLens',
      );
      for (final enabled in [false, true]) {
        await tester.tap(find.byTooltip(l10n.settingsGlassEffectTitle));
        await tester.pumpAndSettle();
        final currentApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(currentApp.theme!.extension<AppGlassTheme>()!.enabled, enabled);
        expect(
          currentApp.darkTheme!.extension<AppGlassTheme>()!.enabled,
          enabled,
        );
        expect(lenses, enabled ? findsWidgets : findsNothing);
        if (!enabled) expect(find.byType(BackdropFilter), findsNothing);
        expect(tester.element(profile), same(profileElement));
        expect(profileScroll.position.pixels, savedOffset);
        final activeNavigation = size.width >= 720
            ? tester
                  .widget<NinjaNavigationRail>(find.byType(NinjaNavigationRail))
                  .currentIndex
            : tester
                  .widget<NinjaBottomBar>(find.byType(NinjaBottomBar))
                  .currentIndex;
        expect(activeNavigation, 4);
        expect(tester.takeException(), isNull);
      }
      await tester.tap(find.byIcon(Icons.light_mode_outlined));
      await tester.pumpAndSettle();
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.light);
      await tester.tap(find.byIcon(Icons.translate_rounded));
      await tester.pumpAndSettle();
      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).locale,
        const Locale('en'),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
