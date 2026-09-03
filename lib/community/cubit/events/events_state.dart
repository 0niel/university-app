part of 'events_cubit.dart';

@freezed
abstract class EventsState with _$EventsState {
  const factory EventsState({
    @Default(EventsStatus.initial) EventsStatus status,
    @Default(<CampusEvent>[]) List<CampusEvent> events,
    @Default(<String>{}) Set<String> pendingRsvps,
    @Default(false) bool isCreating,
    @Default(false) bool isSaving,
  }) = _EventsState;
}
