import 'package:rtu_mirea_app/schedule/view/compare/comparison_slot.dart';
import 'package:schedule_repository/schedule_repository.dart';

export 'comparison_slot.dart';

const kComparisonMinWindowMinutes = 30;

int minutesOf(TimeOfDay time) => time.hour * 60 + time.minute;

List<LessonSchedulePart> lessonsOnDay(
  List<SchedulePart> schedule,
  DateTime day,
) {
  return schedule.whereType<LessonSchedulePart>().where((part) {
    return part.dates.any(
      (date) =>
          date.year == day.year &&
          date.month == day.month &&
          date.day == day.day,
    );
  }).toList()..sort(
    (a, b) => minutesOf(
      a.lessonBells.startTime,
    ).compareTo(minutesOf(b.lessonBells.startTime)),
  );
}

List<ComparisonSlot> buildComparisonSlots(
  List<LessonSchedulePart> mine,
  List<LessonSchedulePart> friends, {
  Iterable<(int start, int end)> busyRanges = const [],
  Iterable<int> uncertainFrom = const [],
}) {
  final starts = <int>{
    for (final lesson in mine) minutesOf(lesson.lessonBells.startTime),
    for (final lesson in friends) minutesOf(lesson.lessonBells.startTime),
    for (final range in busyRanges) range.$1,
  }.toList()..sort();

  List<LessonSchedulePart> at(List<LessonSchedulePart> lessons, int minute) => [
    for (final lesson in lessons)
      if (minute >= minutesOf(lesson.lessonBells.startTime) &&
          minute < minutesOf(lesson.lessonBells.endTime))
        lesson,
  ];

  final slots = <ComparisonSlot>[];
  for (final minute in starts) {
    final activeMine = at(mine, minute);
    final activeFriends = at(friends, minute);
    slots.add(
      ComparisonSlot(
        minute: minute,
        mine: activeMine.firstOrNull,
        friend: activeFriends.firstOrNull,
        mineLessons: activeMine,
        friendLessons: activeFriends,
        freeUntil:
            [
              for (final lesson in [...activeMine, ...activeFriends])
                minutesOf(lesson.lessonBells.endTime),
              for (final range in busyRanges)
                if (minute >= range.$1 && minute < range.$2) range.$2,
            ].fold<int?>(
              null,
              (value, end) => value == null || end < value ? end : value,
            ),
      ),
    );
  }
  final intervals =
      <(int, int)>[
          for (final lesson in [...mine, ...friends])
            (
              minutesOf(lesson.lessonBells.startTime),
              minutesOf(lesson.lessonBells.endTime),
            ),
          ...busyRanges,
        ].where((range) => range.$2 > range.$1).toList()
        ..sort((a, b) => a.$1.compareTo(b.$1));
  int? occupiedUntil;
  for (final (start, end) in intervals) {
    final previousEnd = occupiedUntil;
    if (previousEnd != null) {
      final knownUntil = uncertainFrom.fold<int>(
        start,
        (value, minute) => minute < value ? minute : value,
      );
      if (knownUntil - previousEnd >= kComparisonMinWindowMinutes) {
        slots.add(
          ComparisonSlot(
            minute: previousEnd,
            bothFree: true,
            freeUntil: knownUntil,
          ),
        );
      }
    }
    if (previousEnd == null || end > previousEnd) occupiedUntil = end;
  }
  return slots..sort((a, b) => a.minute.compareTo(b.minute));
}

Iterable<(int start, int end)> comparisonBusyRangesForDay({
  required DateTime day,
  required Iterable<SchedulePart> schedule,
  required Iterable<UserActivity> activities,
}) => comparisonOccupancyForDay(
  day: day,
  schedule: schedule,
  activities: activities,
  includeLessons: false,
).ranges;

class ComparisonDayOccupancy {
  const ComparisonDayOccupancy({
    required this.ranges,
    required this.uncertainFrom,
  });

  final List<(int start, int end)> ranges;
  final List<int> uncertainFrom;

  bool get hasEntries => ranges.isNotEmpty || uncertainFrom.isNotEmpty;

  bool isBusy(int start, int end) =>
      ranges.any((range) => range.$1 < end && range.$2 > start);

  bool isUncertain(int start, int end) =>
      uncertainFrom.any((minute) => minute < end);

  bool isFree(int start, int end) =>
      !isBusy(start, end) && !isUncertain(start, end);
}

ComparisonDayOccupancy comparisonOccupancyForDay({
  required DateTime day,
  required Iterable<SchedulePart> schedule,
  required Iterable<UserActivity> activities,
  bool includeLessons = true,
}) {
  final startOfDay = DateTime(day.year, day.month, day.day);
  bool sameDay(DateTime date) =>
      date.year == day.year && date.month == day.month && date.day == day.day;
  final ranges = <(int, int)>[];
  final uncertain = <int>{};
  void add(DateTime start, DateTime? end) {
    if (end == null || !end.isAfter(start)) {
      if (sameDay(start)) {
        uncertain.add(start.difference(startOfDay).inMinutes.clamp(0, 1440));
      }
      return;
    }
    final from = start.difference(startOfDay).inMinutes.clamp(0, 1440);
    final until = end.difference(startOfDay).inMinutes.clamp(0, 1440);
    if (until > from) ranges.add((from, until));
  }

  if (includeLessons) {
    for (final lesson in schedule.whereType<LessonSchedulePart>()) {
      if (lesson.dates.any(sameDay)) {
        ranges.add((
          minutesOf(lesson.lessonBells.startTime),
          minutesOf(lesson.lessonBells.endTime),
        ));
      }
    }
  }
  for (final activity in activities) {
    add(activity.startsAt, activity.endsAt);
  }
  for (final event in schedule.whereType<CalendarSchedulePart>()) {
    if (event.isAllDay || event.startsAt == null) {
      if (event.dates.any(sameDay)) uncertain.add(0);
    } else {
      add(event.startsAt!, event.endsAt);
    }
  }
  return ComparisonDayOccupancy(
    ranges: ranges,
    uncertainFrom: uncertain.toList()..sort(),
  );
}
