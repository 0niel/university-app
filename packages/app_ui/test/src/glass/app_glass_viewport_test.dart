import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/glass/app_glass_lens.dart';
import 'package:app_ui/src/glass/app_glass_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart' as renderer;

void main() {
  testWidgets(
    'IME metrics preserve the renderer widget and scaled foreground',
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
      final lens = find.byType(AppGlassRenderer);
      final originalWidget = tester.widget<AppGlassRenderer>(lens);
      final originalElement = tester.element(lens);
      final originalField = tester.element(find.byType(TextField));
      final originalLayer = tester.element(
        find.byType(renderer.LiquidGlassLayer),
      );
      const scale = 411 / 390;
      for (final inset in [80.0, 160.0, 240.0, 320.0, 160.0, 0.0]) {
        tester.view.viewInsets = FakeViewPadding(bottom: inset * 3);
        media.value = media.value.copyWith(
          viewInsets: EdgeInsets.only(bottom: inset),
        );
        await tester.pump();
        expect(tester.widget<AppGlassRenderer>(lens), same(originalWidget));
        expect(tester.element(lens), same(originalElement));
        expect(tester.element(find.byType(TextField)), same(originalField));
        expect(
          tester.element(find.byType(renderer.LiquidGlassLayer)),
          same(originalLayer),
        );
        final glass = _rendererMedia(tester, lens);
        expect(glass.size, const Size(411, 890));
        expect(glass.devicePixelRatio, 3);
        expect(glass.viewInsets.bottom, closeTo(inset, .001));
        expect(foreground.viewInsets.bottom, closeTo(inset / scale, .001));
        expect(foreground.devicePixelRatio, closeTo(3 * scale, .001));
        expect(text.text, 'Draft');
        expect(focus.hasFocus, isTrue);
        expect(tester.takeException(), isNull);
      }
    },
    variant: TargetPlatformVariant.only(TargetPlatform.android),
  );

  for (final scale in [.98, 1.05]) {
    testWidgets(
      'shared header and bottom glass map physical pixels at scale $scale',
      (tester) async {
        const ratio = 3.0;
        final width = AppScale.designWidth * scale;
        tester.view
          ..physicalSize = Size(width * ratio, 2700)
          ..devicePixelRatio = ratio;
        addTearDown(tester.view.reset);
        final contentKeys = [GlobalKey(), GlobalKey()];
        late MediaQueryData foreground;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            builder: (_, child) => AppScale(child: child!),
            home: AppGlassBatch.controls(
              child: Builder(
                builder: (context) {
                  foreground = MediaQuery.of(context);
                  return Stack(
                    children: [
                      Positioned(
                        top: 24,
                        right: 20,
                        child: AppGlassSurface(
                          role: AppGlassRole.control,
                          borderRadius: 22,
                          child: SizedBox.square(
                            key: contentKeys[0],
                            dimension: 44,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 40,
                        child: AppGlassSurface(
                          role: AppGlassRole.control,
                          borderRadius: 34,
                          child: SizedBox(key: contentKeys[1], height: 68),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final layer = find.byType(renderer.LiquidGlassLayer);
        expect(layer, findsOneWidget);
        final layerMedia = MediaQuery.of(tester.element(layer));
        expect(layerMedia.devicePixelRatio, ratio);
        expect(layerMedia.size, Size(width, 900));
        expect(foreground.devicePixelRatio, closeTo(ratio * scale, .001));
        expect(foreground.size.width, closeTo(390, .001));
        final glass = find.byType(renderer.LiquidGlass);
        expect(glass, findsNWidgets(2));
        for (var index = 0; index < 2; index++) {
          final shape = glass.at(index);
          final shapeMedia = MediaQuery.of(tester.element(shape));
          expect(shapeMedia.devicePixelRatio, ratio);
          expect(shapeMedia.size, layerMedia.size);
          expect(
            tester.getCenter(shape),
            tester.getCenter(find.byKey(contentKeys[index])),
          );
          final box = tester.renderObject<RenderBox>(shape);
          final localCenter = box.size.center(Offset.zero);
          final physicalCenter = box.localToGlobal(localCenter) * ratio;
          final physicalToLocal = Matrix4.inverted(box.getTransformTo(null));
          final mappedCenter = MatrixUtils.transformPoint(
            physicalToLocal,
            physicalCenter / shapeMedia.devicePixelRatio,
          );
          expect(mappedCenter.dx, closeTo(localCenter.dx, .001));
          expect(mappedCenter.dy, closeTo(localCenter.dy, .001));
          expect(
            tester.widget<renderer.LiquidGlass>(shape).appearance!.colorModel,
            const renderer.LiquidGlassAppearance.ios27RegularDark().colorModel,
          );
        }
        expect(tester.takeException(), isNull);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.android),
    );
  }

  testWidgets(
    'renderer follows resizing and inherited preferences',
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
      final lens = find.byType(AppGlassRenderer);
      final original = tester.widget<AppGlassRenderer>(lens);
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
        expect(tester.widget<AppGlassRenderer>(lens), same(original));
        final glass = _rendererMedia(tester, lens);
        final logical = pixels / ratio;
        expect(glass.size, logical);
        expect(glass.devicePixelRatio, ratio);
        expect(glass.platformBrightness, Brightness.dark);
        expect(glass.textScaler.scale(10), 14);
        expect(glass.disableAnimations, isTrue);
        expect(glass.accessibleNavigation, isTrue);
        expect(glass.highContrast, isTrue);
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
      final lens = find.byType(AppGlassRenderer);
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
      'scaled glass keeps its layout viewport on press, $highlight',
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
        final lens = find.byType(AppGlassRenderer);
        final rendererMedia = _rendererMedia(tester, lens);
        expect(rendererMedia.devicePixelRatio, 3);
        expect(rendererMedia.size, const Size(411, 890));
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
          child: AppGlassBatch.controls(
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
      ),
    );

MediaQueryData _rendererMedia(WidgetTester tester, Finder lens) =>
    MediaQuery.of(
      tester.element(
        find.descendant(of: lens, matching: find.byType(renderer.LiquidGlass)),
      ),
    );
