import 'package:intl/intl.dart';

/// Maximum number of academic weeks in a semester.
const maxWeeksInSemester = 18;

/// Represents an academic period.
class Period {
  Period({
    required this.yearStart,
    required this.yearEnd,
    required this.semester,
  });

  final int yearStart;
  final int yearEnd;
  final int semester;
}

/// Returns the academic period for the specified [date].
///
/// If the month is >= 7, it is considered the first semester (September–January),
/// otherwise it is considered the second semester (February–June).
Period getPeriod(DateTime date) {
  if (date.month >= 7) {
    return Period(yearStart: date.year, yearEnd: date.year + 1, semester: 1);
  } else {
    return Period(yearStart: date.year - 1, yearEnd: date.year, semester: 2);
  }
}

/// Returns the start date of the semester for the specified [period].
///
/// - For semester 1: September 1 of [period.yearStart].
///   If that day is a Sunday, it is shifted to Monday.
///
/// - For semester 2: February 1 of [period.yearEnd] plus 8 days (which is February 9).
///   If that day is on a weekend, it is shifted to Monday.
DateTime getSemesterStartWithPeriod(Period period) {
  DateTime startDate;
  if (period.semester == 1) {
    startDate = DateTime(period.yearStart, 9);
  } else {
    startDate = DateTime(period.yearEnd, 2).add(const Duration(days: 8));
  }

  // Shift to Monday if the resulting date falls on Saturday or Sunday
  while (startDate.weekday == DateTime.saturday || startDate.weekday == DateTime.sunday) {
    startDate = startDate.add(const Duration(days: 1));
  }
  return startDate;
}

/// Returns the academic week number for the specified [date] (or current date
/// if null).
///
/// If [date] is before the semester start date, it returns 0 (or any marker you
///  choose).
/// The first day of the semester counts as week 1; the second week is week 2,
/// etc.
int getWeek([DateTime? date]) {
  final now = date ?? DateTime.now();
  final period = getPeriod(now);
  final startDate = getSemesterStartWithPeriod(period);

  // If the date is before the semester start, consider it week 0 (before
  //official start)
  if (now.isBefore(startDate)) {
    return 0;
  }

  // Calculate how many days have passed since the semester start
  final daysDiff = now.difference(startDate).inDays;
  // Integer division by 7, then add 1
  final week = daysDiff ~/ 7 + 1;

  return week;
}

/// Returns the exact [DateTime] corresponding to the specified [week] and [weekday]
/// in the given [period].
///
/// [weekday] follows Dart's standard: Monday = 1, Sunday = 7.
DateTime getDayByWeek(Period period, int weekday, int week) {
  final startDate = getSemesterStartWithPeriod(period);

  // Calculate how many days to add from the semester start date
  return startDate.add(
    Duration(days: 7 * (week - 1) + weekday - startDate.weekday),
  );
}

extension DateTimeExtension on DateTime {
  /// Calculates the number of weeks in [year] according to the ISO week date
  /// standard.
  /// See: https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int _numOfWeeks(int year) {
    final dec28 = DateTime(year, 12, 28);
    final dayOfDec28 = int.parse(DateFormat('D').format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Returns the ISO 8601 week number of this [DateTime].
  /// See: https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  int get weekOfYear {
    final dayOfYear = int.parse(DateFormat('D').format(this));
    var woy = ((dayOfYear - weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = _numOfWeeks(year - 1);
    } else if (woy > _numOfWeeks(year)) {
      woy = 1;
    }
    return woy;
  }
}
