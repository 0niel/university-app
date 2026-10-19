import 'dart:collection';

import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_day_data.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';
import 'schedule_test_data.dart';

void main() {
  final day = DateTime(2030, 9, 2);
  const morning = LessonBellSlotConfig(startMinutes: 540, endMinutes: 600);

  ScheduleWeekDayData prepare({
    DateTime? date,
    DateTime? now,
    List<SchedulePart> schedule = const [],
    List<UserActivity> activities = const [],
    List<ScheduleChange> changes = const [],
    SchedulePreferencesState preferences = const SchedulePreferencesState(),
    ScheduleDisplayState display = const ScheduleDisplayState(),
  }) => ScheduleWeekDayData(
    day: date ?? day,
    now: now ?? day,
    schedule: schedule,
    changes: changes,
    preferences: preferences,
    display: display,
    activities: activities,
  );

  test('daily preparation retains sorting and composed visibility filters', () {
    final later = scheduleTestLesson(
      day: day,
      subject: 'Later',
      start: 840,
      end: 900,
    );
    final earlier = scheduleTestLesson(
      day: day,
      subject: 'Earlier',
      start: 780,
      end: 840,
    );
    final source = [
      later,
      scheduleTestLesson(day: day, subject: 'Past'),
      scheduleTestLesson(
        day: day,
        subject: 'Hidden',
        start: 780,
        end: 840,
      ),
      scheduleTestLesson(
        day: day,
        subject: 'Seminar',
        type: .practice,
        start: 780,
        end: 840,
      ),
      scheduleTestLesson(
        day: day,
        subject: 'Cancelled',
        start: 780,
        end: 840,
      ),
      earlier,
      scheduleTestLesson(
        day: day.add(const Duration(days: 1)),
        subject: 'Other day',
      ),
    ];
    final data = prepare(
      schedule: source,
      now: day.add(const Duration(hours: 12)),
      preferences: const SchedulePreferencesState(
        hiddenSubjects: ['Hidden'],
        showSeminars: false,
      ),
      display: const ScheduleDisplayState(
        showPast: false,
        showCancelled: false,
      ),
      changes: [
        ScheduleChange(
          id: 'cancel',
          kind: .cancel,
          subject: 'Cancelled',
          lessonDate: day,
          createdAt: day,
        ),
      ],
    );
    expect(data.lessons, [earlier, later]);
    expect(data.lessonsIn(morning), isEmpty);
    expect(
      data.lessonsIn(
        const LessonBellSlotConfig(startMinutes: 810, endMinutes: 870),
      ),
      [earlier, later],
    );
    expect(source.first, same(later));
    expect(source, hasLength(7));
  });

  test('overnight entries keep clipped slots and original order', () {
    final previous = day.subtract(const Duration(days: 1));
    final first = CalendarSchedulePart(
      title: 'First',
      dates: [previous],
      startsAt: previous.add(const Duration(hours: 23)).toUtc(),
      endsAt: day.add(const Duration(hours: 1)).toUtc(),
    );
    final second = first.copyWith(title: 'Second');
    final activity = UserActivity(
      id: 'overnight',
      type: .personal,
      title: 'Overnight',
      startsAt: previous.add(const Duration(hours: 23)),
      endsAt: day.add(const Duration(hours: 1)),
    );
    final data = prepare(
      schedule: [
        first,
        first.copyWith(title: 'All day', isAllDay: true),
        first.copyWith(title: 'No end', endsAt: null),
        first.copyWith(title: 'Invalid', endsAt: first.startsAt),
        second,
      ],
      activities: [
        activity,
        activity.copyWith(id: 'no-end', endsAt: null),
        activity.copyWith(id: 'invalid', endsAt: activity.startsAt),
      ],
    );
    const early = LessonBellSlotConfig(startMinutes: 0, endMinutes: 60);
    expect(data.eventsIn(early), [first, second]);
    expect(data.activitiesIn(early), [activity]);
    expect(
      data.events.map((entry) => (entry.$2.startMinutes, entry.$2.endMinutes)),
      [(0, 60), (0, 60)],
    );
    expect(data.eventsIn(morning), isEmpty);
    expect(data.activitiesIn(morning), isEmpty);
    final hiddenPast = prepare(
      schedule: [first],
      activities: [activity],
      now: day.add(const Duration(hours: 1)),
      display: const ScheduleDisplayState(showPast: false),
    );
    expect(hiddenPast.events, isEmpty);
    expect(hiddenPast.activities, isEmpty);
  });

  test('calendar overlap retains exact second boundaries', () {
    final event = CalendarSchedulePart(
      title: 'Seconds',
      dates: [day],
      startsAt: day.add(const Duration(hours: 8, minutes: 59, seconds: 30)),
      endsAt: day.add(const Duration(hours: 9, seconds: 30)),
    );
    final data = prepare(schedule: [event]);
    expect(data.eventsIn(morning), [event]);
    expect(
      data.eventsIn(
        const LessonBellSlotConfig(startMinutes: 539, endMinutes: 540),
      ),
      [event],
    );
    expect(
      data.eventsIn(
        const LessonBellSlotConfig(startMinutes: 541, endMinutes: 600),
      ),
      isEmpty,
    );
  });

  testWidgets('week cells do not rescan the semester for each bell row', (
    tester,
  ) async {
    final source = _CountingSchedule([
      for (var index = 0; index < 64; index++)
        scheduleTestLesson(
          day: day.add(Duration(days: index * 7)),
          subject: 'Lesson $index',
        ),
    ]);
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: ScheduleWeekView(
            day: day,
            now: day,
            schedule: source,
            changes: const [],
            preferences: const SchedulePreferencesState(),
            display: const ScheduleDisplayState(),
            activities: const [],
            onDay: (_) {},
          ),
        ),
      ),
      size: const Size(900, 2200),
    );
    expect(source.reads, lessThanOrEqualTo(source.length * 18));
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
