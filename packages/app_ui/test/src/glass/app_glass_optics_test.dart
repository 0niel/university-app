import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/glass/app_glass_optics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart' as renderer;

void main() {
  test(
    'dark optics reduce distortion and lighting while retaining refraction',
    () {
      final dark = AppGlassOptics.settingsFor(Brightness.dark);
      final preset = renderer.LiquidGlassSettings.ios27RegularDark();
      expect(
        dark.refractionAmount,
        inExclusiveRange(0, preset.refractionAmount),
      );
      expect(
        dark.refractionHeight,
        inExclusiveRange(0, preset.refractionHeight),
      );
      expect(dark.highlight, inExclusiveRange(0, preset.highlight));
      expect(dark.contourStrength, inExclusiveRange(0, preset.contourStrength));
      expect(dark.bevelShadowStrength, lessThan(preset.bevelShadowStrength));
      expect(dark.refractionAmount, lessThanOrEqualTo(10));
      expect(dark.highlight, lessThanOrEqualTo(.12));
      expect(dark.contourStrength, lessThanOrEqualTo(.15));
      expect(dark.frost, preset.frost);
      expect(
        AppGlassOptics.settingsFor(Brightness.light),
        renderer.LiquidGlassSettings.ios27RegularLight(),
      );
    },
  );

  test(
    'dark surfaces are denser while selected accents and light stay stable',
    () {
      const neutral = Color.fromRGBO(25, 27, 30, .8);
      const selected = Color.fromRGBO(80, 120, 240, .18);
      final dark = AppGlassOptics.tintFor(neutral, Brightness.dark);
      final light = AppGlassOptics.tintFor(neutral, Brightness.light);
      expect(dark.a, greaterThan(.74));
      expect(dark.a, lessThan(neutral.a));
      expect(light, neutral.withValues(alpha: neutral.a * .22));
      expect(dark.withValues(alpha: 1), neutral.withValues(alpha: 1));
      for (final brightness in Brightness.values) {
        expect(AppGlassOptics.tintFor(selected, brightness), selected);
      }
    },
  );

  test('dark navigation and menus keep a dense refractive background', () {
    for (final (role, minimumOpacity) in [
      (AppGlassRole.navigation, .78),
      (AppGlassRole.overlay, .87),
    ]) {
      final style = AppGlassStyle.surface(
        colors: AppColors.dark,
        radius: 24,
        tone: AppGlassTone.regular,
        highContrast: false,
        role: role,
      );
      expect(
        AppGlassOptics.tintFor(style.color, Brightness.dark).a,
        greaterThanOrEqualTo(minimumOpacity),
      );
      expect(style.refractionIndex, greaterThan(1));
      expect(style.liteGlass, isFalse);
    }
  });

  for (final brightness in Brightness.values) {
    testWidgets('owned and shared layers use matching optics, $brightness', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: brightness == Brightness.dark
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,
          home: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppGlassSurface(
                  role: AppGlassRole.navigation,
                  child: SizedBox(width: 100, height: 48),
                ),
                AppGlassBatch.controls(
                  child: AppGlassSurface(
                    role: AppGlassRole.control,
                    child: SizedBox(width: 48, height: 48),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final layers = tester
          .widgetList<renderer.LiquidGlassLayer>(
            find.byType(renderer.LiquidGlassLayer),
          )
          .toList();
      expect(layers, hasLength(2));
      expect(layers.first.settings, AppGlassOptics.settingsFor(brightness));
      expect(layers.last.settings, layers.first.settings);
      expect(layers.every((layer) => !layer.fake), isTrue);
      expect(tester.takeException(), isNull);
    });
  }
}
