part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

/// The event should be called immediately after opening the schedule page
class ScheduleOpenEvent extends ScheduleEvent {}

/// The event should be called when typing a group in the input input
/// field [AutocompleteGroupSelector]. [suggestion] is the text value of
/// the field.
class ScheduleUpdateGroupSuggestionEvent extends ScheduleEvent {
  const ScheduleUpdateGroupSuggestionEvent({required this.suggestion});

  final String suggestion;

  @override
  List<Object> get props => [suggestion];
}

/// The event should be called to update the list of groups
class ScheduleGroupsLoadEvent extends ScheduleEvent {}

/// The event should be called to set the active group for which
/// the schedule will be taken. The group name is the [groupSuggestion]
/// field in [ScheduleBloc]. [groupSuggestion] should be set every
/// time the input is updated using the event
/// [ScheduleUpdateGroupSuggestionEvent].
class ScheduleSetActiveGroupEvent extends ScheduleEvent {}

class ScheduleUpdateLessonsEvent extends ScheduleEvent {
  const ScheduleUpdateLessonsEvent({required this.week});

  final int week;

  @override
  List<Object> get props => [week];
}
