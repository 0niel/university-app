import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/friends/cubit/find_friends_cubit.dart';

class _Friends extends Mock implements FriendsRepository {}

void main() {
  test(
    'closing during roster load does not start suggestions request',
    () async {
      final repository = _Friends();
      final roster = Completer<GroupRoster>();
      when(repository.getGroupMembers).thenAnswer((_) => roster.future);
      final cubit = FindFriendsCubit(friendsRepository: repository);
      final loading = cubit.loadInitial();
      await cubit.close();
      roster.complete(GroupRoster.empty);
      await loading;
      verifyNever(repository.getPeopleYouMayKnow);
    },
  );

  test(
    'pending request is not reported as sent and cannot dispatch twice',
    () async {
      final repository = _Friends();
      final response = Completer<void>();
      when(
        () => repository.sendFriendRequest('friend'),
      ).thenAnswer((_) => response.future);
      final cubit = FindFriendsCubit(friendsRepository: repository);
      final first = cubit.sendRequest('friend');
      expect(cubit.state.sendingTo, {'friend'});
      expect(cubit.state.sentTo, isEmpty);
      expect(await cubit.sendRequest('friend'), isFalse);
      response.complete();
      expect(await first, isTrue);
      expect(cubit.state.sendingTo, isEmpty);
      expect(cubit.state.sentTo, {'friend'});
      verify(() => repository.sendFriendRequest('friend')).called(1);
      await cubit.close();
    },
  );

  test('same query restarted keeps the newest result', () async {
    final repository = _Friends();
    final older = Completer<List<UserSearchResult>>();
    final newer = Completer<List<UserSearchResult>>();
    var calls = 0;
    when(
      () => repository.searchUsers('Anna'),
    ).thenAnswer((_) => ++calls == 1 ? older.future : newer.future);
    final cubit = FindFriendsCubit(friendsRepository: repository);
    final first = cubit.search('Anna');
    final second = cubit.search('Anna');
    newer.complete(const [UserSearchResult(userId: 'new', fullName: 'Anna')]);
    await second;
    older.complete(const []);
    await first;
    expect(cubit.state.results.single.userId, 'new');
    await cubit.close();
  });

  test('closing during batch does not send to the next groupmate', () async {
    final repository = _Friends();
    final response = Completer<void>();
    when(
      () => repository.sendFriendRequest('one'),
    ).thenAnswer((_) => response.future);
    final cubit = FindFriendsCubit(friendsRepository: repository)
      ..emit(
        const FindFriendsState(
          roster: GroupRoster(
            members: [
              GroupMember(userId: 'one', fullName: 'One'),
              GroupMember(userId: 'two', fullName: 'Two'),
            ],
          ),
        ),
      );
    final batch = cubit.addWholeGroup();
    await cubit.close();
    response.complete();
    expect(await batch, isFalse);
    verifyNever(() => repository.sendFriendRequest('two'));
  });
}
