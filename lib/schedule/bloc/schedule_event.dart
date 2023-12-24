part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}

class ScheduleRequested extends ScheduleEvent {
  const ScheduleRequested({
    required this.group,
  });

  final Group group;

  @override
  List<Object> get props => [group];
}

class ClassroomScheduleRequested extends ScheduleEvent {
  const ClassroomScheduleRequested({
    required this.classroom,
  });

  final Classroom classroom;

  @override
  List<Object> get props => [classroom];
}

class TeacherScheduleRequested extends ScheduleEvent {
  const TeacherScheduleRequested({
    required this.teacher,
  });

  final Teacher teacher;

  @override
  List<Object> get props => [teacher];
}

class ScheduleRefreshRequested extends ScheduleEvent {
  const ScheduleRefreshRequested({
    required this.identifier,
    required this.target,
  });

  final UID identifier;
  final ScheduleTarget target;

  @override
  List<Object> get props => [identifier, target];
}

class ScheduleResumed extends ScheduleEvent {
  const ScheduleResumed();

  @override
  List<Object> get props => [];
}

class ScheduleSetDisplayMode extends ScheduleEvent {
  const ScheduleSetDisplayMode({
    required this.isMiniature,
  });

  final bool isMiniature;

  @override
  List<Object> get props => [isMiniature];
}

class SetSelectedSchedule extends ScheduleEvent {
  const SetSelectedSchedule({
    required this.selectedSchedule,
  });

  final SelectedSchedule selectedSchedule;

  @override
  List<Object> get props => [selectedSchedule];
}

class DeleteSchedule extends ScheduleEvent {
  const DeleteSchedule({
    required this.identifier,
    required this.target,
  });

  final UID identifier;
  final ScheduleTarget target;

  @override
  List<Object> get props => [identifier, target];
}
