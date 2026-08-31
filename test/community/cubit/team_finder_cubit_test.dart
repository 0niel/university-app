import 'dart:async';

import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/community.dart';

import '../../helpers/mocks/mock_campus_repository.dart';

void main() {
  late CampusRepository repository;
  const team = Team(id: 'team-1', title: 'Campus Crew');

  setUp(() => repository = MockCampusRepository());

  TeamFinderCubit buildCubit() => .new(repository);

  test('keeps cached teams when refresh fails', () async {
    when(() => repository.getTeams()).thenAnswer((_) async => [team]);
    final cubit = buildCubit();
    expect(await cubit.load(), isTrue);
    when(() => repository.getTeams()).thenThrow(Exception('offline'));

    expect(await cubit.load(), isFalse);
    expect(cubit.state.status, TeamFinderStatus.failure);
    expect(cubit.state.teams, [team]);
    await cubit.close();
  });

  test('ignores a superseded load', () async {
    final first = Completer<List<Team>>();
    var calls = 0;
    when(() => repository.getTeams()).thenAnswer(
      (_) => calls++ == 0 ? first.future : Future.value([team]),
    );
    final cubit = buildCubit();

    final loads = (cubit.load(), cubit.load());
    expect(await loads.$2, isTrue);
    first.complete(const []);
    expect(await loads.$1, isFalse);
    expect(cubit.state.teams, [team]);
    await cubit.close();
  });

  test('failed mutation settles a superseded refresh', () async {
    final refresh = Completer<List<Team>>();
    var loads = 0;
    when(() => repository.getTeams()).thenAnswer(
      (_) => loads++ == 0 ? Future.value([team]) : refresh.future,
    );
    when(() => repository.deleteTeam('team-1')).thenThrow(Exception('offline'));
    final cubit = buildCubit();
    await cubit.load();

    final pendingRefresh = cubit.load();
    expect(cubit.state.status == .loading, isTrue);
    expect(await cubit.delete('team-1'), isFalse);
    expect(cubit.state.status == .ready, isTrue);
    expect(cubit.state.teams, [team]);
    refresh.complete(const []);
    expect(await pendingRefresh, isFalse);
    await cubit.close();
  });

  test('normalizes create data and prevents duplicate submits', () async {
    final created = Completer<void>();
    when(
      () => repository.createTeam(
        title: 'Campus Crew',
        description: 'Build together',
        neededRoles: ['backend'],
        capacity: 20,
        kind: 'project',
        boost: true,
      ),
    ).thenAnswer((_) => created.future);
    when(() => repository.getTeams()).thenAnswer((_) async => [team]);
    final cubit = buildCubit();
    const draft = TeamDraft(
      title: ' Campus Crew ',
      description: ' Build together ',
      neededRoles: [' backend ', 'backend', ' '],
      capacity: 99,
      kind: ' project ',
      boost: true,
    );

    final firstCreate = cubit.create(draft);
    expect(await cubit.create(draft), isFalse);
    created.complete();
    expect(await firstCreate, isTrue);
    verify(
      () => repository.createTeam(
        title: 'Campus Crew',
        description: 'Build together',
        neededRoles: ['backend'],
        capacity: 20,
        kind: 'project',
        boost: true,
      ),
    ).called(1);
    await cubit.close();
  });

  test('locks one application and reloads lifecycle state', () async {
    final sent = Completer<void>();
    when(
      () => repository.applyToTeam(
        teamId: 'team-1',
        role: 'backend',
        message: 'Ready',
        attachProfile: false,
      ),
    ).thenAnswer((_) => sent.future);
    when(
      () => repository.getTeams(),
    ).thenAnswer((_) async => [team.copyWith(hasApplied: true)]);
    final cubit = buildCubit();
    const draft = TeamApplicationDraft(
      teamId: 'team-1',
      role: ' backend ',
      message: ' Ready ',
      attachProfile: false,
    );

    final firstApply = cubit.apply(draft);
    expect(cubit.state.pendingApplyIds, {'team-1'});
    expect(await cubit.apply(draft), isFalse);
    sent.complete();
    expect(await firstApply, isTrue);
    expect(cubit.state.pendingApplyIds, isEmpty);
    expect(cubit.state.teams.singleOrNull?.hasApplied, isTrue);
    await cubit.close();
  });

  test('withdraw uses the typed application action', () async {
    const appliedTeam = Team(
      id: 'team-1',
      title: 'Campus Crew',
      hasApplied: true,
      myApplicationId: 'application-1',
    );
    when(
      () => repository.actOnTeamApplication(
        id: 'application-1',
        action: .withdraw,
      ),
    ).thenAnswer((_) => Future.value());
    when(() => repository.getTeams()).thenAnswer((_) async => [team]);
    final cubit = buildCubit();

    expect(await cubit.withdraw(appliedTeam), isTrue);
    verify(
      () => repository.actOnTeamApplication(
        id: 'application-1',
        action: .withdraw,
      ),
    ).called(1);
    await cubit.close();
  });

  test('mine filter includes owned, member and pending teams', () {
    final state = TeamFinderState(
      teams: [
        team,
        team.copyWith(id: 'owned', isMine: true),
        team.copyWith(id: 'member', isMember: true),
        team.copyWith(id: 'pending', hasApplied: true),
      ],
      filterKey: 'mine',
    );

    expect(state.visibleTeams.map((item) => item.id), [
      'owned',
      'member',
      'pending',
    ]);
  });
}
