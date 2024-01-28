import 'package:flutter_test/flutter_test.dart';
import 'package:neon_framework/blocs.dart';

void main() {
  group('TimerBloc', () {
    tearDown(() {
      TimerBloc().dispose();
    });

    test('Register timer', () async {
      const duration = Duration(milliseconds: 100);

      final stopwatch = Stopwatch()..start();
      final callback = stopwatch.stop;
      TimerBloc().registerTimer(duration, callback);
      await Future<void>.delayed(duration);

      expect(stopwatch.elapsedMilliseconds, greaterThan(duration.inMilliseconds));
      expect(stopwatch.elapsedMilliseconds, lessThan(duration.inMilliseconds * 2));
      expect(TimerBloc().callbacks[duration.inSeconds], contains(callback));
      expect(TimerBloc().timers[duration.inSeconds], isNot(isNull));
    });

    test('Unregister timer', () async {
      const duration = Duration(milliseconds: 100);
      final callback = neverCalled;

      TimerBloc().registerTimer(duration, callback).cancel();
      await Future<void>.delayed(duration);

      expect(TimerBloc().callbacks[duration.inSeconds], isNot(contains(callback)));
    });

    test('dispose', () {
      TimerBloc().registerTimer(const Duration(minutes: 1), () {});
      expect(TimerBloc().timers, hasLength(1));
      expect(TimerBloc().callbacks, hasLength(1));
      TimerBloc().dispose();
      expect(TimerBloc().timers, isEmpty);
      expect(TimerBloc().callbacks, isEmpty);
    });
  });
}
