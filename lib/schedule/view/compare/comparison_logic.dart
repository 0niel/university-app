import 'package:collection/collection.dart';
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
  List<LessonSchedulePart> friends,
) {
  final starts = <int>{
    for (final lesson in mine) minutesOf(lesson.lessonBells.startTime),
    for (final lesson in friends) minutesOf(lesson.lessonBells.startTime),
  }.toList()..sort();

  LessonSchedulePart? at(List<LessonSchedulePart> lessons, int minute) {
    for (final lesson in lessons) {
      final start = minutesOf(lesson.lessonBells.startTime);
      final end = minutesOf(lesson.lessonBells.endTime);
      if (minute >= start && minute < end) return lesson;
    }
    return null;
  }

  final slots = <ComparisonSlot>[];
  for (var i = 0; i < starts.length; i++) {
    final minute = starts[i];
    final my = at(mine, minute);
    final friend = at(friends, minute);
    slots.add(ComparisonSlot(minute: minute, mine: my, friend: friend));

    final nextStart = starts.elementAtOrNull(i + 1);
    if (nextStart != null) {
      final myEnd = my != null ? minutesOf(my.lessonBells.endTime) : minute;
      final friendEnd = friend != null
          ? minutesOf(friend.lessonBells.endTime)
          : minute;
      final freeFrom = myEnd > friendEnd ? myEnd : friendEnd;
      if (nextStart - freeFrom >= kComparisonMinWindowMinutes &&
          at(mine, freeFrom) == null &&
          at(friends, freeFrom) == null) {
        slots.add(
          ComparisonSlot(
            minute: freeFrom,
            bothFree: true,
            freeUntil: nextStart,
          ),
        );
      }
    }
  }
  return slots;
}
