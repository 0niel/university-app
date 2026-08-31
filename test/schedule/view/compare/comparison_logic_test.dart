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
}
