import 'dart:async';

import 'package:campus_repository/campus_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/community.dart';

import '../../helpers/mocks/mock_campus_repository.dart';

void main() {
  late CampusRepository repository;
  const application = TeamApplication(
    id: 'application-1',
    teamId: 'team-1',
    applicantId: 'user-1',
  );

  setUp(() => repository = MockCampusRepository());

  TeamApplicationsCubit buildCubit() => .new(repository, 'team-1');

  test('loads applications and keeps them on refresh failure', () async {
    when(
      () => repository.getTeamApplications('team-1'),
    ).thenAnswer((_) async => [application]);
    final cubit = buildCubit();
    expect(await cubit.load(), isTrue);
    when(
      () => repository.getTeamApplications('team-1'),
    ).thenThrow(Exception('offline'));

    expect(await cubit.load(), isFalse);
    expect(cubit.state.status, TeamApplicationsStatus.failure);
    expect(cubit.state.applications, [application]);
    await cubit.close();
  });

  test('failed action settles a superseded refresh', () async {
    final refresh = Completer<List<TeamApplication>>();
    var loads = 0;
    when(() => repository.getTeamApplications('team-1')).thenAnswer(
      (_) => loads++ == 0 ? Future.value([application]) : refresh.future,
    );
    when(
      () => repository.actOnTeamApplication(
        id: 'application-1',
        action: .reject,
      ),
    ).thenThrow(Exception('offline'));
    final cubit = buildCubit();
    await cubit.load();

    final pendingRefresh = cubit.load();
    expect(cubit.state.status == .loading, isTrue);
    expect(await cubit.act('application-1', .reject), isFalse);
    expect(cubit.state.status == .ready, isTrue);
    expect(cubit.state.applications, [application]);
    refresh.complete(const []);
    expect(await pendingRefresh, isFalse);
    await cubit.close();
  });

  test('accepts a known application once and removes it', () async {
    final accepted = Completer<void>();
    when(
      () => repository.actOnTeamApplication(
        id: 'application-1',
        action: .accept,
      ),
    ).thenAnswer((_) => accepted.future);
    final cubit = buildCubit()
      ..emit(
        const TeamApplicationsState(
          status: .ready,
          applications: [application],
        ),
      );

    final firstAction = cubit.act('application-1', .accept);
    expect(cubit.state.pendingIds, {'application-1'});
    expect(await cubit.act('application-1', .accept), isFalse);
    accepted.complete();
    expect(await firstAction, isTrue);
    expect(cubit.state.applications, isEmpty);
    verify(
      () => repository.actOnTeamApplication(
        id: 'application-1',
        action: .accept,
      ),
    ).called(1);
    await cubit.close();
  });

  test('tracks pendingRejectIds only for reject, not accept', () async {
    final acceptPending = Completer<void>();
    final rejectPending = Completer<void>();
    when(
      () => repository.actOnTeamApplication(
        id: 'application-1',
        action: .accept,
      ),
    ).thenAnswer((_) => acceptPending.future);
    when(
      () => repository.actOnTeamApplication(
        id: 'application-2',
        action: .reject,
      ),
    ).thenAnswer((_) => rejectPending.future);
    const application2 = TeamApplication(
      id: 'application-2',
      teamId: 'team-1',
      applicantId: 'user-2',
    );
    final cubit = buildCubit()
      ..emit(
        const TeamApplicationsState(
          status: .ready,
          applications: [application, application2],
        ),
      );

    final accept = cubit.act('application-1', .accept);
    expect(cubit.state.pendingIds, {'application-1'});
    expect(cubit.state.pendingRejectIds, isEmpty);

    final reject = cubit.act('application-2', .reject);
    expect(cubit.state.pendingIds, {'application-1', 'application-2'});
    expect(cubit.state.pendingRejectIds, {'application-2'});

    acceptPending.complete();
    rejectPending.complete();
    await accept;
    await reject;
    expect(cubit.state.pendingIds, isEmpty);
    expect(cubit.state.pendingRejectIds, isEmpty);
    await cubit.close();
  });

  test('retains an application when the action fails', () async {
    when(
      () => repository.actOnTeamApplication(
        id: 'application-1',
        action: .reject,
      ),
    ).thenThrow(Exception('offline'));
    final cubit = buildCubit()
      ..emit(
        const TeamApplicationsState(
          status: .ready,
          applications: [application],
        ),
      );

    expect(await cubit.act('application-1', .reject), isFalse);
    expect(cubit.state.applications, [application]);
    expect(cubit.state.pendingIds, isEmpty);
    await cubit.close();
  });

  test('rejects an unknown application without an RPC', () async {
    final cubit = buildCubit();

    expect(await cubit.act('missing', .accept), isFalse);
    verifyNever(
      () => repository.actOnTeamApplication(
        id: 'missing',
        action: .accept,
      ),
    );
    await cubit.close();
  });
}
