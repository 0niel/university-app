import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ScheduleShareEvent {
  const ScheduleShareEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.label,
    this.start,
    this.end,
    this.location,
    this.description,
    this.allDay = false,
    this.personal = false,
  });

  final String id;
  final String title;
  final DateTime date;
  final String label;
  final DateTime? start;
  final DateTime? end;
  final String? location;
  final String? description;
  final bool allDay;
  final bool personal;

  bool get canExportCalendar => allDay || start != null;
  bool get hasCompleteTime =>
      allDay || (start != null && end != null && end!.isAfter(start!));

  CalendarSchedulePart toCalendarPart() => CalendarSchedulePart(
    uid: id,
    title: title,
    dates: [date],
    startsAt: start,
    endsAt: end,
    isAllDay: allDay,
    location: location,
    description: [
      label,
      if (description?.isNotEmpty ?? false) description!,
    ].join('\n'),
  );
}

List<ScheduleShareEvent> scheduleShareEvents({
  required AppLocalizations l10n,
  required Iterable<SchedulePart> schedule,
  required Iterable<UserActivity> activities,
  required DateTime first,
  required DateTime last,
  required bool showPast,
  required DateTime now,
}) {
  bool overlaps(DateTime start, DateTime? end) =>
      start.isBefore(last) &&
      (end ?? start.add(const Duration(hours: 1))).isAfter(first) &&
      (showPast || (end ?? start.add(const Duration(hours: 1))).isAfter(now));
  final events = <String, ScheduleShareEvent>{};
  void add(ScheduleShareEvent event) {
    if (event.title.trim().isNotEmpty) {
      events['${event.id}:${event.date.toIso8601String()}:${event.start}'] =
          event;
    }
  }

  for (final event in schedule.whereType<CalendarSchedulePart>()) {
    final id = 'calendar:${event.uid ?? '${event.title}:${event.location}'}';
    if (!event.isAllDay && event.startsAt != null) {
      if (overlaps(event.startsAt!, event.endsAt)) {
        add(
          ScheduleShareEvent(
            id: id,
            title: event.title,
            date: dateOnly(event.startsAt!),
            label: l10n.activityTypeEvent,
            start: event.startsAt,
            end: event.endsAt,
            location: event.location,
            description: event.description,
          ),
        );
      }
    } else {
      for (final date in event.dates.map(dateOnly).toSet()) {
        if (!date.isBefore(first) && date.isBefore(last)) {
          add(
            ScheduleShareEvent(
              id: id,
              title: event.title,
              date: date,
              label: l10n.activityTypeEvent,
              allDay: event.isAllDay,
              location: event.location,
              description: event.description,
            ),
          );
        }
      }
    }
  }
  for (final holiday in schedule.whereType<HolidaySchedulePart>()) {
    for (final date in holiday.dates.map(dateOnly).toSet()) {
      if (!date.isBefore(first) && date.isBefore(last)) {
        add(
          ScheduleShareEvent(
            id: 'holiday:${holiday.title}',
            title: holiday.title,
            date: date,
            label: l10n.legendHoliday,
            allDay: true,
          ),
        );
      }
    }
  }
  for (final activity in activities) {
    if (overlaps(activity.startsAt, activity.endsAt)) {
      add(
        ScheduleShareEvent(
          id: 'activity:${activity.id}',
          title: activity.title,
          date: dateOnly(activity.startsAt),
          label: activityTypeLabel(l10n, activity.type),
          start: activity.startsAt,
          end: activity.endsAt,
          location: activity.place,
          description: activity.subtitle,
          personal: true,
        ),
      );
    }
  }
  return events.values.toList()
    ..sort((a, b) => (a.start ?? a.date).compareTo(b.start ?? b.date));
}
