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
  final List<LessonAppInfo> lessonsAppInfo;
  final LessonAppInfo? updatedLessonAppInfo;

  const ScheduleLoaded({
    required this.schedule,
    required this.activeGroup,
    required this.downloadedScheduleGroups,
    required this.scheduleSettings,
    required this.lessonsAppInfo,
    this.updatedLessonAppInfo
  });

  @override
  List<Object> get props =>
      [schedule, activeGroup, downloadedScheduleGroups,
        scheduleSettings, lessonsAppInfo, updatedLessonAppInfo ?? true];
}

/*
class ScheduleWithAppInfoLoaded extends ScheduleLoaded {
  ScheduleWithAppInfoLoaded({
    required schedule,
    required activeGroup,
    required downloadedScheduleGroups,
    required scheduleSettings,
    required this.lessonsAppInfo
  }) : super(
      schedule: schedule,
      activeGroup: activeGroup,
      downloadedScheduleGroups: downloadedScheduleGroups,
      scheduleSettings: scheduleSettings);

  final List<LessonAppInfo> lessonsAppInfo;

  @override
  List<Object> get props =>
      [schedule, activeGroup, downloadedScheduleGroups, scheduleSettings, lessonsAppInfo];
}
*/

class ScheduleLoadError extends ScheduleState {
  final String errorMessage;

  const ScheduleLoadError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
