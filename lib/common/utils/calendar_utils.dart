import 'package:clock/clock.dart';
import 'package:intl/intl.dart';

abstract class CalendarUtils {
  /// Maximum number of academic weeks per semester
  static const int kMaxWeekInSemester = 17;

  /// Returns the current day of the week, where 1 is Mon, 7 is Sun
  static int getCurrentDayOfWeek({final Clock clock = const Clock()}) {
    return clock.now().weekday;
  }

  /// Returns the number of the current week using the current date
  static int getCurrentWeek({DateTime? mCurrentDate, final Clock clock = const Clock()}) {
    DateTime currentDate = mCurrentDate ?? clock.now();
    DateTime startDate = getSemesterStart(mCurrentDate: currentDate);

    // If the semester has not begun, return the beginning
    if (currentDate.isBefore(startDate)) {
      return 1;
    }

    int week = _weekNumber(currentDate) - _weekNumber(startDate);

    if (currentDate.weekday != 0) {
      week++;
    }

    return week;
  }

  /// Returns the list of dates by [week] number
  static List<DateTime> getDaysInWeek(int week, [DateTime? mCurrentDate]) {
    List<DateTime> daysInWeek = [];

    DateTime semStart = getSemesterStart(mCurrentDate: mCurrentDate);

    // Понедельник недели начала семестра
    var firstDayOfWeek = semStart.subtract(Duration(days: semStart.weekday - 1));

    // Прибавляем сколько дней прошло с начала семестра
    var firstDayOfChosenWeek = firstDayOfWeek.add(Duration(days: (week - 1) * 7));

    // Добавляем дни в массив, увеличивая счётчик на 1 день
    for (int i = 0; i < 7; ++i) {
      daysInWeek.add(firstDayOfChosenWeek);
      firstDayOfChosenWeek = firstDayOfChosenWeek.add(const Duration(days: 1));
    }
    return daysInWeek;
  }

  /// Get the start date of the semester
  ///
  /// [mCurrentDate] is the date for which
  /// the beginning of the semester will be calculated.
  static DateTime getSemesterStart({DateTime? mCurrentDate, final Clock clock = const Clock()}) {
    return _CurrentSemesterStart.getCurrentSemesterStart(mCurrentDate: mCurrentDate, clock: clock);
  }

  /// Get the last date of the semester
  static DateTime getSemesterLastDay({DateTime? mCurrentDate, final Clock clock = const Clock()}) {
    return getDaysInWeek(
        kMaxWeekInSemester,
        _CurrentSemesterStart.getCurrentSemesterStart(
          mCurrentDate: mCurrentDate,
          clock: clock,
        )).last;
  }

  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  static int _numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  static int _weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = _numOfWeeks(date.year - 1);
    } else if (woy > _numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }
}

/// Get the date when the semester begins
abstract class _CurrentSemesterStart {
  /// Get the first Monday of the month from which the current semester begins
  static DateTime _getFirstMondayOfMonth(int year, int month) {
    var firstOfMonth = DateTime(year, month, 1);
    var firstMonday = firstOfMonth.add(Duration(days: (7 - (firstOfMonth.weekday - DateTime.monday)) % 7));
    return firstMonday;
  }

  /// Adjust the start date of the semester
  /// If the selected day is a day off, take the first Monday of the month,
  /// Otherwise the selected day is chosen correctly already
  static DateTime _getCorrectedDate(DateTime date) {
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return _getFirstMondayOfMonth(date.year, date.month);
    } else {
      return date;
    }
  }

  /// Get the expected start date of the semester.
  /// For the first semester it is September 1
  /// For the second semester it is February 9th
  static DateTime _getExpectedSemesterStart(DateTime currentDate) {
    if (currentDate.month >= DateTime.september || (currentDate.month == DateTime.august && currentDate.day >= 25)) {
      return DateTime(currentDate.year, DateTime.september, 1);
    } else {
      return DateTime(currentDate.year, DateTime.february, 9);
    }
  }

  /// Get the start date of the current semester
  static DateTime getCurrentSemesterStart({DateTime? mCurrentDate, final Clock clock = const Clock()}) {
    DateTime currentDate = mCurrentDate ?? clock.now();
    // Expected start date of the semester
    DateTime expectedStart = _getExpectedSemesterStart(currentDate);
    // Adjust in case it falls on a day off
    return _getCorrectedDate(expectedStart);
  }
}
