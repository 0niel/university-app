import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_runner_cubit.dart';

class MockMiniAppsRepository extends Mock implements MiniAppsRepository {}

void main() {
  const app = MiniApp(
    id: 'app-1',
    slug: 'poll',
    name: 'Опросы',
    status: MiniAppStatus.published,
  );
  const remoteApp = MiniApp(
    id: 'app-2',
    slug: 'poll',
    name: 'Опросы',
    status: MiniAppStatus.published,
    sourceKind: MiniAppSourceKind.remote,
    originUrl: 'https://poll.example.com',
    requestedPermissions: [MiniAppPermission.email, MiniAppPermission.group],
  );
  const screen = {'type': 'scaffold'};

  group('MiniAppRunnerCubit', () {
    late MiniAppsRepository repository;

    setUp(() {
      repository = MockMiniAppsRepository();
      when(() => repository.getApp('poll')).thenAnswer((_) async => app);
      when(
        () => repository.fetchScreen(
          slug: any(named: 'slug'),
          path: any(named: 'path'),
        ),
      ).thenAnswer((_) async => screen);
      when(() => repository.trackLaunch(any())).thenAnswer((_) async {});
      when(
        () => repository.readCachedScreen(
          slug: any(named: 'slug'),
          path: any(named: 'path'),
        ),
      ).thenAnswer((_) async => null);
      when(
        () => repository.readCachedStorage(any()),
      ).thenAnswer((_) async => null);
      when(
        () => repository.getStorage(any()),
      ).thenAnswer((_) async => const {});
    });

    MiniAppRunnerCubit buildCubit() =>
        MiniAppRunnerCubit(miniAppsRepository: repository, slug: 'poll');

    group('load', () {
      blocTest<MiniAppRunnerCubit, MiniAppRunnerState>(
        'emits [loading, ready] and tracks the launch',
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <MiniAppRunnerState>[
          MiniAppRunnerState(status: MiniAppRunnerStatus.loading),
          MiniAppRunnerState(
            status: MiniAppRunnerStatus.ready,
            app: app,
            screen: screen,
          ),
        ],
        verify: (_) => verify(() => repository.trackLaunch('app-1')).called(1),
      );

      blocTest<MiniAppRunnerCubit, MiniAppRunnerState>(
        'emits [loading, notFound] when the slug does not resolve',
        setUp: () => when(
          () => repository.getApp('poll'),
        ).thenAnswer((_) async => null),
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <MiniAppRunnerState>[
          MiniAppRunnerState(status: MiniAppRunnerStatus.loading),
          MiniAppRunnerState(status: MiniAppRunnerStatus.notFound),
        ],
      );

      blocTest<MiniAppRunnerCubit, MiniAppRunnerState>(
        'emits [loading, failure] when the proxy fetch fails',
        setUp: () => when(
          () => repository.fetchScreen(
            slug: any(named: 'slug'),
            path: any(named: 'path'),
          ),
        ).thenThrow(const FetchMiniAppScreenFailure('boom')),
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <MiniAppRunnerState>[
          MiniAppRunnerState(status: MiniAppRunnerStatus.loading),
          MiniAppRunnerState(status: MiniAppRunnerStatus.failure),
        ],
        errors: () => [isA<FetchMiniAppScreenFailure>()],
      );

      test(
        'keeps the newest screen when an older load finishes last',
        () async {
          const olderScreen = {'type': 'older'};
          const newerScreen = {'type': 'newer'};
          final older = Completer<Map<String, dynamic>>();
          final newer = Completer<Map<String, dynamic>>();
          var fetchCount = 0;
          when(
            () => repository.fetchScreen(
              slug: any(named: 'slug'),
              path: any(named: 'path'),
            ),
          ).thenAnswer((_) => fetchCount++ == 0 ? older.future : newer.future);
          final cubit = buildCubit();

          final olderLoad = cubit.load();
          await Future<void>.delayed(Duration.zero);
          final newerLoad = cubit.load();
          await Future<void>.delayed(Duration.zero);
          newer.complete(newerScreen);
          await newerLoad;
          older.complete(olderScreen);
          await olderLoad;

          expect(cubit.state.screen, newerScreen);
          verify(() => repository.trackLaunch('app-1')).called(1);
          await cubit.close();
        },
      );
    });

    group('screen cache', () {
      blocTest<MiniAppRunnerCubit, MiniAppRunnerState>(
        'renders the cached screen instantly, then the fresh one',
        setUp: () => when(
          () => repository.readCachedScreen(
            slug: any(named: 'slug'),
            path: any(named: 'path'),
          ),
        ).thenAnswer((_) async => const {'type': 'cached'}),
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <MiniAppRunnerState>[
          MiniAppRunnerState(status: MiniAppRunnerStatus.loading),
          MiniAppRunnerState(
            status: MiniAppRunnerStatus.ready,
            app: app,
            screen: {'type': 'cached'},
            fromCache: true,
          ),
          MiniAppRunnerState(
            status: MiniAppRunnerStatus.ready,
            app: app,
            screen: screen,
          ),
        ],
      );

      blocTest<MiniAppRunnerCubit, MiniAppRunnerState>(
        'keeps the cached screen when the refresh fails',
        setUp: () {
          when(
            () => repository.readCachedScreen(
              slug: any(named: 'slug'),
              path: any(named: 'path'),
            ),
          ).thenAnswer((_) async => const {'type': 'cached'});
          when(
            () => repository.fetchScreen(
              slug: any(named: 'slug'),
              path: any(named: 'path'),
            ),
          ).thenThrow(const FetchMiniAppScreenFailure('offline'));
        },
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <MiniAppRunnerState>[
          MiniAppRunnerState(status: MiniAppRunnerStatus.loading),
          MiniAppRunnerState(
            status: MiniAppRunnerStatus.ready,
            app: app,
            screen: {'type': 'cached'},
            fromCache: true,
          ),
        ],
      );
    });

    group('consent flow', () {
      blocTest<MiniAppRunnerCubit, MiniAppRunnerState>(
        'emits [loading, consentRequired] for an undecided remote app',
        setUp: () => when(
          () => repository.getApp('poll'),
        ).thenAnswer((_) async => remoteApp),
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <MiniAppRunnerState>[
          MiniAppRunnerState(status: MiniAppRunnerStatus.loading),
          MiniAppRunnerState(
            status: MiniAppRunnerStatus.consentRequired,
            app: remoteApp,
          ),
        ],
        verify: (_) => verifyNever(
          () => repository.fetchScreen(
            slug: any(named: 'slug'),
            path: any(named: 'path'),
          ),
        ),
      );

      blocTest<MiniAppRunnerCubit, MiniAppRunnerState>(
        'applyConsents stores the decision and continues the launch',
        setUp: () => when(
          () => repository.setConsents(
            appId: any(named: 'appId'),
            scopes: any(named: 'scopes'),
          ),
        ).thenAnswer((_) async {}),
        build: buildCubit,
        seed: () => const MiniAppRunnerState(
          status: MiniAppRunnerStatus.consentRequired,
          app: remoteApp,
        ),
        act: (cubit) => cubit.applyConsents(const [MiniAppPermission.email]),
        expect: () => [
          const MiniAppRunnerState(
            status: MiniAppRunnerStatus.loading,
            app: remoteApp,
          ),
          MiniAppRunnerState(
            status: MiniAppRunnerStatus.ready,
            app: remoteApp.copyWith(
              grantedPermissions: const [MiniAppPermission.email],
            ),
            screen: screen,
          ),
        ],
        verify: (_) => verify(
          () => repository.setConsents(
            appId: 'app-2',
            scopes: const [MiniAppPermission.email],
          ),
        ).called(1),
      );
    });

    group('updateConsents', () {
      blocTest<MiniAppRunnerCubit, MiniAppRunnerState>(
        'persists the new grants without reloading the screen',
        setUp: () => when(
          () => repository.setConsents(
            appId: any(named: 'appId'),
            scopes: any(named: 'scopes'),
          ),
        ).thenAnswer((_) async {}),
        build: buildCubit,
        seed: () => const MiniAppRunnerState(
          status: MiniAppRunnerStatus.ready,
          app: remoteApp,
          screen: screen,
        ),
        act: (cubit) => cubit.updateConsents(const [MiniAppPermission.group]),
        expect: () => [
          MiniAppRunnerState(
            status: MiniAppRunnerStatus.ready,
            app: remoteApp.copyWith(
              grantedPermissions: const [MiniAppPermission.group],
            ),
            screen: screen,
          ),
        ],
        verify: (_) => verifyNever(
          () => repository.fetchScreen(
            slug: any(named: 'slug'),
            path: any(named: 'path'),
          ),
        ),
      );
    });

    group('setStorageValue', () {
      blocTest<MiniAppRunnerCubit, MiniAppRunnerState>(
        'persists the key for the running app',
        setUp: () => when(
          () => repository.setStorageValue(
            appId: any(named: 'appId'),
            key: any(named: 'key'),
            value: any<Object?>(named: 'value'),
          ),
        ).thenAnswer((_) async {}),
        build: buildCubit,
        seed: () => const MiniAppRunnerState(
          status: MiniAppRunnerStatus.ready,
          app: app,
          screen: screen,
        ),
        act: (cubit) => cubit.setStorageValue('done', true),
        expect: () => const <MiniAppRunnerState>[],
        verify: (_) => verify(
          () => repository.setStorageValue(
            appId: 'app-1',
            key: 'done',
            value: true,
          ),
        ).called(1),
      );

      blocTest<MiniAppRunnerCubit, MiniAppRunnerState>(
        'reports a failed write instead of crashing the app',
        setUp: () => when(
          () => repository.setStorageValue(
            appId: any(named: 'appId'),
            key: any(named: 'key'),
            value: any<Object?>(named: 'value'),
          ),
        ).thenThrow(const MiniAppStorageFailure('boom')),
        build: buildCubit,
        seed: () => const MiniAppRunnerState(
          status: MiniAppRunnerStatus.ready,
          app: app,
          screen: screen,
        ),
        act: (cubit) => cubit.setStorageValue('done', true),
        expect: () => const <MiniAppRunnerState>[],
        errors: () => [isA<MiniAppStorageFailure>()],
      );
    });

    group('fetchPage', () {
      test('returns the page JSON from the proxy', () async {
        final cubit = buildCubit();
        final page = await cubit.fetchPage('/details');
        expect(page, equals(screen));
      });

      test('returns null when the proxy fails', () async {
        when(
          () => repository.fetchScreen(
            slug: any(named: 'slug'),
            path: any(named: 'path'),
          ),
        ).thenThrow(const FetchMiniAppScreenFailure('boom'));
        final cubit = buildCubit();
        expect(await cubit.fetchPage('/details'), isNull);
      });
    });
  });
}
