import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

void main() {
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
      final lens = find.byType(LiquidGlassLite);
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
