import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

const _steps = [
  AppTourStep(
    title: 'Первый',
    body: 'Шапка',
    target: AppTourTarget.homeSearch,
  ),
  AppTourStep(
    title: 'Второй',
    body: 'Расписание',
    target: AppTourTarget.scheduleWeek,
  ),
  AppTourStep(
    title: 'Третий',
    body: 'Профиль',
    target: AppTourTarget.profileStats,
  ),
];

Widget _page({
  bool withSchedule = true,
  bool scrolled = false,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppTourAnchor(
              target: AppTourTarget.homeSearch,
              child: SizedBox(height: 40, child: Text('search')),
            ),
            if (scrolled) const SizedBox(height: 2000),
            if (withSchedule)
              const AppTourAnchor(
                target: AppTourTarget.scheduleWeek,
                child: SizedBox(height: 60, child: Text('week')),
              ),
            const AppTourAnchor(
              target: AppTourTarget.profileStats,
              child: SizedBox(height: 80, child: Text('stats')),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _advance(WidgetTester tester) async {
  for (var tick = 0; tick < 24; tick++) {
    await tester.pump(const Duration(milliseconds: 40));
  }
}

void main() {
  late AppTourController controller;

  setUp(
    () => controller = AppTourController(
      anchorTimeout: const Duration(milliseconds: 200),
    ),
  );
  tearDown(() {
    controller
      ..stop()
      ..dispose();
  });

  testWidgets('highlights the widget the step points at', (tester) async {
    await tester.pumpWidget(_page());

    unawaited(controller.start(_steps));
    await _advance(tester);

    expect(controller.isActive, isTrue);
    expect(controller.isMoving, isFalse);
    expect(controller.step?.title, 'Первый');
    expect(controller.hole, tester.getRect(find.text('search')));
  });

  testWidgets('walks forward and back through the steps', (tester) async {
    await tester.pumpWidget(_page());

    unawaited(controller.start(_steps));
    await _advance(tester);
    unawaited(controller.next());
    await _advance(tester);

    expect(controller.step?.title, 'Второй');
    expect(controller.hole, tester.getRect(find.text('week')));

    unawaited(controller.back());
    await _advance(tester);

    expect(controller.step?.title, 'Первый');
    expect(controller.hole, tester.getRect(find.text('search')));
  });

  testWidgets('keeps the current step visible while the next one resolves', (
    tester,
  ) async {
    await tester.pumpWidget(_page());

    unawaited(controller.start(_steps));
    await _advance(tester);
    final firstHole = controller.hole;

    unawaited(controller.next());
    await tester.pump(const Duration(milliseconds: 40));

    expect(controller.isMoving, isTrue);
    expect(controller.step?.title, 'Первый');
    expect(controller.hole, firstHole);

    await _advance(tester);

    expect(controller.isMoving, isFalse);
    expect(controller.step?.title, 'Второй');
  });

  testWidgets('ignores repeated navigation while a step is resolving', (
    tester,
  ) async {
    await tester.pumpWidget(_page());

    unawaited(controller.start(_steps));
    await _advance(tester);
    unawaited(controller.next());
    unawaited(controller.next());
    await _advance(tester);

    expect(controller.index, 1);
    expect(controller.step?.title, 'Второй');
  });

  testWidgets('skips an optional step whose widget is not on screen', (
    tester,
  ) async {
    await tester.pumpWidget(_page(withSchedule: false));

    unawaited(controller.start(_steps));
    await _advance(tester);
    unawaited(controller.next());
    await _advance(tester);

    expect(controller.step?.title, 'Третий');
    expect(controller.hole, tester.getRect(find.text('stats')));
  });

  testWidgets('shows a required step even without its widget', (tester) async {
    await tester.pumpWidget(_page(withSchedule: false));

    unawaited(
      controller.start(const [
        AppTourStep(
          title: 'Обязательный',
          body: 'Без подсветки',
          target: AppTourTarget.scheduleWeek,
          optional: false,
        ),
      ]),
    );
    await _advance(tester);

    expect(controller.step?.title, 'Обязательный');
    expect(controller.hole, isNull);
    expect(controller.isMoving, isFalse);
  });

  testWidgets('scrolls a target below the fold into view', (tester) async {
    await tester.pumpWidget(_page(scrolled: true));

    unawaited(controller.start(_steps));
    await _advance(tester);
    unawaited(controller.next());
    await _advance(tester);

    final hole = controller.hole;
    expect(hole, isNotNull);
    expect(hole, tester.getRect(find.text('week')));
    expect(hole!.top, greaterThanOrEqualTo(0));
    expect(hole.bottom, lessThanOrEqualTo(tester.view.physicalSize.height));
  });

  testWidgets('finishing the last step ends the tour', (tester) async {
    await tester.pumpWidget(_page());

    unawaited(controller.start(_steps));
    await _advance(tester);
    unawaited(controller.next());
    await _advance(tester);
    unawaited(controller.next());
    await _advance(tester);
    expect(controller.isLast, isTrue);

    unawaited(controller.next());
    await _advance(tester);

    expect(controller.isActive, isFalse);
    expect(controller.step, isNull);
    expect(controller.hole, isNull);
  });

  testWidgets('stopping mid-step drops the highlight', (tester) async {
    await tester.pumpWidget(_page());

    unawaited(controller.start(_steps));
    await _advance(tester);
    controller.stop();

    expect(controller.isActive, isFalse);
    expect(controller.hole, isNull);

    await _advance(tester);
    expect(controller.isActive, isFalse);
  });

  testWidgets('anchors unregister when their widget leaves the tree', (
    tester,
  ) async {
    await tester.pumpWidget(_page());
    expect(AppTourAnchors.rectOf(AppTourTarget.homeSearch), isNotNull);

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

    expect(AppTourAnchors.rectOf(AppTourTarget.homeSearch), isNull);
  });
}
