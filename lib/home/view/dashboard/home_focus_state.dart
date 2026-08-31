import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:rtu_mirea_app/home/view/dashboard/home_bell_time.dart';
import 'package:schedule_repository/schedule_repository.dart';

typedef HomeFocusState = ({
  LessonSchedulePart? current,
  LessonSchedulePart? focus,
  List<LessonSchedulePart> following,
});

HomeFocusState homeFocusState({
  required DateTime day,
  required List<LessonSchedulePart> lessons,
  required DateTime now,
}) {
  final isToday = DateUtils.isSameDay(day, now);
  final current = isToday
      ? lessons.where((lesson) => lesson.isLive(now)).firstOrNull
      : null;
  final upcoming = isToday
      ? lessons.where((lesson) => lesson.startsAfter(now)).toList()
      : lessons;
  return (
    current: current,
    focus: current ?? upcoming.firstOrNull,
    following: (current == null ? upcoming.skip(1) : upcoming).toList(),
  );
}
