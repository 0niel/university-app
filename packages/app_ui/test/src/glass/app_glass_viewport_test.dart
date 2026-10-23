import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/glass/app_glass_lens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

void main() {
  testWidgets(
    'IME metrics preserve the full lens widget and scaled foreground',
    (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(1233, 2670)
        ..devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final media = ValueNotifier(
        const MediaQueryData(size: Size(411, 890), devicePixelRatio: 3),
      );
      final text = TextEditingController();
      final focus = FocusNode();
      addTearDown(media.dispose);
      addTearDown(text.dispose);
      addTearDown(focus.dispose);
      late MediaQueryData foreground;
      await tester.pumpWidget(
        _viewportHost(
          media,
          Builder(
            builder: (context) {
              foreground = MediaQuery.of(context);
              return SizedBox(
                width: 240,
                height: 80,
                child: Material(
                  type: MaterialType.transparency,
                  child: TextField(controller: text, focusNode: focus),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Draft');
      final lens = find.byType(LiquidGlassLens);
      final originalWidget = tester.widget<LiquidGlassLens>(lens);
      final originalElement = tester.element(lens);
      final originalField = tester.element(find.byType(TextField));
      const scale = 411 / 390;
      for (final inset in [80.0, 160.0, 240.0, 320.0, 160.0, 0.0]) {
        tester.view.viewInsets = FakeViewPadding(bottom: inset * 3);
        media.value = media.value.copyWith(
          viewInsets: EdgeInsets.only(bottom: inset),
        );
        await tester.pump();
        expect(tester.widget<LiquidGlassLens>(lens), same(originalWidget));
        expect(tester.element(lens), same(originalElement));
        expect(tester.element(find.byType(TextField)), same(originalField));
        final shader = _shaderMedia(tester, lens);
        expect(shader.size, const Size(411, 890));
        expect(shader.devicePixelRatio, 3);
        expect(shader.viewInsets.bottom, inset);
        expect(foreground.viewInsets.bottom, closeTo(inset / scale, .001));
        expect(foreground.devicePixelRatio, closeTo(3 * scale, .001));
        expect(text.text, 'Draft');
        expect(focus.hasFocus, isTrue);
        expect(tester.takeException(), isNull);
      }
    },
    variant: TargetPlatformVariant.only(TargetPlatform.android),
  );

  testWidgets(
    'physical lens viewport follows resizing and inherited preferences',
    (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(1233, 2670)
        ..devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final media = ValueNotifier(
        const MediaQueryData(size: Size(411, 890), devicePixelRatio: 3),
      );
      addTearDown(media.dispose);
      await tester.pumpWidget(
        _viewportHost(media, const SizedBox(width: 240, height: 80)),
      );
      await tester.pumpAndSettle();
      final lens = find.byType(LiquidGlassLens);
      final original = tester.widget<LiquidGlassLens>(lens);
      for (final (pixels, ratio) in [
        (const Size(2790, 1260), 3.0),
        (const Size(2790, 1260), 2.0),
      ]) {
        tester.view
          ..physicalSize = pixels
          ..devicePixelRatio = ratio;
        media.value = media.value.copyWith(
          size: pixels / ratio,
          devicePixelRatio: ratio,
          platformBrightness: Brightness.dark,
          textScaler: const TextScaler.linear(1.4),
          disableAnimations: true,
          accessibleNavigation: true,
          highContrast: true,
        );
        await tester.pump();
        expect(tester.widget<LiquidGlassLens>(lens), same(original));
        final shader = _shaderMedia(tester, lens);
        expect(shader.size, pixels / ratio);
        expect(shader.devicePixelRatio, ratio);
        expect(shader.platformBrightness, Brightness.dark);
        expect(shader.textScaler.scale(10), 14);
        expect(shader.disableAnimations, isTrue);
        expect(shader.accessibleNavigation, isTrue);
        expect(shader.highContrast, isTrue);
        expect(tester.takeException(), isNull);
      }
    },
    variant: TargetPlatformVariant.only(TargetPlatform.android),
  );

  testWidgets(
    'state changes hide the old glass and keep the new action usable',
    (tester) async {
      var loaded = false;
      var taps = 0;
      late StateSetter update;
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return NinjaStateSwitcher(
                  child: AppGlassSurface(
                    key: ValueKey(loaded),
                    role: AppGlassRole.control,
                    child: loaded
                        ? AppButton.primary(
                            label: 'Ready',
                            onPressed: () => taps++,
                          )
                        : TextField(focusNode: focus),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextField));
      expect(focus.hasFocus, isTrue);
      update(() => loaded = true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(find.byType(TextField), findsNothing);
      expect(focus.hasFocus, isFalse);
      final lens = find.byType(LiquidGlassLens);
      expect(lens, findsOneWidget);
      expect(
        find.ancestor(of: lens, matching: find.byType(FadeTransition)),
        findsNothing,
      );
      await tester.tap(find.text('Ready'));
      expect(taps, 1);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  for (final highlight in [false, true]) {
    testWidgets(
      'scaled glass keeps its physical viewport on press, $highlight',
      (tester) async {
        tester.view
          ..physicalSize = const Size(1233, 2670)
          ..devicePixelRatio = 3;
        addTearDown(tester.view.reset);
        late MediaQueryData layoutMedia;
        late MediaQueryData contentMedia;
        var taps = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            builder: (_, child) => AppScale(child: child!),
            home: Builder(
              builder: (context) {
                layoutMedia = MediaQuery.of(context);
                final content = Builder(
                  builder: (context) {
                    contentMedia = MediaQuery.of(context);
                    return const SizedBox(
                      width: 240,
                      height: 80,
                      child: Center(child: Text('Glass')),
                    );
                  },
                );
                return Center(
                  child: AppPressable(
                    onTap: () => taps++,
                    child: highlight
                        ? AppGlassHighlight(child: content)
                        : AppGlassSurface(
                            role: AppGlassRole.control,
                            child: content,
                          ),
                  ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(layoutMedia.size.width, closeTo(390, .001));
        expect(layoutMedia.devicePixelRatio, closeTo(3 * 411 / 390, .001));
        expect(contentMedia, layoutMedia);
        final lens = find.byType(LiquidGlassLens);
        final shaderMedia = MediaQuery.of(tester.element(lens));
        expect(shaderMedia.devicePixelRatio, 3);
        expect(shaderMedia.size, const Size(411, 890));
        final gesture = await tester.startGesture(tester.getCenter(lens));
        await tester.pump(const Duration(milliseconds: 100));
        RenderObject? ancestor = tester.renderObject(lens);
        while (ancestor != null) {
          if (ancestor is RenderOpacity) expect(ancestor.opacity, 1);
          if (ancestor is RenderAnimatedOpacity) {
            expect(ancestor.opacity.value, 1);
          }
          ancestor = ancestor.parent;
        }
        expect(contentMedia, layoutMedia);
        await gesture.up();
        await tester.pumpAndSettle();
        expect(taps, 1);
        expect(tester.takeException(), isNull);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.android),
    );
  }
}

Widget _viewportHost(ValueNotifier<MediaQueryData> media, Widget child) =>
    MaterialApp(
      theme: AppTheme.darkTheme,
      home: ValueListenableBuilder(
        valueListenable: media,
        builder: (context, value, child) =>
            MediaQuery(data: value, child: child!),
        child: AppScale(
          child: Center(
            child: AppGlassLens(
              style: AppGlassStyle.surface(
                colors: AppColors.dark,
                radius: 24,
                tone: AppGlassTone.regular,
                highContrast: false,
                role: AppGlassRole.control,
              ),
              borderRadius: 24,
              fallbackColor: Colors.black,
              child: child,
            ),
          ),
        ),
      ),
    );

MediaQueryData _shaderMedia(WidgetTester tester, Finder lens) =>
    tester.element(lens).getInheritedWidgetOfExactType<MediaQuery>()!.data;
