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
        'still emits populated with an empty list for the source that throws, '
        'keeping the other sources',
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
            status: KnowledgeBankStatus.populated,
            profile: profile,
            authors: [author],
          ),
        ],
        errors: () => [isA<Exception>()],
      );

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

    group('download', () {
      blocTest<KnowledgeBankCubit, KnowledgeBankState>(
        'optimistically increments the matched material download counter '
        'and returns true on success',
        build: buildCubit,
        seed: () => const KnowledgeBankState(materials: [note, cheatsheet]),
        act: (cubit) async => expect(await cubit.download(note), isTrue),
        expect: () => const <KnowledgeBankState>[
          KnowledgeBankState(
            materials: [
              StudyMaterial(
                id: 'm-1',
                title: 'Конспект по матану',
                downloads: 4,
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
        'reverts the optimistic increment and returns false when the '
        'remote call throws',
        setUp: () => when(
          () => campusRepository.incrementMaterialDownloads(any()),
        ).thenThrow(Exception('remote down')),
        build: buildCubit,
        seed: () => const KnowledgeBankState(materials: [note]),
        act: (cubit) async => expect(await cubit.download(note), isFalse),
        expect: () => const <KnowledgeBankState>[
          KnowledgeBankState(
            materials: [
              StudyMaterial(
                id: 'm-1',
                title: 'Конспект по матану',
                downloads: 4,
              ),
            ],
          ),
          KnowledgeBankState(materials: [note]),
        ],
        errors: () => [isA<Exception>()],
      );
    });

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
