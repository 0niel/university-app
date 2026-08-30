import 'package:academic_calendar/academic_calendar.dart';
import 'package:schedule_repository/schedule_repository.dart';

DateTime dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

bool isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

DateTime weekStartFor(DateTime day) {
  final date = dateOnly(day);
  return date.subtract(Duration(days: date.weekday - DateTime.monday));
}

List<DateTime> weekDaysFor(DateTime day) {
  final start = weekStartFor(day);
  return List.generate(7, (index) => start.add(Duration(days: index)));
}

DateTime atTime(DateTime day, TimeOfDay time) {
  return DateTime(day.year, day.month, day.day, time.hour, time.minute);
}

int minutesOfDay(TimeOfDay time) => time.hour * 60 + time.minute;

int studyWeekNumber(DateTime day) => getWeek(day);
