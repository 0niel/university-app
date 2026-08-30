part of 'events_cubit.dart';

@freezed
abstract class EventsState with _$EventsState {
  const factory EventsState({
    @Default(EventsStatus.initial) EventsStatus status,
    @Default(<CampusEvent>[]) List<CampusEvent> events,
    @Default(EventCategory.all) EventCategory category,
    @Default(<String>{}) Set<String> pendingRsvps,
    @Default(false) bool isCreating,
  }) = _EventsState;

  const EventsState._();

  List<CampusEvent> get filteredEvents => category == .all
      ? events
      : events
            .where((event) => event.category == category.wireName)
            .toList(growable: false);

  CampusEvent? get featuredEvent {
    CampusEvent? featured;
    for (final event in filteredEvents) {
      if (featured == null || event.goingCount > featured.goingCount) {
        featured = event;
      }
    }
    return featured;
  }

  List<CampusEvent> get upcomingEvents {
    final featuredId = featuredEvent?.id;
    return filteredEvents
        .where((event) => event.id != featuredId)
        .toList(growable: false);
  }
}
