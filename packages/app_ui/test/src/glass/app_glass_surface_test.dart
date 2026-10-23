import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/glass/app_glass_lens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

void main() {
  testWidgets('content never records a glass pass in either theme or setting', (
    tester,
  ) async {
    for (final colors in [AppColors.dark, AppColors.light]) {
      for (final enabled in [false, true]) {
        for (final highContrast in [false, true]) {
          await tester.pumpWidget(
            _SurfaceFixture(
              colors: colors,
              glassEnabled: enabled,
              highContrast: highContrast,
              child: const AppGlassSurface(
                child: SizedBox(width: 240, height: 80),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.byType(AppGlassLens), findsNothing);
          expect(find.byType(LiquidGlassLens), findsNothing);
          expect(find.byType(LiquidGlassLite), findsNothing);
          expect(find.byType(BackdropFilter), findsNothing);
          expect(find.byType(ImageFiltered), findsNothing);
          expect(find.byType(ShaderMask), findsNothing);
          expect(tester.layers.whereType<BackdropFilterLayer>(), isEmpty);
          final render = tester.renderObject<RenderDecoratedBox>(
            find.descendant(
              of: find.byType(AppGlassSurface),
              matching: find.byType(DecoratedBox),
            ),
          );
          for (final method in [
            #drawVertices,
            #saveLayer,
            #drawImage,
            #drawImageRect,
          ]) {
            expect(render, paintsExactlyCountTimes(method, 0));
          }
          expect(
            tester.binding.transientCallbackCount,
            0,
          );
        }
      }
    }
  });

  testWidgets('content fill and rim follow tint, theme and high contrast', (
    tester,
  ) async {
    const tint = Color(0xFFB472E8);
    const customColor = Color(0x773AA6AE);
    for (final colors in [AppColors.dark, AppColors.light]) {
      for (final highContrast in [false, true]) {
        for (final tone in AppGlassTone.values) {
          for (final color in [null, customColor]) {
            await tester.pumpWidget(
              _SurfaceFixture(
                colors: colors,
                highContrast: highContrast,
                child: AppGlassSurface(
                  tone: tone,
                  tint: tint,
                  color: color,
                  child: const SizedBox(width: 240, height: 80),
                ),
              ),
            );
            await tester.pumpAndSettle();
            final decoration =
                tester
                        .widget<DecoratedBox>(
                          find.descendant(
                            of: find.byType(AppGlassSurface),
                            matching: find.byType(DecoratedBox),
                          ),
                        )
                        .decoration
                    as BoxDecoration;
            final base =
                color ??
                (tone == AppGlassTone.accent
                    ? Color.alphaBlend(
                        tint.withValues(alpha: .13),
                        colors.surface,
                      )
                    : colors.surface);
            expect(decoration.color, Color.alphaBlend(base, colors.surface));
            expect(decoration.color!.a, 1);
            expect(decoration.boxShadow, isNull);
            expect(decoration.gradient, isNull);
            expect(decoration.backgroundBlendMode, isNull);
            final border = decoration.border! as Border;
            expect(
              border.top.color,
              highContrast ? colors.ink.withValues(alpha: .24) : colors.line,
            );
            expect(border.top.width, highContrast ? 1 : .75);
          }
        }
      }
    }
  });

  testWidgets('content keeps directional padding, clipping and hit testing', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    const childKey = Key('content');
    await tester.pumpWidget(
      _SurfaceFixture(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: AppGlassSurface(
            borderRadius: 26,
            padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 20, 16),
            child: GestureDetector(
              onTap: () => taps++,
              child: Semantics(
                label: 'Lesson',
                child: const ColoredBox(
                  key: childKey,
                  color: Colors.blue,
                  child: SizedBox(width: 240, height: 80),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final bounds = tester.getRect(find.byType(AppGlassSurface));
    final childBounds = tester.getRect(find.byKey(childKey));
    expect(bounds.size, const Size(272, 104));
    expect(childBounds.left - bounds.left, 20);
    expect(childBounds.top - bounds.top, 8);
    expect(bounds.right - childBounds.right, 12);
    expect(bounds.bottom - childBounds.bottom, 16);
    final clip = tester.widget<ClipRRect>(
      find.descendant(
        of: find.byType(AppGlassSurface),
        matching: find.byType(ClipRRect),
      ),
    );
    expect(clip.borderRadius, BorderRadius.circular(26));
    expect(clip.clipBehavior, Clip.antiAlias);
    expect(find.bySemanticsLabel('Lesson'), findsOneWidget);
    handle.dispose();
    await tester.tapAt(childBounds.center);
    expect(taps, 1);

    await tester.pumpWidget(
      _SurfaceFixture(
        child: RepaintBoundary(
          key: const Key('capture'),
          child: AppGlassSurface(
            borderRadius: 26,
            child: GestureDetector(
              onTap: () => taps++,
              behavior: HitTestBehavior.opaque,
              child: const ColoredBox(
                color: Colors.blue,
                child: SizedBox(width: 240, height: 80),
              ),
            ),
          ),
        ),
      ),
    );
    final pixels = (await tester.runAsync(() async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(const Key('capture')),
      );
      final image = await boundary.toImage();
      try {
        return (await image.toByteData())!;
      } finally {
        image.dispose();
      }
    }))!;
    expect(pixels.getUint8(3), 0);
    expect(pixels.getUint8((40 * 240 + 120) * 4 + 3), 255);
    final clippedBounds = tester.getRect(find.byType(AppGlassSurface));
    await tester.tapAt(clippedBounds.topLeft - const Offset(1, 1));
    expect(taps, 1);
    await tester.tapAt(clippedBounds.center);
    expect(taps, 2);
  });

  testWidgets('floating surfaces retain their glass rendering path', (
    tester,
  ) async {
    for (final role in [
      AppGlassRole.control,
      AppGlassRole.pinned,
      AppGlassRole.navigation,
      AppGlassRole.overlay,
    ]) {
      await tester.pumpWidget(
        _SurfaceFixture(
          child: AppGlassSurface(
            role: role,
            child: const SizedBox(width: 240, height: 80),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppGlassLens), findsOneWidget);
      expect(
        find.byType(LiquidGlassLens).evaluate().length +
            find.byType(LiquidGlassLite).evaluate().length,
        greaterThan(0),
      );
      expect(tester.takeException(), isNull);
    }
  });

  for (final dark in [false, true]) {
    testWidgets(
      'content preserves focused input and actions, dark $dark',
      (tester) async {
        final text = TextEditingController();
        final focus = FocusNode();
        addTearDown(text.dispose);
        addTearDown(focus.dispose);
        var highContrast = false;
        late StateSetter update;
        var taps = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            home: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return MediaQuery(
                  data: const MediaQueryData(
                    disableAnimations: true,
                  ).copyWith(highContrast: highContrast),
                  child: Scaffold(
                    body: Center(
                      child: SizedBox(
                        width: 280,
                        child: AppGlassSurface(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(controller: text, focusNode: focus),
                              AppButton.primary(
                                label: 'Action',
                                onPressed: () => taps++,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'query');
        expect(focus.hasFocus, isTrue);
        final bounds = tester.getRect(find.byType(TextField));
        update(() => highContrast = true);
        await tester.pumpAndSettle();
        expect(text.text, 'query');
        expect(focus.hasFocus, isTrue);
        expect(tester.getRect(find.byType(TextField)), bounds);
        await tester.tap(find.text('Action'));
        expect(taps, 1);
        expect(tester.takeException(), isNull);
        expect(tester.binding.transientCallbackCount, 0);
      },
    );
  }
}

class _SurfaceFixture extends StatelessWidget {
  const _SurfaceFixture({
    required this.child,
    this.colors = AppColors.dark,
    this.glassEnabled = true,
    this.highContrast = false,
  });

  final Widget child;
  final AppColors colors;
  final bool glassEnabled;
  final bool highContrast;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: AppTheme.generateTheme(
      colors,
      colors.isDark ? Brightness.dark : Brightness.light,
      glassEnabled: glassEnabled,
    ),
    home: MediaQuery(
      data: MediaQueryData(highContrast: highContrast),
      child: Center(child: child),
    ),
  );
}
