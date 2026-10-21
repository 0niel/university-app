import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/glass/app_glass_lens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

void main() {
  testWidgets('elides only transparent primitives with identical pixels', (
    tester,
  ) async {
    for (final colors in [AppColors.light, AppColors.dark]) {
      for (final (size, radius) in [
        (const Size(44, 44), 22.0),
        (const Size(180, 56), 28.0),
        (const Size(360, 120), 24.0),
      ]) {
        for (final role in [AppGlassRole.content, AppGlassRole.pinned]) {
          final style = AppGlassStyle.surface(
            colors: colors,
            radius: radius,
            tone: AppGlassTone.regular,
            highContrast: false,
            role: role,
          );
          await tester.pumpWidget(
            MaterialApp(
              theme: colors.isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
              home: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Capture(
                      id: 'reference',
                      size: size,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(radius),
                        child: LiquidGlassLite(
                          shape: style.shape!,
                          specular: style.specular,
                          glow: style.glow,
                          blur: style.blur,
                          color: style.color,
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                    _Capture(
                      id: 'optimized',
                      size: size,
                      child: AppGlassLens(
                        style: style,
                        borderRadius: radius,
                        fallbackColor: style.color,
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.pump();
          for (final (id, passes) in [('reference', 4), ('optimized', 2)]) {
            final paint = tester.widget<CustomPaint>(
              find.descendant(
                of: find.descendant(
                  of: find.byKey(ValueKey(id)),
                  matching: find.byType(LiquidGlassLite),
                ),
                matching: find.byWidgetPredicate(
                  (widget) =>
                      widget is CustomPaint && widget.foregroundPainter != null,
                ),
              ),
            );
            expect(
              (Canvas canvas) => paint.foregroundPainter!.paint(canvas, size),
              paintsExactlyCountTimes(#drawVertices, passes),
            );
          }
          for (final ratio in [1.0, 2.0, 3.0]) {
            final reference = await _pixels(tester, 'reference', ratio);
            final optimized = await _pixels(tester, 'optimized', ratio);
            expect(
              _firstDifference(reference, optimized),
              -1,
              reason: '$role at $size, DPR $ratio, dark=${colors.isDark}',
            );
          }
        }
      }
    }
  });

  testWidgets('custom Lite lighting and full lens lighting remain unchanged', (
    tester,
  ) async {
    const custom = LiquidGlassLight.glow(thickness: 4, intensity: .8);
    for (final lite in [false, true]) {
      final glow = lite ? custom : AppGlassStyle.glow;
      final style = LiquidGlassStyle(
        liteGlass: lite,
        specular: AppGlassStyle.rim,
        glow: glow,
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Center(
            child: AppGlassLens(
              style: style,
              borderRadius: 24,
              fallbackColor: Colors.black,
              child: const SizedBox(width: 180, height: 56),
            ),
          ),
        ),
      );
      if (lite) {
        expect(
          tester.widget<LiquidGlassLite>(find.byType(LiquidGlassLite)).glow,
          glow,
        );
      } else {
        expect(
          tester
              .widget<LiquidGlassLens>(find.byType(LiquidGlassLens))
              .style
              .glow,
          glow,
        );
      }
    }
  });
}

Future<Uint8List> _pixels(WidgetTester tester, String id, double ratio) async =>
    (await tester.runAsync(() async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(ValueKey(id)),
      );
      final image = await boundary.toImage(pixelRatio: ratio);
      try {
        return (await image.toByteData())!.buffer.asUint8List();
      } finally {
        image.dispose();
      }
    }))!;

int _firstDifference(Uint8List first, Uint8List second) {
  if (first.length != second.length) return 0;
  for (var index = 0; index < first.length; index++) {
    if (first[index] != second[index]) return index;
  }
  return -1;
}

class _Capture extends StatelessWidget {
  const _Capture({required this.id, required this.size, required this.child});
  final String id;
  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    key: ValueKey(id),
    child: SizedBox.fromSize(
      size: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const CustomPaint(painter: _Backdrop()),
          child,
        ],
      ),
    ),
  );
}

class _Backdrop extends CustomPainter {
  const _Backdrop();

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..drawPaint(
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF091D4F), Color(0xFFDA6D91)],
          ).createShader(Offset.zero & size),
      )
      ..drawCircle(
        Offset(size.width * .25, size.height * .45),
        size.height * .3,
        Paint()..color = const Color(0xFF45C9A3),
      );
  }

  @override
  bool shouldRepaint(_Backdrop oldDelegate) => false;
}
