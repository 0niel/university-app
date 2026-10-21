import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/utils/schedule_date_index.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_day_data.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../view/schedule_page/schedule_test_data.dart';

void main() {
  final monday = DateTime(2026, 10, 19);
  final tuesday = DateTime(2026, 10, 20);

  test(
    'indexes calendar dates once while preserving source order and kinds',
    () {
      final lesson = scheduleTestLesson(day: monday).copyWith(
        dates: [monday, monday.add(const Duration(hours: 8)), tuesday],
      );
      final holiday = HolidaySchedulePart(title: 'Holiday', dates: [monday]);
      final event = CalendarSchedulePart(title: 'Event', dates: [tuesday]);
      final index = ScheduleDateIndex([holiday, lesson, event]);

      expect(index.partsForDay(monday), [holiday, lesson]);
      expect(index.partsForDay(monday.add(const Duration(hours: 23))), [
        holiday,
        lesson,
      ]);
      expect(index.partsForDay(tuesday), [lesson, event]);
      expect(index.partsForDay(DateTime(2026, 10, 21)), isEmpty);
      expect(() => index.partsForDay(monday).clear(), throwsUnsupportedError);
    },
  );

  test('retains separate source entries and detects replacement snapshots', () {
    final lesson = scheduleTestLesson(day: monday);
    final source = [lesson, lesson];
    final index = ScheduleDateIndex(source);
    expect(index.partsForDay(monday), [lesson, lesson]);
    expect(index.matches(List.of(source)), isTrue);

    final changed = lesson.copyWith(dates: [tuesday]);
    expect(index.matches([lesson, changed]), isFalse);
    final replacement = ScheduleDateIndex([lesson, changed]);
    expect(replacement.partsForDay(monday), [lesson]);
    expect(replacement.partsForDay(tuesday), [changed]);
  });

  test('indexed week data retains events crossing their listed date', () {
    final event = CalendarSchedulePart(
      title: 'Night event',
      dates: [monday],
      startsAt: monday.add(const Duration(hours: 23)),
      endsAt: tuesday.add(const Duration(hours: 1)),
    );
    final index = ScheduleDateIndex([event]);
    final data = ScheduleWeekDayData(
      day: tuesday,
      now: tuesday,
      schedule: index.partsForDay(tuesday),
      calendarEvents: index.calendarEvents,
      changes: const [],
      preferences: const SchedulePreferencesState(),
      display: const ScheduleDisplayState(),
      activities: const [],
    );
    expect(data.events.single.$1, same(event));
    expect(data.events.single.$2.startMinutes, 0);
    expect(data.events.single.$2.endMinutes, 60);
  });
}
