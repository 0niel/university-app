part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleActiveGroupEmpty extends ScheduleState {
  final List<String> groups;

  ScheduleActiveGroupEmpty({required this.groups});

  @override
  List<Object> get props => [groups];
}

class ScheduleGroupNotFound extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final Schedule schedule;
  final String activeGroup;
  final List<String> downloadedScheduleGroups;

  ScheduleLoaded({
    required this.schedule,
    required this.activeGroup,
    required this.downloadedScheduleGroups,
  });

  @override
  List<Object> get props => [schedule];
}

class ScheduleLoadError extends ScheduleState {
  final String errorMessage;

  ScheduleLoadError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
