import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_event.dart';
part 'search_state.dart';

const _duration = Duration(milliseconds: 300);

EventTransformer<Event> restartableDebounce<Event>(
  Duration duration, {
  required bool Function(Event) isDebounced,
}) {
  return (events, mapper) {
    final debouncedEvents = events.where(isDebounced).debounce(duration);
    final otherEvents = events.where((event) => !isDebounced(event));
    return otherEvents.merge(debouncedEvents).switchMap(mapper);
  };
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required ScheduleRepository scheduleRepository,
  })  : _scheduleRepository = scheduleRepository,
        super(const SearchState.initial()) {
    on<SearchQueryChanged>(
      (event, emit) async {
        if (event.searchQuery.isNotEmpty) {
          await _onSearchQueryChanged(event, emit);
        }
      },
      transformer: restartableDebounce(
        _duration,
        isDebounced: (event) => event.searchQuery.isNotEmpty,
      ),
    );
  }

  final ScheduleRepository _scheduleRepository;

  FutureOr<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SearchStatus.loading,
      ),
    );
    try {
      final results = await Future.wait([
        _scheduleRepository.searchGroups(query: event.searchQuery),
        _scheduleRepository.searchTeachers(query: event.searchQuery),
        _scheduleRepository.searchClassrooms(query: event.searchQuery),
      ]);

      emit(
        state.copyWith(
          groups: results[0] as SearchGroupsResponse,
          teachers: results[1] as SearchTeachersResponse,
          classrooms: results[2] as SearchClassroomsResponse,
          status: SearchStatus.populated,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: SearchStatus.failure));
      addError(error, stackTrace);
    }
  }
}
