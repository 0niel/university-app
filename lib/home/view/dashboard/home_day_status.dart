import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:rtu_mirea_app/home/view/dashboard/home_bell_time.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_day_status_kind.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_focus_state.dart';
import 'package:schedule_repository/schedule_repository.dart';

typedef HomeDayStatus = ({
  HomeDayStatusKind kind,
  int lessonCount,
  int minutes,
  DateTime? startsAt,
});

int homeCountdownMinutes(Duration duration) {
  final minutes = (duration.inSeconds / 60).ceil();
  return minutes < 0 ? 0 : minutes;
}

HomeDayStatus homeDayStatus({
  required DateTime day,
  required List<LessonSchedulePart> lessons,
  required DateTime now,
}) {
  final firstLesson = lessons.firstOrNull;
  if (firstLesson == null) {
    return (
      kind: HomeDayStatusKind.free,
      lessonCount: 0,
      minutes: 0,
      startsAt: null,
    );
  }
  final first = firstLesson.lessonBells.startTime.toDateTime(day);
  if (!DateUtils.isSameDay(day, now)) {
    return (
      kind: HomeDayStatusKind.scheduled,
      lessonCount: lessons.length,
      minutes: 0,
      startsAt: first,
    );
  }
  final focus = homeFocusState(day: day, lessons: lessons, now: now);
  final current = focus.current;
  if (current != null) {
    final end = current.lessonBells.endTime.toDateTime(day);
    return (
      kind: HomeDayStatusKind.live,
      lessonCount: lessons.length,
      minutes: homeCountdownMinutes(end.difference(now)),
      startsAt: current.lessonBells.startTime.toDateTime(day),
    );
  }
  final next = focus.focus;
  if (next == null) {
    return (
      kind: HomeDayStatusKind.done,
      lessonCount: lessons.length,
      minutes: 0,
      startsAt: first,
    );
  }
  final startsAt = next.lessonBells.startTime.toDateTime(day);
  return (
    kind: HomeDayStatusKind.upcoming,
    lessonCount: lessons.length,
    minutes: homeCountdownMinutes(startsAt.difference(now)),
    startsAt: startsAt,
  );
}
