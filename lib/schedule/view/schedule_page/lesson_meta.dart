import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';

String? lessonGroupsLabel(
  LessonSchedulePart lesson,
  SelectedSchedule? selected,
) {
  final groups = lesson.groups;
  if (groups == null || groups.isEmpty) return null;
  if (selected is SelectedGroupSchedule && groups.length <= 1) return null;
  return groups.join(', ');
}
