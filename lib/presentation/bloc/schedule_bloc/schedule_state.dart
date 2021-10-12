part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

/// The state is set when there is no active group.
/// Most likely this is the first launch of the application
/// or user does not want to use the schedule.
///
/// [ScheduleActiveGroupEmpty.groups] is a list of all available groups
/// for which a schedule exists. [ScheduleActiveGroupEmpty.groups] can be
/// empty if for some reason it was not possible to get a list of groups.
class ScheduleActiveGroupEmpty extends ScheduleState {
  final List<String> groups;

  const ScheduleActiveGroupEmpty({required this.groups});

  @override
  List<Object> get props => [groups];
}

class ScheduleGroupNotFound extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final Schedule schedule;
  final String activeGroup;
  final List<String> downloadedScheduleGroups;
  final ScheduleSettings scheduleSettings;

  const ScheduleLoaded({
    required this.schedule,
    required this.activeGroup,
    required this.downloadedScheduleGroups,
    required this.scheduleSettings,
  });

  @override
  List<Object> get props =>
      [schedule, activeGroup, downloadedScheduleGroups, scheduleSettings];
}

class ScheduleLoadError extends ScheduleState {
  final String errorMessage;

  const ScheduleLoadError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
