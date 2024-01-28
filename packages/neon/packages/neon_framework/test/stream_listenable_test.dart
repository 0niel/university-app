import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/src/utils/stream_listenable.dart';
import 'package:rxdart/rxdart.dart';

class MockCallbackFunction extends Mock {
  FutureOr<void> call();
}

void main() {
  group('StreamListenable', () {
    test('stream', () async {
      final stream = BehaviorSubject<bool>();
      final callback = MockCallbackFunction();

      StreamListenable(stream).addListener(callback.call);

      verifyNever(callback.call);

      stream.value = true;
      await Future<void>.delayed(const Duration(milliseconds: 100));
      verify(callback.call).called(1);

      stream.value = true;
      await Future<void>.delayed(const Duration(milliseconds: 100));
      verify(callback.call).called(1);

      unawaited(stream.close());
    });

    test('multiStream', () async {
      final stream = BehaviorSubject<bool>();
      final stream2 = BehaviorSubject<int>();
      final callback = MockCallbackFunction();

      StreamListenable.multiListenable({
        stream,
        stream2,
      }).addListener(callback.call);

      verifyNever(callback.call);

      stream.value = true;
      await Future<void>.delayed(const Duration(milliseconds: 100));
      verify(callback.call).called(1);

      stream2.value = 3;
      await Future<void>.delayed(const Duration(milliseconds: 100));
      verify(callback.call).called(1);

      unawaited(stream.close());
      unawaited(stream2.close());
    });

    test('dispose', () {
      final controller = StreamController<void>();

      final listenable = StreamListenable(controller.stream);

      expect(controller.hasListener, true);

      // ignore: cascade_invocations
      listenable.dispose();

      expect(controller.isClosed, false);
      unawaited(controller.close());
    });
  });
}
