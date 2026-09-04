import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:schedule_repository/schedule_repository.dart';

String timeRangeText(LessonSchedulePart lesson) {
  return '${lesson.lessonBells.startTime}–${lesson.lessonBells.endTime}';
}

String lessonTypeName(AppLocalizations l10n, LessonType type) =>
    LessonCard.getLessonTypeName(l10n, type);

String singleClassroomText(AppLocalizations l10n, LessonSchedulePart lesson) {
  if (lesson.classrooms.isEmpty) return l10n.classroomNotSpecified;
  final classroom = lesson.classrooms.firstOrNull;
  return classroom == null
      ? l10n.classroomNotSpecified
      : classroomLabel(classroom);
}

String classroomLabel(Classroom classroom) {
  final room = classroom.name.trim();
  final shortCampus = classroom.campus?.shortName?.trim();
  final campusName = classroom.campus?.name.trim();
  final campus = shortCampus != null && shortCampus.isNotEmpty
      ? shortCampus
      : campusName;
  if (campus == null || campus.isEmpty || room == campus) return room;
  return '$room · $campus';
}

String lessonMetaText(AppLocalizations l10n, LessonSchedulePart lesson) {
  final teachers = lesson.teachers.map((teacher) => teacher.name).join(', ');
  final number = lessonNumberOf(lesson);
  return [
    if (number != null) l10n.lessonDetailsPairNumber('$number'),
    LessonCard.getLessonTypeName(l10n, lesson.lessonType).toLowerCase(),
    singleClassroomText(l10n, lesson),
    if (teachers.isNotEmpty) teachers,
  ].join(' · ');
}

int? lessonNumberOf(LessonSchedulePart lesson) {
  final explicit = lesson.lessonBells.number;
  if (explicit != null) return explicit;
  final start = lesson.lessonBells.startTime;
  final end = lesson.lessonBells.endTime;
  final index = UniversityConfig.defaultLessonBellSlots.indexWhere(
    (slot) =>
        slot.startHour == start.hour &&
        slot.startMinute == start.minute &&
        slot.endHour == end.hour &&
        slot.endMinute == end.minute,
  );
  return index < 0 ? null : index + 1;
}

String lessonCountText(AppLocalizations l10n, int count) {
  return l10n.lessonsCount(count);
}

String lessonShortLabel(AppLocalizations l10n, LessonType type) {
  return switch (type) {
    .lecture => l10n.lessonShortLecture,
    .practice => l10n.lessonShortPractice,
    .laboratoryWork => l10n.lessonShortLab,
    .physicalEducation => l10n.lessonShortPe,
    .consultation => l10n.lessonShortConsult,
    .exam => l10n.lessonShortExam,
    .credit => l10n.lessonShortCredit,
    .courseWork || .courseProject => l10n.lessonShortCourse,
    .individualWork => l10n.lessonShortIndividual,
    .unknown => l10n.unknown,
  };
}

String activityTypeLabel(AppLocalizations l10n, UserActivityType type) {
  return switch (type) {
    .personal => l10n.activityTypeEvent,
    .event => l10n.activityTypeEvent,
    .retake => l10n.activityTypeRetake,
    .extra => l10n.activityTypeExtra,
    .consult => l10n.consultation,
  };
}

String teacherInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  final letters = parts.take(2).map((part) => part[0].toUpperCase());
  return letters.isEmpty ? '?' : letters.join();
}

String shortTeacherName(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.length < 2) return parts.isEmpty ? '' : parts.first;
  final initials = parts
      .skip(1)
      .expand((part) => part.split('.'))
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => '${String.fromCharCode(part.runes.first).toUpperCase()}.')
      .join(' ');
  return initials.isEmpty ? parts.first : '${parts.first} $initials';
}

String capitalizeFirst(String value) {
  if (value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1);
}

Color lessonAccentOf(BuildContext context, LessonSchedulePart lesson) {
  return LessonCard.colorOfFor(context, lesson);
}

Color lessonTintOf(BuildContext context, LessonSchedulePart lesson) {
  return context.colors.tintOf(lessonAccentOf(context, lesson));
}
