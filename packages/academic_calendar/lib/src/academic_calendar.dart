import 'package:intl/intl.dart';

const maxWeeksInSemester = 18;

class Period {
  Period({
    required this.yearStart,
    required this.yearEnd,
    required this.semester,
  });
  int yearStart;
  int yearEnd;
  int semester;
}

Period getPeriod(DateTime date) {
  if (date.month >= 7) {
    return Period(yearStart: date.year, yearEnd: date.year + 1, semester: 1);
  } else {
    return Period(yearStart: date.year - 1, yearEnd: date.year, semester: 2);
  }
}

/// Returns the academic week number for the given date. if date is null, the
/// current date is used.
int getWeek([DateTime? date]) {
  final now = date ?? DateTime.now();
  final startDate = getSemesterStart(now);

  if (now.millisecondsSinceEpoch < startDate.millisecondsSinceEpoch) {
    return 1;
  }

  var week = now.weekOfYear - startDate.weekOfYear;

  week += 1;

  return week;
}

DateTime getDayByWeek(Period period, int weekday, int week) {
  final startDate = getSemesterStart(
    DateTime(period.yearStart, period.semester == 1 ? 9 : 2),
  );

  if (week == 1) {
    return startDate.add(Duration(days: weekday - startDate.weekday));
  }

  return startDate.add(
    Duration(
      days: 7 * (week - 1) + weekday - startDate.weekday,
    ),
  );
}

DateTime getSemesterStart(DateTime date) {
  if (date.month >= 9) {
    var startDate = DateTime(date.year, 9);
    if (startDate.weekday == DateTime.sunday) {
      startDate = startDate.add(const Duration(days: 1));
    }
    return startDate;
  }

  var startDate = DateTime(date.year, 2);
  startDate = startDate.add(const Duration(days: 8));

  if (startDate.weekday == DateTime.sunday) {
    startDate = startDate.add(const Duration(days: 1));
  }

  return startDate;
}

extension DateTimeExtension on DateTime {
  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int _numOfWeeks(int year) {
    final dec28 = DateTime(year, 12, 28);
    final dayOfDec28 = int.parse(DateFormat('D').format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
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
