import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_client/connectivity_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rtu_mirea_app/profile/cubit/sync_preferences_cubit.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/utils/schedule_widget_updater.dart';
import 'package:schedule_repository/schedule_repository.dart';

class MockScheduleRepository extends Mock implements ScheduleRepository {}

class MockPreferencesRepository extends Mock implements PreferencesRepository {}

class MockScheduleWidgetUpdater extends Mock implements ScheduleWidgetUpdater {}

class MockConnectivityClient extends Mock implements ConnectivityClient {}

class MockStorage extends Mock implements Storage {}

void main() {
  group('ScheduleBloc offline handling', () {
    late ScheduleRepository scheduleRepository;
    late ScheduleWidgetUpdater widgetUpdater;
    late Storage storage;

    const group = Group(name: 'ИКБО-09-22');
    final lesson = LessonSchedulePart(
      subject: 'Машинное обучение',
      lessonType: LessonType.practice,
      teachers: const [],
      classrooms: const [],
      lessonBells: LessonBells(
        startTime: const TimeOfDay(hour: 10, minute: 40),
        endTime: const TimeOfDay(hour: 12, minute: 10),
      ),
      dates: [DateTime(2026, 5, 20)],
    );
    final cached = SelectedGroupSchedule(group: group, schedule: [lesson]);
    final lastSynced = DateTime(2026, 5, 20, 9, 12);

    setUpAll(() {
      registerFallbackValue(cached);
    });

    setUp(() {
      storage = MockStorage();
      when(() => storage.read(any())).thenReturn(null);
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      when(() => storage.delete(any())).thenAnswer((_) async {});
      HydratedBloc.storage = storage;

      scheduleRepository = MockScheduleRepository();
      widgetUpdater = MockScheduleWidgetUpdater();
      when(
        () => widgetUpdater.updateWidgetsFromSelectedSchedule(any()),
      ).thenAnswer((_) async {});
    });

    ScheduleBloc buildBloc() => ScheduleBloc(
      scheduleRepository: scheduleRepository,
      widgetUpdater: widgetUpdater,
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'a successful load records lastSyncedAt and clears isOffline',
      setUp: () => when(
        () => scheduleRepository.getSchedule(group: any(named: 'group')),
      ).thenAnswer((_) async => ScheduleResponse(data: [lesson])),
      build: buildBloc,
      act: (bloc) => bloc.add(const ScheduleRequested(group: group)),
      expect: () => [
        isA<ScheduleState>().having(
          (s) => s.status,
          'status',
          ScheduleStatus.loading,
        ),
        isA<ScheduleState>()
            .having((s) => s.status, 'status', ScheduleStatus.loaded)
            .having((s) => s.isOffline, 'isOffline', isFalse)
            .having((s) => s.lastSyncedAt, 'lastSyncedAt', isNotNull),
      ],
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'refresh without a selected schedule completes the initial state',
      build: buildBloc,
      act: (bloc) => bloc.add(const SelectedScheduleRefreshRequested()),
      expect: () => [
        isA<ScheduleState>().having(
          (state) => state.status,
          'status',
          ScheduleStatus.loaded,
        ),
      ],
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'records a per-schedule sync time on a successful load',
      setUp: () => when(
        () => scheduleRepository.getSchedule(group: any(named: 'group')),
      ).thenAnswer((_) async => ScheduleResponse(data: [lesson])),
      build: buildBloc,
      act: (bloc) => bloc.add(const ScheduleRequested(group: group)),
      verify: (bloc) => expect(
        bloc.state.scheduleSyncedAt.containsKey('ИКБО-09-22'),
        isTrue,
      ),
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'ScheduleRequested(makeActive: false) saves the group but keeps the '
      'currently active schedule',
      setUp: () => when(
        () => scheduleRepository.getSchedule(group: any(named: 'group')),
      ).thenAnswer((_) async => ScheduleResponse(data: [lesson])),
      build: buildBloc,
      seed: () => ScheduleState(
        status: ScheduleStatus.loaded,
        selectedSchedule: SelectedTeacherSchedule(
          teacher: const Teacher(name: 'Соколова М. В.'),
          schedule: [lesson],
        ),
      ),
      act: (bloc) =>
          bloc.add(const ScheduleRequested(group: group, makeActive: false)),
      verify: (bloc) {
        expect(
          bloc.state.groupsSchedule.map((e) => e.$1),
          contains('ИКБО-09-22'),
        );
        expect(bloc.state.selectedSchedule, isA<SelectedTeacherSchedule>());
      },
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'ScheduleRequested(makeActive: false) still activates the first schedule '
      'when none is selected yet',
      setUp: () => when(
        () => scheduleRepository.getSchedule(group: any(named: 'group')),
      ).thenAnswer((_) async => ScheduleResponse(data: [lesson])),
      build: buildBloc,
      act: (bloc) =>
          bloc.add(const ScheduleRequested(group: group, makeActive: false)),
      verify: (bloc) => expect(
        bloc.state.selectedSchedule,
        isA<SelectedGroupSchedule>().having(
          (selected) => selected.schedule,
          'loaded schedule',
          [lesson],
        ),
      ),
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'ScheduleReordered moves a saved group to the requested position',
      build: buildBloc,
      seed: () => ScheduleState(
        status: ScheduleStatus.loaded,
        groupsSchedule: [
          ('a', const Group(name: 'ИКБО-01-22'), [lesson]),
          ('b', const Group(name: 'ИКБО-02-22'), [lesson]),
          ('c', const Group(name: 'ИКБО-03-22'), [lesson]),
        ],
      ),
      act: (bloc) => bloc.add(
        const ScheduleReordered(
          target: ScheduleTarget.group,
          orderedIds: ['c', 'a', 'b'],
        ),
      ),
      verify: (bloc) => expect(
        bloc.state.groupsSchedule.map((e) => e.$1).toList(),
        ['c', 'a', 'b'],
      ),
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'ScheduleDeleteRequested drops the schedule and its sync timestamp',
      build: buildBloc,
      seed: () => ScheduleState(
        status: ScheduleStatus.loaded,
        groupsSchedule: [
          ('a', const Group(name: 'ИКБО-01-22'), [lesson]),
        ],
        scheduleSyncedAt: {'a': lastSynced},
      ),
      act: (bloc) => bloc.add(
        const ScheduleDeleteRequested(
          identifier: 'a',
          target: ScheduleTarget.group,
        ),
      ),
      verify: (bloc) {
        expect(bloc.state.groupsSchedule, isEmpty);
        expect(bloc.state.scheduleSyncedAt.containsKey('a'), isFalse);
      },
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'a failed refresh with cached lessons keeps the schedule, sets isOffline '
      'and preserves the last sync time',
      setUp: () => when(
        () => scheduleRepository.getSchedule(group: any(named: 'group')),
      ).thenThrow(Exception('no network')),
      build: buildBloc,
      seed: () => ScheduleState(
        status: ScheduleStatus.loaded,
        selectedSchedule: cached,
        lastSyncedAt: lastSynced,
      ),
      act: (bloc) => bloc.add(const SelectedScheduleRefreshRequested()),
      expect: () => [
        isA<ScheduleState>()
            .having((s) => s.status, 'status', ScheduleStatus.loaded)
            .having((s) => s.isOffline, 'isOffline', isTrue)
            .having(
              (s) => s.selectedSchedule?.schedule,
              'cached schedule kept',
              isNotEmpty,
            )
            .having(
              (s) => s.lastSyncedAt,
              'lastSyncedAt preserved',
              lastSynced,
            ),
      ],
      errors: () => [isA<Exception>()],
    );
  });

  group('ScheduleBloc sync policy gate', () {
    late ScheduleRepository scheduleRepository;
    late ScheduleWidgetUpdater widgetUpdater;
    late ConnectivityClient connectivity;
    late Storage storage;

    const group = Group(name: 'ИКБО-09-22');
    final lesson = LessonSchedulePart(
      subject: 'Машинное обучение',
      lessonType: LessonType.practice,
      teachers: const [],
      classrooms: const [],
      lessonBells: LessonBells(
        startTime: const TimeOfDay(hour: 10, minute: 40),
        endTime: const TimeOfDay(hour: 12, minute: 10),
      ),
      dates: [DateTime(2026, 5, 20)],
    );
    final cached = SelectedGroupSchedule(group: group, schedule: [lesson]);

    setUpAll(() => registerFallbackValue(cached));

    setUp(() {
      storage = MockStorage();
      when(() => storage.read(any())).thenReturn(null);
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      when(() => storage.delete(any())).thenAnswer((_) async {});
      HydratedBloc.storage = storage;

      scheduleRepository = MockScheduleRepository();
      widgetUpdater = MockScheduleWidgetUpdater();
      connectivity = MockConnectivityClient();
      when(
        () => widgetUpdater.updateWidgetsFromSelectedSchedule(any()),
      ).thenAnswer((_) async {});
      when(
        () => scheduleRepository.getSchedule(group: any(named: 'group')),
      ).thenAnswer((_) async => ScheduleResponse(data: [lesson]));
    });

    ScheduleBloc buildBloc(SyncPolicy policy) => ScheduleBloc(
      scheduleRepository: scheduleRepository,
      widgetUpdater: widgetUpdater,
      connectivityClient: connectivity,
      syncPolicy: () => policy,
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'wifiOnly on mobile skips the network for an automatic refresh',
      setUp: () =>
          when(connectivity.hasWifiOrEthernet).thenAnswer((_) async => false),
      build: () => buildBloc(SyncPolicy.wifiOnly),
      seed: () => ScheduleState(
        status: ScheduleStatus.loaded,
        selectedSchedule: cached,
      ),
      act: (bloc) => bloc.add(const SelectedScheduleRefreshRequested()),
      verify: (_) {
        verifyNever(
          () => scheduleRepository.getSchedule(group: any(named: 'group')),
        );
      },
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'a manual refresh hits the network even under manualOnly',
      build: () => buildBloc(SyncPolicy.manualOnly),
      seed: () => ScheduleState(
        status: ScheduleStatus.loaded,
        selectedSchedule: cached,
      ),
      act: (bloc) =>
          bloc.add(const SelectedScheduleRefreshRequested(manual: true)),
      verify: (_) {
        verify(
          () => scheduleRepository.getSchedule(group: any(named: 'group')),
        ).called(1);
      },
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'wifiOnly on Wi-Fi allows an automatic refresh',
      setUp: () =>
          when(connectivity.hasWifiOrEthernet).thenAnswer((_) async => true),
      build: () => buildBloc(SyncPolicy.wifiOnly),
      seed: () => ScheduleState(
        status: ScheduleStatus.loaded,
        selectedSchedule: cached,
      ),
      act: (bloc) => bloc.add(const SelectedScheduleRefreshRequested()),
      verify: (_) {
        verify(
          () => scheduleRepository.getSchedule(group: any(named: 'group')),
        ).called(1);
      },
    );
  });

  group('ScheduleBloc remote selection restore', () {
    late ScheduleRepository scheduleRepository;
    late PreferencesRepository preferences;
    late ScheduleWidgetUpdater widgetUpdater;
    late Storage storage;
    late StreamController<String?> authChanges;
    String? currentUserId;

    UserPreferenceEntry remoteGroup(String name) => UserPreferenceEntry(
      key: 'selected_schedule',
      value: {'type': 'group', 'name': name},
      revision: 1,
      updatedAt: DateTime.utc(2026),
    );

    ScheduleBloc buildBloc() => ScheduleBloc(
      scheduleRepository: scheduleRepository,
      preferencesRepository: preferences,
      widgetUpdater: widgetUpdater,
    );

    Future<void> signIn(String? userId) async {
      currentUserId = userId;
      authChanges.add(userId);
      await pumpEventQueue();
    }

    setUp(() {
      currentUserId = null;
      authChanges = StreamController<String?>.broadcast();
      storage = MockStorage();
      when(() => storage.read(any())).thenReturn(null);
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      when(() => storage.delete(any())).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
      scheduleRepository = MockScheduleRepository();
      preferences = MockPreferencesRepository();
      widgetUpdater = MockScheduleWidgetUpdater();
      when(() => preferences.currentUserId).thenAnswer((_) => currentUserId);
      when(
        () => preferences.userIdChanges,
      ).thenAnswer((_) => authChanges.stream);
      when(() => preferences.get(any())).thenAnswer((_) async => null);
      when(() => preferences.set(any(), any())).thenAnswer((_) async {});
      when(
        () => scheduleRepository.getSchedule(group: any(named: 'group')),
      ).thenAnswer((_) async => const ScheduleResponse(data: []));
      when(
        () => widgetUpdater.updateWidgetsFromSelectedSchedule(any()),
      ).thenAnswer((_) async {});
    });

    tearDown(() async {
      await authChanges.close();
    });

    test('restores a group when login happens after startup', () async {
      when(
        () => preferences.get('selected_schedule'),
      ).thenAnswer((_) async => remoteGroup('GROUP-A'));
      final bloc = buildBloc();
      await pumpEventQueue();
      verifyNever(() => preferences.get(any()));

      await signIn('user-a');

      expect(
        bloc.state.selectedSchedule,
        isA<SelectedGroupSchedule>().having(
          (s) => s.group.name,
          'group',
          'GROUP-A',
        ),
      );
      expect(bloc.state.groupsSchedule.single.$2.name, 'GROUP-A');
      verify(() => preferences.get('selected_schedule')).called(1);
      verifyNever(() => preferences.set(any(), any()));
      await bloc.close();
    });

    test('keeps the restored group when its schedule cannot load', () async {
      currentUserId = 'user-a';
      when(
        () => preferences.get('selected_schedule'),
      ).thenAnswer((_) async => remoteGroup('GROUP-A'));
      when(
        () => scheduleRepository.getSchedule(group: any(named: 'group')),
      ).thenThrow(Exception('offline'));
      final bloc = buildBloc();
      await pumpEventQueue();

      expect(
        bloc.state.selectedSchedule,
        isA<SelectedGroupSchedule>().having(
          (s) => s.group.name,
          'group',
          'GROUP-A',
        ),
      );
      expect(bloc.toJson(bloc.state)['selectionOwnerId'], 'user-a');
      await bloc.close();
    });

    test('ignores malformed remote selection values', () async {
      currentUserId = 'user-a';
      when(() => preferences.get('selected_schedule')).thenAnswer(
        (_) async => UserPreferenceEntry(
          key: 'selected_schedule',
          value: const {'type': 'group', 'name': 42},
          revision: 1,
          updatedAt: DateTime.utc(2026),
        ),
      );
      final bloc = buildBloc();
      await pumpEventQueue();

      expect(bloc.state.selectedSchedule, isNull);
      verifyNever(
        () => scheduleRepository.getSchedule(group: any(named: 'group')),
      );
      await bloc.close();
    });

    test('ignores a remote response from an account that signed out', () async {
      final firstResponse = Completer<UserPreferenceEntry?>();
      currentUserId = 'user-a';
      when(() => preferences.get('selected_schedule')).thenAnswer(
        (_) => currentUserId == 'user-a'
            ? firstResponse.future
            : Future.value(remoteGroup('GROUP-B')),
      );
      final bloc = buildBloc();
      await pumpEventQueue();
      await signIn('user-b');
      firstResponse.complete(remoteGroup('GROUP-A'));
      await pumpEventQueue();

      expect(
        bloc.state.selectedSchedule,
        isA<SelectedGroupSchedule>().having(
          (s) => s.group.name,
          'group',
          'GROUP-B',
        ),
      );
      verifyNever(() => scheduleRepository.getSchedule(group: 'GROUP-A'));
      await bloc.close();
    });

    test(
      'restores local state with a stable key and backs it up on login',
      () async {
        const localState = ScheduleState(
          selectedSchedule: SelectedGroupSchedule(
            group: Group(name: 'LOCAL'),
            schedule: [],
          ),
        );
        when(() => storage.read('ScheduleBloc')).thenReturn({
          ...localState.toJson(),
          'selectionOwnerId': 'user-a',
        });
        final bloc = buildBloc();
        await signIn('user-a');

        expect(bloc.state.selectedSchedule, localState.selectedSchedule);
        verify(() => storage.read('ScheduleBloc')).called(1);
        verify(
          () => preferences.set('selected_schedule', {
            'type': 'group',
            'name': 'LOCAL',
            'uid': null,
          }),
        ).called(1);
        verifyNever(() => preferences.get(any()));
        await bloc.close();
      },
    );

    test('does not upload a cached group to a different account', () async {
      when(() => storage.read(any())).thenReturn({
        ...const ScheduleState(
          selectedSchedule: SelectedGroupSchedule(
            group: Group(name: 'GROUP-A'),
            schedule: [],
          ),
        ).toJson(),
        'selectionOwnerId': 'user-a',
      });
      currentUserId = 'user-b';
      when(
        () => preferences.get('selected_schedule'),
      ).thenAnswer((_) async => remoteGroup('GROUP-B'));
      final bloc = buildBloc();
      await pumpEventQueue();

      expect(
        bloc.state.selectedSchedule,
        isA<SelectedGroupSchedule>().having(
          (s) => s.group.name,
          'group',
          'GROUP-B',
        ),
      );
      verifyNever(() => preferences.set(any(), any()));
      await bloc.close();
    });

    test('retries a failed write on the next schedule refresh', () async {
      currentUserId = 'user-a';
      var writes = 0;
      var offline = true;
      when(() => preferences.set(any(), any())).thenAnswer((_) async {
        writes += 1;
        if (offline) throw SetPreferenceFailure(Exception('offline'));
      });
      final bloc = buildBloc();
      await pumpEventQueue();
      bloc.add(const ScheduleRequested(group: Group(name: 'GROUP-A')));
      await pumpEventQueue();
      expect(writes, 2);

      offline = false;
      bloc.add(const SelectedScheduleRefreshRequested());
      await pumpEventQueue();
      expect(writes, 3);
      bloc.add(const SelectedScheduleRefreshRequested());
      await pumpEventQueue();
      expect(writes, 3);
      await bloc.close();
    });

    test('serializes preference writes so the final selection wins', () async {
      currentUserId = 'user-a';
      final firstWrite = Completer<void>();
      final writtenGroups = <String>[];
      when(() => preferences.set(any(), any())).thenAnswer((invocation) async {
        final value = invocation.positionalArguments[1] as Map<String, dynamic>;
        writtenGroups.add(value['name'] as String);
        if (writtenGroups.length == 1) await firstWrite.future;
      });
      final bloc = buildBloc();
      await pumpEventQueue();
      bloc.add(const ScheduleRequested(group: Group(name: 'GROUP-A')));
      await pumpEventQueue();
      bloc.add(const ScheduleRequested(group: Group(name: 'GROUP-B')));
      await pumpEventQueue();
      expect(writtenGroups, ['GROUP-A']);

      firstWrite.complete();
      await pumpEventQueue();
      expect(writtenGroups, ['GROUP-A', 'GROUP-B']);
      await bloc.close();
    });

    test('ignores an old schedule load after the account changes', () async {
      currentUserId = 'user-a';
      final firstSchedule = Completer<ScheduleResponse>();
      when(
        () => scheduleRepository.getSchedule(group: 'GROUP-A'),
      ).thenAnswer((_) => firstSchedule.future);
      final bloc = buildBloc();
      await pumpEventQueue();
      bloc.add(const ScheduleRequested(group: Group(name: 'GROUP-A')));
      await pumpEventQueue();
      await signIn('user-b');
      firstSchedule.complete(const ScheduleResponse(data: []));
      await pumpEventQueue();

      expect(bloc.state.selectedSchedule, isNull);
      verify(
        () => preferences.set('selected_schedule', {
          'type': 'group',
          'name': 'GROUP-A',
          'uid': null,
        }),
      ).called(1);
      await bloc.close();
    });

    test(
      'a pending write cannot suppress returning to the saved group',
      () async {
        currentUserId = 'user-a';
        final pendingWrite = Completer<void>();
        final writtenGroups = <String>[];
        when(() => preferences.set(any(), any())).thenAnswer((
          invocation,
        ) async {
          final value =
              invocation.positionalArguments[1] as Map<String, dynamic>;
          final group = value['name'] as String;
          writtenGroups.add(group);
          if (group == 'GROUP-B') await pendingWrite.future;
        });
        final bloc = buildBloc();
        await pumpEventQueue();
        bloc.add(const ScheduleRequested(group: Group(name: 'GROUP-A')));
        await pumpEventQueue();
        bloc.add(const ScheduleRequested(group: Group(name: 'GROUP-B')));
        await pumpEventQueue();
        bloc.add(const ScheduleRequested(group: Group(name: 'GROUP-A')));
        await pumpEventQueue();
        pendingWrite.complete();
        await pumpEventQueue();

        expect(writtenGroups, ['GROUP-A', 'GROUP-B', 'GROUP-A']);
        await bloc.close();
      },
    );

    test(
      'a restored schedule cannot overwrite a newer manual choice',
      () async {
        currentUserId = 'user-a';
        final remoteSchedule = Completer<ScheduleResponse>();
        when(
          () => preferences.get('selected_schedule'),
        ).thenAnswer((_) async => remoteGroup('GROUP-A'));
        when(
          () => scheduleRepository.getSchedule(group: 'GROUP-A'),
        ).thenAnswer((_) => remoteSchedule.future);
        final bloc = buildBloc();
        await pumpEventQueue();
        bloc.add(const ScheduleRequested(group: Group(name: 'GROUP-B')));
        await pumpEventQueue();
        remoteSchedule.complete(const ScheduleResponse(data: []));
        await pumpEventQueue();

        expect(
          bloc.state.selectedSchedule,
          isA<SelectedGroupSchedule>().having(
            (s) => s.group.name,
            'group',
            'GROUP-B',
          ),
        );
        verify(
          () => preferences.set('selected_schedule', {
            'type': 'group',
            'name': 'GROUP-B',
            'uid': null,
          }),
        ).called(1);
        verifyNever(
          () => preferences.set('selected_schedule', {
            'type': 'group',
            'name': 'GROUP-A',
            'uid': null,
          }),
        );
        await bloc.close();
      },
    );

    test('prefers the server group over an unowned legacy selection', () async {
      when(() => storage.read(any())).thenReturn(
        const ScheduleState(
          selectedSchedule: SelectedGroupSchedule(
            group: Group(name: 'LEGACY'),
            schedule: [],
          ),
        ).toJson(),
      );
      currentUserId = 'user-b';
      when(
        () => preferences.get('selected_schedule'),
      ).thenAnswer((_) async => remoteGroup('GROUP-B'));
      final bloc = buildBloc();
      await pumpEventQueue();

      expect(
        bloc.state.selectedSchedule,
        isA<SelectedGroupSchedule>().having(
          (s) => s.group.name,
          'group',
          'GROUP-B',
        ),
      );
      verifyNever(() => preferences.set(any(), any()));
      await bloc.close();
    });

    test(
      'persists ownership even when adopting an unchanged local group',
      () async {
        const legacy = ScheduleState(
          selectedSchedule: SelectedGroupSchedule(
            group: Group(name: 'LEGACY'),
            schedule: [],
          ),
        );
        when(() => storage.read(any())).thenReturn(legacy.toJson());
        currentUserId = 'user-a';
        final bloc = buildBloc();
        await pumpEventQueue();

        final saved = verify(
          () => storage.write('ScheduleBloc', captureAny<dynamic>()),
        ).captured.cast<Map<String, dynamic>>();
        expect(saved.last['selectionOwnerId'], 'user-a');
        expect(bloc.state.selectedSchedule, legacy.selectedSchedule);
        verify(() => preferences.get('selected_schedule')).called(1);
        await bloc.close();
      },
    );

    test(
      'backs up a manual choice after the initial preference read fails',
      () async {
        currentUserId = 'user-a';
        when(
          () => preferences.get(any()),
        ).thenThrow(GetPreferencesFailure(Exception('offline')));
        final bloc = buildBloc();
        await pumpEventQueue();
        bloc.add(const ScheduleRequested(group: Group(name: 'GROUP-B')));
        await pumpEventQueue();

        expect(bloc.toJson(bloc.state)['selectionOwnerId'], 'user-a');
        verify(
          () => preferences.set('selected_schedule', {
            'type': 'group',
            'name': 'GROUP-B',
            'uid': null,
          }),
        ).called(1);
        await bloc.close();
      },
    );

    test(
      'remembers an explicit group when the schedule service is offline',
      () async {
        currentUserId = 'user-a';
        when(
          () => scheduleRepository.getSchedule(group: 'GROUP-B'),
        ).thenThrow(Exception('schedule unavailable'));
        final bloc = buildBloc();
        await pumpEventQueue();
        bloc.add(const ScheduleRequested(group: Group(name: 'GROUP-B')));
        await pumpEventQueue();

        expect(
          bloc.state.selectedSchedule,
          isA<SelectedGroupSchedule>().having(
            (s) => s.group.name,
            'group',
            'GROUP-B',
          ),
        );
        expect(bloc.state.groupsSchedule.single.$2.name, 'GROUP-B');
        verify(
          () => preferences.set('selected_schedule', {
            'type': 'group',
            'name': 'GROUP-B',
            'uid': null,
          }),
        ).called(1);
        await bloc.close();
      },
    );

    test('cancels its auth listener on close', () async {
      final bloc = buildBloc();
      await bloc.close();
      expect(authChanges.hasListener, isFalse);
      await signIn('user-a');
      verifyNever(() => preferences.get(any()));
    });
  });
}
