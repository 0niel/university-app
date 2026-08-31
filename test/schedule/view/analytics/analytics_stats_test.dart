import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/view/analytics/analytics_stats.dart';
import 'package:schedule_repository/schedule_repository.dart';

LessonSchedulePart _lesson({
  required int startHour,
  required int startMinute,
  required int endHour,
  required int endMinute,
  required List<DateTime> dates,
  LessonType type = LessonType.lecture,
}) {
  return LessonSchedulePart(
    subject: 'S',
    lessonType: type,
    teachers: const [],
    classrooms: const [],
    lessonBells: LessonBells(
      startTime: TimeOfDay(hour: startHour, minute: startMinute),
      endTime: TimeOfDay(hour: endHour, minute: endMinute),
    ),
    dates: dates,
  );
}

void main() {
  // All three lessons fall on Mondays so the weekly aggregation is predictable.
  final monday = DateTime(2026, 5, 18);

  group('AnalyticsStats.fromLessons', () {
    test('empty schedule yields zeroed analytics', () {
      final stats = AnalyticsStats.fromLessons(const []);
      expect(stats.hoursPerWeek, 0);
      expect(stats.windowsPerWeek, 0);
      expect(stats.typeShares, isEmpty);
    });

    test('sums weekly hours per weekday', () {
      final stats = AnalyticsStats.fromLessons([
        _lesson(
          startHour: 9,
          startMinute: 0,
          endHour: 10,
          endMinute: 30,
          dates: [monday],
        ),
        _lesson(
          startHour: 10,
          startMinute: 40,
          endHour: 12,
          endMinute: 10,
          dates: [monday],
        ),
      ]);
      // 1.5 h + 1.5 h on Monday.
      expect(stats.hoursByWeekday[DateTime.monday], closeTo(3.0, 1e-9));
      expect(stats.hoursPerWeek, closeTo(3.0, 1e-9));
    });

    test('counts a free window when the gap is >= 30 minutes', () {
      final stats = AnalyticsStats.fromLessons([
        _lesson(
          startHour: 9,
          startMinute: 0,
          endHour: 10,
          endMinute: 30,
          dates: [monday],
        ),
        // 90-minute gap, then a lesson.
        _lesson(
          startHour: 12,
          startMinute: 0,
          endHour: 13,
          endMinute: 30,
          dates: [monday],
        ),
      ]);
      expect(stats.windowsPerWeek, 1);
      expect(stats.gapHoursPerWeek, closeTo(1.5, 1e-9));
    });

    test('a short break (< 30 min) is not a window', () {
      final stats = AnalyticsStats.fromLessons([
        _lesson(
          startHour: 9,
          startMinute: 0,
          endHour: 10,
          endMinute: 30,
          dates: [monday],
        ),
        _lesson(
          startHour: 10,
          startMinute: 40,
          endHour: 12,
          endMinute: 10,
          dates: [monday],
        ),
      ]);
      expect(stats.windowsPerWeek, 0);
    });

    test('type shares are fractions that sum to one, most frequent first', () {
      final stats = AnalyticsStats.fromLessons([
        _lesson(
          startHour: 9,
          startMinute: 0,
          endHour: 10,
          endMinute: 30,
          dates: [monday],
        ),
        _lesson(
          startHour: 11,
          startMinute: 0,
          endHour: 12,
          endMinute: 30,
          dates: [monday],
        ),
        _lesson(
          startHour: 13,
          startMinute: 0,
          endHour: 14,
          endMinute: 30,
          dates: [monday],
          type: LessonType.practice,
        ),
      ]);
      expect(stats.typeShares.first.$1, LessonType.lecture);
      expect(stats.typeShares.first.$2, closeTo(2 / 3, 1e-9));
      final total = stats.typeShares.fold<double>(0, (s, t) => s + t.$2);
      expect(total, closeTo(1.0, 1e-9));
    });
  });
}
