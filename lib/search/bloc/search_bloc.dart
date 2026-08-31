import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'search_event.dart';
part 'search_state.dart';
part 'search_status.dart';
part 'search_mode.dart';
part 'search_bloc.freezed.dart';
part 'search_bloc.g.dart';

const kSearchDebounceDuration = Duration(milliseconds: 600);

class SearchBloc extends HydratedBloc<SearchEvent, SearchState> {
  SearchBloc({
    required this._scheduleRepository,
    this._friendsRepository,
    this._campusRepository,
  }) : super(const SearchState()) {
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: restartable(),
    );
    on<SearchHistoryQueryAdded>((event, emit) {
      final logSearch = _campusRepository?.logSearchQuery(event.query);
      if (logSearch != null) {
        unawaited(logSearch.onError(addError));
      }
      if (state.searchHisoty.contains(event.query)) return;

      emit(
        state.copyWith(
          searchHisoty: [event.query, ...state.searchHisoty.take(4)],
        ),
      );
    });
    on<SearchTrendingRequested>(
      _onSearchTrendingRequested,
      transformer: droppable(),
    );
    on<SearchHistoryCleared>((event, emit) {
      emit(state.copyWith(searchHisoty: const []));
    });
    on<SearchHistoryQueryRemoved>((event, emit) {
      emit(
        state.copyWith(
          searchHisoty: state.searchHisoty
              .where((e) => e != event.query)
              .toList(),
        ),
      );
    });
    on<SearchModeChanged>((event, emit) {
      if (state.searchMode == event.searchMode) return;
      final hasQuery = _query.trim().isNotEmpty;
      emit(
        state.copyWith(
          searchMode: event.searchMode,
          status: hasQuery ? .loading : state.status,
          groups: const SearchGroupsResponse(results: []),
          teachers: const SearchTeachersResponse(results: []),
          classrooms: const SearchClassroomsResponse(results: []),
          people: const [],
          posts: const [],
        ),
      );
      if (hasQuery) {
        add(SearchQueryChanged(searchQuery: _query));
      }
    });
  }

  final ScheduleRepository _scheduleRepository;

  final FriendsRepository? _friendsRepository;
  final CampusRepository? _campusRepository;
  String _query = '';
  int _searchRevision = 0;

  @override
  void onEvent(SearchEvent event) {
    if (event is SearchQueryChanged) {
      _query = event.searchQuery;
      _searchRevision++;
    } else if (event is SearchModeChanged &&
        event.searchMode != state.searchMode) {
      _searchRevision++;
    }
    super.onEvent(event);
  }

  Future<void> _onSearchTrendingRequested(
    SearchTrendingRequested event,
    Emitter<SearchState> emit,
  ) async {
    final campus = _campusRepository;
    if (campus == null) return;
    try {
      final trending = await campus.getTrendingSearches();
      emit(state.copyWith(trending: trending));
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final revision = _searchRevision;
    final query = event.searchQuery.trim();
    if (query.isEmpty) {
      if (state.status == .initial &&
          state.groups.results.isEmpty &&
          state.teachers.results.isEmpty &&
          state.classrooms.results.isEmpty &&
          state.people.isEmpty &&
          state.posts.isEmpty) {
        return;
      }
      emit(
        state.copyWith(
          status: .initial,
          groups: const SearchGroupsResponse(results: []),
          teachers: const SearchTeachersResponse(results: []),
          classrooms: const SearchClassroomsResponse(results: []),
          people: const [],
          posts: const [],
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: .loading,
        groups: const SearchGroupsResponse(results: []),
        teachers: const SearchTeachersResponse(results: []),
        classrooms: const SearchClassroomsResponse(results: []),
        people: const [],
        posts: const [],
      ),
    );
    await Future<void>.delayed(kSearchDebounceDuration);
    if (emit.isDone || revision != _searchRevision) return;

    final mode = state.searchMode;
    final friends = _friendsRepository;
    final campus = _campusRepository;
    bool wants(SearchMode m) => mode == .all || mode == m;

    try {
      final groupsFuture = wants(.schedule)
          ? _scheduleRepository.searchGroups(query: query)
          : Future.value(state.groups);
      final teachersFuture = wants(.schedule)
          ? _scheduleRepository.searchTeachers(query: query)
          : Future.value(state.teachers);
      final classroomsFuture = wants(.classrooms)
          ? _scheduleRepository.searchClassrooms(query: query)
          : Future.value(state.classrooms);
      final peopleFuture = wants(.people) && friends != null
          ? friends.searchUsers(query)
          : Future.value(state.people);
      final postsFuture = wants(.community) && campus != null
          ? campus.searchGroupPosts(query)
          : Future.value(state.posts);
      final (groups, teachers, classrooms, people, posts) = await (
        groupsFuture,
        teachersFuture,
        classroomsFuture,
        peopleFuture,
        postsFuture,
      ).wait;
      if (emit.isDone || revision != _searchRevision) return;

      emit(
        state.copyWith(
          groups: groups,
          teachers: teachers,
          classrooms: classrooms,
          people: people,
          posts: posts,
          status: .populated,
        ),
      );
    } on Exception catch (error, stackTrace) {
      if (emit.isDone || revision != _searchRevision) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  @override
  SearchState fromJson(Map<String, dynamic> json) => .fromJson(json);

  @override
  Map<String, dynamic> toJson(SearchState state) => state.toJson();
}
