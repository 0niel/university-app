import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:schedule_repository/schedule_repository.dart';

List<(String, Color)> scheduleDayMarks(
  BuildContext context, {
  required List<SchedulePart> schedule,
  required DateTime day,
  required DateTime now,
  required SchedulePreferencesState preferences,
  required ScheduleDisplayState display,
  required List<ScheduleChange> changes,
}) => [
  for (final lesson in visibleLessonsForDay(
    schedule: schedule,
    day: day,
    now: now,
    preferences: preferences,
    display: display,
    changes: changes,
  ))
    (
      '${lessonTypeName(context.l10n, lesson.lessonType)} · ${lesson.subject}',
      lessonAccentOf(context, lesson),
    ),
];
