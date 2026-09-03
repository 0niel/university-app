import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';

class MockScheduleRepository extends Mock implements ScheduleRepository {}

class MockFriendsRepository extends Mock implements FriendsRepository {}

class MockCampusRepository extends Mock implements CampusRepository {}

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;
  late ScheduleRepository scheduleRepository;
  late FriendsRepository friendsRepository;
  late CampusRepository campusRepository;

  const groupsResponse = SearchGroupsResponse(
    results: [Group(name: 'ИКБО-01-21', uid: 'g1')],
  );
  const teachersResponse = SearchTeachersResponse(
    results: [Teacher(name: 'Иванов И.И.', uid: 't1')],
  );
  const classroomsResponse = SearchClassroomsResponse(
    results: [Classroom(name: 'А-101', uid: 'c1')],
  );

  setUp(() {
    storage = MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;

    scheduleRepository = MockScheduleRepository();
    when(
      () => scheduleRepository.searchGroups(query: any(named: 'query')),
    ).thenAnswer((_) async => groupsResponse);
    when(
      () => scheduleRepository.searchTeachers(query: any(named: 'query')),
    ).thenAnswer((_) async => teachersResponse);
    when(
      () => scheduleRepository.searchClassrooms(query: any(named: 'query')),
    ).thenAnswer((_) async => classroomsResponse);

    friendsRepository = MockFriendsRepository();
    when(
      () => friendsRepository.searchUsers(any()),
    ).thenAnswer((_) async => const <UserSearchResult>[]);

    campusRepository = MockCampusRepository();
    when(
      () => campusRepository.searchGroupPosts(any()),
    ).thenAnswer((_) async => const <GroupPostSearchResult>[]);
    when(
      () => campusRepository.logSearchQuery(any()),
    ).thenAnswer((_) async {});
    when(
      () => campusRepository.getTrendingSearches(),
    ).thenAnswer((_) async => const <TrendingSearch>[]);
  });

  SearchBloc buildBloc() => SearchBloc(
    scheduleRepository: scheduleRepository,
    friendsRepository: friendsRepository,
    campusRepository: campusRepository,
  );

  group('SearchBloc', () {
    test('initial state is SearchState.initial()', () {
      expect(buildBloc().state, equals(const SearchState()));
    });

    group('SearchQueryChanged', () {
      blocTest<SearchBloc, SearchState>(
        'enters loading before the debounce completes',
        build: buildBloc,
        act: (bloc) => bloc.add(const SearchQueryChanged(searchQuery: 'ИКБО')),
        wait: const Duration(milliseconds: 100),
        expect: () => const <SearchState>[
          SearchState(status: SearchStatus.loading),
        ],
        verify: (_) {
          verifyNever(
            () => scheduleRepository.searchGroups(query: any(named: 'query')),
          );
          verifyNever(
            () => scheduleRepository.searchTeachers(
              query: any(named: 'query'),
            ),
          );
          verifyNever(
            () => scheduleRepository.searchClassrooms(
              query: any(named: 'query'),
            ),
          );
        },
      );

      blocTest<SearchBloc, SearchState>(
        'emits [loading, populated] with all three results when search '
        'succeeds in SearchMode.all',
        build: buildBloc,
        act: (bloc) => bloc.add(const SearchQueryChanged(searchQuery: 'ИКБО')),
        wait: const Duration(milliseconds: 700),
        expect: () => const <SearchState>[
          SearchState(status: SearchStatus.loading),
          SearchState(
            status: SearchStatus.populated,
            groups: groupsResponse,
            teachers: teachersResponse,
            classrooms: classroomsResponse,
          ),
        ],
        verify: (_) {
          verify(
            () => scheduleRepository.searchGroups(query: 'ИКБО'),
          ).called(1);
          verify(
            () => scheduleRepository.searchTeachers(query: 'ИКБО'),
          ).called(1);
          verify(
            () => scheduleRepository.searchClassrooms(query: 'ИКБО'),
          ).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'emits [loading, failure] and forwards the error when a repository '
        'call fails',
        setUp: () => when(
          () => scheduleRepository.searchTeachers(query: any(named: 'query')),
        ).thenThrow(const SearchTeachersFailure('boom')),
        build: buildBloc,
        act: (bloc) => bloc.add(const SearchQueryChanged(searchQuery: 'ИКБО')),
        wait: const Duration(milliseconds: 700),
        expect: () => const <SearchState>[
          SearchState(status: SearchStatus.loading),
          SearchState(status: SearchStatus.failure),
        ],
        errors: () => [isA<SearchTeachersFailure>()],
      );

      blocTest<SearchBloc, SearchState>(
        'emits nothing and does not call the repository for an empty query',
        build: buildBloc,
        act: (bloc) => bloc.add(const SearchQueryChanged()),
        wait: const Duration(milliseconds: 700),
        expect: () => const <SearchState>[],
        verify: (_) {
          verifyNever(
            () => scheduleRepository.searchGroups(query: any(named: 'query')),
          );
          verifyNever(
            () => scheduleRepository.searchTeachers(query: any(named: 'query')),
          );
          verifyNever(
            () =>
                scheduleRepository.searchClassrooms(query: any(named: 'query')),
          );
        },
      );
    });

    group('SearchModeChanged', () {
      test('searches an unchanged query again after changing scope', () async {
        final bloc = buildBloc()
          ..add(const SearchModeChanged(searchMode: SearchMode.schedule));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SearchQueryChanged(searchQuery: 'A'));
        await Future<void>.delayed(const Duration(milliseconds: 700));
        expect(bloc.state.status, SearchStatus.populated);
        bloc.add(const SearchModeChanged(searchMode: SearchMode.classrooms));
        await Future<void>.delayed(const Duration(milliseconds: 700));
        expect(bloc.state.status, SearchStatus.populated);
        verify(() => scheduleRepository.searchClassrooms(query: 'A')).called(1);
        await bloc.close();
      });

      test('retries the same query after an asynchronous failure', () async {
        var attempts = 0;
        when(() => scheduleRepository.searchGroups(query: 'A')).thenAnswer((
          _,
        ) async {
          if (attempts++ == 0) throw Exception('offline');
          return groupsResponse;
        });
        final bloc = buildBloc()
          ..add(const SearchQueryChanged(searchQuery: 'A'));
        await Future<void>.delayed(const Duration(milliseconds: 700));
        expect(bloc.state.status, SearchStatus.failure);
        bloc.add(const SearchQueryChanged(searchQuery: 'A'));
        await Future<void>.delayed(const Duration(milliseconds: 700));
        expect(bloc.state.status, SearchStatus.populated);
        expect(attempts, 2);
        await bloc.close();
      });

      test('discards an in-flight response from the previous scope', () async {
        final groups = Completer<SearchGroupsResponse>();
        final teachers = Completer<SearchTeachersResponse>();
        when(
          () => scheduleRepository.searchGroups(query: 'old'),
        ).thenAnswer((_) => groups.future);
        when(
          () => scheduleRepository.searchTeachers(query: 'old'),
        ).thenAnswer((_) => teachers.future);

        final bloc = buildBloc();
        final emitted = <SearchState>[];
        final subscription = bloc.stream.listen(emitted.add);
        bloc.add(const SearchQueryChanged(searchQuery: 'old'));
        await Future<void>.delayed(const Duration(milliseconds: 650));
        emitted.clear();

        bloc.add(const SearchModeChanged(searchMode: SearchMode.people));
        groups.complete(groupsResponse);
        teachers.complete(teachersResponse);
        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(bloc.state.searchMode, SearchMode.people);
        expect(bloc.state.status, SearchStatus.loading);
        expect(bloc.state.groups.results, isEmpty);
        expect(
          emitted.where((state) => state.groups.results.isNotEmpty),
          isEmpty,
        );

        await subscription.cancel();
        await bloc.close();
      });

      test(
        'uses the latest query when scope changes during debounce',
        () async {
          final bloc = buildBloc()
            ..add(const SearchQueryChanged(searchQuery: 'old'));
          await Future<void>.delayed(const Duration(milliseconds: 700));
          clearInteractions(friendsRepository);

          bloc
            ..add(const SearchQueryChanged(searchQuery: 'latest'))
            ..add(const SearchModeChanged(searchMode: SearchMode.people));
          await Future<void>.delayed(Duration.zero);

          expect(bloc.state.searchMode, SearchMode.people);
          expect(bloc.state.status, SearchStatus.loading);
          await Future<void>.delayed(const Duration(milliseconds: 700));

          verify(() => friendsRepository.searchUsers('latest')).called(1);
          verifyNever(() => friendsRepository.searchUsers('old'));
          await bloc.close();
        },
      );

      blocTest<SearchBloc, SearchState>(
        'searches groups and teachers when in SearchMode.schedule',
        build: buildBloc,
        act: (bloc) => bloc
          ..add(const SearchModeChanged(searchMode: SearchMode.schedule))
          ..add(const SearchQueryChanged(searchQuery: 'ИКБО')),
        wait: const Duration(milliseconds: 700),
        expect: () => const <SearchState>[
          SearchState(
            searchMode: SearchMode.schedule,
            status: SearchStatus.loading,
          ),
          SearchState(
            searchMode: SearchMode.schedule,
            status: SearchStatus.populated,
            groups: groupsResponse,
            teachers: teachersResponse,
          ),
        ],
        verify: (_) {
          verify(
            () => scheduleRepository.searchGroups(query: 'ИКБО'),
          ).called(1);
          verify(
            () => scheduleRepository.searchTeachers(query: 'ИКБО'),
          ).called(1);
          verifyNever(
            () =>
                scheduleRepository.searchClassrooms(query: any(named: 'query')),
          );
        },
      );

      blocTest<SearchBloc, SearchState>(
        'searches only classrooms when in SearchMode.classrooms',
        build: buildBloc,
        act: (bloc) => bloc
          ..add(const SearchModeChanged(searchMode: SearchMode.classrooms))
          ..add(const SearchQueryChanged(searchQuery: 'А-101')),
        wait: const Duration(milliseconds: 700),
        expect: () => const <SearchState>[
          SearchState(
            searchMode: SearchMode.classrooms,
            status: SearchStatus.loading,
          ),
          SearchState(
            searchMode: SearchMode.classrooms,
            status: SearchStatus.populated,
            classrooms: classroomsResponse,
          ),
        ],
        verify: (_) {
          verify(
            () => scheduleRepository.searchClassrooms(query: 'А-101'),
          ).called(1);
          verifyNever(
            () => scheduleRepository.searchGroups(query: any(named: 'query')),
          );
          verifyNever(
            () => scheduleRepository.searchTeachers(query: any(named: 'query')),
          );
        },
      );

      blocTest<SearchBloc, SearchState>(
        'searches only people when in SearchMode.people',
        setUp: () =>
            when(() => friendsRepository.searchUsers(any())).thenAnswer(
              (_) async => const [
                UserSearchResult(
                  userId: 'u1',
                  fullName: 'Машков Тимур',
                  group: 'ИВТ-04',
                ),
              ],
            ),
        build: buildBloc,
        act: (bloc) => bloc
          ..add(const SearchModeChanged(searchMode: SearchMode.people))
          ..add(const SearchQueryChanged(searchQuery: 'Маш')),
        wait: const Duration(milliseconds: 700),
        expect: () => const <SearchState>[
          SearchState(
            searchMode: SearchMode.people,
            status: SearchStatus.loading,
          ),
          SearchState(
            searchMode: SearchMode.people,
            status: SearchStatus.populated,
            people: [
              UserSearchResult(
                userId: 'u1',
                fullName: 'Машков Тимур',
                group: 'ИВТ-04',
              ),
            ],
          ),
        ],
        verify: (_) {
          verify(() => friendsRepository.searchUsers('Маш')).called(1);
          verifyNever(
            () => scheduleRepository.searchGroups(query: any(named: 'query')),
          );
        },
      );

      blocTest<SearchBloc, SearchState>(
        'searches only group posts when in SearchMode.community',
        setUp: () =>
            when(() => campusRepository.searchGroupPosts(any())).thenAnswer(
              (_) async => const [
                GroupPostSearchResult(
                  id: 'p1',
                  title: 'Конспект по ML',
                  authorName: 'Аня К.',
                ),
              ],
            ),
        build: buildBloc,
        act: (bloc) => bloc
          ..add(const SearchModeChanged(searchMode: SearchMode.community))
          ..add(const SearchQueryChanged(searchQuery: 'ML')),
        wait: const Duration(milliseconds: 700),
        expect: () => const <SearchState>[
          SearchState(
            searchMode: SearchMode.community,
            status: SearchStatus.loading,
          ),
          SearchState(
            searchMode: SearchMode.community,
            status: SearchStatus.populated,
            posts: [
              GroupPostSearchResult(
                id: 'p1',
                title: 'Конспект по ML',
                authorName: 'Аня К.',
              ),
            ],
          ),
        ],
        verify: (_) {
          verify(() => campusRepository.searchGroupPosts('ML')).called(1);
          verifyNever(
            () => scheduleRepository.searchGroups(query: any(named: 'query')),
          );
        },
      );

      blocTest<SearchBloc, SearchState>(
        'emits nothing when the mode is unchanged',
        build: buildBloc,
        act: (bloc) =>
            bloc.add(const SearchModeChanged(searchMode: SearchMode.all)),
        expect: () => const <SearchState>[],
      );
    });

    group('SearchHistoryQueryAdded', () {
      blocTest<SearchBloc, SearchState>(
        'prepends the query to the history and logs it for trending',
        build: buildBloc,
        act: (bloc) => bloc.add(const SearchHistoryQueryAdded(query: 'ИКБО')),
        expect: () => const <SearchState>[
          SearchState(searchHisoty: ['ИКБО']),
        ],
        verify: (_) {
          verify(() => campusRepository.logSearchQuery('ИКБО')).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'still updates the history when logging the query fails',
        setUp: () => when(
          () => campusRepository.logSearchQuery(any()),
        ).thenAnswer((_) async => throw Exception('offline')),
        build: buildBloc,
        act: (bloc) => bloc.add(const SearchHistoryQueryAdded(query: 'ИКБО')),
        expect: () => const <SearchState>[
          SearchState(searchHisoty: ['ИКБО']),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'does not add a duplicate query already present in the history',
        build: buildBloc,
        seed: () => const SearchState(searchHisoty: ['ИКБО']),
        act: (bloc) => bloc.add(const SearchHistoryQueryAdded(query: 'ИКБО')),
        expect: () => const <SearchState>[],
      );

      blocTest<SearchBloc, SearchState>(
        'keeps only the five most recent queries',
        build: buildBloc,
        seed: () => const SearchState(searchHisoty: ['a', 'b', 'c', 'd', 'e']),
        act: (bloc) => bloc.add(const SearchHistoryQueryAdded(query: 'f')),
        expect: () => const <SearchState>[
          SearchState(searchHisoty: ['f', 'a', 'b', 'c', 'd']),
        ],
      );
    });

    group('SearchHistoryQueryRemoved', () {
      blocTest<SearchBloc, SearchState>(
        'removes the matching query from the history',
        build: buildBloc,
        seed: () => const SearchState(searchHisoty: ['a', 'b', 'c']),
        act: (bloc) => bloc.add(const SearchHistoryQueryRemoved(query: 'b')),
        expect: () => const <SearchState>[
          SearchState(searchHisoty: ['a', 'c']),
        ],
      );
    });

    group('SearchHistoryCleared', () {
      blocTest<SearchBloc, SearchState>(
        'empties the history',
        build: buildBloc,
        seed: () => const SearchState(searchHisoty: ['a', 'b']),
        act: (bloc) => bloc.add(const SearchHistoryCleared()),
        expect: () => const <SearchState>[
          SearchState(),
        ],
      );
    });

    group('SearchTrendingRequested', () {
      const trending = [
        TrendingSearch(query: 'ML', count: 12),
        TrendingSearch(query: 'Г-407', count: 5),
      ];

      blocTest<SearchBloc, SearchState>(
        'emits the trending list when the repository succeeds',
        setUp: () => when(
          () => campusRepository.getTrendingSearches(),
        ).thenAnswer((_) async => trending),
        build: buildBloc,
        act: (bloc) => bloc.add(const SearchTrendingRequested()),
        expect: () => const <SearchState>[
          SearchState(trending: trending),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'emits nothing and forwards the error when loading fails',
        setUp: () => when(
          () => campusRepository.getTrendingSearches(),
        ).thenThrow(Exception('boom')),
        build: buildBloc,
        act: (bloc) => bloc.add(const SearchTrendingRequested()),
        expect: () => const <SearchState>[],
        errors: () => [isA<Exception>()],
      );
    });

    group('hydration', () {
      test('toJson/fromJson round-trips the search history', () {
        final bloc = buildBloc();
        const state = SearchState(searchHisoty: ['ИКБО', 'А-101']);

        final json = bloc.toJson(state);
        expect(json, isNotNull);
        expect(bloc.fromJson(json), equals(state));
      });
    });
  });
}
