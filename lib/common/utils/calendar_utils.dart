import 'package:clock/clock.dart';

abstract class CalendarUtils {
  static const int kMaxWeekInSemester = 17;

  static List<DateTime> getDaysInWeek(int week, [DateTime? mCurrentDate]) {
    final daysInWeek = <DateTime>[];

    final semesterStart = getSemesterStart(mCurrentDate: mCurrentDate);

    final firstDayOfWeek = semesterStart.subtract(
      Duration(days: semesterStart.weekday - 1),
    );

    var firstDayOfChosenWeek = firstDayOfWeek.add(
      Duration(days: (week - 1) * 7),
    );

    for (var i = 0; i < 7; ++i) {
      daysInWeek.add(firstDayOfChosenWeek);
      firstDayOfChosenWeek = firstDayOfChosenWeek.add(const Duration(days: 1));
    }
    return daysInWeek;
  }

  static DateTime getSemesterStart({
    DateTime? mCurrentDate,
    Clock clock = const Clock(),
  }) {
    return _CurrentSemesterStart.getCurrentSemesterStart(
      mCurrentDate: mCurrentDate,
      clock: clock,
    );
  }
}

abstract class _CurrentSemesterStart {
  static DateTime _getFirstMondayOfMonth(int year, int month) {
    final firstOfMonth = DateTime(year, month);
    final firstMonday = firstOfMonth.add(
      Duration(days: (7 - (firstOfMonth.weekday - DateTime.monday)) % 7),
    );
    return firstMonday;
  }

  static DateTime _getCorrectedDate(DateTime date) {
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return _getFirstMondayOfMonth(date.year, date.month);
    }
    return date;
  }

  static DateTime _getExpectedSemesterStart(DateTime currentDate) {
    if (currentDate.month >= DateTime.september ||
        (currentDate.month == DateTime.august && currentDate.day >= 25)) {
      return DateTime(currentDate.year, DateTime.september);
    }
    return DateTime(currentDate.year, DateTime.february, 9);
  }

  static DateTime getCurrentSemesterStart({
    DateTime? mCurrentDate,
    Clock clock = const Clock(),
  }) {
    final currentDate = mCurrentDate ?? clock.now();
    final expectedStart = _getExpectedSemesterStart(currentDate);
    return _getCorrectedDate(expectedStart);
  }
}
