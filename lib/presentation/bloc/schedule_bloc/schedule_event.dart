part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

/// The event should be called immediately after opening the schedule page
class ScheduleOpenEvent extends ScheduleEvent {}

/// The event should be called to update the list of groups
class ScheduleGroupsLoadEvent extends ScheduleEvent {}

/// The event should be called to set the active group for which
/// the schedule will be taken.
class ScheduleSetActiveGroupEvent extends ScheduleEvent {
  const ScheduleSetActiveGroupEvent({required this.group});

  final String group;
}

class ScheduleUpdateLessonsEvent extends ScheduleEvent {
  const ScheduleUpdateLessonsEvent({required this.week});

  final int week;

  @override
  List<Object> get props => [week];
}

class ScheduleUpdateEvent extends ScheduleEvent {
  const ScheduleUpdateEvent({required this.group, required this.activeGroup});

  final String group;
  final String activeGroup;

  @override
  List<Object> get props => [group, activeGroup];
}

class ScheduleDeleteEvent extends ScheduleEvent {
  const ScheduleDeleteEvent({required this.group, required this.schedule});

  final String group;
  final Schedule schedule;

  @override
  List<Object> get props => [group, schedule];
}

class ScheduleUpdateSettingsEvent extends ScheduleEvent {
  const ScheduleUpdateSettingsEvent({
    this.showEmptyLessons,
    this.showLesonsNums,
    this.calendarFormat,
  });

  final bool? showEmptyLessons;
  final bool? showLesonsNums;
  final int? calendarFormat;
}
