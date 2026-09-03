import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/knowledge_bank/knowledge_bank.dart';

class MockCampusRepository extends Mock implements CampusRepository {}

class MockGamificationRepository extends Mock
    implements GamificationRepository {}

void main() {
  setUpAll(
    () => registerFallbackValue(
      const StudyMaterial(id: 'fallback', title: 'Fallback'),
    ),
  );

  group('KnowledgeBankCubit', () {
    late CampusRepository campusRepository;
    late GamificationRepository gamificationRepository;

    const profile = UserGamificationProfile(
      userId: 'user-1',
      xp: 120,
      level: 3,
      shurikens: 42,
      streakDays: 5,
    );
    const note = StudyMaterial(
      id: 'm-1',
      title: 'Конспект по матану',
      downloads: 3,
      fileName: 'math.pdf',
      hasFile: true,
    );
    const cheatsheet = StudyMaterial(
      id: 'm-2',
      title: 'Шпора по физике',
      materialType: 'cheatsheet',
      downloads: 7,
    );
    const author = MaterialAuthor(name: 'Аня', downloads: 10, materials: 2);

    setUp(() {
      campusRepository = MockCampusRepository();
      gamificationRepository = MockGamificationRepository();
      when(
        () => gamificationRepository.getProfile(),
      ).thenAnswer((_) async => profile);
      when(
        () => campusRepository.getPublicMaterials(),
      ).thenAnswer((_) async => const [note, cheatsheet]);
      when(
        () => campusRepository.getTopMaterialAuthors(),
      ).thenAnswer((_) async => const [author]);
      when(
        () => campusRepository.incrementMaterialDownloads(any()),
      ).thenAnswer((_) async {});
      when(
        () => campusRepository.createPublicMaterialUrl(any()),
      ).thenAnswer(
        (_) async => 'https://project.supabase.co/storage/material.pdf',
      );
    });

    KnowledgeBankCubit buildCubit() => KnowledgeBankCubit(
      campusRepository: campusRepository,
      gamificationRepository: gamificationRepository,
    );

    test('initial state is KnowledgeBankState with initial status', () {
      expect(buildCubit().state, equals(const KnowledgeBankState()));
    });

    group('load', () {
      blocTest<KnowledgeBankCubit, KnowledgeBankState>(
        'emits [loading, populated] when every source succeeds',
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <KnowledgeBankState>[
          KnowledgeBankState(status: KnowledgeBankStatus.loading),
          KnowledgeBankState(
            status: KnowledgeBankStatus.populated,
            profile: profile,
            materials: [note, cheatsheet],
            authors: [author],
          ),
        ],
        verify: (_) {
          verify(() => gamificationRepository.getProfile()).called(1);
          verify(() => campusRepository.getPublicMaterials()).called(1);
          verify(() => campusRepository.getTopMaterialAuthors()).called(1);
        },
      );

      blocTest<KnowledgeBankCubit, KnowledgeBankState>(
        'reports a material loading failure while keeping secondary sources',
        setUp: () =>
            when(
              () => campusRepository.getPublicMaterials(),
            ).thenAnswer(
              (_) => Future<List<StudyMaterial>>.error(
                Exception('materials down'),
              ),
            ),
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <KnowledgeBankState>[
          KnowledgeBankState(status: KnowledgeBankStatus.loading),
          KnowledgeBankState(
            status: KnowledgeBankStatus.failure,
            profile: profile,
            authors: [author],
          ),
        ],
        errors: () => [isA<Exception>()],
      );

      test('ignores a load that completes after disposal', () async {
        final response = Completer<List<StudyMaterial>>();
        when(
          () => campusRepository.getPublicMaterials(),
        ).thenAnswer((_) => response.future);
        final cubit = buildCubit();
        final loading = cubit.load();
        await cubit.close();
        response.complete([note]);
        await loading;
        expect(cubit.isClosed, isTrue);
      });

      test('a stale load cannot replace the latest material list', () async {
        final old = Completer<List<StudyMaterial>>();
        final latest = Completer<List<StudyMaterial>>();
        var calls = 0;
        when(() => campusRepository.getPublicMaterials()).thenAnswer(
          (_) => calls++ == 0 ? old.future : latest.future,
        );
        final cubit = buildCubit();
        addTearDown(cubit.close);
        final first = cubit.load();
        final second = cubit.load();
        latest.complete([cheatsheet]);
        await second;
        old.complete([note]);
        await first;
        expect(cubit.state.materials, [cheatsheet]);
      });

      blocTest<KnowledgeBankCubit, KnowledgeBankState>(
        'preserves cached data and emits failure when every source fails',
        setUp: () {
          when(
            () => gamificationRepository.getProfile(),
          ).thenAnswer((_) async => throw Exception('profile down'));
          when(
            () => campusRepository.getPublicMaterials(),
          ).thenAnswer((_) async => throw Exception('materials down'));
          when(
            () => campusRepository.getTopMaterialAuthors(),
          ).thenAnswer((_) async => throw Exception('authors down'));
        },
        build: buildCubit,
        seed: () => const KnowledgeBankState(
          status: KnowledgeBankStatus.populated,
          profile: profile,
          materials: [note],
          authors: [author],
        ),
        act: (cubit) => cubit.load(),
        expect: () => const [
          KnowledgeBankState(
            status: KnowledgeBankStatus.loading,
            profile: profile,
            materials: [note],
            authors: [author],
          ),
          KnowledgeBankState(
            status: KnowledgeBankStatus.failure,
            profile: profile,
            materials: [note],
            authors: [author],
          ),
        ],
        errors: () => [isA<Exception>(), isA<Exception>(), isA<Exception>()],
      );
    });

    group('typeChanged', () {
      blocTest<KnowledgeBankCubit, KnowledgeBankState>(
        'emits the new material type filter',
        build: buildCubit,
        act: (cubit) => cubit.typeChanged('cheatsheet'),
        expect: () => const <KnowledgeBankState>[
          KnowledgeBankState(type: 'cheatsheet'),
        ],
      );
    });

    group('materialUrl', () {
      test('returns a valid signed material URL', () async {
        final cubit = buildCubit();

        await expectLater(
          cubit.materialUrl(note),
          completion(
            Uri.parse('https://project.supabase.co/storage/material.pdf'),
          ),
        );

        verify(() => campusRepository.createPublicMaterialUrl(note)).called(1);
        await cubit.close();
      });

      test('returns null and reports the error when signing fails', () async {
        when(
          () => campusRepository.createPublicMaterialUrl(any()),
        ).thenThrow(Exception('storage down'));
        final cubit = buildCubit();

        await expectLater(cubit.materialUrl(note), completion(isNull));

        verify(() => campusRepository.createPublicMaterialUrl(note)).called(1);
        await cubit.close();
      });
    });

    group('materialOpened', () {
      blocTest<KnowledgeBankCubit, KnowledgeBankState>(
        'increments the matched material only after the remote call succeeds',
        build: buildCubit,
        seed: () => const KnowledgeBankState(materials: [note, cheatsheet]),
        act: (cubit) => cubit.materialOpened(note),
        expect: () => const <KnowledgeBankState>[
          KnowledgeBankState(
            materials: [
              StudyMaterial(
                id: 'm-1',
                title: 'Конспект по матану',
                downloads: 4,
                fileName: 'math.pdf',
                hasFile: true,
              ),
              cheatsheet,
            ],
          ),
        ],
        verify: (_) {
          verify(
            () => campusRepository.incrementMaterialDownloads('m-1'),
          ).called(1);
        },
      );

      blocTest<KnowledgeBankCubit, KnowledgeBankState>(
        'does not increment locally when the remote call throws',
        setUp: () => when(
          () => campusRepository.incrementMaterialDownloads(any()),
        ).thenThrow(Exception('remote down')),
        build: buildCubit,
        seed: () => const KnowledgeBankState(materials: [note]),
        act: (cubit) => cubit.materialOpened(note),
        expect: () => const <KnowledgeBankState>[],
        errors: () => [isA<Exception>()],
      );
    });

    test(
      'purchase refreshes the wallet only after authoritative success',
      () async {
        when(
          () =>
              campusRepository.purchasePublicMaterial(note, expectedPrice: 40),
        ).thenAnswer((_) async {});
        final cubit = buildCubit();
        addTearDown(cubit.close);
        await cubit.purchaseMaterial(note, expectedPrice: 40);
        verifyInOrder([
          () =>
              campusRepository.purchasePublicMaterial(note, expectedPrice: 40),
          () => gamificationRepository.getProfile(),
        ]);
        expect(cubit.state.profile, profile);
      },
    );

    test(
      'a rejected purchase propagates without a wallet update or retry',
      () async {
        when(
          () =>
              campusRepository.purchasePublicMaterial(note, expectedPrice: 40),
        ).thenThrow(const MaterialPurchaseException(.insufficientBalance));
        final cubit = buildCubit();
        addTearDown(cubit.close);
        await expectLater(
          cubit.purchaseMaterial(note, expectedPrice: 40),
          throwsA(isA<MaterialPurchaseException>()),
        );
        verify(
          () =>
              campusRepository.purchasePublicMaterial(note, expectedPrice: 40),
        ).called(1);
        verifyNever(() => gamificationRepository.getProfile());
      },
    );

    group('filteredMaterials', () {
      test('returns all materials when type is "all"', () {
        const state = KnowledgeBankState(materials: [note, cheatsheet]);
        expect(state.filteredMaterials, equals(const [note, cheatsheet]));
      });

      test('keeps only materials of the active type', () {
        const state = KnowledgeBankState(
          materials: [note, cheatsheet],
          type: 'cheatsheet',
        );
        expect(state.filteredMaterials, equals(const [cheatsheet]));
      });
    });
  });
}
