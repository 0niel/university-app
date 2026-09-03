import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_hero.dart';

import '../../gallery/home_dashboard_fixture.dart';
import '../../helpers/pump_app.dart';

void main() {
  testWidgets('full dashboard remains scrollable at 320px and 200% text', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpApp(
      Scaffold(body: homeDashboardFixture(controller: controller)),
      size: const Size(320, 844),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  for (final loading in [true, false]) {
    testWidgets(
      '${loading ? 'loading' : 'no schedule'} never claims a free day',
      (tester) async {
        final controller = ScrollController();
        addTearDown(controller.dispose);
        await tester.pumpApp(
          Scaffold(
            body: homeDashboardFixture(
              controller: controller,
              loading: loading,
              noSchedule: !loading,
            ),
          ),
          size: const Size(390, 844),
        );
        await tester.pump();
        expect(find.byType(HomeHero), findsNothing);
        expect(find.text('Сегодня пар нет'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
