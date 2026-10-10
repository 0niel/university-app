import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/teacher_account/domain/teacher_workload_projection.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_lesson_occurrence.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_gap.dart';
import 'package:schedule_repository/schedule_repository.dart';

export 'package:rtu_mirea_app/teacher_account/models/teacher_lesson_occurrence.dart';
export 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_gap.dart';

part 'teacher_workload.freezed.dart';

@freezed
abstract class TeacherWorkload with _$TeacherWorkload {
  const factory TeacherWorkload({
    required DateTime weekStart,
    required List<TeacherLessonOccurrence> occurrences,
    required Duration totalDuration,
    required List<Group> groups,
    required List<String> subjects,
    required List<Classroom> classrooms,
    required List<TeacherScheduleGap> gaps,
  }) = _TeacherWorkload;

  const TeacherWorkload._();

  factory TeacherWorkload.fromSchedule({
    required List<SchedulePart> schedule,
    required DateTime weekStart,
    List<ScheduleChange> changes = const [],
  }) => projectTeacherWorkload(
    schedule: schedule,
    weekStart: weekStart,
    changes: changes,
  );
  List<TeacherLessonOccurrence> occurrencesForDay(DateTime day) => [
    for (final occurrence in occurrences)
      if (occurrence.date == DateTime(day.year, day.month, day.day)) occurrence,
  ];

  TeacherLessonOccurrence? currentAt(DateTime now) => occurrences
      .where(
        (entry) =>
            !entry.isCancelled &&
            !entry.start.isAfter(now) &&
            entry.end.isAfter(now),
      )
      .firstOrNull;

  TeacherLessonOccurrence? nextAt(DateTime now) => occurrences
      .where((entry) => !entry.isCancelled && entry.start.isAfter(now))
      .firstOrNull;
}
