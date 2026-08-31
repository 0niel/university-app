import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:schedule_repository/schedule_repository.dart';

String timeRangeText(LessonSchedulePart lesson) {
  return '${lesson.lessonBells.startTime}–${lesson.lessonBells.endTime}';
}

String singleClassroomText(AppLocalizations l10n, LessonSchedulePart lesson) {
  if (lesson.classrooms.isEmpty) return l10n.classroomNotSpecified;
  return lesson.classrooms.firstOrNull?.name ?? l10n.classroomNotSpecified;
}

String lessonMetaText(AppLocalizations l10n, LessonSchedulePart lesson) {
  final teachers = lesson.teachers.map((teacher) => teacher.name).join(', ');
  final number = lesson.lessonBells.number;
  return [
    if (number != null) l10n.lessonDetailsPairNumber('$number'),
    LessonCard.getLessonTypeName(l10n, lesson.lessonType).toLowerCase(),
    singleClassroomText(l10n, lesson),
    if (teachers.isNotEmpty) teachers,
  ].join(' · ');
}

String lessonCountText(AppLocalizations l10n, int count) {
  return l10n.lessonsCount(count);
}

String inMinutesText(AppLocalizations l10n, int minutes) {
  if (minutes >= 90) {
    final hours = (minutes / 60).toStringAsFixed(minutes % 60 == 0 ? 0 : 1);
    return l10n.nextInHours(hours);
  }
  return l10n.nextInMinutes(minutes);
}

String? prepHint(AppLocalizations l10n, LessonSchedulePart lesson) {
  return switch (lesson.lessonType) {
    .laboratoryWork => l10n.prepHintLab,
    .exam || .credit => l10n.prepHintExam,
    .courseWork || .courseProject => l10n.prepHintCourse,
    .lecture ||
    .practice ||
    .consultation ||
    .individualWork ||
    .physicalEducation ||
    .unknown => null,
  };
}

String capitalizeFirst(String value) {
  if (value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1);
}

Color subjectColorOf(NinjaColors colors, LessonSchedulePart lesson) {
  return colors.subjectColor(lesson.subject);
}
