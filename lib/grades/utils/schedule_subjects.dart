import 'package:rtu_mirea_app/grades/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';

List<SubjectGrades> scheduleSubjectsFor(
  List<SchedulePart> parts,
  GradesTerm term,
) {
  final byName = <String, SubjectGrades>{};
  for (final part in parts) {
    if (part is! LessonSchedulePart || part.isSessionLesson) continue;
    if (!part.dates.any(term.contains)) continue;
    final subject = part.subject.trim();
    if (subject.isEmpty) continue;
    final teacher = part.teachers.isEmpty ? '' : part.teachers.first.name;
    final existing = byName[subject];
    if (existing == null) {
      byName[subject] = SubjectGrades(subject: subject, teacher: teacher);
    } else if (existing.teacher.isEmpty && teacher.isNotEmpty) {
      byName[subject] = existing.copyWith(teacher: teacher);
    }
  }
  return byName.values.toList(growable: false);
}

List<LessonSchedulePart> lessonsFor(
  List<SchedulePart> parts,
  GradesTerm term,
) => [
  for (final part in parts)
    if (part is LessonSchedulePart &&
        !part.isSessionLesson &&
        part.dates.any(term.contains))
      part,
];
