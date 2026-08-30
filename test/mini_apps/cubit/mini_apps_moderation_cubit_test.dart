import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_moderation_cubit.dart';

class MockMiniAppsRepository extends Mock implements MiniAppsRepository {}

void main() {
  const pendingApp = MiniApp(
    id: 'app-1',
    slug: 'poll',
    name: 'Опросы',
    status: MiniAppStatus.pendingReview,
  );
  const queue = MiniAppsModerationQueue(pending: [pendingApp]);

  group('MiniAppsModerationCubit', () {
    late MiniAppsRepository repository;

    setUpAll(() {
      registerFallbackValue(MiniAppModerationAction.approve);
    });

    setUp(() {
      repository = MockMiniAppsRepository();
      when(repository.getModerationQueue).thenAnswer((_) async => queue);
    });

    MiniAppsModerationCubit buildCubit() =>
        MiniAppsModerationCubit(miniAppsRepository: repository);

    group('load', () {
      blocTest<MiniAppsModerationCubit, MiniAppsModerationState>(
        'emits [loading, populated] with the queue',
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <MiniAppsModerationState>[
          MiniAppsModerationState(status: MiniAppsModerationStatus.loading),
          MiniAppsModerationState(
            status: MiniAppsModerationStatus.populated,
            queue: queue,
          ),
        ],
      );

      blocTest<MiniAppsModerationCubit, MiniAppsModerationState>(
        'emits [loading, failure] when the queue request fails',
        setUp: () => when(
          repository.getModerationQueue,
        ).thenThrow(const GetModerationQueueFailure('boom')),
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <MiniAppsModerationState>[
          MiniAppsModerationState(status: MiniAppsModerationStatus.loading),
          MiniAppsModerationState(status: MiniAppsModerationStatus.failure),
        ],
        errors: () => [isA<GetModerationQueueFailure>()],
      );
    });

    group('moderate', () {
      blocTest<MiniAppsModerationCubit, MiniAppsModerationState>(
        'marks the app as processing and reloads the queue on success',
        setUp: () => when(
          () => repository.moderateApp(
            appId: any(named: 'appId'),
            action: any(named: 'action'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async {}),
        build: buildCubit,
        act: (cubit) =>
            cubit.moderate(pendingApp, MiniAppModerationAction.approve),
        expect: () => const <MiniAppsModerationState>[
          MiniAppsModerationState(processingAppId: 'app-1'),
          MiniAppsModerationState(
            status: MiniAppsModerationStatus.loading,
            processingAppId: 'app-1',
          ),
          MiniAppsModerationState(
            status: MiniAppsModerationStatus.populated,
            queue: queue,
          ),
        ],
        verify: (_) => verify(
          () => repository.moderateApp(
            appId: 'app-1',
            action: MiniAppModerationAction.approve,
          ),
        ).called(1),
      );

      blocTest<MiniAppsModerationCubit, MiniAppsModerationState>(
        'resolveReports closes reports and reloads the queue',
        setUp: () => when(
          () => repository.resolveReports(
            appId: any(named: 'appId'),
            dismiss: any(named: 'dismiss'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async {}),
        build: buildCubit,
        act: (cubit) => cubit.resolveReports(pendingApp, dismiss: true),
        expect: () => const <MiniAppsModerationState>[
          MiniAppsModerationState(processingAppId: 'app-1'),
          MiniAppsModerationState(
            status: MiniAppsModerationStatus.loading,
            processingAppId: 'app-1',
          ),
          MiniAppsModerationState(
            status: MiniAppsModerationStatus.populated,
            queue: queue,
          ),
        ],
        verify: (_) => verify(
          () => repository.resolveReports(
            appId: 'app-1',
            dismiss: true,
          ),
        ).called(1),
      );

      blocTest<MiniAppsModerationCubit, MiniAppsModerationState>(
        'clears the processing flag and reports the error on failure',
        setUp: () => when(
          () => repository.moderateApp(
            appId: any(named: 'appId'),
            action: any(named: 'action'),
            notes: any(named: 'notes'),
          ),
        ).thenThrow(const ModerateMiniAppFailure('boom')),
        build: buildCubit,
        act: (cubit) =>
            cubit.moderate(pendingApp, MiniAppModerationAction.approve),
        expect: () => const <MiniAppsModerationState>[
          MiniAppsModerationState(processingAppId: 'app-1'),
          MiniAppsModerationState(),
        ],
        errors: () => [isA<ModerateMiniAppFailure>()],
      );
    });
  });
}
