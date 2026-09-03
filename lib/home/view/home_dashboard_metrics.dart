import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';

bool homeWaitsForScheduleRefresh(SelectedSchedule? selected) =>
    selected != null && selected is! SelectedCustomSchedule;

(ScheduleTargetType, String)? homeScheduleTarget(SelectedSchedule? selected) =>
    switch (selected) {
      SelectedGroupSchedule() => (ScheduleTargetType.group, selected.name),
      SelectedTeacherSchedule() => (ScheduleTargetType.teacher, selected.name),
      SelectedClassroomSchedule() => (
        ScheduleTargetType.classroom,
        selected.name,
      ),
      _ => null,
    };
