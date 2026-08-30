import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/community/cubit/events/events_status.dart';
import 'package:rtu_mirea_app/community/models/event_category.dart';
import 'package:rtu_mirea_app/community/models/event_draft.dart';

part 'events_cubit.freezed.dart';
part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  EventsCubit({required CampusRepository repository})
    : _campusRepository = repository,
      super(const EventsState());

  final CampusRepository _campusRepository;

  var _loadRevision = 0;
  var _eventsRevision = 0;

  Future<bool> load() async {
    final revision = ++_loadRevision;
    final hasContent = state.events.isNotEmpty;
    if (!hasContent) emit(state.copyWith(status: .loading));

    try {
      final events = await _campusRepository.getEvents();
      if (!_isCurrentLoad(revision)) return false;
      _eventsRevision++;
      emit(state.copyWith(status: .ready, events: events));
      return true;
    } on Exception catch (error, stackTrace) {
      if (!_isCurrentLoad(revision)) return false;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
      return false;
    }
  }

  void categoryChanged(EventCategory category) {
    if (category == state.category) return;
    emit(state.copyWith(category: category));
  }

  Future<bool> toggleRsvp(String eventId) async {
    if (state.pendingRsvps.contains(eventId)) return true;
    final previous = _eventById(eventId);
    if (previous == null) return false;

    final going = !previous.isGoing;
    final eventsRevision = _eventsRevision;
    ++_loadRevision;
    _replaceEvent(_withRsvp(previous, going), pendingEventId: eventId);

    try {
      await _campusRepository.setEventRsvp(eventId: eventId, going: going);
      if (isClosed) return false;
      _finishRsvp(eventId, going);
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      if (isClosed) return false;
      if (_eventsRevision == eventsRevision) {
        _replaceEvent(previous);
      } else {
        _clearPending(eventId);
      }
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> createEvent(EventDraft draft) async {
    if (state.isCreating) return false;
    emit(state.copyWith(isCreating: true));
    try {
      await _campusRepository.createEvent(
        title: draft.title,
        startsAt: draft.startsAt,
        place: draft.place,
        emoji: draft.emoji,
        category: draft.category.wireName,
        description: draft.description,
      );
      if (isClosed) return false;
      emit(state.copyWith(isCreating: false));
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      if (isClosed) return false;
      emit(state.copyWith(isCreating: false));
      addError(error, stackTrace);
      return false;
    }
  }

  bool _isCurrentLoad(int revision) => !isClosed && revision == _loadRevision;

  CampusEvent? _eventById(String eventId) {
    for (final event in state.events) {
      if (event.id == eventId) return event;
    }
    return null;
  }

  CampusEvent _withRsvp(CampusEvent event, bool going) {
    if (event.isGoing == going) return event;
    final delta = going ? 1 : -1;
    return event.copyWith(
      isGoing: going,
      goingCount: math.max(0, event.goingCount + delta),
      goingNames: const [],
    );
  }

  void _replaceEvent(CampusEvent replacement, {String? pendingEventId}) {
    final pending = {...state.pendingRsvps};
    if (pendingEventId == null) {
      pending.remove(replacement.id);
    } else {
      pending.add(pendingEventId);
    }
    emit(
      state.copyWith(
        events: [
          for (final event in state.events)
            if (event.id == replacement.id) replacement else event,
        ],
        pendingRsvps: pending,
      ),
    );
  }

  void _clearPending(String eventId) {
    emit(
      state.copyWith(
        pendingRsvps: {...state.pendingRsvps}..remove(eventId),
      ),
    );
  }

  void _finishRsvp(String eventId, bool going) {
    final matchingEvents = state.events.where((event) => event.id == eventId);
    final event = matchingEvents.firstOrNull;
    if (event == null || event.isGoing == going) {
      _clearPending(eventId);
      return;
    }
    _replaceEvent(_withRsvp(event, going));
  }
}
