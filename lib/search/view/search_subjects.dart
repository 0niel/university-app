import 'package:rtu_mirea_app/schedule/models/selected_schedule.dart';
import 'package:schedule_repository/schedule_repository.dart';

List<String> scheduleSubjects(SelectedSchedule? selected) {
  final seen = <String>{};
  return [
    for (final part in selected?.schedule ?? const <SchedulePart>[])
      if (part is LessonSchedulePart &&
          part.subject.trim().isNotEmpty &&
          seen.add(part.subject))
        part.subject,
  ];
}
