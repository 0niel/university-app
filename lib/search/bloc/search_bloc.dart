import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_event.dart';
part 'search_state.dart';
part 'search_bloc.g.dart';

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

class SearchBloc extends HydratedBloc<SearchEvent, SearchState> {
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
    on<AddQueryToSearchHistory>(
      (event, emit) {
        if (state.searchHisoty.contains(event.query)) return;

        emit(state.copyWith(
          searchHisoty: [
            event.query,
            ...state.searchHisoty.take(4),
          ],
        ));
      },
    );
    on<ClearSearchHistory>(
      (event, emit) {
        emit(state.copyWith(searchHisoty: const []));
      },
    );
    on<RemoveQueryFromSearchHistory>(
      (event, emit) {
        emit(state.copyWith(
          searchHisoty: state.searchHisoty.where((e) => e != event.query).toList(),
        ));
      },
    );
    on<ChangeSearchMode>(
      (event, emit) {
        if (state.searchMode == event.searchMode) return;
        emit(
          state.copyWith(
            searchMode: event.searchMode,
            groups: const SearchGroupsResponse(results: []),
            teachers: const SearchTeachersResponse(results: []),
            classrooms: const SearchClassroomsResponse(results: []),
          ),
        );
      },
    );
  }

  final ScheduleRepository _scheduleRepository;

  FutureOr<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: SearchStatus.loading));

    final List<Future<dynamic>> tasks = <Future<dynamic>>[];

    switch (state.searchMode) {
      case SearchMode.all:
        tasks
          ..add(_scheduleRepository.searchGroups(query: event.searchQuery))
          ..add(_scheduleRepository.searchTeachers(query: event.searchQuery))
          ..add(_scheduleRepository.searchClassrooms(query: event.searchQuery));
        break;
      case SearchMode.groups:
        tasks.add(_scheduleRepository.searchGroups(query: event.searchQuery));
        break;
      case SearchMode.teachers:
        tasks.add(_scheduleRepository.searchTeachers(query: event.searchQuery));
        break;
      case SearchMode.classrooms:
        tasks.add(_scheduleRepository.searchClassrooms(query: event.searchQuery));
        break;
    }

    try {
      final results = await Future.wait(tasks);

      emit(state.copyWith(
        groups: state.searchMode == SearchMode.all || state.searchMode == SearchMode.groups
            ? results[state.searchMode == SearchMode.all ? 0 : 0] as SearchGroupsResponse
            : state.groups,
        teachers: state.searchMode == SearchMode.all || state.searchMode == SearchMode.teachers
            ? results[state.searchMode == SearchMode.all ? 1 : 0] as SearchTeachersResponse
            : state.teachers,
        classrooms: state.searchMode == SearchMode.all || state.searchMode == SearchMode.classrooms
            ? results[state.searchMode == SearchMode.all ? 2 : 0] as SearchClassroomsResponse
            : state.classrooms,
        status: SearchStatus.populated,
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: SearchStatus.failure));
      addError(error, stackTrace);
    }
  }

  @override
  SearchState? fromJson(Map<String, dynamic> json) => SearchState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(SearchState state) => state.toJson();
}
