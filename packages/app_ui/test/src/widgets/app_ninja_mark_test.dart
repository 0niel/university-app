import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: AppTheme.darkTheme,
    home: Scaffold(body: Center(child: child)),
  );

  group('AppNinjaMark', () {
    for (final (cutout, pixelRatio) in [
      (true, 1),
      (false, 1),
      (true, 2),
      (false, 2),
    ]) {
      testWidgets('preserves the central hole: $cutout at ${pixelRatio}x', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrap(AppNinjaMark(size: 64, color: Colors.white, cutout: cutout)),
        );
        final painter = tester
            .widget<CustomPaint>(
              find.descendant(
                of: find.byType(AppNinjaMark),
                matching: find.byType(CustomPaint),
              ),
            )
            .painter!;
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder)
          ..drawColor(const Color(0xFFFF0000), BlendMode.src)
          ..scale(pixelRatio.toDouble());
        painter.paint(canvas, const Size(64, 64));
        final picture = recorder.endRecording();
        await tester.runAsync(() async {
          final pixels = 64 * pixelRatio;
          final image = await picture.toImage(pixels, pixels);
          try {
            final bytes = (await image.toByteData())!;
            int channel(int x, int y, int c) =>
                bytes.getUint8((y * pixels + x) * 4 + c);
            final center = 32 * pixelRatio;
            final edge = ((32 + 6.8) * pixelRatio).floor();
            expect(channel(center, center, 3), 255);
            expect(channel(center, center, 0), 255);
            expect(channel(center, center, 1), cutout ? 0 : 255);
            expect(channel(center, 12 * pixelRatio, 1), 255);
            expect(channel(3 * pixelRatio, 3 * pixelRatio, 1), 0);
            expect(channel(edge, center, 3), 255);
            expect(
              channel(edge, center, 1),
              cutout ? inExclusiveRange(0, 255) : 255,
            );
          } finally {
            image.dispose();
          }
        });
        picture.dispose();
      });
    }

    testWidgets('paints the mark', (tester) async {
      await tester.pumpWidget(wrap(const AppNinjaMark(size: 40)));

      expect(
        find.descendant(
          of: find.byType(AppNinjaMark),
          matching: find.byType(CustomPaint),
        ),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('is static by default', (tester) async {
      await tester.pumpWidget(wrap(const AppNinjaMark(size: 40)));

      expect(
        find.descendant(
          of: find.byType(AppNinjaMark),
          matching: find.byType(RotationTransition),
        ),
        findsNothing,
      );
    });

    testWidgets('spin wraps the mark in a RotationTransition', (tester) async {
      await tester.pumpWidget(wrap(const AppNinjaMark(size: 40, spin: true)));
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.descendant(
          of: find.byType(AppNinjaMark),
          matching: find.byType(RotationTransition),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders solid (cutout: false) without error', (tester) async {
      await tester.pumpWidget(
        wrap(const AppNinjaMark(size: 40, cutout: false)),
      );

      expect(find.byType(AppNinjaMark), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
