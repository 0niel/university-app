import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  testWidgets('pulse frames do not repaint the surrounding card', (
    tester,
  ) async {
    var cardPaints = 0;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 200,
          height: 96,
          child: CustomPaint(
            painter: _PaintProbe(onPaint: () => cardPaints++),
            child: const Center(child: AppPulseDot(size: 8)),
          ),
        ),
      ),
    );
    final initialPaints = cardPaints;
    expect(initialPaints, greaterThan(0));
    expect(tester.getSize(find.byType(AppPulseDot)), const Size.square(8));

    for (var frame = 0; frame < 8; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(tester.binding.hasScheduledFrame, isTrue);
    expect(cardPaints, initialPaints);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('pulse pauses and resumes with its navigation branch', (
    tester,
  ) async {
    final enabled = ValueNotifier(true);
    addTearDown(enabled.dispose);
    await tester.pumpWidget(
      wrapKit(
        ValueListenableBuilder(
          valueListenable: enabled,
          builder: (context, value, child) => TickerMode(
            enabled: value,
            child: child!,
          ),
          child: const AppPulseDot(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.binding.hasScheduledFrame, isTrue);

    enabled.value = false;
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);

    enabled.value = true;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

class _PaintProbe extends CustomPainter {
  const _PaintProbe({required this.onPaint});

  final VoidCallback onPaint;

  @override
  void paint(Canvas canvas, Size size) => onPaint();

  @override
  bool shouldRepaint(_PaintProbe oldDelegate) => false;
}
