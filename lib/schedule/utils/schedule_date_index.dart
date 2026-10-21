import 'package:schedule_repository/schedule_repository.dart';

class ScheduleDateIndex {
  factory ScheduleDateIndex(List<SchedulePart> schedule) {
    final parts = <int, List<SchedulePart>>{};
    final calendarEvents = <CalendarSchedulePart>[];
    for (final part in schedule) {
      if (part is CalendarSchedulePart) calendarEvents.add(part);
      for (final day in part.dates.map(_dayKey).toSet()) {
        (parts[day] ??= []).add(part);
      }
    }
    return ScheduleDateIndex._(
      schedule,
      {
        for (final entry in parts.entries)
          entry.key: List.unmodifiable(entry.value),
      },
      List.unmodifiable(calendarEvents),
    );
  }

  const ScheduleDateIndex._(this._source, this._parts, this.calendarEvents);

  final List<SchedulePart> _source;
  final Map<int, List<SchedulePart>> _parts;
  final List<CalendarSchedulePart> calendarEvents;

  bool matches(List<SchedulePart> schedule) {
    if (identical(schedule, _source)) return true;
    if (schedule.length != _source.length) return false;
    for (var index = 0; index < schedule.length; index++) {
      if (!identical(
        schedule.elementAtOrNull(index),
        _source.elementAtOrNull(index),
      )) {
        return false;
      }
    }
    return true;
  }

  List<SchedulePart> partsForDay(DateTime day) =>
      _parts[_dayKey(day)] ?? const [];

  static int _dayKey(DateTime date) =>
      date.year * 10000 + date.month * 100 + date.day;
}
