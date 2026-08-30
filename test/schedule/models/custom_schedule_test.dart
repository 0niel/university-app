import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/utils/lesson_repeat.dart';
import 'package:schedule_repository/schedule_repository.dart';

class CustomScheduleTestFixture {
  static LessonSchedulePart lesson(List<DateTime> dates) => .new(
    subject: 'Algorithms',
    lessonType: .lecture,
    teachers: const [],
    classrooms: const [],
    lessonBells: LessonBells(
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 10, minute: 30),
      number: 1,
    ),
    dates: dates,
  );
}

void main() {
  test('weekly recurrence expands for a new semester after round-trip', () {
    const recurrence = CustomLessonRecurrence.weekly(
      weekday: DateTime.monday,
    );
    final restored = CustomLessonRecurrence.fromJson(recurrence.toJson());
    final spring = restored.expand(DateTime(2026, 2));
    final autumn = restored.expand(DateTime(2026, 9));

    expect(spring, isNotEmpty);
    expect(autumn, isNotEmpty);
    expect(spring.first.month, isNot(autumn.first.month));
    expect(spring.every((date) => date.weekday == DateTime.monday), isTrue);
    expect(autumn.every((date) => date.weekday == DateTime.monday), isTrue);
  });

  test('compact recurrence is smaller than expanded semester dates', () {
    final dates = expandRepeat(
      weekday: DateTime.monday,
      repeat: .everyWeek,
      reference: DateTime(2026, 2),
    );
    final legacy = CustomScheduleTestFixture.lesson(dates);
    final compact = CustomLesson.fromSchedulePart(legacy, id: 'lesson-1');

    expect(
      utf8.encode(jsonEncode(compact.toJson())).length,
      lessThan(utf8.encode(jsonEncode(legacy.toJson())).length),
    );
    expect(compact.recurrence, isA<CustomLessonWeeklyRecurrence>());
  });
}
