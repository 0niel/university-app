import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_submit_cubit.dart';

class MockMiniAppsRepository extends Mock implements MiniAppsRepository {}

void main() {
  group('MiniAppSubmitCubit', () {
    late MiniAppsRepository repository;

    setUpAll(() {
      registerFallbackValue(MiniAppCategory.other);
      registerFallbackValue(MiniAppSourceKind.hosted);
    });

    setUp(() {
      repository = MockMiniAppsRepository();
      when(
        () => repository.submitApp(
          slug: any(named: 'slug'),
          name: any(named: 'name'),
          description: any(named: 'description'),
          iconEmoji: any(named: 'iconEmoji'),
          category: any(named: 'category'),
          sourceKind: any(named: 'sourceKind'),
          originUrl: any(named: 'originUrl'),
          entryPath: any(named: 'entryPath'),
          screens: any(named: 'screens'),
          permissions: any(named: 'permissions'),
          asDraft: any(named: 'asDraft'),
        ),
      ).thenAnswer((_) async => 'app-1');
    });

    MiniAppSubmitCubit buildCubit() =>
        MiniAppSubmitCubit(miniAppsRepository: repository);

    test('parseScreenJson returns the map for a valid object', () {
      final cubit = buildCubit();
      expect(
        cubit.parseScreenJson('{"type": "scaffold"}'),
        equals({'type': 'scaffold'}),
      );
    });

    blocTest<MiniAppSubmitCubit, MiniAppSubmitState>(
      'parseScreenJson emits invalidJson for malformed text',
      build: buildCubit,
      act: (cubit) => cubit.parseScreenJson('not a json'),
      expect: () => const <MiniAppSubmitState>[
        MiniAppSubmitState(status: MiniAppSubmitStatus.invalidJson),
      ],
    );

    group('submit', () {
      blocTest<MiniAppSubmitCubit, MiniAppSubmitState>(
        'emits [submitting, success] for a valid hosted app',
        build: buildCubit,
        act: (cubit) => cubit.submit(
          slug: 'my-poll',
          name: 'Опросы',
          description: '',
          iconEmoji: '🗳',
          category: MiniAppCategory.social,
          sourceKind: MiniAppSourceKind.hosted,
          screens: const [
            MiniAppScreen(json: {'type': 'scaffold'}),
          ],
        ),
        expect: () => const <MiniAppSubmitState>[
          MiniAppSubmitState(status: MiniAppSubmitStatus.submitting),
          MiniAppSubmitState(status: MiniAppSubmitStatus.success),
        ],
      );

      blocTest<MiniAppSubmitCubit, MiniAppSubmitState>(
        'emits invalidFields for a bad slug',
        build: buildCubit,
        act: (cubit) => cubit.submit(
          slug: 'Опросы!!',
          name: 'Опросы',
          description: '',
          iconEmoji: '🗳',
          category: MiniAppCategory.social,
          sourceKind: MiniAppSourceKind.hosted,
          screens: const [
            MiniAppScreen(json: {'type': 'scaffold'}),
          ],
        ),
        expect: () => const <MiniAppSubmitState>[
          MiniAppSubmitState(status: MiniAppSubmitStatus.invalidFields),
        ],
      );

      blocTest<MiniAppSubmitCubit, MiniAppSubmitState>(
        'emits invalidScreens for duplicate screen paths',
        build: buildCubit,
        act: (cubit) => cubit.submit(
          slug: 'my-poll',
          name: 'Опросы',
          description: '',
          iconEmoji: '🗳',
          category: MiniAppCategory.social,
          sourceKind: MiniAppSourceKind.hosted,
          screens: const [
            MiniAppScreen(json: {'type': 'scaffold'}),
            MiniAppScreen(json: {'type': 'scaffold'}),
          ],
        ),
        expect: () => const <MiniAppSubmitState>[
          MiniAppSubmitState(status: MiniAppSubmitStatus.invalidScreens),
        ],
      );

      blocTest<MiniAppSubmitCubit, MiniAppSubmitState>(
        'emits invalidFields for a remote app without https origin',
        build: buildCubit,
        act: (cubit) => cubit.submit(
          slug: 'my-poll',
          name: 'Опросы',
          description: '',
          iconEmoji: '🗳',
          category: MiniAppCategory.social,
          sourceKind: MiniAppSourceKind.remote,
          originUrl: 'http://insecure.example.com',
        ),
        expect: () => const <MiniAppSubmitState>[
          MiniAppSubmitState(status: MiniAppSubmitStatus.invalidFields),
        ],
      );

      blocTest<MiniAppSubmitCubit, MiniAppSubmitState>(
        'emits [submitting, failure] when the repository throws',
        setUp: () => when(
          () => repository.submitApp(
            slug: any(named: 'slug'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            iconEmoji: any(named: 'iconEmoji'),
            category: any(named: 'category'),
            sourceKind: any(named: 'sourceKind'),
            originUrl: any(named: 'originUrl'),
            entryPath: any(named: 'entryPath'),
            screens: any(named: 'screens'),
            permissions: any(named: 'permissions'),
            asDraft: any(named: 'asDraft'),
          ),
        ).thenThrow(const SubmitMiniAppFailure('slug taken')),
        build: buildCubit,
        act: (cubit) => cubit.submit(
          slug: 'my-poll',
          name: 'Опросы',
          description: '',
          iconEmoji: '🗳',
          category: MiniAppCategory.social,
          sourceKind: MiniAppSourceKind.hosted,
          screens: const [
            MiniAppScreen(json: {'type': 'scaffold'}),
          ],
        ),
        expect: () => const <MiniAppSubmitState>[
          MiniAppSubmitState(status: MiniAppSubmitStatus.submitting),
          MiniAppSubmitState(status: MiniAppSubmitStatus.failure),
        ],
        errors: () => [isA<SubmitMiniAppFailure>()],
      );
    });
  });
}
