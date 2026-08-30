import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/watch/bloc/bloc.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

final class WatchConnectivityCubitTest extends Mock
    implements WatchConnectivity {}

void main() {
  setUp(() => debugDefaultTargetPlatformOverride = .android);
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('does not emit after closing during a schedule sync', () async {
    final connectivity = WatchConnectivityCubitTest();
    final response = Completer<void>();
    final cubit = WatchConnectivityCubit(watchConnectivity: connectivity);
    when(
      () => connectivity.sendMessage(any()),
    ).thenAnswer((_) => response.future);

    final sync = cubit.sendSchedule('Schedule', const []);
    await cubit.close();
    response.complete();

    await expectLater(sync, completes);
  });
}
