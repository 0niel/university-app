import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/study_group/cubit/study_group_cubit.dart';
import 'package:study_groups_repository/study_groups_repository.dart';

class MockStudyGroupsRepository extends Mock implements StudyGroupsRepository {}

void main() {
  late StudyGroupsRepository repository;

  const sampleGroup = StudyGroup(
    id: 'g1',
    name: 'ИКБО-09-22',
    joinCode: 'MNMN6T',
  );
  const owned = MyStudyGroup(
    hasGroup: true,
    isOwner: true,
    group: sampleGroup,
    members: [
      StudyGroupMember(
        userId: 'u1',
        fullName: 'Я',
        role: 'owner',
        isOwner: true,
        isMe: true,
      ),
    ],
  );
  const none = MyStudyGroup.empty;

  setUp(() => repository = MockStudyGroupsRepository());

  group('StudyGroupCubit', () {
    test('does not mutate after disposal', () async {
      final cubit = StudyGroupCubit(repository: repository);
      await cubit.close();
      expect(await cubit.removeMember('u2'), isFalse);
      expect(
        await cubit.respondJoinRequest(inviteId: 'i1', accept: true),
        isFalse,
      );
      verifyNever(() => repository.removeMember(any()));
    });

    test(
      'a failed mutation does not leave an invalidated load pending',
      () async {
        final response = Completer<MyStudyGroup>();
        when(repository.getMyGroup).thenAnswer((_) => response.future);
        when(
          () => repository.inviteByUserId('u2'),
        ).thenThrow(StateError('offline'));
        final cubit = StudyGroupCubit(repository: repository);
        addTearDown(cubit.close);
        final loading = cubit.load();
        expect(await cubit.inviteByUserId('u2'), isFalse);
        expect(cubit.state.status, StudyGroupStatus.failure);
        response.complete(owned);
        await loading;
        expect(cubit.state.status, StudyGroupStatus.failure);
      },
    );

    test('does not emit after disposal during a load', () async {
      final response = Completer<MyStudyGroup>();
      when(repository.getMyGroup).thenAnswer((_) => response.future);
      final cubit = StudyGroupCubit(repository: repository);
      final loading = cubit.load();
      await cubit.close();
      response.complete(owned);
      await loading;
      expect(cubit.isClosed, isTrue);
    });

    test('a stale load cannot overwrite a newer result', () async {
      final old = Completer<MyStudyGroup>();
      final latest = Completer<MyStudyGroup>();
      var calls = 0;
      when(repository.getMyGroup).thenAnswer(
        (_) => calls++ == 0 ? old.future : latest.future,
      );
      final cubit = StudyGroupCubit(repository: repository);
      addTearDown(cubit.close);
      final first = cubit.load();
      final second = cubit.load();
      latest.complete(none);
      await second;
      old.complete(owned);
      await first;
      expect(cubit.state.data, none);
    });

    test('reports a reload failure after a successful mutation', () async {
      when(() => repository.inviteByUserId('u2')).thenAnswer((_) async {});
      when(
        repository.getMyGroup,
      ).thenThrow(const GetMyStudyGroupFailure('offline'));
      final cubit = StudyGroupCubit(repository: repository);
      addTearDown(cubit.close);
      expect(await cubit.inviteByUserId('u2'), isFalse);
      expect(cubit.state.status, StudyGroupStatus.failure);
    });

    test('initial state is initial/empty', () {
      expect(
        StudyGroupCubit(repository: repository).state,
        const StudyGroupState(),
      );
    });

    group('load', () {
      blocTest<StudyGroupCubit, StudyGroupState>(
        'emits [loading, populated] when getMyGroup succeeds',
        setUp: () => when(repository.getMyGroup).thenAnswer((_) async => owned),
        build: () => StudyGroupCubit(repository: repository),
        act: (cubit) => cubit.load(),
        expect: () => const <StudyGroupState>[
          StudyGroupState(status: StudyGroupStatus.loading),
          StudyGroupState(status: StudyGroupStatus.populated, data: owned),
        ],
      );

      blocTest<StudyGroupCubit, StudyGroupState>(
        'emits [loading, failure] when getMyGroup throws',
        setUp: () => when(repository.getMyGroup).thenThrow(
          const GetMyStudyGroupFailure('boom'),
        ),
        build: () => StudyGroupCubit(repository: repository),
        act: (cubit) => cubit.load(),
        expect: () => const <StudyGroupState>[
          StudyGroupState(status: StudyGroupStatus.loading),
          StudyGroupState(status: StudyGroupStatus.failure),
        ],
      );
    });

    group('leave reloads the group', () {
      blocTest<StudyGroupCubit, StudyGroupState>(
        'leaves then reloads to an empty group',
        setUp: () {
          when(repository.leaveGroup).thenAnswer((_) async {});
          when(repository.getMyGroup).thenAnswer((_) async => none);
        },
        build: () => StudyGroupCubit(repository: repository),
        act: (cubit) => cubit.leave(),
        expect: () => const <StudyGroupState>[
          StudyGroupState(status: StudyGroupStatus.loading),
          StudyGroupState(status: StudyGroupStatus.populated),
        ],
        verify: (_) {
          verify(repository.leaveGroup).called(1);
          verify(repository.getMyGroup).called(1);
        },
      );
    });

    group('removeMember reloads the roster', () {
      blocTest<StudyGroupCubit, StudyGroupState>(
        'removes then reloads, tracking the member id as pending',
        setUp: () {
          when(() => repository.removeMember(any())).thenAnswer((_) async {});
          when(repository.getMyGroup).thenAnswer((_) async => owned);
        },
        build: () => StudyGroupCubit(repository: repository),
        act: (cubit) => cubit.removeMember('u2'),
        expect: () => const <StudyGroupState>[
          StudyGroupState(pendingMemberIds: {'u2'}),
          StudyGroupState(
            status: StudyGroupStatus.loading,
            pendingMemberIds: {'u2'},
          ),
          StudyGroupState(
            status: StudyGroupStatus.populated,
            data: owned,
            pendingMemberIds: {'u2'},
          ),
          StudyGroupState(status: StudyGroupStatus.populated, data: owned),
        ],
      );

      blocTest<StudyGroupCubit, StudyGroupState>(
        'ignores a second remove for the same id while one is pending',
        setUp: () {
          when(() => repository.removeMember(any())).thenAnswer((_) async {});
          when(repository.getMyGroup).thenAnswer((_) async => owned);
        },
        build: () => StudyGroupCubit(repository: repository),
        act: (cubit) async {
          final first = cubit.removeMember('u2');
          final second = await cubit.removeMember('u2');
          expect(second, isFalse);
          await first;
        },
        verify: (_) => verify(() => repository.removeMember('u2')).called(1),
      );
    });

    group('transferOwnership reloads the roster', () {
      blocTest<StudyGroupCubit, StudyGroupState>(
        'transfers then reloads, tracking the member id as pending',
        setUp: () {
          when(
            () => repository.transferOwnership(any()),
          ).thenAnswer((_) async => owned);
          when(repository.getMyGroup).thenAnswer((_) async => owned);
        },
        build: () => StudyGroupCubit(repository: repository),
        act: (cubit) => cubit.transferOwnership('u2'),
        expect: () => const <StudyGroupState>[
          StudyGroupState(pendingMemberIds: {'u2'}),
          StudyGroupState(
            status: StudyGroupStatus.populated,
            data: owned,
            pendingMemberIds: {'u2'},
          ),
          StudyGroupState(status: StudyGroupStatus.populated, data: owned),
        ],
        verify: (_) =>
            verify(() => repository.transferOwnership('u2')).called(1),
      );

      blocTest<StudyGroupCubit, StudyGroupState>(
        'ignores a second transfer for the same id while one is pending',
        setUp: () {
          when(
            () => repository.transferOwnership(any()),
          ).thenAnswer((_) async => owned);
          when(repository.getMyGroup).thenAnswer((_) async => owned);
        },
        build: () => StudyGroupCubit(repository: repository),
        act: (cubit) async {
          final first = cubit.transferOwnership('u2');
          final second = await cubit.transferOwnership('u2');
          expect(second, isFalse);
          await first;
        },
        verify: (_) =>
            verify(() => repository.transferOwnership('u2')).called(1),
      );
    });

    group('respondJoinRequest tracks pending invite ids', () {
      blocTest<StudyGroupCubit, StudyGroupState>(
        'accepts and clears the pending id once resolved',
        setUp: () => when(
          () => repository.respondJoinRequest(
            inviteId: 'invite-1',
            accept: true,
          ),
        ).thenAnswer((_) async => owned),
        build: () => StudyGroupCubit(repository: repository),
        act: (cubit) => cubit.respondJoinRequest(
          inviteId: 'invite-1',
          accept: true,
        ),
        expect: () => const <StudyGroupState>[
          StudyGroupState(pendingRequestIds: {'invite-1'}),
          StudyGroupState(
            status: StudyGroupStatus.populated,
            data: owned,
            pendingRequestIds: {'invite-1'},
          ),
          StudyGroupState(status: StudyGroupStatus.populated, data: owned),
        ],
      );
    });

    group('inviteByUserId', () {
      blocTest<StudyGroupCubit, StudyGroupState>(
        'invites then reloads',
        setUp: () {
          when(() => repository.inviteByUserId(any())).thenAnswer((_) async {});
          when(repository.getMyGroup).thenAnswer((_) async => owned);
        },
        build: () => StudyGroupCubit(repository: repository),
        act: (cubit) async {
          final ok = await cubit.inviteByUserId('u2');
          expect(ok, isTrue);
        },
        verify: (_) => verify(() => repository.inviteByUserId('u2')).called(1),
      );
    });
  });
}
