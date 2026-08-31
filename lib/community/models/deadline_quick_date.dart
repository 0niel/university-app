import 'package:rtu_mirea_app/config/config.dart';

enum DeadlineQuickDate { today, tomorrow, week, session }

DateTime resolveDeadlineQuickDate(
  DeadlineQuickDate quickDate, {
  required DateTime now,
  required UniversityConfig universityConfig,
}) {
  return switch (quickDate) {
    .today => _endOfDay(now),
    .tomorrow => _endOfDay(now.add(const Duration(days: 1))),
    .week => _endOfDay(now.add(const Duration(days: 7))),
    .session => _nextSessionStart(now, universityConfig),
  };
}

DateTime _endOfDay(DateTime day) => .new(day.year, day.month, day.day, 23, 59);

DateTime _nextSessionStart(DateTime now, UniversityConfig config) {
  final candidates = [
    for (final year in [now.year, now.year + 1]) ...[
      DateTime(
        year,
        config.winterSessionStartMonth,
        config.winterSessionStartDay,
        23,
        59,
      ),
      DateTime(
        year,
        config.summerSessionStartMonth,
        config.summerSessionStartDay,
        23,
        59,
      ),
    ],
  ]..sort();
  for (final candidate in candidates) {
    if (candidate.isAfter(now)) return candidate;
  }
  throw StateError('No future session start configured');
}
