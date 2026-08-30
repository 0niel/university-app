part of '../schedule_page.dart';

LessonSchedulePart? _nextLessonOf(
  List<LessonSchedulePart> lessons,
  DateTime day,
) {
  if (!isSameDate(day, DateTime.now())) return null;
  final now = DateTime.now();
  for (final lesson in lessons) {
    if (atTime(day, lesson.lessonBells.startTime).isAfter(now)) return lesson;
  }
  return null;
}

int _minutesToStart(LessonSchedulePart lesson, DateTime day) {
  final start = atTime(day, lesson.lessonBells.startTime);
  return math.max(0, start.difference(DateTime.now()).inMinutes);
}

({bool past, bool live, double? progress, int minutesLeft}) _lessonStatus(
  LessonSchedulePart lesson,
  DateTime day,
) {
  if (!isSameDate(day, DateTime.now())) {
    return (
      past: day.isBefore(dateOnly(DateTime.now())),
      live: false,
      progress: null,
      minutesLeft: 0,
    );
  }

  final now = DateTime.now();
  final start = atTime(day, lesson.lessonBells.startTime);
  final end = atTime(day, lesson.lessonBells.endTime);

  if (now.isBefore(start)) {
    return (
      past: false,
      live: false,
      progress: null,
      minutesLeft: end.difference(now).inMinutes,
    );
  }
  if (!now.isBefore(end)) {
    return (past: true, live: false, progress: null, minutesLeft: 0);
  }
  final total = end.difference(start).inSeconds;
  final passed = now.difference(start).inSeconds;
  return (
    past: false,
    live: true,
    progress: total == 0 ? 1 : (passed / total).clamp(0, 1).toDouble(),
    minutesLeft: math.max(0, end.difference(now).inMinutes),
  );
}

List<LessonSchedulePart> _lessonsForDay(
  List<SchedulePart> schedule,
  DateTime day,
) {
  final lessons =
      schedule
          .whereType<LessonSchedulePart>()
          .where((part) => part.dates.any((date) => isSameDate(date, day)))
          .toList()
        ..sort(
          (a, b) => minutesOfDay(
            a.lessonBells.startTime,
          ).compareTo(minutesOfDay(b.lessonBells.startTime)),
        );
  return lessons;
}

List<LessonSchedulePart> _applyPreferences(
  List<LessonSchedulePart> lessons,
  SchedulePreferencesState preferences,
) {
  bool typeEnabled(LessonType type) {
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

  return lessons
      .where(
        (lesson) =>
            !preferences.hiddenSubjects.contains(lesson.subject) &&
            typeEnabled(lesson.lessonType),
      )
      .toList();
}

List<LessonSchedulePart> _filteredLessonsStatic(
  List<LessonSchedulePart> lessons,
  _ScheduleFilter filter,
) {
  if (filter == .all) return lessons;
  return lessons.where((lesson) {
    return switch (filter) {
      .all => true,
      .lecture => lesson.lessonType == .lecture,
      .seminar => lesson.lessonType == .practice,
      .laboratory => lesson.lessonType == .laboratoryWork,
      .exam => lesson.lessonType == .exam || lesson.lessonType == .credit,
    };
  }).toList();
}

(ScheduleTargetType, String)? _changesRequestFor(SelectedSchedule? selected) {
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
