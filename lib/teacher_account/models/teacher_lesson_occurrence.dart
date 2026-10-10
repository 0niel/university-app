import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'teacher_lesson_occurrence.freezed.dart';

@freezed
abstract class TeacherLessonOccurrence with _$TeacherLessonOccurrence {
  const factory TeacherLessonOccurrence({
    required LessonSchedulePart lesson,
    required DateTime date,
    required DateTime start,
    required DateTime end,
    required List<Group> groups,
    @Default(false) bool isCancelled,
  }) = _TeacherLessonOccurrence;

  const TeacherLessonOccurrence._();

  Duration get duration => end.difference(start);
}
