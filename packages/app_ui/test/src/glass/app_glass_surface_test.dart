import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

void main() {
  testWidgets('content keeps the package rim without reading the backdrop', (
    tester,
  ) async {
    for (final highContrast in [false, true]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: MediaQuery(
            data: MediaQueryData(highContrast: highContrast),
            child: const Center(
              child: AppGlassSurface(child: SizedBox(width: 240, height: 80)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsNothing);
      expect(tester.layers.whereType<BackdropFilterLayer>(), isEmpty);
      expect(find.byType(LiquidGlassLens), findsNothing);
      final glass = tester.widget<LiquidGlassLite>(
        find.byType(LiquidGlassLite),
      );
      expect(glass.specular, AppGlassStyle.rim);
      expect(glass.glow, AppGlassStyle.glow);
      expect(glass.blur, 0);
      expect(glass.magnification, 1);
    }
  });

  testWidgets('animated content reuses the static glass background layer', (
    tester,
  ) async {
    final frames = ValueNotifier(0);
    addTearDown(frames.dispose);
    var contentPaints = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Center(
          child: AppGlassSurface(
            child: CustomPaint(
              painter: _AnimatedContent(
                frames: frames,
                onPaint: () => contentPaints++,
              ),
              child: const SizedBox(width: 240, height: 80),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final background = tester.renderObject<RenderRepaintBoundary>(
      find
          .ancestor(
            of: find.byType(LiquidGlassLite),
            matching: find.byType(RepaintBoundary),
          )
          .first,
    )..debugResetMetrics();
    final initialPaints = contentPaints;
    for (var frame = 1; frame <= 8; frame++) {
      frames.value = frame;
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(contentPaints, initialPaints + 8);
    expect(background.debugSymmetricPaintCount, 0);
    expect(background.debugAsymmetricPaintCount, 8);
  });

  for (final dark in [false, true]) {
    testWidgets(
      'glass works without a shader host and preserves input, dark $dark',
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

class _AnimatedContent extends CustomPainter {
  _AnimatedContent({required this.frames, required this.onPaint})
    : super(repaint: frames);

  final ValueNotifier<int> frames;
  final VoidCallback onPaint;

  @override
  void paint(Canvas canvas, Size size) {
    onPaint();
    canvas.drawCircle(
      Offset(frames.value.toDouble(), size.height / 2),
      4,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(_AnimatedContent oldDelegate) => false;
}
