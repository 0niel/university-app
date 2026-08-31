import 'package:schedule_repository/schedule_repository.dart';

const kAnalyticsWindowMinutes = 30;

class AnalyticsStats {
  const AnalyticsStats({
    required this.hoursByWeekday,
    required this.typeShares,
    required this.hoursPerWeek,
    required this.avgPerDay,
    required this.windowsPerWeek,
    required this.gapHoursPerWeek,
  });

  factory AnalyticsStats.fromLessons(List<LessonSchedulePart> lessons) {
    final minutesByWeekday = <int, int>{};
    final weeksByWeekday = <int, Set<int>>{};
    final countByType = <LessonType, int>{};
    final slotsByWeekday = <int, Set<(int, int)>>{};
    var totalOccurrences = 0;

    int startOf(LessonSchedulePart l) =>
        l.lessonBells.startTime.hour * 60 + l.lessonBells.startTime.minute;
    int endOf(LessonSchedulePart l) =>
        l.lessonBells.endTime.hour * 60 + l.lessonBells.endTime.minute;

    for (final lesson in lessons) {
      final duration = endOf(lesson) - startOf(lesson);
      for (final date in lesson.dates) {
        totalOccurrences += 1;
        minutesByWeekday[date.weekday] =
            (minutesByWeekday[date.weekday] ?? 0) + duration;
        (weeksByWeekday[date.weekday] ??= {}).add(
          date.difference(DateTime(date.year)).inDays ~/ 7,
        );
        (slotsByWeekday[date.weekday] ??= {}).add((
          startOf(lesson),
          endOf(lesson),
        ));
        countByType[lesson.lessonType] =
            (countByType[lesson.lessonType] ?? 0) + 1;
      }
    }

    final hoursByWeekday = <int, double>{};
    for (final entry in minutesByWeekday.entries) {
      final weeks = weeksByWeekday[entry.key]?.length ?? 1;
      hoursByWeekday[entry.key] = entry.value / 60 / weeks;
    }

    final hoursPerWeek = hoursByWeekday.values.fold<double>(
      0,
      (sum, hours) => sum + hours,
    );
    final activeDays = hoursByWeekday.values.where((h) => h > 0).length;
    final totalWeeks = weeksByWeekday.values
        .expand((weeks) => weeks)
        .toSet()
        .length;
    final avgPerDay = activeDays == 0 || totalWeeks == 0
        ? 0.0
        : totalOccurrences / totalWeeks / activeDays;

    final typeShares = <(LessonType, double)>[
      for (final entry in countByType.entries)
        (entry.key, entry.value / totalOccurrences),
    ]..sort((a, b) => b.$2.compareTo(a.$2));

    var windows = 0;
    var gapMinutes = 0;
    for (final slots in slotsByWeekday.values) {
      final sorted = slots.toList()..sort((a, b) => a.$1.compareTo(b.$1));
      for (var i = 0; i < sorted.length - 1; i++) {
        final current = sorted.elementAtOrNull(i);
        final next = sorted.elementAtOrNull(i + 1);
        if (current == null || next == null) continue;
        final gap = next.$1 - current.$2;
        if (gap >= kAnalyticsWindowMinutes) {
          windows += 1;
          gapMinutes += gap;
        }
      }
    }

    return AnalyticsStats(
      hoursByWeekday: hoursByWeekday,
      typeShares: typeShares,
      hoursPerWeek: hoursPerWeek,
      avgPerDay: avgPerDay,
      windowsPerWeek: windows,
      gapHoursPerWeek: gapMinutes / 60,
    );
  }

  final Map<int, double> hoursByWeekday;

  final List<(LessonType, double)> typeShares;

  final double hoursPerWeek;

  final double avgPerDay;

  final int windowsPerWeek;

  final double gapHoursPerWeek;
}
