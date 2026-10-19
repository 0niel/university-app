import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';

List<SelectedSchedule> schedulePickerOptions(ScheduleState state) {
  final schedules = <String, SelectedSchedule>{};
  void add(SelectedSchedule schedule) {
    schedules.putIfAbsent(schedule.pickerId, () => schedule);
  }

  if (state.selectedSchedule case final selected?) add(selected);
  for (final (_, group, parts) in state.groupsSchedule) {
    add(SelectedGroupSchedule(group: group, schedule: parts));
  }
  for (final (_, teacher, parts) in state.teachersSchedule) {
    add(SelectedTeacherSchedule(teacher: teacher, schedule: parts));
  }
  for (final (_, classroom, parts) in state.classroomsSchedule) {
    add(SelectedClassroomSchedule(classroom: classroom, schedule: parts));
  }
  return schedules.values.toList(growable: false);
}

extension SchedulePickerOption on SelectedSchedule {
  String get pickerId => switch (this) {
    SelectedGroupSchedule(:final group) => 'group:${group.uid ?? group.name}',
    SelectedTeacherSchedule(:final teacher) =>
      'teacher:${teacher.uid ?? teacher.name}',
    SelectedClassroomSchedule(:final classroom) =>
      'classroom:${classroom.uid ?? classroom.name}',
    SelectedCustomSchedule(:final id) => 'custom:$id',
  };

  AppLineIcon get pickerIcon => switch (this) {
    SelectedGroupSchedule() => AppLineIcon.people,
    SelectedTeacherSchedule() => AppLineIcon.user,
    SelectedClassroomSchedule() => AppLineIcon.pin,
    SelectedCustomSchedule() => AppLineIcon.calendar,
  };

  String pickerSubtitle(AppLocalizations l10n) => switch (this) {
    SelectedGroupSchedule() => l10n.group,
    SelectedTeacherSchedule() => l10n.teacher,
    SelectedClassroomSchedule() => l10n.classroom,
    SelectedCustomSchedule() => l10n.mySchedules,
  };
}
