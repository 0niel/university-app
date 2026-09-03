import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:schedule_repository/schedule_repository.dart';

class SessionExam {
  const SessionExam({
    required this.subject,
    required this.typeName,
    required this.color,
    required this.date,
    required this.room,
    required this.teacher,
    required this.days,
  });

  final String subject;
  final String typeName;
  final Color color;
  final DateTime date;
  final String room;
  final String teacher;
  final int days;

  String get key => '$subject|${date.toIso8601String()}';

  static List<SessionExam> fromSchedule(
    BuildContext context,
    List<SchedulePart> schedule, {
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final today = DateTime(current.year, current.month, current.day);
    final exams = <SessionExam>[];
    final seen = <String>{};
    for (final lesson in schedule.whereType<LessonSchedulePart>()) {
      if (!{
        LessonType.exam,
        LessonType.credit,
        LessonType.consultation,
      }.contains(lesson.lessonType)) {
        continue;
      }
      for (final day in lesson.dates) {
        final date = DateTime(
          day.year,
          day.month,
          day.day,
          lesson.lessonBells.startTime.hour,
          lesson.lessonBells.startTime.minute,
        );
        if (date.isBefore(today)) continue;
        final exam = SessionExam(
          subject: lesson.subject,
          typeName: LessonCard.getLessonTypeName(
            context.l10n,
            lesson.lessonType,
          ),
          color: LessonCard.getColorByTypeFor(context, lesson.lessonType),
          date: date,
          room: lesson.classrooms.firstOrNull?.name ?? '',
          teacher: lesson.teachers.firstOrNull?.name ?? '',
          days: DateTime(day.year, day.month, day.day).difference(today).inDays,
        );
        if (seen.add('${exam.key}|${exam.typeName}')) exams.add(exam);
      }
    }
    return exams..sort((a, b) => a.date.compareTo(b.date));
  }
}
