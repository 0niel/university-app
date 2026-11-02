import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/main/bootstrap/touch_input.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  late bool originalEnabled;
  late Duration originalOffset;

  setUp(() {
    originalEnabled = binding.resamplingEnabled;
    originalOffset = binding.samplingOffset;
    binding
      ..resamplingEnabled = false
      ..samplingOffset = const Duration(milliseconds: -38);
  });

  tearDown(() {
    binding
      ..resamplingEnabled = false
      ..handlePointerEvent(const PointerRemovedEvent())
      ..resamplingEnabled = originalEnabled
      ..samplingOffset = originalOffset;
  });

  for (final rate in [90.0, 120.0, 144.0]) {
    test('high refresh Android uses a bounded sampling offset at $rate Hz', () {
      configureTouchInput(
        binding: binding,
        platform: TargetPlatform.android,
        refreshRate: rate,
      );
      expect(binding.resamplingEnabled, isTrue);
      expect(binding.samplingOffset, const Duration(milliseconds: -12));
    });
  }

  for (final platform in TargetPlatform.values) {
    if (platform == TargetPlatform.android) continue;
    test('preserves platform input policy on $platform', () {
      configureTouchInput(
        binding: binding,
        platform: platform,
        refreshRate: 120,
      );
      expect(binding.resamplingEnabled, isFalse);
      expect(binding.samplingOffset, const Duration(milliseconds: -38));
    });
  }

  for (final rate in [0.0, 60.0, 89.0, double.nan, double.infinity]) {
    test('leaves low or unknown refresh rates unchanged at $rate Hz', () {
      configureTouchInput(
        binding: binding,
        platform: TargetPlatform.android,
        refreshRate: rate,
      );
      expect(binding.resamplingEnabled, isFalse);
      expect(binding.samplingOffset, const Duration(milliseconds: -38));
    });
  }

  testWidgets('sampled touch still activates buttons and scrolls content', (
    tester,
  ) async {
    configureTouchInput(
      binding: binding,
      platform: TargetPlatform.android,
      refreshRate: 120,
    );
    var taps = 0;
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            controller: controller,
            children: [
              TextButton(onPressed: () => taps++, child: const Text('Open')),
              const SizedBox(height: 2400),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pump(const Duration(milliseconds: 60));
    expect(taps, 1);
    await tester.timedDrag(
      find.byType(ListView),
      const Offset(0, -300),
      const Duration(milliseconds: 600),
    );
    await tester.pumpAndSettle();
    expect(controller.offset, greaterThan(100));
    expect(taps, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sampled two-finger gesture preserves pinch scaling', (
    tester,
  ) async {
    configureTouchInput(
      binding: binding,
      platform: TargetPlatform.android,
      refreshRate: 120,
    );
    var largestScale = 1.0;
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: GestureDetector(
            onScaleUpdate: (details) {
              if (details.scale > largestScale) largestScale = details.scale;
            },
            child: const SizedBox(
              key: ValueKey('pinch-target'),
              width: 300,
              height: 300,
              child: ColoredBox(color: Colors.blue),
            ),
          ),
        ),
      ),
    );
    final center = tester.getCenter(find.byKey(const ValueKey('pinch-target')));
    final first = TestGesture(
      dispatcher: tester.sendEventToBinding,
      device: 1,
    );
    final second = TestGesture(
      dispatcher: tester.sendEventToBinding,
      pointer: 2,
      device: 2,
    );
    await first.down(
      center - const Offset(30, 0),
      timeStamp: binding.currentSystemFrameTimeStamp,
    );
    await second.down(
      center + const Offset(30, 0),
      timeStamp: binding.currentSystemFrameTimeStamp,
    );
    await tester.pump(const Duration(milliseconds: 32));
    for (var step = 1; step <= 4; step++) {
      await first.moveTo(
        center - Offset(30 + step * 20, 0),
        timeStamp: binding.currentSystemFrameTimeStamp,
      );
      await second.moveTo(
        center + Offset(30 + step * 20, 0),
        timeStamp: binding.currentSystemFrameTimeStamp,
      );
      await tester.pump(const Duration(milliseconds: 16));
    }
    await first.up(timeStamp: binding.currentSystemFrameTimeStamp);
    await second.up(timeStamp: binding.currentSystemFrameTimeStamp);
    await tester.pumpAndSettle();
    expect(largestScale, greaterThan(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('sampled drag cancellation permits a fresh drag without a tap', (
    tester,
  ) async {
    configureTouchInput(
      binding: binding,
      platform: TargetPlatform.android,
      refreshRate: 120,
    );
    var starts = 0;
    var cancels = 0;
    var ends = 0;
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: Listener(
            onPointerCancel: (_) => cancels++,
            child: GestureDetector(
              onPanStart: (_) => starts++,
              onPanUpdate: (_) {},
              onPanEnd: (_) => ends++,
              onTap: () => taps++,
              child: const SizedBox(
                key: ValueKey('drag-target'),
                width: 300,
                height: 300,
                child: ColoredBox(color: Colors.blue),
              ),
            ),
          ),
        ),
      ),
    );
    final center = tester.getCenter(find.byKey(const ValueKey('drag-target')));
    final cancelled = TestGesture(
      dispatcher: tester.sendEventToBinding,
      pointer: 3,
      device: 3,
    );
    await cancelled.down(
      center,
      timeStamp: binding.currentSystemFrameTimeStamp,
    );
    await tester.pump(const Duration(milliseconds: 32));
    await cancelled.moveBy(
      const Offset(60, 0),
      timeStamp: binding.currentSystemFrameTimeStamp,
    );
    await tester.pump(const Duration(milliseconds: 32));
    await cancelled.cancel(timeStamp: binding.currentSystemFrameTimeStamp);
    await tester.pump(const Duration(milliseconds: 60));
    expect(starts, 1);
    expect(cancels, 1);
    expect(ends, 1);
    expect(taps, 0);

    final fresh = TestGesture(
      dispatcher: tester.sendEventToBinding,
      pointer: 4,
      device: 4,
    );
    await fresh.down(center, timeStamp: binding.currentSystemFrameTimeStamp);
    await tester.pump(const Duration(milliseconds: 32));
    await fresh.moveBy(
      const Offset(60, 0),
      timeStamp: binding.currentSystemFrameTimeStamp,
    );
    await tester.pump(const Duration(milliseconds: 32));
    await fresh.up(timeStamp: binding.currentSystemFrameTimeStamp);
    await tester.pumpAndSettle();
    expect(starts, 2);
    expect(cancels, 1);
    expect(ends, 2);
    expect(taps, 0);
    expect(tester.takeException(), isNull);
  });
}
