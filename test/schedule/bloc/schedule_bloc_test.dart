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
      verify: (bloc) =>
          expect(bloc.state.selectedSchedule, isA<SelectedGroupSchedule>()),
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

    setUp(() {
      storage = MockStorage();
      when(() => storage.read(any())).thenReturn(null);
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      when(() => storage.delete(any())).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
      scheduleRepository = MockScheduleRepository();
      preferences = MockPreferencesRepository();
      widgetUpdater = MockScheduleWidgetUpdater();
      when(
        () => preferences.set(any(), any()),
      ).thenAnswer((_) async {});
      when(
        () => widgetUpdater.updateWidgetsFromSelectedSchedule(any()),
      ).thenAnswer((_) async {});
    });

    test('waits for the auth session before restoring the remote '
        'selection on a fresh install', () async {
      // Simulates the cold-start race: the session is not restored yet when
      // the bloc is created, and appears a few polls later.
      var authChecks = 0;
      when(() => preferences.hasAuthenticatedUser).thenAnswer((_) {
        authChecks += 1;
        return authChecks > 2;
      });
      when(() => preferences.get('selected_schedule')).thenAnswer(
        (_) async => UserPreferenceEntry(
          key: 'selected_schedule',
          value: const {'type': 'group', 'name': 'ИКБО-09-22'},
          revision: 1,
          updatedAt: DateTime(2026, 8, 13),
        ),
      );
      when(
        () => scheduleRepository.getSchedule(group: any(named: 'group')),
      ).thenAnswer(
        (_) async => const ScheduleResponse(data: []),
      );

      final bloc = ScheduleBloc(
        scheduleRepository: scheduleRepository,
        preferencesRepository: preferences,
        widgetUpdater: widgetUpdater,
        connectivityClient: MockConnectivityClient(),
        syncPolicy: () => SyncPolicy.always,
        authRetryDelay: Duration.zero,
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      verify(() => preferences.get('selected_schedule')).called(1);
      await bloc.close();
    });

    test('gives up quietly when the session never appears', () async {
      when(() => preferences.hasAuthenticatedUser).thenReturn(false);

      final bloc = ScheduleBloc(
        scheduleRepository: scheduleRepository,
        preferencesRepository: preferences,
        widgetUpdater: widgetUpdater,
        connectivityClient: MockConnectivityClient(),
        syncPolicy: () => SyncPolicy.always,
        authRetryDelay: Duration.zero,
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      verifyNever(() => preferences.get(any()));
      await bloc.close();
    });
  });
}
