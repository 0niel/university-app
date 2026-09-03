import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_list_cubit.dart';

class _Repository extends Mock implements FriendsRepository {}

void main() {
  final now = DateTime(2026, 9, 2, 14);
  final live = Friend(
    friendshipId: 'friendship',
    userId: 'friend',
    fullName: 'Анна',
    latitude: 55.6,
    longitude: 37.4,
    locationUpdatedAt: now,
  );

  test('hidden, stale, future, and invalid coordinates are not on-map', () {
    expect(friendOnCampus(live, now), isTrue);
    for (final friend in [
      live.copyWith(isGhost: true),
      live.copyWith(locationUpdatedAt: now.subtract(const Duration(hours: 1))),
      live.copyWith(locationUpdatedAt: now.add(const Duration(minutes: 1))),
      live.copyWith(latitude: 91),
      live.copyWith(longitude: -181),
    ]) {
      expect(friendOnCampus(friend, now), isFalse);
    }
    expect(
      friendPresence(live.copyWith(latitude: 91), now),
      FriendPresence.off,
    );
  });

  test(
    'filter retains all friends and narrows to recent shared coordinates',
    () {
      final state = FriendsListState(
        friends: [
          live,
          live.copyWith(userId: 'hidden', isGhost: true),
        ],
      );
      expect(state.visible(now).length, 2);
      expect(state.onCampusCount(now), 1);
      expect(state.copyWith(filter: FriendsFilter.onCampus).visible(now), [
        live,
      ]);
    },
  );

  test('loading failure can be retried', () async {
    final repository = _Repository();
    final cubit = FriendsListCubit(friendsRepository: repository);
    addTearDown(cubit.close);
    when(repository.getFriends).thenThrow(StateError('offline'));
    await cubit.load();
    expect(cubit.state.status, FriendsListStatus.failure);
    when(repository.getFriends).thenAnswer((_) async => [live]);
    await cubit.load();
    expect(cubit.state.status, FriendsListStatus.loaded);
    expect(cubit.state.friends, [live]);
  });

  test('removal only changes the list when the server confirms it', () async {
    final repository = _Repository();
    final cubit = FriendsListCubit(friendsRepository: repository);
    addTearDown(cubit.close);
    when(repository.getFriends).thenAnswer((_) async => [live]);
    when(
      () => repository.removeFriend('friend'),
    ).thenThrow(StateError('offline'));
    await cubit.load();
    expect(await cubit.removeFriend('friend'), isFalse);
    expect(cubit.state.friends, [live]);
    when(() => repository.removeFriend('friend')).thenAnswer((_) async {});
    expect(await cubit.removeFriend('friend'), isTrue);
    expect(cubit.state.friends, isEmpty);
  });
}
