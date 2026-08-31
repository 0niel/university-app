import 'package:rtu_mirea_app/schedule/schedule.dart';

String? scheduleSelectedId(SelectedSchedule? selected) => switch (selected) {
  SelectedGroupSchedule(:final group) => group.uid ?? group.name,
  SelectedTeacherSchedule(:final teacher) => teacher.uid ?? teacher.name,
  SelectedClassroomSchedule(:final classroom) =>
    classroom.uid ?? classroom.name,
  SelectedCustomSchedule() || null => null,
};
