import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:schedule_repository/schedule_repository.dart';

class LessonDayStatus {
  const LessonDayStatus({
    required this.past,
    required this.live,
    required this.progress,
    required this.minutesLeft,
  });

  final bool past;
  final bool live;
  final double? progress;
  final int minutesLeft;
}

LessonDayStatus lessonDayStatus(
  LessonSchedulePart lesson,
  DateTime day,
  DateTime now,
) {
  final start = atTime(day, lesson.lessonBells.startTime);
  final end = atTime(day, lesson.lessonBells.endTime);
  if (now.isBefore(start)) {
    return LessonDayStatus(
      past: false,
      live: false,
      progress: null,
      minutesLeft: end.difference(now).inMinutes,
    );
  }
  if (!now.isBefore(end)) {
    return const LessonDayStatus(
      past: true,
      live: false,
      progress: null,
      minutesLeft: 0,
    );
  }
  final total = end.difference(start).inSeconds;
  final passed = now.difference(start).inSeconds;
  return LessonDayStatus(
    past: false,
    live: true,
    progress: total == 0 ? 1 : (passed / total).clamp(0, 1).toDouble(),
    minutesLeft: math.max(0, end.difference(now).inMinutes),
  );
}

List<LessonSchedulePart> lessonsForDay(
  List<SchedulePart> schedule,
  DateTime day,
) {
  return schedule
      .whereType<LessonSchedulePart>()
      .where((part) => part.dates.any((date) => isSameDate(date, day)))
      .sorted(
        (a, b) => minutesOfDay(
          a.lessonBells.startTime,
        ).compareTo(minutesOfDay(b.lessonBells.startTime)),
      );
}

bool lessonTypeVisible(SchedulePreferencesState preferences, LessonType type) {
  return switch (type) {
    .lecture => preferences.showLectures,
    .practice => preferences.showSeminars,
    .laboratoryWork => preferences.showLabs,
    .exam || .credit => preferences.showExams,
    .physicalEducation ||
    .consultation ||
    .individualWork ||
    .courseWork ||
    .courseProject ||
    .unknown => true,
  };
}

List<LessonSchedulePart> applyPreferences(
  List<LessonSchedulePart> lessons,
  SchedulePreferencesState preferences,
) {
  return lessons
      .where(
        (lesson) =>
            !preferences.hiddenSubjects.contains(lesson.subject) &&
            lessonTypeVisible(preferences, lesson.lessonType),
      )
      .toList();
}

List<LessonSchedulePart> visibleLessonsForDay({
  required List<SchedulePart> schedule,
  required DateTime day,
  required DateTime now,
  required SchedulePreferencesState preferences,
  required ScheduleDisplayState display,
  required List<ScheduleChange> changes,
}) => applyPreferences(lessonsForDay(schedule, day), preferences)
    .where(
      (lesson) =>
          (display.showCancelled ||
              !isCancelled(changeFor(changes, lesson, day))) &&
          (display.showPast || !lessonDayStatus(lesson, day, now).past),
    )
    .toList();

ScheduleChange? changeFor(
  List<ScheduleChange> changes,
  LessonSchedulePart lesson,
  DateTime day,
) {
  return changes.firstWhereOrNull(
    (change) =>
        change.kind != .add &&
        change.subject == lesson.subject &&
        isSameDate(change.lessonDate, day) &&
        (change.lessonNumber == null ||
            change.lessonNumber == lesson.lessonBells.number),
  );
}

bool isNewLesson(
  List<ScheduleChange> changes,
  LessonSchedulePart lesson,
  DateTime day,
) {
  return changes.any(
    (change) =>
        change.kind == .add &&
        change.subject == lesson.subject &&
        isSameDate(change.lessonDate, day),
  );
}

bool isCancelled(ScheduleChange? change) => change?.kind == .cancel;

bool isMoved(ScheduleChange? change) =>
    change?.kind == .room || change?.kind == .move;

List<ScheduleChange> changesInWeek(List<ScheduleChange> changes, DateTime day) {
  final start = weekStartFor(day);
  final end = start.add(const Duration(days: 7));
  return changes
      .where(
        (change) =>
            !change.lessonDate.isBefore(start) &&
            change.lessonDate.isBefore(end),
      )
      .toList();
}

bool dayHasChanges(
  List<ScheduleChange> changes,
  List<LessonSchedulePart> lessons,
  DateTime day,
) {
  return lessons.any(
    (lesson) =>
        changeFor(changes, lesson, day) != null ||
        isNewLesson(changes, lesson, day),
  );
}

(ScheduleTargetType, String)? changesRequestFor(SelectedSchedule? selected) {
  return switch (selected) {
    SelectedGroupSchedule(:final group) => (
      ScheduleTargetType.group,
      group.name,
    ),
    SelectedTeacherSchedule(:final teacher) => (
      ScheduleTargetType.teacher,
      teacher.name,
    ),
    SelectedClassroomSchedule(:final classroom) => (
      ScheduleTargetType.classroom,
      classroom.name,
    ),
    SelectedCustomSchedule() || null => null,
  };
}

List<ScheduleChange> changesForSelectedLesson(
  ScheduleChangesCubit? cubit,
  SelectedSchedule? selected,
  LessonSchedulePart lesson,
) {
  final request = changesRequestFor(selected);
  if (request == null ||
      cubit == null ||
      !selected!.schedule.contains(lesson) ||
      !cubit.matchesTarget(request.$1, request.$2)) {
    return const [];
  }
  return cubit.state.changes;
}

LessonSchedulePart? nextLessonOf(
  List<LessonSchedulePart> lessons,
  DateTime day,
  DateTime now,
  List<ScheduleChange> changes,
) {
  if (!isSameDate(day, now)) return null;
  for (final lesson in lessons) {
    if (isCancelled(changeFor(changes, lesson, day))) continue;
    if (atTime(day, lesson.lessonBells.startTime).isAfter(now)) return lesson;
  }
  return null;
}

String lessonKey(LessonSchedulePart lesson, DateTime day) {
  return '${day.year}-${day.month}-${day.day}-'
      '${minutesOfDay(lesson.lessonBells.startTime)}-${lesson.subject}';
}
