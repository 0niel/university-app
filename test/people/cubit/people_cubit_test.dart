import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/people/people.dart';
import 'package:study_groups_repository/study_groups_repository.dart';

import 'mock_friends_repository.dart';

void main() {
  late FriendsRepository friendsRepository;
  late StudyGroupsRepository studyGroupsRepository;
  const friend = Friend(
    friendshipId: 'friendship-1',
    userId: 'friend-1',
    fullName: 'Friend One',
  );
  const request = FriendRequest(
    friendshipId: 'request-1',
    userId: 'requester-1',
    fullName: 'Requester One',
  );
  const studyGroup = MyStudyGroup(
    hasGroup: true,
    members: [
      StudyGroupMember(userId: 'me', fullName: 'Me', isMe: true),
      StudyGroupMember(userId: 'peer-1', fullName: 'Peer One'),
    ],
  );

  setUp(() {
    friendsRepository = MockFriendsRepository();
    studyGroupsRepository = MockStudyGroupsRepository();
  });

  PeopleCubit buildCubit() => .new(
    friendsRepository: friendsRepository,
    studyGroupsRepository: studyGroupsRepository,
    currentUserId: 'me',
  );

  void stubLoad({
    Future<List<Friend>>? friends,
    Future<List<FriendRequest>>? requests,
    Future<MyStudyGroup>? group,
  }) {
    when(
      friendsRepository.getFriends,
    ).thenAnswer((_) => friends ?? Future.value([friend]));
    when(
      friendsRepository.getFriendRequests,
    ).thenAnswer((_) => requests ?? Future.value([request]));
    when(
      studyGroupsRepository.getMyGroup,
    ).thenAnswer((_) => group ?? Future.value(studyGroup));
  }

  test('preserves successful sources when a refresh partially fails', () async {
    stubLoad();
    final cubit = buildCubit();
    expect(await cubit.load(), isTrue);
    stubLoad(
      friends: Future.error(Exception('friends offline')),
      requests: Future.value(const []),
      group: Future.error(Exception('group offline')),
    );

    expect(await cubit.load(), isFalse);
    expect(cubit.state.status, PeopleStatus.ready);
    expect(cubit.state.friends, [friend]);
    expect(cubit.state.requests, isEmpty);
    expect(
      cubit.state.failedSources,
      {PeopleSource.friends, PeopleSource.studyGroup},
    );
    await cubit.close();
  });

  test('friend mutation supersedes an active refresh', () async {
    stubLoad();
    when(
      () => friendsRepository.sendFriendRequest('peer-1'),
    ).thenAnswer((_) => Future<void>.value());
    final cubit = buildCubit();
    await cubit.load();
    final friends = Completer<List<Friend>>();
    final requests = Completer<List<FriendRequest>>();
    final group = Completer<MyStudyGroup>();
    stubLoad(
      friends: friends.future,
      requests: requests.future,
      group: group.future,
    );

    final refresh = cubit.load();
    expect(cubit.state.status, PeopleStatus.loading);
    expect(await cubit.sendFriendRequest('peer-1'), isTrue);
    expect(cubit.state.status, PeopleStatus.ready);
    friends.complete(const []);
    requests.complete(const []);
    group.complete(MyStudyGroup.empty);

    expect(await refresh, isFalse);
    expect(cubit.state.friends, [friend]);
    expect(
      cubit.state.studyGroup.members.lastOrNull?.friendshipStatus,
      'pending',
    );
    await cubit.close();
  });

  test(
    'blocks duplicate friend requests until the mutation completes',
    () async {
      stubLoad();
      final sent = Completer<void>();
      when(
        () => friendsRepository.sendFriendRequest('peer-1'),
      ).thenAnswer((_) => sent.future);
      final cubit = buildCubit();
      await cubit.load();

      final mutation = cubit.sendFriendRequest('peer-1');
      expect(cubit.state.pendingFriendIds, {'peer-1'});
      expect(await cubit.sendFriendRequest('peer-1'), isFalse);
      sent.complete();

      expect(await mutation, isTrue);
      expect(cubit.state.pendingFriendIds, isEmpty);
      verify(
        () => friendsRepository.sendFriendRequest('peer-1'),
      ).called(1);
      await cubit.close();
    },
  );

  test('rolls back an optimistic friend response on failure', () async {
    stubLoad();
    when(
      () => friendsRepository.respondFriendRequest(
        friendshipId: request.friendshipId,
        accept: true,
      ),
    ).thenThrow(Exception('offline'));
    final cubit = buildCubit();
    await cubit.load();

    expect(
      await cubit.respondFriendRequest(
        friendshipId: request.friendshipId,
        accept: true,
      ),
      isFalse,
    );
    expect(cubit.state.requests, [request]);
    expect(cubit.state.friends, [friend]);
    expect(cubit.state.pendingResponseIds, isEmpty);
    await cubit.close();
  });
}
