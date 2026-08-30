import 'package:academic_calendar/src/period.dart';

export 'date_time_extension.dart';
export 'period.dart';

const kMaxWeeksInSemester = 18;

Period getPeriod(DateTime date) => date.month >= 7
    ? .new(yearStart: date.year, yearEnd: date.year + 1, semester: 1)
    : .new(yearStart: date.year - 1, yearEnd: date.year, semester: 2);

DateTime getSemesterStartWithPeriod(Period period) {
  final startDate = switch (period.semester) {
    1 => DateTime(period.yearStart, 9),
    2 => DateTime(period.yearEnd, 2, 9),
    _ => throw ArgumentError.value(period.semester, 'period.semester'),
  };
  if (startDate.weekday == DateTime.saturday ||
      startDate.weekday == DateTime.sunday) {
    return startDate.add(
      Duration(days: DateTime.monday - startDate.weekday + 7),
    );
  }
  return startDate;
}

int getWeek([DateTime? date]) {
  final now = date ?? DateTime.now();
  final period = getPeriod(now);
  final startDate = getSemesterStartWithPeriod(period);

  if (now.isBefore(startDate)) {
    return 0;
  }

  final startMonday = _mondayOf(startDate);
  final nowMonday = _mondayOf(now);
  return nowMonday.difference(startMonday).inDays ~/ 7 + 1;
}

DateTime _mondayOf(DateTime date) {
  final dateOnly = DateTime(date.year, date.month, date.day);
  return dateOnly.subtract(Duration(days: dateOnly.weekday - DateTime.monday));
}

DateTime getDayByWeek(Period period, int weekday, int week) {
  if (weekday < DateTime.monday || weekday > DateTime.sunday) {
    throw RangeError.range(weekday, DateTime.monday, DateTime.sunday);
  }
  if (week < 1 || week > kMaxWeeksInSemester) {
    throw RangeError.range(week, 1, kMaxWeeksInSemester);
  }
  final startDate = getSemesterStartWithPeriod(period);

  return startDate.add(
    Duration(days: 7 * (week - 1) + weekday - startDate.weekday),
  );
}
