import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/view/compare/comparison_logic.dart';
import 'package:schedule_repository/schedule_repository.dart';

LessonSchedulePart _lesson({
  required String subject,
  required int startHour,
  required int startMinute,
  required int endHour,
  required int endMinute,
  required DateTime date,
  LessonType type = LessonType.practice,
}) {
  return LessonSchedulePart(
    subject: subject,
    lessonType: type,
    teachers: const [],
    classrooms: const [],
    lessonBells: LessonBells(
      startTime: TimeOfDay(hour: startHour, minute: startMinute),
      endTime: TimeOfDay(hour: endHour, minute: endMinute),
    ),
    dates: [date],
  );
}

void main() {
  final day = DateTime(2026, 5, 20);
  final otherDay = DateTime(2026, 5, 21);

  LessonSchedulePart part(String subject, int start, int end) => _lesson(
    subject: subject,
    startHour: start ~/ 60,
    startMinute: start % 60,
    endHour: end ~/ 60,
    endMinute: end % 60,
    date: day,
  );

  group('lessonsOnDay', () {
    test('keeps only lessons on the requested day, sorted by start time', () {
      final late = _lesson(
        subject: 'Базы данных',
        startHour: 12,
        startMinute: 40,
        endHour: 14,
        endMinute: 10,
        date: day,
      );
      final early = _lesson(
        subject: 'Машинное обучение',
        startHour: 9,
        startMinute: 0,
        endHour: 10,
        endMinute: 30,
        date: day,
      );
      final wrongDay = _lesson(
        subject: 'Системы ИИ',
        startHour: 9,
        startMinute: 0,
        endHour: 10,
        endMinute: 30,
        date: otherDay,
      );

      final result = lessonsOnDay([late, early, wrongDay], day);

      expect(result.map((l) => l.subject), [
        'Машинное обучение',
        'Базы данных',
      ]);
    });
  });

  group('buildComparisonSlots', () {
    test('keeps overlapping subjects and the true end of merged occupancy', () {
      final slots = buildComparisonSlots(
        [
          part('A', 540, 660),
          part('B', 600, 720),
          part('C', 780, 840),
        ],
        [part('B', 600, 720)],
      );
      final overlap = slots.singleWhere((slot) => slot.minute == 600);
      expect(overlap.allMine.map((lesson) => lesson.subject), ['A', 'B']);
      expect(overlap.allFriends.single.subject, 'B');
      expect(overlap.isTogether, isTrue);
      final free = slots.where((slot) => slot.bothFree).toList();
      expect(free, hasLength(1));
      expect((free.single.minute, free.single.freeUntil), (720, 780));
    });

    test('does not fabricate free time inside a longer overlapping lesson', () {
      final slots = buildComparisonSlots([
        part('A', 540, 840),
        part('B', 600, 630),
        part('C', 780, 810),
      ], const []);
      expect(slots.where((slot) => slot.bothFree), isEmpty);
    });

    test('accepts a thirty minute break with arbitrary bell times', () {
      final slots = buildComparisonSlots([
        part('A', 545, 615),
        part('B', 645, 700),
      ], const []);
      final free = slots.singleWhere((slot) => slot.bothFree);
      expect((free.time, free.untilTime), ('10:15', '10:45'));
    });

    test(
      'activities split common windows and touching intervals stay busy',
      () {
        final slots = buildComparisonSlots(
          [part('A', 540, 600), part('B', 780, 840)],
          const [],
          busyRanges: const [(660, 690), (690, 720)],
        );
        expect(
          slots
              .where((slot) => slot.bothFree)
              .map((slot) => (slot.minute, slot.freeUntil)),
          [(600, 660), (720, 780)],
        );
      },
    );

    test('empty schedules have no fabricated full-day window', () {
      expect(buildComparisonSlots(const [], const []), isEmpty);
    });

    test('event-only occupancy is visible and is not called an empty day', () {
      final slots = buildComparisonSlots([], [], busyRanges: [(600, 660)]);
      expect(slots, hasLength(1));
      expect(slots.single.bothFree, isFalse);
      expect((slots.single.time, slots.single.untilTime), ('10:00', '11:00'));
    });

    test(
      'same subject in different rooms or at different times is not together',
      () {
        final mine = part(
          'Math',
          540,
          660,
        ).copyWith(classrooms: [const Classroom(name: 'A')]);
        final friend = part(
          'Math',
          540,
          660,
        ).copyWith(classrooms: [const Classroom(name: 'B')]);
        expect(
          buildComparisonSlots([mine], [friend]).single.isTogether,
          isFalse,
        );
        expect(
          buildComparisonSlots(
            [mine],
            [part('Math', 600, 660)],
          ).last.isTogether,
          isFalse,
        );
      },
    );

    test('flags a shared subject at the same start time as together', () {
      final mine = [
        _lesson(
          subject: 'Машинное обучение',
          startHour: 10,
          startMinute: 40,
          endHour: 12,
          endMinute: 10,
          date: day,
        ),
      ];
      final friends = [
        _lesson(
          subject: 'Машинное обучение',
          startHour: 10,
          startMinute: 40,
          endHour: 12,
          endMinute: 10,
          date: day,
        ),
      ];

      final slots = buildComparisonSlots(mine, friends);

      expect(slots, hasLength(1));
      expect(slots.single.isTogether, isTrue);
    });

    test('different subjects at the same time are not together', () {
      final mine = [
        _lesson(
          subject: 'Архитектура ЭВМ',
          startHour: 9,
          startMinute: 0,
          endHour: 10,
          endMinute: 30,
          date: day,
        ),
      ];
      final friends = [
        _lesson(
          subject: 'Алгоритмы',
          startHour: 9,
          startMinute: 0,
          endHour: 10,
          endMinute: 30,
          date: day,
        ),
      ];

      final slots = buildComparisonSlots(mine, friends);

      expect(slots.single.isTogether, isFalse);
    });

    test('inserts a both-free window when a shared gap is long enough', () {
      final lessonA = _lesson(
        subject: 'A',
        startHour: 9,
        startMinute: 0,
        endHour: 10,
        endMinute: 30,
        date: day,
      );
      final lessonB = _lesson(
        subject: 'B',
        startHour: 12,
        startMinute: 40,
        endHour: 14,
        endMinute: 10,
        date: day,
      );

      final slots = buildComparisonSlots(
        [lessonA, lessonB],
        [lessonA, lessonB],
      );

      final free = slots.where((s) => s.bothFree).toList();
      expect(free, hasLength(1));
      expect(free.single.time, '10:30');
      expect(free.single.untilTime, '12:40');
    });

    test('does not insert a window shorter than the minimum gap', () {
      final lessonA = _lesson(
        subject: 'A',
        startHour: 9,
        startMinute: 0,
        endHour: 10,
        endMinute: 30,
        date: day,
      );
      final lessonB = _lesson(
        subject: 'B',
        startHour: 10,
        startMinute: 40,
        endHour: 12,
        endMinute: 10,
        date: day,
      );

      final slots = buildComparisonSlots(
        [lessonA, lessonB],
        [lessonA, lessonB],
      );

      expect(slots.any((s) => s.bothFree), isFalse);
    });

    test('marks an empty cell when only one person has a lesson', () {
      final mine = [
        _lesson(
          subject: 'Системы ИИ',
          startHour: 16,
          startMinute: 0,
          endHour: 17,
          endMinute: 30,
          date: day,
        ),
      ];

      final slots = buildComparisonSlots(mine, const []);

      expect(slots.single.mine, isNotNull);
      expect(slots.single.friend, isNull);
      expect(slots.single.isTogether, isFalse);
    });
  });

  test('busy ranges are clipped to the selected day without losing events', () {
    final ranges = comparisonBusyRangesForDay(
      day: day,
      schedule: [
        CalendarSchedulePart(
          title: 'Timed event',
          dates: [day],
          startsAt: day.add(const Duration(hours: 11)),
          endsAt: day.add(const Duration(hours: 12)),
        ),
        CalendarSchedulePart(
          title: 'Academic day marker',
          dates: [day],
          isAllDay: true,
          startsAt: day,
          endsAt: otherDay,
        ),
      ],
      activities: [
        UserActivity(
          id: 'overnight',
          type: UserActivityType.personal,
          title: 'Overnight',
          startsAt: day.subtract(const Duration(hours: 1)),
          endsAt: day.add(const Duration(minutes: 45)),
        ),
        UserActivity(
          id: 'no-end',
          type: UserActivityType.event,
          title: 'Activity',
          startsAt: day.add(const Duration(hours: 15)),
        ),
        UserActivity(
          id: 'other-day',
          type: UserActivityType.personal,
          title: 'Tomorrow',
          startsAt: otherDay.add(const Duration(hours: 9)),
        ),
      ],
    ).toList();
    expect(ranges, [(0, 45), (660, 720)]);
  });

  test(
    'mixed occupancy retains real overlapping intervals and every lesson type',
    () {
      final occupancy = comparisonOccupancyForDay(
        day: day,
        schedule: [
          part(
            'PE',
            540,
            600,
          ).copyWith(lessonType: LessonType.physicalEducation),
          part('Exam', 555, 630).copyWith(lessonType: LessonType.exam),
          CalendarSchedulePart(
            title: 'Event',
            dates: [day],
            startsAt: day.add(const Duration(minutes: 615)),
            endsAt: day.add(const Duration(minutes: 675)),
          ),
        ],
        activities: [
          UserActivity(
            id: 'personal',
            type: UserActivityType.personal,
            title: 'Personal',
            startsAt: day.add(const Duration(minutes: 660)),
            endsAt: day.add(const Duration(minutes: 720)),
          ),
        ],
      );
      expect(occupancy.ranges, [
        (540, 600),
        (555, 630),
        (660, 720),
        (615, 675),
      ]);
      expect(occupancy.isBusy(650, 665), isTrue);
      expect(occupancy.isFree(720, 750), isTrue);
    },
  );

  test('missing ends are uncertain, never fabricated one-hour intervals', () {
    final occupancy = comparisonOccupancyForDay(
      day: day,
      schedule: [
        CalendarSchedulePart(
          title: 'Start only',
          dates: [day],
          startsAt: day.add(const Duration(hours: 11)),
        ),
      ],
      activities: const [],
    );
    expect(occupancy.ranges, isEmpty);
    expect(occupancy.uncertainFrom, [660]);
    expect(occupancy.isFree(600, 660), isTrue);
    expect(occupancy.isBusy(660, 720), isFalse);
    expect(occupancy.isFree(780, 840), isFalse);
    final windows = buildComparisonSlots(
      [part('A', 540, 600), part('B', 780, 840)],
      const [],
      uncertainFrom: occupancy.uncertainFrom,
    ).where((slot) => slot.bothFree);
    expect(windows.map((slot) => (slot.minute, slot.freeUntil)), [(600, 660)]);
  });

  test(
    'untimed day markers do not assert an all-day busy or free interval',
    () {
      final occupancy = comparisonOccupancyForDay(
        day: day,
        schedule: [
          CalendarSchedulePart(title: 'All day', dates: [day], isAllDay: true),
          CalendarSchedulePart(title: 'Unknown time', dates: [day]),
        ],
        activities: const [],
      );
      expect(occupancy.ranges, isEmpty);
      expect(occupancy.uncertainFrom, [0]);
      expect(occupancy.isFree(540, 630), isFalse);
      expect(occupancy.isBusy(540, 630), isFalse);
    },
  );
}
