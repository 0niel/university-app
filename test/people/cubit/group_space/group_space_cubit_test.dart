import 'dart:async';

import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/people/people.dart';

class GroupSpaceCubitTest extends Mock implements CampusRepository {}

void main() {
  late CampusRepository repository;

  const note = GroupNote(
    id: 'note-1',
    title: 'Notes',
    authorName: 'Student',
    likes: 2,
  );
  const space = GroupSpace(
    group: 'Group',
    hasGroup: true,
    notes: [note],
  );

  setUp(() {
    repository = GroupSpaceCubitTest();
  });

  GroupSpaceCubit createCubit() => .new(repository: repository);

  test('cold failure is distinct from having no group', () async {
    when(repository.getGroupSpace).thenThrow(StateError('offline'));
    final cubit = createCubit();
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state.status, GroupSpaceStatus.failure);
    expect(cubit.state.space, GroupSpace.empty);
  });

  test('refresh failure preserves stale content', () async {
    when(repository.getGroupSpace).thenAnswer((_) async => space);
    final cubit = createCubit();
    addTearDown(cubit.close);
    await cubit.load();
    when(repository.getGroupSpace).thenThrow(StateError('offline'));

    await cubit.load();

    expect(cubit.state.status, GroupSpaceStatus.success);
    expect(cubit.state.space, space);
    expect(cubit.state.mutationFailure, GroupSpaceMutationFailure.refresh);
  });

  test('a late refresh cannot overwrite a newer mutation refresh', () async {
    const updated = GroupSpace(
      group: 'Group',
      hasGroup: true,
      links: [
        GroupLink(
          id: 'link-1',
          title: 'Chat',
          url: 'https://t.me/group',
          kind: 'telegram',
        ),
      ],
      notes: [note],
    );
    final staleRefresh = Completer<GroupSpace>();
    var loads = 0;
    when(repository.getGroupSpace).thenAnswer((_) {
      loads++;
      return switch (loads) {
        1 => Future.value(space),
        2 => staleRefresh.future,
        _ => Future.value(updated),
      };
    });
    when(
      () => repository.addGroupLink(
        title: 'Chat',
        url: 'https://t.me/group',
        emoji: '✈️',
        kind: 'telegram',
      ),
    ).thenAnswer((_) async => 'link-1');
    final cubit = createCubit();
    addTearDown(cubit.close);
    await cubit.load();

    final refresh = cubit.load();
    final mutation = cubit.addLink(
      title: 'Chat',
      url: 'https://t.me/group',
      emoji: '✈️',
      kind: 'telegram',
    );
    await mutation;
    staleRefresh.complete(space);
    await refresh;

    expect(cubit.state.space, updated);
  });

  test('a failed mutation cancels the stale refreshing state', () async {
    final staleRefresh = Completer<GroupSpace>();
    var loads = 0;
    when(repository.getGroupSpace).thenAnswer((_) {
      loads++;
      return loads == 1 ? Future.value(space) : staleRefresh.future;
    });
    when(
      () => repository.addGroupLink(
        title: 'Portal',
        url: 'https://example.com',
      ),
    ).thenThrow(StateError('offline'));
    final cubit = createCubit();
    addTearDown(cubit.close);
    await cubit.load();

    final refresh = cubit.load();
    final saved = await cubit.addLink(
      title: 'Portal',
      url: 'https://example.com',
      emoji: '🔗',
      kind: 'link',
    );
    staleRefresh.complete(space);
    await refresh;

    expect(saved, isFalse);
    expect(cubit.state.isRefreshing, isFalse);
    expect(cubit.state.mutationFailure, GroupSpaceMutationFailure.link);
  });

  test('a late refresh cannot revert a confirmed like', () async {
    final staleRefresh = Completer<GroupSpace>();
    var loads = 0;
    when(repository.getGroupSpace).thenAnswer((_) {
      loads++;
      return loads == 1 ? Future.value(space) : staleRefresh.future;
    });
    when(
      () => repository.toggleGroupPostLike('note-1'),
    ).thenAnswer((_) async => true);
    final cubit = createCubit();
    addTearDown(cubit.close);
    await cubit.load();

    final refresh = cubit.load();
    await cubit.toggleLike('note-1');
    staleRefresh.complete(space);
    await refresh;

    expect(cubit.state.space.notes.singleOrNull?.likedByMe, isTrue);
    expect(cubit.state.space.notes.singleOrNull?.likes, 3);
  });

  test('like is optimistic and uses the authoritative server result', () async {
    when(repository.getGroupSpace).thenAnswer((_) async => space);
    final response = Completer<bool>();
    when(
      () => repository.toggleGroupPostLike('note-1'),
    ).thenAnswer((_) => response.future);
    final cubit = createCubit();
    addTearDown(cubit.close);
    await cubit.load();

    final mutation = cubit.toggleLike('note-1');
    expect(cubit.state.space.notes.singleOrNull?.likedByMe, isTrue);
    expect(cubit.state.space.notes.singleOrNull?.likes, 3);
    response.complete(false);
    await mutation;

    expect(cubit.state.space.notes.singleOrNull?.likedByMe, isFalse);
    expect(cubit.state.space.notes.singleOrNull?.likes, 2);
  });

  test('failed like rolls back and exposes a typed failure', () async {
    when(repository.getGroupSpace).thenAnswer((_) async => space);
    when(
      () => repository.toggleGroupPostLike('note-1'),
    ).thenThrow(StateError('offline'));
    final cubit = createCubit();
    addTearDown(cubit.close);
    await cubit.load();

    await cubit.toggleLike('note-1');

    expect(cubit.state.space.notes.singleOrNull, note);
    expect(cubit.state.pendingLikeIds, isEmpty);
    expect(cubit.state.mutationFailure, GroupSpaceMutationFailure.like);
  });

  test('duplicate like taps share one in-flight mutation', () async {
    when(repository.getGroupSpace).thenAnswer((_) async => space);
    final response = Completer<bool>();
    when(
      () => repository.toggleGroupPostLike('note-1'),
    ).thenAnswer((_) => response.future);
    final cubit = createCubit();
    addTearDown(cubit.close);
    await cubit.load();

    final first = cubit.toggleLike('note-1');
    await cubit.toggleLike('note-1');
    response.complete(true);
    await first;

    verify(() => repository.toggleGroupPostLike('note-1')).called(1);
  });

  test('successful link mutation refreshes the authoritative space', () async {
    when(
      () => repository.addGroupLink(
        title: 'Chat',
        url: 't.me/group',
        emoji: '✈️',
        kind: 'telegram',
      ),
    ).thenAnswer((_) async => 'link-id');
    when(repository.getGroupSpace).thenAnswer((_) async => space);
    final cubit = createCubit();
    addTearDown(cubit.close);

    final saved = await cubit.addLink(
      title: 'Chat',
      url: 't.me/group',
      emoji: '✈️',
      kind: 'telegram',
    );

    expect(saved, isTrue);
    expect(cubit.state.space, space);
    expect(cubit.state.status, GroupSpaceStatus.success);
  });

  test('failed post mutation exposes a typed failure', () async {
    when(
      () => repository.createGroupPost(
        title: 'Notice',
        body: 'Body',
        kind: 'announcement',
        pinned: true,
      ),
    ).thenThrow(StateError('forbidden'));
    final cubit = createCubit();
    addTearDown(cubit.close);

    final saved = await cubit.createPost(
      title: 'Notice',
      body: 'Body',
      announcement: true,
    );

    expect(saved, isFalse);
    expect(cubit.state.mutationFailure, GroupSpaceMutationFailure.post);
  });
}
