import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/teacher_account/domain/teacher_workload.dart';
import 'package:schedule_repository/schedule_repository.dart';

LessonSchedulePart _lesson({
  required List<DateTime> dates,
  String subject = 'Mathematics',
  String? uid,
  int start = 540,
  int end = 630,
  int? number,
  List<String>? groups,
  List<Group>? groupEntities,
  List<Classroom> classrooms = const [Classroom(name: '101')],
}) => LessonSchedulePart(
  uid: uid,
  subject: subject,
  lessonType: .lecture,
  teachers: const [Teacher(name: 'Teacher', uid: 'teacher')],
  classrooms: classrooms,
  lessonBells: LessonBells(
    number: number,
    startTime: TimeOfDay(hour: start ~/ 60, minute: start % 60),
    endTime: TimeOfDay(hour: end ~/ 60, minute: end % 60),
  ),
  dates: dates,
  groups: groups,
  groupEntities: groupEntities,
);

void main() {
  final monday = DateTime(2026, 12, 28);
  final tuesday = monday.add(const Duration(days: 1));

  test('uses an actual calendar week across the year boundary', () {
    final workload = TeacherWorkload.fromSchedule(
      weekStart: DateTime(2027, 1, 2, 20),
      schedule: [
        _lesson(
          dates: [
            monday.subtract(const Duration(days: 1)),
            monday,
            DateTime(2027, 1, 3),
            DateTime(2027, 1, 4),
          ],
        ),
      ],
    );
    expect(workload.weekStart, monday);
    expect(workload.occurrences.map((entry) => entry.date), [
      monday,
      DateTime(2027, 1, 3),
    ]);
    expect(workload.totalDuration, const Duration(hours: 3));
    expect(workload.occurrencesForDay(DateTime(2027, 1, 3, 22)), hasLength(1));
  });

  test('deduplicates repeated dates and stream rows then merges groups', () {
    final workload = TeacherWorkload.fromSchedule(
      weekStart: monday,
      schedule: [
        _lesson(
          uid: 'stream',
          dates: [monday, monday],
          groups: ['A'],
        ),
        _lesson(
          uid: 'stream',
          dates: [monday],
          groupEntities: const [Group(name: 'A', uid: 'group-a')],
          groups: ['A', 'B'],
        ),
      ],
    );
    expect(workload.occurrences, hasLength(1));
    expect(workload.totalDuration, const Duration(minutes: 90));
    expect(workload.groups.map((group) => group.name), ['A', 'B']);
    expect(workload.groups.first.uid, 'group-a');
    expect(workload.occurrences.single.lesson.groups, ['A', 'B']);
    expect(workload.subjects, ['Mathematics']);
  });

  test('deduplicates equivalent sessions without ids across group rows', () {
    final workload = TeacherWorkload.fromSchedule(
      weekStart: monday,
      schedule: [
        _lesson(dates: [monday], groups: ['A']),
        _lesson(dates: [monday], groups: ['B']),
        _lesson(dates: [tuesday], groups: ['C']),
      ],
    );
    expect(workload.occurrences, hasLength(2));
    expect(workload.totalDuration, const Duration(hours: 3));
    expect(workload.groups.map((group) => group.name), ['A', 'B', 'C']);
  });

  test('keeps distinct slots and different same-name groups', () {
    final workload = TeacherWorkload.fromSchedule(
      weekStart: monday,
      schedule: [
        _lesson(
          uid: 'repeat',
          dates: [monday],
          groupEntities: const [Group(name: 'A', uid: 'group-a')],
        ),
        _lesson(
          uid: 'repeat',
          dates: [monday],
          start: 660,
          end: 750,
          groupEntities: const [Group(name: 'A', uid: 'group-b')],
        ),
      ],
    );
    expect(workload.occurrences, hasLength(2));
    expect(workload.groups.map((group) => group.uid), ['group-a', 'group-b']);
    expect(workload.totalDuration, const Duration(hours: 3));
  });

  test('finds windows after overlapping intervals without false gaps', () {
    final workload = TeacherWorkload.fromSchedule(
      weekStart: monday,
      schedule: [
        _lesson(uid: 'long', dates: [monday], end: 720),
        _lesson(uid: 'short', dates: [monday], start: 600),
        _lesson(uid: 'middle', dates: [monday], start: 690, end: 735),
        _lesson(uid: 'after', dates: [monday], start: 780, end: 870),
        _lesson(uid: 'next-day', dates: [tuesday]),
      ],
    );
    expect(workload.gaps, hasLength(1));
    expect(workload.gaps.single.start, DateTime(2026, 12, 28, 12, 15));
    expect(workload.gaps.single.duration, const Duration(minutes: 45));
  });

  test('bell breaks below thirty minutes are not teaching windows', () {
    final workload = TeacherWorkload.fromSchedule(
      weekStart: monday,
      schedule: [
        _lesson(dates: [monday]),
        _lesson(dates: [monday], start: 650, end: 740),
      ],
    );
    expect(workload.gaps, isEmpty);
  });

  test(
    'retains cancelled entries but excludes them from workload and next',
    () {
      final workload = TeacherWorkload.fromSchedule(
        weekStart: monday,
        schedule: [
          _lesson(
            dates: [monday],
            number: 1,
            groups: ['A'],
          ),
          _lesson(
            dates: [monday],
            start: 660,
            end: 750,
            number: 2,
            groups: ['B'],
            subject: 'Physics',
            classrooms: const [Classroom(name: '102')],
          ),
        ],
        changes: [
          ScheduleChange(
            id: 'cancel',
            kind: .cancel,
            subject: ' mathematics ',
            lessonDate: monday,
            lessonNumber: 1,
            createdAt: monday,
          ),
        ],
      );
      expect(workload.occurrences.first.isCancelled, isTrue);
      expect(workload.totalDuration, const Duration(minutes: 90));
      expect(workload.groups.map((group) => group.name), ['B']);
      expect(workload.subjects, ['Physics']);
      expect(workload.classrooms.map((room) => room.name), ['102']);
      expect(workload.currentAt(DateTime(2026, 12, 28, 9, 10)), isNull);
      expect(
        workload.nextAt(DateTime(2026, 12, 28, 8))?.lesson.subject,
        'Physics',
      );
    },
  );

  test('matches time-qualified cancellation to only its slot', () {
    final workload = TeacherWorkload.fromSchedule(
      weekStart: monday,
      schedule: [
        _lesson(dates: [monday]),
        _lesson(dates: [monday], start: 660, end: 750),
      ],
      changes: [
        ScheduleChange(
          id: 'cancel',
          kind: .cancel,
          subject: 'Mathematics',
          lessonDate: monday,
          oldValue: const ScheduleChangeSlot(start: '09:00'),
          createdAt: monday,
        ),
      ],
    );
    expect(workload.occurrences.map((entry) => entry.isCancelled), [
      true,
      false,
    ]);
  });

  test(
    'does not apply an ambiguous cancellation to every same-subject slot',
    () {
      final workload = TeacherWorkload.fromSchedule(
        weekStart: monday,
        schedule: [
          _lesson(dates: [monday]),
          _lesson(dates: [monday], start: 660, end: 750),
        ],
        changes: [
          ScheduleChange(
            id: 'unknown-slot',
            kind: .cancel,
            subject: 'Mathematics',
            lessonDate: monday,
            createdAt: monday,
          ),
        ],
      );
      expect(workload.occurrences.every((entry) => !entry.isCancelled), isTrue);
    },
  );

  test('current lesson ends exclusively and next spans following dates', () {
    final workload = TeacherWorkload.fromSchedule(
      weekStart: monday,
      schedule: [
        _lesson(dates: [monday]),
        _lesson(dates: [tuesday]),
      ],
    );
    expect(workload.currentAt(DateTime(2026, 12, 28, 9)), isNotNull);
    expect(workload.currentAt(DateTime(2026, 12, 28, 10, 30)), isNull);
    expect(workload.nextAt(DateTime(2026, 12, 28, 10, 30))?.date, tuesday);
    expect(workload.nextAt(DateTime(2027, 1, 4)), isNull);
  });

  test('empty data does not invent workload or subjects', () {
    final workload = TeacherWorkload.fromSchedule(
      weekStart: monday,
      schedule: const [],
    );
    expect(workload.totalDuration, Duration.zero);
    expect(workload.occurrences, isEmpty);
    expect(workload.groups, isEmpty);
    expect(workload.subjects, isEmpty);
    expect(workload.classrooms, isEmpty);
    expect(workload.gaps, isEmpty);
  });
}
