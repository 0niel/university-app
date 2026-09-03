import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_metrics.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';

void main() {
  final day = DateTime(2026, 9, 2);
  LessonSchedulePart lesson(int hour, {String subject = 'Алгебра'}) =>
      LessonSchedulePart(
        subject: subject,
        lessonType: LessonType.lecture,
        teachers: const [],
        classrooms: const [],
        lessonBells: LessonBells(
          number: hour == 9 ? 1 : 2,
          startTime: TimeOfDay(hour: hour, minute: 0),
          endTime: TimeOfDay(hour: hour + 1, minute: 30),
        ),
        dates: [day],
      );
  final lessons = [lesson(9), lesson(11)];

  List<HomeLessonEntry> entries(
    DateTime now, {
    List<ScheduleChange> changes = const [],
  }) => homeDayEntries(day: day, lessons: lessons, now: now, changes: changes);

  test('hero transitions at exact start and end boundaries', () {
    final cases = <(DateTime, HomeHeroKind)>[
      (day.add(const Duration(hours: 8)), HomeHeroKind.before),
      (day.add(const Duration(hours: 9)), HomeHeroKind.during),
      (day.add(const Duration(hours: 10, minutes: 30)), HomeHeroKind.pause),
      (day.add(const Duration(hours: 11)), HomeHeroKind.during),
      (day.add(const Duration(hours: 12, minutes: 30)), HomeHeroKind.done),
    ];
    for (final (now, expected) in cases) {
      expect(homeHeroKind(entries: entries(now), isToday: true), expected);
    }
  });

  test('other day never gets current or next live state', () {
    final result = entries(day.add(const Duration(days: 1, hours: 9)));
    expect(result.any((e) => e.isCurrent || e.isNext || e.isPast), isFalse);
    expect(homeHeroKind(entries: result, isToday: false), HomeHeroKind.other);
    expect(homeHeroKind(entries: [], isToday: true), HomeHeroKind.free);
  });

  test('cancel only the matching occurrence of a repeated subject', () {
    final change = ScheduleChange(
      id: 'cancel-1',
      kind: ScheduleChangeKind.cancel,
      subject: ' АЛГЕБРА ',
      lessonDate: day,
      createdAt: day,
      oldValue: const ScheduleChangeSlot(start: '9:00:00'),
    );
    final result = entries(
      day.add(const Duration(hours: 9)),
      changes: [change],
    );
    expect(result.first.isCancelled, isTrue);
    expect(result.first.isCurrent, isFalse);
    expect(result.last.isCancelled, isFalse);
    expect(homeHeroEntry(result, HomeHeroKind.before), result.last);
  });

  test('ambiguous subject-only changes do not cancel both occurrences', () {
    final change = ScheduleChange(
      id: 'cancel-unknown',
      kind: ScheduleChangeKind.cancel,
      subject: 'Алгебра',
      lessonDate: day,
      createdAt: day,
    );
    final result = entries(day, changes: [change]);
    expect(result.any((e) => e.isCancelled), isFalse);
  });

  test('lesson number resolves a repeated subject when time is absent', () {
    final change = ScheduleChange(
      id: 'cancel-2',
      kind: ScheduleChangeKind.cancel,
      subject: 'Алгебра',
      lessonDate: day,
      createdAt: day,
      lessonNumber: 2,
    );
    final result = entries(day, changes: [change]);
    expect(result.first.isCancelled, isFalse);
    expect(result.last.isCancelled, isTrue);
  });

  test('all cancelled lessons produce a free-day hero', () {
    final result = entries(
      day,
      changes: [
        for (var number = 1; number <= 2; number++)
          ScheduleChange(
            id: '$number',
            kind: ScheduleChangeKind.cancel,
            subject: 'Алгебра',
            lessonDate: day,
            createdAt: day,
            lessonNumber: number,
          ),
      ],
    );
    expect(homeHeroKind(entries: result, isToday: true), HomeHeroKind.free);
  });

  test(
    'day filter sorts lessons and excludes dates outside the selected day',
    () {
      expect(homeLessonsForDay([lessons.last, lessons.first], day), lessons);
      expect(
        homeLessonsForDay(lessons, day.add(const Duration(days: 1))),
        isEmpty,
      );
    },
  );

  test('remaining minutes round up and never become negative', () {
    expect(homeMinutesUntil(day.add(const Duration(seconds: 1)), day), 1);
    expect(homeMinutesUntil(day.subtract(const Duration(seconds: 1)), day), 0);
  });

  test('week selection crosses month boundaries from Monday to Sunday', () {
    final week = homeWeekDays(DateTime(2026, 9, 1, 14));
    expect(week.first, DateTime(2026, 8, 31));
    expect(week.last, DateTime(2026, 9, 6));
  });

  test(
    'change target follows selected schedule and excludes custom schedules',
    () {
      expect(
        homeScheduleTarget(
          SelectedSchedule.group(
            group: const Group(name: 'Г-1'),
            schedule: lessons,
          ),
        ),
        (ScheduleTargetType.group, 'Г-1'),
      );
      expect(
        homeScheduleTarget(
          const SelectedSchedule.custom(
            id: 'mine',
            name: 'Моё расписание',
            schedule: [],
          ),
        ),
        isNull,
      );
      expect(homeScheduleTarget(null), isNull);
    },
  );
}
