import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  testWidgets('stripes follow 135 degrees with 10px perpendicular bands',
      (tester) async {
    await tester.pumpWidget(
      wrapKit(
        const SizedBox.square(
          dimension: 40,
          child: AppStripePlaceholder(),
        ),
      ),
    );
    final paint = tester.widget<CustomPaint>(
      find.descendant(
        of: find.byType(AppStripePlaceholder),
        matching: find.byType(CustomPaint),
      ),
    );
    final recorder = ui.PictureRecorder();
    paint.painter!.paint(Canvas(recorder), const Size(40, 40));
    final picture = recorder.endRecording();
    await tester.runAsync(() async {
      final image = await picture.toImage(40, 40);
      final data = (await image.toByteData())!;
      int pixel(int x, int y) {
        final offset = (y * 40 + x) * 4;
        return (data.getUint8(offset + 3) << 24) |
            (data.getUint8(offset) << 16) |
            (data.getUint8(offset + 1) << 8) |
            data.getUint8(offset + 2);
      }

      expect(pixel(2, 2), kitColors.surface2.toARGB32());
      expect(pixel(12, 12), kitColors.surface.toARGB32());
      expect(pixel(24, 10), kitColors.surface2.toARGB32());
      expect(pixel(20, 0), pixel(0, 20));
      image.dispose();
    });
    picture.dispose();
  });
}
