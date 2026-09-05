import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final monday = DateTime(2026, 9, 7);

  Future<void> pump(
    WidgetTester tester,
    ValueNotifier<DateTime> week,
    List<DateTime> changes, {
    double width = 390,
    double scale = 1,
    bool reduced = false,
    int dots = 0,
    int Function(DateTime)? weekDots,
    bool markToday = false,
    ValueChanged<DateTime>? onChange,
    ValueChanged<int>? onSelect,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: MediaQuery(
            data: MediaQueryData(
              size: Size(width, 800),
              textScaler: TextScaler.linear(scale),
              disableAnimations: reduced,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width,
                child: ValueListenableBuilder<DateTime>(
                  valueListenable: week,
                  builder: (context, start, child) => AppWeekPager(
                    weekStart: start,
                    selectedIndex: 2,
                    onSelected: onSelect ?? (index) {},
                    onWeekChanged: (value) {
                      changes.add(value);
                      if (onChange != null) {
                        onChange(value);
                      } else {
                        week.value = value;
                      }
                    },
                    daysBuilder: (start) => [
                      for (var index = 0; index < 7; index++)
                        AppWeekDay(
                        DateUtils.addDaysToDate(start, index).day.toString(),
                          short: 'ПН',
                          isToday: markToday && index == 0,
                          dots: List.filled(
                            weekDots?.call(start) ?? dots,
                            Colors.blue,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('week follows finger and cancelled swipe does not select a week',
      (tester) async {
    final week = ValueNotifier(monday);
    addTearDown(week.dispose);
    final changes = <DateTime>[];
    await pump(tester, week, changes);
    final gesture = await tester.startGesture(const Offset(300, 32));
    await gesture.moveBy(const Offset(-30, 0));
    await gesture.moveBy(const Offset(-210, 0));
    await tester.pump();
    expect(tester.getTopLeft(find.byKey(ValueKey(monday))).dx, lessThan(-180));
    expect(changes, isEmpty);
    expect(week.value, monday);
    await gesture.moveBy(const Offset(240, 0));
    await tester.pump(const Duration(milliseconds: 300));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(changes, isEmpty);
    expect(tester.getTopLeft(find.byKey(ValueKey(monday))).dx, closeTo(0, .01));
  });

  testWidgets('settled swipe publishes once and can reverse across weeks',
      (tester) async {
    final week = ValueNotifier(monday);
    addTearDown(week.dispose);
    final changes = <DateTime>[];
    await pump(tester, week, changes);
    await tester.fling(find.byType(AppWeekPager), const Offset(-260, 0), 800);
    await tester.pumpAndSettle();
    expect(changes, [DateTime(2026, 9, 14)]);
    await tester.fling(find.byType(AppWeekPager), const Offset(260, 0), 800);
    await tester.pumpAndSettle();
    expect(changes, [DateTime(2026, 9, 14), monday]);
  });

  testWidgets(
      'first external change animates and rapid retarget keeps final week',
      (tester) async {
    final week = ValueNotifier(monday);
    addTearDown(week.dispose);
    final changes = <DateTime>[];
    await pump(tester, week, changes);
    final controller =
        tester.widget<PageView>(find.byType(PageView)).controller!;
    final initial = controller.page!;
    week.value = DateTime(2026, 9, 14);
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 90));
    expect(controller.page, greaterThan(initial));
    expect(controller.page, lessThan(initial + 1));
    week.value = DateTime(2026, 9, 21);
    await tester.pumpAndSettle();
    expect(controller.page, closeTo(initial + 2, .001));
    expect(changes, isEmpty);
    week.value = monday;
    await tester.pumpAndSettle();
    expect(controller.page, closeTo(initial, .001));
  });

  testWidgets('reduced motion uses immediate external navigation',
      (tester) async {
    final week = ValueNotifier(monday);
    addTearDown(week.dispose);
    final changes = <DateTime>[];
    await pump(tester, week, changes, reduced: true);
    final controller =
        tester.widget<PageView>(find.byType(PageView)).controller!;
    final initial = controller.page!;
    week.value = DateTime(2026, 9, 14);
    await tester.pump();
    await tester.pump();
    expect(controller.page, initial + 1);
    expect(changes, isEmpty);
  });

  testWidgets('all seven days stay reachable at narrow width and 200% text',
      (tester) async {
    final week = ValueNotifier(monday);
    addTearDown(week.dispose);
    final selected = <int>[];
    await pump(
      tester,
      week,
      [],
      width: 280,
      scale: 2,
      dots: 14,
      onSelect: selected.add,
    );
    final cells = find.byType(AppDayPill).hitTestable();
    expect(cells, findsNWidgets(7));
    for (final element in cells.evaluate()) {
      final size = tester.getSize(find.byWidget(element.widget));
      expect(size.width, greaterThanOrEqualTo(44));
      expect(size.height, greaterThanOrEqualTo(44));
      await tester.tap(find.byWidget(element.widget));
    }
    expect(selected, [0, 1, 2, 3, 4, 5, 6]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('today border reserves enough room for six lesson marks',
      (tester) async {
    final week = ValueNotifier(monday);
    addTearDown(week.dispose);
    await pump(tester, week, [], width: 350, dots: 6, markToday: true);
    expect(tester.takeException(), isNull);
    expect(find.byType(AppDayPill).hitTestable(), findsNWidgets(7));
  });

  testWidgets(
      'external animation retains outgoing and intermediate week heights',
      (tester) async {
    final week = ValueNotifier(monday);
    addTearDown(week.dispose);
    await pump(
      tester,
      week,
      [],
      width: 280,
      scale: 2,
      weekDots: (start) =>
          start == monday || start == DateTime(2026, 9, 14) ? 14 : 0,
    );
    final initialHeight = tester.getSize(find.byType(AppWeekPager)).height;
    week.value = DateTime(2026, 9, 28);
    await tester.pump();
    expect(
      tester.getSize(find.byType(AppWeekPager)).height,
      greaterThanOrEqualTo(initialHeight),
    );
    for (var frame = 0; frame < 12; frame++) {
      await tester.pump(const Duration(milliseconds: 30));
      expect(tester.takeException(), isNull);
    }
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byType(AppWeekPager)).height,
      lessThan(initialHeight),
    );
  });

  testWidgets('coalesced parent selection does not leave a stale reported week',
      (tester) async {
    final week = ValueNotifier(monday);
    addTearDown(week.dispose);
    final changes = <DateTime>[];
    await pump(
      tester,
      week,
      changes,
      onChange: (value) => week.value = DateTime(2026, 9, 21),
    );
    final controller =
        tester.widget<PageView>(find.byType(PageView)).controller!;
    final initial = controller.page!;
    await tester.fling(find.byType(AppWeekPager), const Offset(-260, 0), 800);
    await tester.pumpAndSettle();
    expect(changes, [DateTime(2026, 9, 14)]);
    expect(controller.page, closeTo(initial + 2, .001));
    week.value = DateTime(2026, 9, 14);
    await tester.pumpAndSettle();
    expect(controller.page, closeTo(initial + 1, .001));
    expect(changes.length, 1);
  });
}
