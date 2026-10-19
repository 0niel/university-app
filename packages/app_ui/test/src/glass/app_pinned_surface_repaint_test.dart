import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'pinned frost reads the live backdrop without repainting its rim',
    (
      tester,
    ) async {
      final color = ValueNotifier<Color>(Colors.red);
      addTearDown(color.dispose);
      const captureKey = ValueKey('capture');
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Center(
            child: RepaintBoundary(
              key: captureKey,
              child: SizedBox(
                width: 240,
                height: 80,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(painter: _Backdrop(color)),
                    const AppPinnedSurface(
                      elevated: true,
                      child: SizedBox.expand(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final background = find.descendant(
        of: find.byType(AppPinnedSurface),
        matching: find.byType(RepaintBoundary),
      );
      expect(background, findsOneWidget);
      expect(tester.layers.whereType<BackdropFilterLayer>(), hasLength(1));
      final rim = tester.renderObject<RenderRepaintBoundary>(background)
        ..debugResetMetrics();
      final capture = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(captureKey),
      );
      Future<Color> centerPixel() async => (await tester.runAsync(() async {
        final image = await capture.toImage();
        try {
          final bytes = (await image.toByteData())!;
          final index = (40 * image.width + 120) * 4;
          return Color.fromARGB(
            bytes.getUint8(index + 3),
            bytes.getUint8(index),
            bytes.getUint8(index + 1),
            bytes.getUint8(index + 2),
          );
        } finally {
          image.dispose();
        }
      }))!;
      final before = await centerPixel();
      for (var frame = 1; frame <= 8; frame++) {
        color.value = Color.lerp(Colors.red, Colors.blue, frame / 8)!;
        await tester.pump(const Duration(milliseconds: 16));
      }
      final after = await centerPixel();
      expect(after.r, lessThan(before.r));
      expect(after.b, greaterThan(before.b));
      expect(rim.debugSymmetricPaintCount, 0);
      expect(rim.debugAsymmetricPaintCount, 8);
      expect(tester.takeException(), isNull);
    },
  );
}

class _Backdrop extends CustomPainter {
  _Backdrop(this.color) : super(repaint: color);

  final ValueNotifier<Color> color;

  @override
  void paint(Canvas canvas, Size size) =>
      canvas.drawRect(Offset.zero & size, Paint()..color = color.value);

  @override
  bool shouldRepaint(_Backdrop oldDelegate) => false;
}
