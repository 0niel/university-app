enum ScheduleView { day, week, month }

final scheduleAnchorMonday = DateTime.utc(2020, 1, 6);

int scheduleDayIndex(DateTime day) {
  return DateTime.utc(
    day.year,
    day.month,
    day.day,
  ).difference(scheduleAnchorMonday).inDays;
}

int scheduleWeekIndex(DateTime day) => (scheduleDayIndex(day) / 7).floor();

DateTime scheduleDayOfIndex(int index) {
  final utc = scheduleAnchorMonday.add(Duration(days: index));
  return DateTime(utc.year, utc.month, utc.day);
}

bool schedulePagerShouldJump(int from, int to, {int threshold = 7}) {
  return (to - from).abs() >= threshold;
}

class SchedulePaging {
  SchedulePaging({required DateTime today, this.weekRadius = 104})
    : firstWeekIndex = scheduleWeekIndex(today) - weekRadius;

  final int weekRadius;
  final int firstWeekIndex;

  int get weekPageCount => weekRadius * 2 + 1;

  int get dayPageCount => weekPageCount * 7;

  int get firstDayIndex => firstWeekIndex * 7;

  int dayPageOf(DateTime day) {
    return (scheduleDayIndex(day) - firstDayIndex).clamp(0, dayPageCount - 1);
  }

  DateTime dayOfPage(int page) {
    return scheduleDayOfIndex(
      firstDayIndex + page.clamp(0, dayPageCount - 1),
    );
  }

  int weekPageOfDayPage(int dayPage) {
    return (dayPage.clamp(0, dayPageCount - 1) ~/ 7).clamp(
      0,
      weekPageCount - 1,
    );
  }

  int weekPageOf(DateTime day) => weekPageOfDayPage(dayPageOf(day));

  int dayPageInWeek(int weekPage, int weekday) {
    final start = weekPage.clamp(0, weekPageCount - 1) * 7;
    return (start + (weekday - DateTime.monday)).clamp(0, dayPageCount - 1);
  }

  List<DateTime> daysOfWeekPage(int weekPage) {
    final start = weekPage.clamp(0, weekPageCount - 1) * 7;
    return [for (var index = 0; index < 7; index++) dayOfPage(start + index)];
  }
}

class ScheduleMonthPaging {
  ScheduleMonthPaging({required DateTime today, this.radius = defaultRadius})
    : firstMonthIndex = _monthIndex(today) - radius;

  final int radius;
  static const defaultRadius = 24;
  final int firstMonthIndex;

  int get pageCount => radius * 2 + 1;

  int pageOf(DateTime month) {
    return (_monthIndex(month) - firstMonthIndex).clamp(0, pageCount - 1);
  }

  DateTime monthOfPage(int page) {
    final index = firstMonthIndex + page.clamp(0, pageCount - 1);
    return DateTime(index ~/ 12, index % 12 + 1);
  }

  DateTime dayInPage(int page, int preferredDay) {
    final month = monthOfPage(page);
    final lastDay = DateTime(month.year, month.month + 1, 0).day;
    return DateTime(month.year, month.month, preferredDay.clamp(1, lastDay));
  }
}

int _monthIndex(DateTime date) => date.year * 12 + date.month - 1;
