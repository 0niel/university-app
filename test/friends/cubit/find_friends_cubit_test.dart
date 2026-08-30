import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/friends/cubit/find_friends_cubit.dart';

class _MockFriendsRepository extends Mock implements FriendsRepository {}

void main() {
  late FriendsRepository repository;

  const roster = GroupRoster(
    group: 'ИКБО-09',
    members: [
      GroupMember(userId: 'g1', fullName: 'Олег'),
      GroupMember(userId: 'me', fullName: 'Я', isMe: true),
    ],
  );
  const suggestions = [
    SuggestedFriend(userId: 's1', fullName: 'Вера', mutualCount: 3),
  ];

  setUp(() => repository = _MockFriendsRepository());

  group('loadInitial', () {
    blocTest<FindFriendsCubit, FindFriendsState>(
      'emits [loading, ready] with roster + suggestions on success',
      setUp: () {
        when(
          () => repository.getGroupMembers(),
        ).thenAnswer((_) async => roster);
        when(
          () => repository.getPeopleYouMayKnow(),
        ).thenAnswer((_) async => suggestions);
      },
      build: () => FindFriendsCubit(friendsRepository: repository),
      act: (cubit) => cubit.loadInitial(),
      expect: () => [
        isA<FindFriendsState>().having(
          (s) => s.status,
          'status',
          FindFriendsStatus.loading,
        ),
        isA<FindFriendsState>()
            .having((s) => s.status, 'status', FindFriendsStatus.ready)
            .having((s) => s.roster.group, 'group', 'ИКБО-09')
            .having((s) => s.suggestions.length, 'suggestions', 1),
      ],
    );

    blocTest<FindFriendsCubit, FindFriendsState>(
      'emits [loading, failure] and reports the error when loading fails',
      setUp: () =>
          when(() => repository.getGroupMembers()).thenThrow(Exception('boom')),
      build: () => FindFriendsCubit(friendsRepository: repository),
      act: (cubit) => cubit.loadInitial(),
      expect: () => [
        isA<FindFriendsState>().having(
          (s) => s.status,
          'status',
          FindFriendsStatus.loading,
        ),
        isA<FindFriendsState>().having(
          (s) => s.status,
          'status',
          FindFriendsStatus.failure,
        ),
      ],
      errors: () => [isA<Exception>()],
    );
  });

  group('search', () {
    blocTest<FindFriendsCubit, FindFriendsState>(
      'emits [query, searching, results] for a runnable query',
      setUp: () => when(() => repository.searchUsers(any())).thenAnswer(
        (_) async => const [UserSearchResult(userId: 'x', fullName: 'Найден')],
      ),
      build: () => FindFriendsCubit(friendsRepository: repository),
      act: (cubit) => cubit.search('на'),
      expect: () => [
        isA<FindFriendsState>().having((s) => s.query, 'query', 'на'),
        isA<FindFriendsState>().having((s) => s.searching, 'searching', true),
        isA<FindFriendsState>()
            .having((s) => s.results.length, 'results', 1)
            .having((s) => s.searching, 'searching', false),
      ],
    );

    blocTest<FindFriendsCubit, FindFriendsState>(
      'does not search for a query shorter than 2 chars',
      build: () => FindFriendsCubit(friendsRepository: repository),
      act: (cubit) => cubit.search('a'),
      verify: (_) => verifyNever(() => repository.searchUsers(any())),
    );

    test('a stale failure does not clear the active search state', () async {
      final oldResult = Completer<List<UserSearchResult>>();
      final newResult = Completer<List<UserSearchResult>>();
      when(() => repository.searchUsers(any())).thenAnswer((invocation) {
        final query = invocation.positionalArguments.first as String;
        return query == 'old' ? oldResult.future : newResult.future;
      });
      final cubit = FindFriendsCubit(friendsRepository: repository);

      final oldSearch = cubit.search('old');
      final newSearch = cubit.search('new');
      oldResult.completeError(Exception('stale'), StackTrace.current);
      await oldSearch;

      expect(cubit.state.query, 'new');
      expect(cubit.state.searching, isTrue);

      newResult.complete(const [
        UserSearchResult(userId: 'new', fullName: 'Новый результат'),
      ]);
      await newSearch;

      expect(cubit.state.searching, isFalse);
      expect(cubit.state.results.single.userId, 'new');
      await cubit.close();
    });

    blocTest<FindFriendsCubit, FindFriendsState>(
      'clears previous results when the current query fails',
      setUp: () => when(
        () => repository.searchUsers(any()),
      ).thenThrow(Exception('network')),
      build: () => FindFriendsCubit(friendsRepository: repository),
      seed: () => const FindFriendsState(
        query: 'old',
        results: [UserSearchResult(userId: 'old', fullName: 'Старый')],
      ),
      act: (cubit) => cubit.search('new'),
      expect: () => [
        isA<FindFriendsState>().having((s) => s.query, 'query', 'new'),
        isA<FindFriendsState>().having((s) => s.searching, 'searching', true),
        isA<FindFriendsState>()
            .having((s) => s.searching, 'searching', false)
            .having((s) => s.results, 'results', isEmpty),
      ],
      errors: () => [isA<Exception>()],
    );
  });

  group('sendRequest', () {
    blocTest<FindFriendsCubit, FindFriendsState>(
      'adds the user to sentTo on success',
      setUp: () => when(
        () => repository.sendFriendRequest(any()),
      ).thenAnswer((_) async {}),
      build: () => FindFriendsCubit(friendsRepository: repository),
      act: (cubit) => cubit.sendRequest('g1'),
      expect: () => [
        isA<FindFriendsState>().having((s) => s.sentTo, 'sentTo', {'g1'}),
      ],
    );

    blocTest<FindFriendsCubit, FindFriendsState>(
      'rolls sentTo back and reports the error on failure',
      setUp: () => when(
        () => repository.sendFriendRequest(any()),
      ).thenThrow(Exception('x')),
      build: () => FindFriendsCubit(friendsRepository: repository),
      act: (cubit) => cubit.sendRequest('g1'),
      expect: () => [
        isA<FindFriendsState>().having((s) => s.sentTo, 'sentTo', {'g1'}),
        isA<FindFriendsState>().having((s) => s.sentTo, 'sentTo', isEmpty),
      ],
      errors: () => [isA<Exception>()],
    );
  });

  group('addWholeGroup', () {
    const roster = GroupRoster(
      members: [
        GroupMember(userId: 'g1', fullName: 'A'),
        GroupMember(userId: 'g2', fullName: 'B'),
        GroupMember(userId: 'me', fullName: 'Me', isMe: true),
      ],
    );

    blocTest<FindFriendsCubit, FindFriendsState>(
      'sends a request to every groupmate except me and resolves true',
      setUp: () => when(
        () => repository.sendFriendRequest(any()),
      ).thenAnswer((_) async {}),
      build: () => FindFriendsCubit(friendsRepository: repository),
      seed: () => const FindFriendsState(roster: roster),
      act: (cubit) => cubit.addWholeGroup(),
      verify: (_) {
        verify(() => repository.sendFriendRequest('g1')).called(1);
        verify(() => repository.sendFriendRequest('g2')).called(1);
        verifyNever(() => repository.sendFriendRequest('me'));
      },
      expect: () => [
        isA<FindFriendsState>().having(
          (s) => s.isAddingGroup,
          'isAddingGroup',
          true,
        ),
        isA<FindFriendsState>().having((s) => s.sentTo, 'sentTo', {'g1'}),
        isA<FindFriendsState>().having(
          (s) => s.sentTo,
          'sentTo',
          {'g1', 'g2'},
        ),
        isA<FindFriendsState>().having(
          (s) => s.isAddingGroup,
          'isAddingGroup',
          false,
        ),
      ],
    );

    test('resolves true immediately when nothing needs sending', () async {
      final cubit = FindFriendsCubit(friendsRepository: repository);
      final result = await cubit.addWholeGroup();
      expect(result, isTrue);
      expect(cubit.state.isAddingGroup, isFalse);
      verifyNever(() => repository.sendFriendRequest(any()));
    });

    test(
      'resolves false and clears isAddingGroup when a request fails',
      () async {
        when(
          () => repository.sendFriendRequest('g1'),
        ).thenAnswer((_) async {});
        when(
          () => repository.sendFriendRequest('g2'),
        ).thenThrow(Exception('network'));
        final cubit = FindFriendsCubit(friendsRepository: repository)
          ..emit(const FindFriendsState(roster: roster));

        final result = await cubit.addWholeGroup();

        expect(result, isFalse);
        expect(cubit.state.isAddingGroup, isFalse);
        expect(cubit.state.sentTo, {'g1'});
      },
    );

    test('ignores a re-entrant call while already adding the group', () async {
      final started = Completer<void>();
      final release = Completer<void>();
      when(() => repository.sendFriendRequest('g1')).thenAnswer((_) async {
        started.complete();
        await release.future;
      });
      final cubit = FindFriendsCubit(friendsRepository: repository)
        ..emit(
          const FindFriendsState(
            roster: GroupRoster(
              members: [GroupMember(userId: 'g1', fullName: 'A')],
            ),
          ),
        );

      final first = cubit.addWholeGroup();
      await started.future;
      final second = await cubit.addWholeGroup();

      expect(second, isFalse);
      release.complete();
      expect(await first, isTrue);
    });
  });
}
