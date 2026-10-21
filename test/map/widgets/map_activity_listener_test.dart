import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/widgets/map_activity_listener.dart';

void main() {
  testWidgets('activity follows retained branch, covered route and lifecycle', (
    tester,
  ) async {
    final events = <bool>[];
    final active = ValueNotifier(true);
    addTearDown(active.dispose);
    final navigator = GlobalKey<NavigatorState>();
    var builds = 0;
    tester.binding.handleAppLifecycleStateChanged(
      AppLifecycleState.resumed,
    );
    addTearDown(
      () => tester.binding.handleAppLifecycleStateChanged(
        AppLifecycleState.resumed,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        home: ValueListenableBuilder<bool>(
          valueListenable: active,
          builder: (context, enabled, child) =>
              TickerMode(enabled: enabled, child: child!),
          child: MapActivityListener(
            onChanged: events.add,
            child: Builder(
              builder: (_) {
                builds++;
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final element = tester.element(find.byType(MapActivityListener));
    active.value = false;
    await tester.pumpAndSettle();
    active.value = true;
    await tester.pumpAndSettle();
    expect(events, [true, false, true]);
    expect(tester.element(find.byType(MapActivityListener)), same(element));
    unawaited(
      navigator.currentState!.push<void>(
        MaterialPageRoute(builder: (_) => const SizedBox()),
      ),
    );
    await tester.pumpAndSettle();
    expect(events.last, isFalse);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(events.last, isTrue);
    tester.binding.handleAppLifecycleStateChanged(
      AppLifecycleState.paused,
    );
    expect(events.last, isFalse);
    await tester.pump();
    expect(events.last, isFalse);
    tester.binding.handleAppLifecycleStateChanged(
      AppLifecycleState.resumed,
    );
    await tester.pumpAndSettle();
    expect(events.last, isTrue);
    expect(builds, 1);
    expect(tester.takeException(), isNull);
  });
}
