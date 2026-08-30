import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart' show DividerHorizontalBlock;
import 'package:news_repository/news_repository.dart';
import 'package:rtu_mirea_app/feed/feed.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

class MockStorage extends Mock implements Storage {}

void main() {
  group('FeedBloc', () {
    const category = Category(id: 'all', name: 'All');
    final blocks = <NewsBlock>[const DividerHorizontalBlock()];

    late NewsRepository newsRepository;
    late Storage storage;

    setUp(() {
      storage = MockStorage();
      when(() => storage.read(any())).thenReturn(null);
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      when(() => storage.delete(any())).thenAnswer((_) async {});
      HydratedBloc.storage = storage;

      newsRepository = MockNewsRepository();
    });

    FeedBloc buildBloc() => FeedBloc(newsRepository: newsRepository);

    test('initial state is empty', () {
      expect(buildBloc().state, equals(const FeedState()));
    });

    group('FeedRequested', () {
      blocTest<FeedBloc, FeedState>(
        'emits [loading, populated] when getFeed succeeds',
        setUp: () {
          when(
            () => newsRepository.getFeed(
              categoryId: any(named: 'categoryId'),
              offset: any(named: 'offset'),
            ),
          ).thenAnswer(
            (_) async => FeedResponse(feed: blocks, totalCount: 2),
          );
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const FeedRequested(category: category)),
        expect: () => <FeedState>[
          const FeedState(status: FeedStatus.loading),
          FeedState(
            status: FeedStatus.populated,
            feed: {category.id: blocks},
            hasMoreNews: {category.id: true},
          ),
        ],
        verify: (_) {
          verify(
            () => newsRepository.getFeed(categoryId: category.id),
          ).called(1);
        },
      );

      blocTest<FeedBloc, FeedState>(
        'hasMoreNews is false when totalCount equals fetched length',
        setUp: () {
          when(
            () => newsRepository.getFeed(
              categoryId: any(named: 'categoryId'),
              offset: any(named: 'offset'),
            ),
          ).thenAnswer(
            (_) async => FeedResponse(feed: blocks, totalCount: 1),
          );
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const FeedRequested(category: category)),
        expect: () => <FeedState>[
          const FeedState(status: FeedStatus.loading),
          FeedState(
            status: FeedStatus.populated,
            feed: {category.id: blocks},
            hasMoreNews: {category.id: false},
          ),
        ],
      );

      blocTest<FeedBloc, FeedState>(
        'emits [loading, failure] when getFeed throws',
        setUp: () {
          when(
            () => newsRepository.getFeed(
              categoryId: any(named: 'categoryId'),
              offset: any(named: 'offset'),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const FeedRequested(category: category)),
        expect: () => const <FeedState>[
          FeedState(status: FeedStatus.loading),
          FeedState(status: FeedStatus.failure),
        ],
      );
    });

    group('FeedRefreshRequested', () {
      blocTest<FeedBloc, FeedState>(
        'emits [loading, populated] replacing the category feed at offset 0',
        setUp: () {
          when(
            () => newsRepository.getFeed(
              categoryId: any(named: 'categoryId'),
              offset: any(named: 'offset'),
            ),
          ).thenAnswer(
            (_) async => FeedResponse(feed: blocks, totalCount: 5),
          );
        },
        build: buildBloc,
        seed: () => FeedState(
          status: FeedStatus.populated,
          feed: {
            category.id: [const DividerHorizontalBlock()],
          },
          hasMoreNews: {category.id: true},
        ),
        act: (bloc) => bloc.add(const FeedRefreshRequested(category: category)),
        expect: () => <FeedState>[
          FeedState(
            status: FeedStatus.loading,
            feed: {
              category.id: [const DividerHorizontalBlock()],
            },
            hasMoreNews: {category.id: true},
          ),
          FeedState(
            status: FeedStatus.populated,
            feed: {category.id: blocks},
            hasMoreNews: {category.id: true},
          ),
        ],
        verify: (_) {
          verify(
            () => newsRepository.getFeed(categoryId: category.id),
          ).called(1);
        },
      );

      blocTest<FeedBloc, FeedState>(
        'emits [loading, failure] when getFeed throws',
        setUp: () {
          when(
            () => newsRepository.getFeed(
              categoryId: any(named: 'categoryId'),
              offset: any(named: 'offset'),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const FeedRefreshRequested(category: category)),
        expect: () => const <FeedState>[
          FeedState(status: FeedStatus.loading),
          FeedState(status: FeedStatus.failure),
        ],
      );
    });

    group('FeedResumed', () {
      blocTest<FeedBloc, FeedState>(
        'refetches every seeded category and appends results',
        setUp: () {
          when(
            () => newsRepository.getFeed(
              categoryId: any(named: 'categoryId'),
              offset: any(named: 'offset'),
            ),
          ).thenAnswer(
            (_) async => FeedResponse(feed: blocks, totalCount: 4),
          );
        },
        build: buildBloc,
        seed: () => FeedState(
          status: FeedStatus.populated,
          feed: {category.id: blocks},
          hasMoreNews: {category.id: true},
        ),
        act: (bloc) => bloc.add(const FeedResumed()),
        expect: () => <FeedState>[
          FeedState(
            status: FeedStatus.populated,
            feed: {
              category.id: [...blocks, ...blocks],
            },
            hasMoreNews: {category.id: true},
          ),
        ],
        verify: (_) {
          verify(
            () => newsRepository.getFeed(categoryId: category.id, offset: 1),
          ).called(1);
        },
      );

      blocTest<FeedBloc, FeedState>(
        'is a no-op when there are no seeded categories',
        build: buildBloc,
        act: (bloc) => bloc.add(const FeedResumed()),
        expect: () => const <FeedState>[],
        verify: (_) {
          verifyNever(
            () => newsRepository.getFeed(
              categoryId: any(named: 'categoryId'),
              offset: any(named: 'offset'),
            ),
          );
        },
      );
    });

    group('hydration', () {
      test('toJson/fromJson round-trips a populated state', () {
        final bloc = buildBloc();
        final state = FeedState(
          status: FeedStatus.populated,
          feed: {category.id: blocks},
          hasMoreNews: {category.id: true},
        );
        final json = bloc.toJson(state);
        expect(bloc.fromJson(json), equals(state));
      });
    });
  });
}
