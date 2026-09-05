import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_clock_ticker.dart';

class _ClockProbe extends StatefulWidget {
  const _ClockProbe({super.key});

  @override
  State<_ClockProbe> createState() => _ClockProbeState();
}

class _ClockProbeState extends State<_ClockProbe> with ScheduleClockTicker {
  int ticks = 0;

  @override
  bool get isClockTickNeeded => true;

  @override
  void onClockTick() => setState(() => ticks++);

  @override
  Widget build(BuildContext context) => Text(
    '${clock.now().toIso8601String()} / $ticks',
    textDirection: TextDirection.ltr,
  );
}

void main() {
  testWidgets('ticks at the next minute boundary and stops after disposal', (
    tester,
  ) async {
    var now = DateTime(2026, 9, 2, 9, 0, 59, 500);
    await withClock(Clock(() => now), () async {
      final key = GlobalKey<_ClockProbeState>();
      await tester.pumpWidget(
        TickerMode(enabled: true, child: _ClockProbe(key: key)),
      );
      await tester.pump();
      final ticks = key.currentState!.ticks;
      now = now.add(const Duration(milliseconds: 499));
      await tester.pump(const Duration(milliseconds: 499));
      expect(key.currentState!.ticks, ticks);
      now = now.add(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 1));
      expect(key.currentState!.ticks, ticks + 1);
      expect(find.textContaining('09:01:00.000'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(minutes: 2));
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('disabled ticker stays quiet and refreshes when enabled', (
    tester,
  ) async {
    var now = DateTime(2026, 9, 2, 9);
    await withClock(Clock(() => now), () async {
      final enabled = ValueNotifier(true);
      final key = GlobalKey<_ClockProbeState>();
      await tester.pumpWidget(
        ValueListenableBuilder<bool>(
          valueListenable: enabled,
          child: _ClockProbe(key: key),
          builder: (_, value, child) =>
              TickerMode(enabled: value, child: child!),
        ),
      );
      await tester.pump();
      enabled.value = false;
      await tester.pump();
      final ticks = key.currentState!.ticks;
      now = now.add(const Duration(minutes: 2));
      await tester.pump(const Duration(minutes: 2));
      expect(key.currentState!.ticks, ticks);
      enabled.value = true;
      await tester.pump();
      await tester.pump();
      expect(key.currentState!.ticks, ticks + 1);
      expect(find.textContaining('09:02:00.000'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      enabled.dispose();
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets(
    'inactive lifecycle stops ticking and resume refreshes immediately',
    (
      tester,
    ) async {
      var now = DateTime(2026, 9, 2, 9);
      await withClock(Clock(() => now), () async {
        final key = GlobalKey<_ClockProbeState>();
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pumpWidget(
          TickerMode(enabled: true, child: _ClockProbe(key: key)),
        );
        await tester.pump();
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.inactive,
        );
        final ticks = key.currentState!.ticks;
        now = now.add(const Duration(minutes: 2));
        await tester.pump(const Duration(minutes: 2));
        expect(key.currentState!.ticks, ticks);
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pump();
        await tester.pump();
        expect(key.currentState!.ticks, ticks + 1);
        expect(find.textContaining('09:02:00.000'), findsOneWidget);
        await tester.pumpWidget(const SizedBox());
        expect(tester.takeException(), isNull);
      });
    },
  );
}
