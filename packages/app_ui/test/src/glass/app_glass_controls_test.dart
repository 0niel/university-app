import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

void main() {
  test('materials protect text while keeping controls translucent', () {
    for (final colors in [AppColors.light, AppColors.dark]) {
      LiquidGlassStyle material(AppGlassRole role) => AppGlassStyle.surface(
        colors: colors,
        radius: 28,
        tone: AppGlassTone.regular,
        highContrast: false,
        role: role,
      );
      final content = material(AppGlassRole.content);
      final control = material(AppGlassRole.control);
      final navigation = material(AppGlassRole.navigation);
      final pinned = material(AppGlassRole.pinned);
      final overlay = material(AppGlassRole.overlay);
      final sheet = material(AppGlassRole.sheet);
      expect(content.liteGlass, isTrue);
      expect(content.refractionIndex, 1);
      expect(content.blur, 0);
      expect(pinned.liteGlass, isTrue);
      expect(pinned.refractionIndex, 1);
      expect(pinned.refractionWidth, 0);
      expect(pinned.blur, inExclusiveRange(0, navigation.blur));
      expect(pinned.color.a, greaterThanOrEqualTo(.9));
      expect(
        AppGlassStyle.surface(
          colors: colors,
          radius: 28,
          tone: AppGlassTone.regular,
          highContrast: true,
        ).blur,
        0,
      );
      expect(control.liteGlass, isFalse);
      expect(control.refractionIndex, inExclusiveRange(1, 1.02));
      expect(navigation.refractionIndex, lessThan(control.refractionIndex));
      expect(navigation.color.a, greaterThan(.8));
      expect(overlay.color.a, greaterThan(.9));
      expect(sheet.liteGlass, isTrue);
      expect(sheet.blur, 0);
      expect(sheet.refractionIndex, 1);
      expect(sheet.refractionWidth, 0);
      expect(sheet.color, overlay.color);
      expect(overlay.color.a, greaterThan(navigation.color.a));
      expect(navigation.color.a, greaterThan(control.color.a));
      for (final surface in [
        content,
        control,
        pinned,
        navigation,
        overlay,
        sheet,
      ]) {
        expect(surface.specular, AppGlassStyle.rim);
      }
    }
  });

  for (final dark in [false, true]) {
    testWidgets('floating glass controls retain input and actions, '
        'dark=$dark', (
      tester,
    ) async {
      var glass = true;
      var taps = 0;
      late StateSetter update;
      final input = TextEditingController();
      final focus = FocusNode();
      addTearDown(input.dispose);
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return MaterialApp(
              theme: AppTheme.generateTheme(
                dark ? AppColors.dark : AppColors.light,
                dark ? Brightness.dark : Brightness.light,
                glassEnabled: glass,
              ),
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppSearchField(
                          controller: input,
                          focusNode: focus,
                          tone: AppSearchFieldTone.glass,
                        ),
                        Row(
                          children: [
                            AppButton.glass(
                              label: 'Campus',
                              onPressed: () => taps++,
                            ),
                            AppIconButton(
                              icon: const Icon(Icons.map),
                              tone: AppIconButtonTone.glass,
                              onPressed: () => taps++,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();
      final lenses = find.byType(LiquidGlassLens);
      expect(lenses, findsNWidgets(3));
      for (final lens in tester.widgetList<LiquidGlassLens>(lenses)) {
        expect(lens.style.liteGlass, isFalse);
        expect(lens.style.refractionIndex, greaterThan(1));
        expect(lens.style.refractionIndex, lessThan(1.02));
        expect(lens.style.refractionWidth, inInclusiveRange(8, 16));
        expect(lens.style.color.a, inExclusiveRange(.5, .85));
        expect(lens.style.specular, AppGlassStyle.rim);
        expect(lens.style.glow, AppGlassStyle.glow);
      }
      await tester.enterText(find.byType(EditableText), 'A-101');
      await tester.pumpAndSettle();
      final element = tester.element(find.byType(EditableText));
      final bounds = tester.getRect(find.byType(AppSearchField));
      for (final next in [false, true]) {
        update(() => glass = next);
        await tester.pumpAndSettle();
        expect(tester.element(find.byType(EditableText)), same(element));
        expect(tester.getRect(find.byType(AppSearchField)), bounds);
        expect(input.text, 'A-101');
        expect(focus.hasFocus, isTrue);
        expect(lenses, next ? findsNWidgets(3) : findsNothing);
      }

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Campus')),
      );
      await tester.pump(const Duration(milliseconds: 80));
      for (final match in lenses.evaluate()) {
        var ancestor = match.renderObject;
        while (ancestor != null) {
          if (ancestor is RenderOpacity) expect(ancestor.opacity, 1);
          if (ancestor is RenderAnimatedOpacity) {
            expect(ancestor.opacity.value, 1);
          }
          ancestor = ancestor.parent;
        }
      }
      await gesture.up();
      await tester.pumpAndSettle();
      await tester.tap(find.byType(AppIconButton));
      expect(taps, 2);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('high contrast keeps an opaque readable glass fallback', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MediaQuery(
          data: MediaQueryData(highContrast: true),
          child: Scaffold(
            body: Column(
              children: [
                AppGlassSurface(child: SizedBox(width: 100, height: 40)),
                AppGlassHighlight(child: SizedBox(width: 100, height: 40)),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final lenses = tester.widgetList<LiquidGlassLite>(
      find.byType(LiquidGlassLite),
    );
    expect(lenses, hasLength(2));
    for (final lens in lenses) {
      expect(lens.color!.a, greaterThan(.97));
      expect(lens.specular, AppGlassStyle.rim);
      expect(lens.glow, AppGlassStyle.glow);
    }
    expect(lenses.first.blur, 0);
    final highlight = lenses.last.color!;
    expect(highlight.withValues(alpha: 1), AppColors.dark.tint);
    expect(tester.takeException(), isNull);
  });
}
