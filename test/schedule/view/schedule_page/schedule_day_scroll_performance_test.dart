import 'dart:collection';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_strip.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_month_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';
import 'schedule_test_data.dart';

void main() {
  final day = DateTime(2030, 9, 2);
  final lessons = [
    scheduleTestLesson(day: day, subject: 'Lecture', end: 600),
    scheduleTestLesson(
      day: day,
      subject: 'Practice',
      type: .practice,
      end: 600,
    ),
  ];

  Widget dayView({DateTime? now, bool extras = false}) => AppPreviewScope(
    child: ScheduleDayView(
      day: day,
      now: now ?? day,
      schedule: [
        ...lessons,
        if (extras)
          CalendarSchedulePart(
            title: 'Calendar event',
            dates: [day],
            startsAt: day.add(const Duration(hours: 12)),
            endsAt: day.add(const Duration(hours: 13)),
          ),
      ],
      changes: const [],
      preferences: const SchedulePreferencesState(),
      display: const ScheduleDisplayState(),
      activities: [
        if (extras)
          UserActivity(
            id: 'personal',
            type: .personal,
            title: 'Personal activity',
            startsAt: day.add(const Duration(hours: 10, minutes: 30)),
            endsAt: day.add(const Duration(hours: 11)),
          ),
      ],
      comparing: false,
      showDayStrip: false,
      onDay: (_) {},
    ),
  );

  testWidgets('scrolling reuses the complete lesson foreground layer', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [dayView(), const SizedBox(height: 1000)],
          ),
        ),
      ),
      size: const Size(390, 844),
    );
    await tester.pumpAndSettle();
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey('schedule-day-row-0')),
    )..debugResetMetrics();
    for (var frame = 1; frame <= 8; frame++) {
      controller.jumpTo(frame * 4);
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(boundary.debugSymmetricPaintCount, 0);
    expect(boundary.debugAsymmetricPaintCount, 8);
    expect(find.text('Lecture'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final width in [320.0, 390.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'row isolation preserves overlaps and time overlay at $width/$scale',
        (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: dayView(
                    now: day.add(const Duration(hours: 9, minutes: 30)),
                    extras: true,
                  ),
                ),
              ),
            ),
            size: Size(width, 844),
            textScaler: TextScaler.linear(scale),
          );
          await tester.pumpAndSettle();
          for (var index = 0; index < 3; index++) {
            final row = find.byKey(ValueKey('schedule-day-row-$index'));
            expect(
              find.descendant(of: row, matching: find.byType(AppLessonCard)),
              findsOneWidget,
            );
            expect(tester.getRect(row).left, 20);
            expect(tester.getRect(row).right, width - 20);
          }
          final timeMarker = find.byKey(const ValueKey('schedule-now-line'));
          expect(timeMarker, findsOneWidget);
          expect(
            find.ancestor(
              of: timeMarker,
              matching: find.byKey(const ValueKey('schedule-day-row-0')),
            ),
            findsNothing,
          );
          await tester.tap(
            find.byKey(const ValueKey('schedule-overlap-next')),
          );
          await tester.pumpAndSettle();
          expect(find.text('Practice'), findsOneWidget);
          expect(find.text('Lecture'), findsNothing);
          expect(find.text('Personal activity'), findsOneWidget);
          expect(find.text('Calendar event'), findsOneWidget);
          expect(timeMarker, findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('month totals and cells scan semester data only once', (
    tester,
  ) async {
    final source = _CountingSchedule([
      ...lessons,
      for (var index = 1; index <= 62; index++)
        scheduleTestLesson(
          day: day.add(Duration(days: index * 7)),
          subject: 'Future $index',
        ),
    ]);
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: ScheduleMonthView(
            day: day,
            now: day,
            schedule: source,
            preferences: const SchedulePreferencesState(),
            onDay: (_) {},
            onMonth: (_) {},
          ),
        ),
      ),
      size: const Size(390, 844),
    );
    await tester.pumpAndSettle();
    expect(source.reads, source.length);
    expect(find.byType(ScheduleMonthTypeChart), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('day marks reuse the date index across visibility filters', (
    tester,
  ) async {
    final source = _CountingSchedule([
      ...lessons,
      for (var index = 1; index <= 62; index++)
        scheduleTestLesson(
          day: day.add(Duration(days: index * 7)),
          subject: 'Future $index',
        ),
    ]);
    Future<void> pump({bool showLectures = true}) => tester.pumpApp(
      Scaffold(
        body: ScheduleDayStrip(
          day: day,
          now: day,
          schedule: source,
          preferences: SchedulePreferencesState(showLectures: showLectures),
          display: const ScheduleDisplayState(),
          changes: const [],
          onDay: (_) {},
        ),
      ),
      size: const Size(390, 844),
    );
    await pump();
    await tester.pumpAndSettle();
    expect(source.reads, source.length);
    final initial = tester
        .widget<AppWeekStrip>(find.byType(AppWeekStrip))
        .days[day.weekday - 1];
    expect(initial.dots, hasLength(2));
    expect(initial.semanticsLabel, contains('Lecture'));
    expect(initial.semanticsLabel, contains('Practice'));
    source.reads = 0;
    await pump(showLectures: false);
    await tester.pumpAndSettle();
    expect(source.reads, 0);
    final filtered = tester
        .widget<AppWeekStrip>(find.byType(AppWeekStrip))
        .days[day.weekday - 1];
    expect(filtered.dots, [initial.dots.last]);
    expect(filtered.semanticsLabel, isNot(contains('Lecture')));
    expect(filtered.semanticsLabel, contains('Practice'));
    expect(tester.takeException(), isNull);
  });
}

class _CountingSchedule extends ListBase<SchedulePart> {
  _CountingSchedule(this.source);

  final List<SchedulePart> source;
  int reads = 0;

  @override
  int get length => source.length;

  @override
  set length(int value) => throw UnsupportedError('Read only');

  @override
  SchedulePart operator [](int index) {
    reads++;
    return source[index];
  }

  @override
  void operator []=(int index, SchedulePart value) =>
      throw UnsupportedError('Read only');
}
