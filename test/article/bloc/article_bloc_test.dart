import 'package:article_repository/article_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:rtu_mirea_app/article/article.dart';
import 'package:share_launcher/share_launcher.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

class MockShareLauncher extends Mock implements ShareLauncher {}

class MockStorage extends Mock implements Storage {}

void main() {
  group('ArticleBloc', () {
    const articleId = 'article-id';
    const title = 'title';
    final url = Uri.parse('https://mirea.ninja/article');

    const content = <NewsBlock>[DividerHorizontalBlock()];
    const relatedArticles = <NewsBlock>[DividerHorizontalBlock()];

    final articleResponse = ArticleResponse(
      title: title,
      content: content,
      url: url,
    );
    const relatedArticlesResponse = RelatedArticlesResponse(
      relatedArticles: relatedArticles,
      totalCount: 1,
    );

    late ArticleRepository articleRepository;
    late ShareLauncher shareLauncher;
    late Storage storage;

    setUp(() {
      storage = MockStorage();
      when(() => storage.read(any())).thenReturn(null);
      when(
        () => storage.write(any(), any<dynamic>()),
      ).thenAnswer((_) async {});
      when(() => storage.delete(any())).thenAnswer((_) async {});
      HydratedBloc.storage = storage;

      articleRepository = MockArticleRepository();
      shareLauncher = MockShareLauncher();

      when(
        () => articleRepository.getArticle(id: any(named: 'id')),
      ).thenAnswer((_) async => articleResponse);
      when(
        () => articleRepository.getRelatedArticles(
          id: any(named: 'id'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => relatedArticlesResponse);
      when(
        () => articleRepository.incrementArticleViews(),
      ).thenAnswer((_) async {});
      when(
        () => articleRepository.decrementArticleViews(),
      ).thenAnswer((_) async {});
      when(
        () => articleRepository.resetArticleViews(),
      ).thenAnswer((_) async {});
      when(
        () => articleRepository.fetchArticleViews(),
      ).thenAnswer((_) async => const ArticleViews(views: 0, resetAt: null));
      when(
        () => articleRepository.incrementTotalArticleViews(),
      ).thenAnswer((_) async {});
      when(
        () => articleRepository.fetchTotalArticleViews(),
      ).thenAnswer((_) async => 1);

      when(
        () => shareLauncher.share(text: any(named: 'text')),
      ).thenAnswer((_) async {});
    });

    ArticleBloc buildBloc() => ArticleBloc(
      id: articleId,
      articleRepository: articleRepository,
      shareLauncher: shareLauncher,
    );

    test('initial state is empty', () {
      expect(buildBloc().state, equals(const ArticleState()));
    });

    group('ArticleRequested', () {
      blocTest<ArticleBloc, ArticleState>(
        'emits [loading, populated] when all repository calls succeed',
        build: buildBloc,
        act: (bloc) => bloc.add(const ArticleRequested()),
        expect: () => <ArticleState>[
          const ArticleState(status: ArticleStatus.loading),
          const ArticleState(
            status: ArticleStatus.populated,
            title: title,
            content: content,
            relatedArticles: relatedArticles,
          ).copyWith(uri: url),
        ],
        verify: (_) {
          verify(() => articleRepository.getArticle(id: articleId)).called(1);
          verify(
            () => articleRepository.getRelatedArticles(
              id: articleId,
              limit: any(named: 'limit'),
            ),
          ).called(1);
          verify(
            () => articleRepository.incrementTotalArticleViews(),
          ).called(1);
          verify(() => articleRepository.fetchTotalArticleViews()).called(1);
        },
      );

      blocTest<ArticleBloc, ArticleState>(
        'increments article views on the initial request',
        build: buildBloc,
        act: (bloc) => bloc.add(const ArticleRequested()),
        verify: (_) {
          verify(() => articleRepository.fetchArticleViews()).called(1);
          verify(() => articleRepository.incrementArticleViews()).called(1);
        },
      );

      blocTest<ArticleBloc, ArticleState>(
        'resets and increments article views when never reset before',
        setUp: () =>
            when(
              () => articleRepository.fetchArticleViews(),
            ).thenAnswer(
              (_) async => const ArticleViews(views: 0, resetAt: null),
            ),
        build: buildBloc,
        act: (bloc) => bloc.add(const ArticleRequested()),
        verify: (_) {
          verify(() => articleRepository.resetArticleViews()).called(1);
          verify(() => articleRepository.incrementArticleViews()).called(1);
        },
      );

      blocTest<ArticleBloc, ArticleState>(
        'does not fetch related articles when they are already populated',
        build: buildBloc,
        seed: () => const ArticleState(
          status: ArticleStatus.populated,
          relatedArticles: relatedArticles,
        ),
        act: (bloc) => bloc.add(const ArticleRequested()),
        verify: (_) {
          verifyNever(
            () => articleRepository.getRelatedArticles(
              id: any(named: 'id'),
              limit: any(named: 'limit'),
            ),
          );
        },
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits [loading, failure] when getArticle throws',
        setUp: () => when(
          () => articleRepository.getArticle(id: any(named: 'id')),
        ).thenThrow(GetArticleFailure(Exception('oops'))),
        build: buildBloc,
        act: (bloc) => bloc.add(const ArticleRequested()),
        expect: () => <ArticleState>[
          const ArticleState(status: ArticleStatus.loading),
          const ArticleState(status: ArticleStatus.failure),
        ],
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits [loading, failure] when getRelatedArticles throws',
        setUp: () => when(
          () => articleRepository.getRelatedArticles(
            id: any(named: 'id'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(GetRelatedArticlesFailure(Exception('oops'))),
        build: buildBloc,
        act: (bloc) => bloc.add(const ArticleRequested()),
        expect: () => <ArticleState>[
          const ArticleState(status: ArticleStatus.loading),
          const ArticleState(status: ArticleStatus.failure),
        ],
      );
    });

    group('ArticleContentSeen', () {
      blocTest<ArticleBloc, ArticleState>(
        'emits new contentSeenCount when it increases',
        build: buildBloc,
        act: (bloc) => bloc.add(const ArticleContentSeen(contentIndex: 2)),
        expect: () => <ArticleState>[
          const ArticleState(contentSeenCount: 3),
        ],
      );

      blocTest<ArticleBloc, ArticleState>(
        'does not emit when contentSeenCount does not increase',
        build: buildBloc,
        seed: () => const ArticleState(
          status: ArticleStatus.populated,
          contentSeenCount: 5,
        ),
        act: (bloc) => bloc.add(const ArticleContentSeen(contentIndex: 2)),
        expect: () => <ArticleState>[],
      );
    });

    group('ArticleRewardedAdWatched', () {
      blocTest<ArticleBloc, ArticleState>(
        'decrements article views and emits nothing on success',
        build: buildBloc,
        act: (bloc) => bloc.add(const ArticleRewardedAdWatched()),
        expect: () => <ArticleState>[],
        verify: (_) {
          verify(() => articleRepository.decrementArticleViews()).called(1);
        },
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits rewardedAdWatchedFailure when decrement throws',
        setUp: () => when(
          () => articleRepository.decrementArticleViews(),
        ).thenThrow(DecrementArticleViewsFailure(Exception('oops'))),
        build: buildBloc,
        act: (bloc) => bloc.add(const ArticleRewardedAdWatched()),
        expect: () => <ArticleState>[
          const ArticleState(
            status: ArticleStatus.rewardedAdWatchedFailure,
          ),
        ],
      );
    });

    group('ShareRequested', () {
      blocTest<ArticleBloc, ArticleState>(
        'shares the uri and emits nothing on success',
        build: buildBloc,
        act: (bloc) => bloc.add(ShareRequested(uri: url)),
        expect: () => <ArticleState>[],
        verify: (_) {
          verify(() => shareLauncher.share(text: url.toString())).called(1);
        },
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits shareFailure when share throws',
        setUp: () => when(
          () => shareLauncher.share(text: any(named: 'text')),
        ).thenThrow(Exception('oops')),
        build: buildBloc,
        act: (bloc) => bloc.add(ShareRequested(uri: url)),
        expect: () => <ArticleState>[
          const ArticleState(status: ArticleStatus.shareFailure),
        ],
      );
    });

    group('hydration', () {
      test('toJson/fromJson round-trips the state', () {
        final bloc = buildBloc();
        final state = const ArticleState(
          status: ArticleStatus.populated,
          title: title,
          content: content,
          relatedArticles: relatedArticles,
          contentSeenCount: 2,
        ).copyWith(uri: url);

        final json = bloc.toJson(state);
        expect(json, isNotNull);
        expect(bloc.fromJson(json), equals(state));
      });
    });
  });
}
