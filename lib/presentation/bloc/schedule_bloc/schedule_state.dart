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
  final Map<String, List<String>> groupsByInstitute;

  const ScheduleActiveGroupEmpty({
    required this.groups,
    required this.groupsByInstitute,
  });

  @override
  List<Object> get props => [groups, groupsByInstitute];
}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final Schedule schedule;
  final String activeGroup;
  final List<String> downloadedScheduleGroups;
  final ScheduleSettings scheduleSettings;
  final List<String> groups;
  final Map<String, List<String>> groupsByInstitute;

  const ScheduleLoaded({
    required this.schedule,
    required this.activeGroup,
    required this.downloadedScheduleGroups,
    required this.scheduleSettings,
    required this.groups,
    required this.groupsByInstitute,
  });

  @override
  List<Object> get props => [
        schedule,
        activeGroup,
        downloadedScheduleGroups,
        scheduleSettings,
        groups,
        groupsByInstitute,
      ];
}

class ScheduleLoadError extends ScheduleState {
  final String errorMessage;

  const ScheduleLoadError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
