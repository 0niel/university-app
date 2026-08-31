import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/utils/lesson_reminders.dart';
import 'package:schedule_repository/schedule_repository.dart';

void main() {
  CustomLesson lesson({
    required String id,
    required String subject,
    required List<DateTime> dates,
    int? reminderMinutes,
    String room = '',
    int startHour = 10,
  }) => .new(
    id: id,
    subject: subject,
    lessonType: .lecture,
    teachers: const [],
    classrooms: room.isEmpty ? const [] : [Classroom(name: room)],
    lessonBells: LessonBells(
      startTime: TimeOfDay(hour: startHour, minute: 0),
      endTime: TimeOfDay(hour: startHour + 1, minute: 30),
      number: 1,
    ),
    recurrence: CustomLessonRecurrence.dates(dates: dates),
    reminderMinutes: reminderMinutes,
  );

  CustomSchedule schedule(List<CustomLesson> lessons) =>
      .new(id: 's1', name: 'W', lessons: lessons);

  final now = DateTime(2030, 1, 1, 8);

  group('buildLessonReminders', () {
    test('skips lessons without a reminder lead time', () {
      final value = schedule([
        lesson(id: 'a', subject: 'A', dates: [DateTime(2030, 1, 2)]),
      ]);
      expect(
        buildLessonReminders(
          scheduleId: 's1',
          schedule: value,
          now: now,
          bodyOf: defaultLessonReminderBody,
        ),
        isEmpty,
      );
    });

    test('schedules every future occurrence with a distinct id', () {
      final value = schedule([
        lesson(
          id: 'a',
          subject: 'A',
          reminderMinutes: 15,
          dates: [DateTime(2030), DateTime(2030, 1, 8)],
          room: 'Г-407',
        ),
      ]);
      final reminders = buildLessonReminders(
        scheduleId: 's1',
        schedule: value,
        now: now,
        bodyOf: defaultLessonReminderBody,
      );
      expect(reminders, hasLength(2));
      expect(reminders.first.when, DateTime(2030, 1, 1, 9, 45));
      expect(reminders.last.when, DateTime(2030, 1, 8, 9, 45));
      expect(reminders.map((reminder) => reminder.id).toSet(), hasLength(2));
      expect(reminders.first.title, 'A');
      expect(reminders.first.body, contains('Г-407'));
    });

    test('skips when every occurrence is in the past', () {
      final value = schedule([
        lesson(
          id: 'a',
          subject: 'A',
          reminderMinutes: 15,
          dates: [DateTime(2029)],
        ),
      ]);
      expect(
        buildLessonReminders(
          scheduleId: 's1',
          schedule: value,
          now: now,
          bodyOf: defaultLessonReminderBody,
        ),
        isEmpty,
      );
    });
  });

  group('reminderIdFor', () {
    test('is stable and non-negative', () {
      final value = lesson(
        id: 'lesson-a',
        subject: 'A',
        dates: [DateTime(2030)],
      );
      expect(reminderIdFor('s1', value), reminderIdFor('s1', value));
      expect(reminderIdFor('s1', value), greaterThanOrEqualTo(0));
    });

    test('uses schedule and stable lesson ids', () {
      final first = lesson(
        id: 'lesson-a',
        subject: 'A',
        dates: [DateTime(2030)],
      );
      final second = first.copyWith(id: 'lesson-b');
      expect(reminderIdFor('s1', first), isNot(reminderIdFor('s2', first)));
      expect(reminderIdFor('s1', first), isNot(reminderIdFor('s1', second)));
    });
  });
}
