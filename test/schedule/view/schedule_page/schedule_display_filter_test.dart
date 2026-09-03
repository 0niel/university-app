import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_month_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';
import 'schedule_test_data.dart';

void main() {
  final day = DateTime(2026, 9, 2);
  final now = DateTime(2026, 9, 2, 12);
  final lessons = [
    scheduleTestLesson(subject: 'Прошедшая', day: day),
    scheduleTestLesson(subject: 'Отменённая', day: day, start: 760, end: 850),
    scheduleTestLesson(subject: 'Будущая', day: day, start: 860, end: 950),
  ];
  final changes = [
    ScheduleChange(
      id: 'cancel',
      kind: ScheduleChangeKind.cancel,
      subject: 'Отменённая',
      lessonDate: day,
      createdAt: day,
    ),
  ];

  test(
    'display and subject filters compose without changing source lessons',
    () {
      final visible = visibleLessonsForDay(
        schedule: lessons,
        day: day,
        now: now,
        preferences: const SchedulePreferencesState(),
        display: const ScheduleDisplayState(
          showPast: false,
          showCancelled: false,
        ),
        changes: changes,
      );
      expect(visible.map((lesson) => lesson.subject), ['Будущая']);
      expect(lessons, hasLength(3));
      expect(
        visibleLessonsForDay(
          schedule: lessons,
          day: day,
          now: now,
          preferences: const SchedulePreferencesState(
            hiddenSubjects: ['Будущая'],
          ),
          display: const ScheduleDisplayState(
            showPast: false,
            showCancelled: false,
          ),
          changes: changes,
        ),
        isEmpty,
      );
    },
  );

  testWidgets('month dots follow display filters and retain date navigation', (
    tester,
  ) async {
    DateTime? picked;
    Future<void> pump(ScheduleDisplayState display) => tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ScheduleMonthView(
              day: day,
              now: now,
              schedule: lessons,
              preferences: const SchedulePreferencesState(),
              display: display,
              changes: changes,
              onDay: (value) => picked = value,
              onMonth: (_) {},
            ),
          ),
        ),
      ),
      size: const Size(390, 844),
    );
    final cell = find.byKey(const ValueKey('schedule-month-day-2'));
    final dots = find.descendant(of: cell, matching: find.byType(AppDot));
    await pump(const ScheduleDisplayState());
    expect(dots, findsNWidgets(3));
    await pump(
      const ScheduleDisplayState(showPast: false, showCancelled: false),
    );
    expect(dots, findsOneWidget);
    await tester.tap(cell);
    expect(picked, day);
    expect(tester.takeException(), isNull);
  });
}
