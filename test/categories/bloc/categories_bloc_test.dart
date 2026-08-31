import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';
import 'package:rtu_mirea_app/categories/categories.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  group('CategoriesBloc', () {
    late NewsRepository newsRepository;

    const science = Category(id: 'science', name: 'Наука');
    const sport = Category(id: 'sport', name: 'Спорт');
    const response = CategoriesResponse(categories: [science, sport]);

    setUp(() {
      newsRepository = MockNewsRepository();
    });

    CategoriesBloc buildBloc() =>
        CategoriesBloc(newsRepository: newsRepository);

    test('initial state is empty', () {
      expect(buildBloc().state, equals(const CategoriesState()));
    });

    group('CategoriesRequested', () {
      blocTest<CategoriesBloc, CategoriesState>(
        'emits [loading, populated] when getCategories succeeds, '
        'selecting the first category',
        setUp: () => when(
          () => newsRepository.getCategories(),
        ).thenAnswer((_) async => response),
        build: buildBloc,
        act: (bloc) => bloc.add(const CategoriesRequested()),
        expect: () => const <CategoriesState>[
          CategoriesState(status: CategoriesStatus.loading),
          CategoriesState(
            status: CategoriesStatus.populated,
            categories: [science, sport],
            selectedCategory: science,
          ),
        ],
        verify: (_) {
          verify(() => newsRepository.getCategories()).called(1);
        },
      );

      blocTest<CategoriesBloc, CategoriesState>(
        'emits [loading, failure] when getCategories throws',
        setUp: () => when(
          () => newsRepository.getCategories(),
        ).thenThrow(Exception('oops')),
        build: buildBloc,
        act: (bloc) => bloc.add(const CategoriesRequested()),
        expect: () => const <CategoriesState>[
          CategoriesState(status: CategoriesStatus.loading),
          CategoriesState(status: CategoriesStatus.failure),
        ],
        errors: () => [isA<Exception>()],
        verify: (_) {
          verify(() => newsRepository.getCategories()).called(1);
        },
      );
    });

    group('CategorySelected', () {
      blocTest<CategoriesBloc, CategoriesState>(
        'emits the newly selected category',
        build: buildBloc,
        seed: () => const CategoriesState(
          status: CategoriesStatus.populated,
          categories: [science, sport],
          selectedCategory: science,
        ),
        act: (bloc) => bloc.add(const CategorySelected(category: sport)),
        expect: () => const <CategoriesState>[
          CategoriesState(
            status: CategoriesStatus.populated,
            categories: [science, sport],
            selectedCategory: sport,
          ),
        ],
      );
    });
  });
}
