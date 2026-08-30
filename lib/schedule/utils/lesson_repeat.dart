import 'package:academic_calendar/academic_calendar.dart';
import 'package:collection/collection.dart';

enum LessonRepeat {
  everyWeek,

  evenWeek,

  oddWeek,

  custom,
}

List<DateTime> expandRepeat({
  required int weekday,
  required LessonRepeat repeat,
  DateTime? reference,
}) {
  if (repeat == .custom) return const [];

  final period = getPeriod(reference ?? DateTime.now());
  final dates = <DateTime>[];
  for (var week = 1; week <= kMaxWeeksInSemester; week++) {
    final matches = switch (repeat) {
      .everyWeek => true,
      .evenWeek => week.isEven,
      .oddWeek => week.isOdd,
      .custom => false,
    };
    if (matches) {
      final day = getDayByWeek(period, weekday, week);
      dates.add(DateTime(day.year, day.month, day.day));
    }
  }
  return dates;
}

LessonRepeat inferRepeat(List<DateTime> dates, int weekday) {
  final reference = dates.firstOrNull;
  if (reference == null) return .custom;
  for (final repeat in const [
    LessonRepeat.everyWeek,
    LessonRepeat.evenWeek,
    LessonRepeat.oddWeek,
  ]) {
    final expanded = expandRepeat(
      weekday: weekday,
      repeat: repeat,
      reference: reference,
    );
    if (_sameDateSet(expanded, dates)) return repeat;
  }
  return .custom;
}

int clampWeekday(int weekday) =>
    weekday >= DateTime.monday && weekday <= DateTime.saturday
    ? weekday
    : DateTime.monday;

bool _sameDateSet(List<DateTime> a, List<DateTime> b) {
  if (a.length != b.length) return false;
  String key(DateTime d) => '${d.year}-${d.month}-${d.day}';
  final setA = a.map(key).toSet();
  return b.every((d) => setA.contains(key(d)));
}
