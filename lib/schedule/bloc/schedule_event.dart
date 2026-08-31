part of 'schedule_bloc.dart';

sealed class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class ScheduleRequested extends ScheduleEvent with AnalyticsEventMixin {
  const ScheduleRequested({required this.group, this.makeActive = true});

  final Group group;
  final bool makeActive;

  @override
  AnalyticsEvent get event =>
      .new('ScheduleRequested', properties: {'group': group.name});

  @override
  List<Object> get props => [group, makeActive];
}

class TeacherScheduleRequested extends ScheduleEvent with AnalyticsEventMixin {
  const TeacherScheduleRequested({
    required this.teacher,
    this.makeActive = true,
  });

  final Teacher teacher;
  final bool makeActive;

  @override
  AnalyticsEvent get event => .new(
    'TeacherScheduleRequested',
    properties: {'teacher': teacher.name},
  );

  @override
  List<Object> get props => [teacher, makeActive];
}

class ClassroomScheduleRequested extends ScheduleEvent
    with AnalyticsEventMixin {
  const ClassroomScheduleRequested({
    required this.classroom,
    this.makeActive = true,
  });

  final Classroom classroom;
  final bool makeActive;

  @override
  AnalyticsEvent get event => .new(
    'ClassroomScheduleRequested',
    properties: {'classroom': classroom.name, 'campus': classroom.campus?.name},
  );

  @override
  List<Object> get props => [classroom, makeActive];
}

class SelectedScheduleRefreshRequested extends ScheduleEvent {
  const SelectedScheduleRefreshRequested({this.manual = false});

  final bool manual;

  @override
  List<Object> get props => [manual];
}

class ScheduleSelected extends ScheduleEvent with AnalyticsEventMixin {
  const ScheduleSelected({required this.selectedSchedule});

  final SelectedSchedule selectedSchedule;

  @override
  List<Object> get props => [selectedSchedule];

  @override
  AnalyticsEvent get event {
    final schedule = selectedSchedule;
    return switch (schedule) {
      SelectedGroupSchedule() => AnalyticsEvent(
        'SetSelectedGroupSchedule',
        properties: {'group': schedule.group.name},
      ),
      SelectedClassroomSchedule() => AnalyticsEvent(
        'SetSelectedClassroomSchedule',
        properties: {
          'classroom': schedule.classroom.name,
          'campus': schedule.classroom.campus?.name,
        },
      ),
      SelectedTeacherSchedule() => AnalyticsEvent(
        'SetSelectedTeacherSchedule',
        properties: {'teacher': schedule.teacher.name},
      ),
      SelectedCustomSchedule() => const AnalyticsEvent('SetSelectedSchedule'),
    };
  }
}

class ScheduleDeleteRequested extends ScheduleEvent {
  const ScheduleDeleteRequested({
    required this.identifier,
    required this.target,
  });

  final UID identifier;
  final ScheduleTarget target;

  @override
  List<Object> get props => [identifier, target];
}

class ScheduleReordered extends ScheduleEvent {
  const ScheduleReordered({required this.target, required this.orderedIds});

  final ScheduleTarget target;
  final List<UID> orderedIds;

  @override
  List<Object> get props => [target, orderedIds];
}
