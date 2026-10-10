import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_day_pager.dart';

void main() {
  final first = DateTime(2026, 10, 8);
  final changes = <DateTime>[];
  late DateTime selected;
  late StateSetter update;
  var largeText = false;

  setUp(() {
    selected = first;
    changes.clear();
    largeText = false;
  });

  Future<void> pump(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(largeText ? 2 : 1),
              ),
              child: Scaffold(
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.screen),
                  child: TeacherDayPager(
                    day: selected,
                    onDay: (day) => setState(() {
                      changes.add(day);
                      selected = day;
                    }),
                    builder: (_, date) => Column(
                      key: ValueKey('day-body-${date.toIso8601String()}'),
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('${date.day}', style: AppText.title),
                        for (var index = 0; index < 3; index++)
                          Text(
                            'Длинное название занятия и учебной группы $index',
                            style: AppText.title,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'rapid sync ignores stale scroll end then user swipe selects once',
    (
      tester,
    ) async {
      await pump(tester);
      final pager = find.byKey(const ValueKey('teacher-dashboard-day-pager'));
      update(() => selected = first.add(const Duration(days: 1)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 30));
      update(() => selected = first.add(const Duration(days: 3)));
      await tester.pump();
      final position = tester.widget<PageView>(pager).controller!.position;
      ScrollEndNotification(
        metrics: position,
        context: tester.element(pager),
      ).dispatch(tester.element(pager));
      await tester.pumpAndSettle();
      expect(changes, isEmpty);
      expect(selected, first.add(const Duration(days: 3)));
      final controller = tester.widget<PageView>(pager).controller!;
      expect(controller.page, controller.page!.roundToDouble());
      await tester.drag(pager, const Offset(-310, 0));
      await tester.pumpAndSettle();
      expect(changes, [first.add(const Duration(days: 4))]);
      expect(selected, changes.single);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('user swipe interrupts a pending sync without a later day jump', (
    tester,
  ) async {
    await pump(tester);
    final pager = find.byKey(const ValueKey('teacher-dashboard-day-pager'));
    final target = first.add(const Duration(days: 3));
    update(() => selected = target);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    await tester.drag(pager, const Offset(310, 0));
    await tester.pumpAndSettle();
    expect(changes, hasLength(1));
    expect(selected, changes.single);
    expect(selected, isNot(target));
    final settled = selected;
    await tester.pump(const Duration(seconds: 1));
    expect(selected, settled);
    expect(changes, hasLength(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('live width and text scale changes remeasure the entire day', (
    tester,
  ) async {
    await pump(tester);
    final pager = find.byKey(const ValueKey('teacher-dashboard-day-pager'));
    final body = find.byKey(ValueKey('day-body-${first.toIso8601String()}'));
    final before = tester.getSize(pager).height;
    final state = tester.state(pager);
    tester.view.physicalSize = const Size(320, 844);
    update(() => largeText = true);
    await tester.pumpAndSettle();
    expect(tester.state(pager), same(state));
    expect(tester.getSize(pager).height, greaterThan(before));
    expect(
      tester.getSize(pager).height,
      greaterThanOrEqualTo(tester.getSize(body).height),
    );
    expect(changes, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
