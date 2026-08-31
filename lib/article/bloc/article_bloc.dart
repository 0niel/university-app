import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:article_repository/article_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:share_launcher/share_launcher.dart';

part 'article_event.dart';
part 'article_status.dart';
part 'article_state.dart';
part 'article_bloc.freezed.dart';
part 'article_bloc.g.dart';

class ArticleBloc extends HydratedBloc<ArticleEvent, ArticleState> {
  ArticleBloc({
    required this.id,
    required this.articleRepository,
    required this.shareLauncher,
  }) : super(const ArticleState()) {
    on<ArticleRequested>(_onArticleRequested, transformer: sequential());
    on<ArticleContentSeen>(_onArticleContentSeen);
    on<ArticleRewardedAdWatched>(
      _onArticleRewardedAdWatched,
      transformer: droppable(),
    );
    on<ShareRequested>(_onShareRequested);
  }

  @override
  final String id;
  final ShareLauncher shareLauncher;
  final ArticleRepository articleRepository;

  static const _articleViewsLimit = 4;

  static const _resetArticleViewsAfterDuration = Duration(days: 1);

  static const _relatedArticlesLimit = 5;

  FutureOr<void> _onArticleRequested(
    ArticleRequested event,
    Emitter<ArticleState> emit,
  ) async {
    final isInitialRequest = state.status == .initial;

    try {
      emit(state.copyWith(status: .loading));

      final totalArticleViews = await _updateTotalArticleViews();

      final showInterstitialAd = _shouldShowInterstitialAd(totalArticleViews);

      emit(state.copyWith(showInterstitialAd: showInterstitialAd));

      if (isInitialRequest) {
        await _updateArticleViews();
      }

      final response = await articleRepository.getArticle(id: id);

      RelatedArticlesResponse? relatedArticlesResponse;
      if (state.relatedArticles.isEmpty) {
        relatedArticlesResponse = await articleRepository.getRelatedArticles(
          id: id,
          limit: _relatedArticlesLimit,
        );
      }

      emit(
        state.copyWith(
          status: .populated,
          title: response.title,
          content: response.content,
          relatedArticles: relatedArticlesResponse?.relatedArticles ?? [],
          uri: response.url,
        ),
      );
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  void _onArticleContentSeen(
    ArticleContentSeen event,
    Emitter<ArticleState> emit,
  ) {
    final contentSeenCount = event.contentIndex + 1;
    if (contentSeenCount > state.contentSeenCount) {
      emit(state.copyWith(contentSeenCount: contentSeenCount));
    }
  }

  FutureOr<void> _onArticleRewardedAdWatched(
    ArticleRewardedAdWatched event,
    Emitter<ArticleState> emit,
  ) async {
    try {
      await articleRepository.decrementArticleViews();
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .rewardedAdWatchedFailure));
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onShareRequested(
    ShareRequested event,
    Emitter<ArticleState> emit,
  ) async {
    try {
      await shareLauncher.share(text: event.uri.toString());
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .shareFailure));
      addError(error, stackTrace);
    }
  }

  Future<void> _updateArticleViews() async {
    final currentArticleViews = await articleRepository.fetchArticleViews();
    final resetAt = currentArticleViews.resetAt;

    final now = clock.now();
    final shouldResetArticleViews =
        resetAt == null ||
        now.isAfter(resetAt.add(_resetArticleViewsAfterDuration));

    if (shouldResetArticleViews) {
      await articleRepository.resetArticleViews();
      await articleRepository.incrementArticleViews();
    } else if (currentArticleViews.views < _articleViewsLimit) {
      await articleRepository.incrementArticleViews();
    }
  }

  Future<int> _updateTotalArticleViews() async {
    await articleRepository.incrementTotalArticleViews();
    return articleRepository.fetchTotalArticleViews();
  }

  bool _shouldShowInterstitialAd(int totalArticleViews) =>
      (totalArticleViews != 0) && totalArticleViews % _articleViewsLimit == 0;

  @override
  ArticleState fromJson(Map<String, dynamic> json) => .fromJson(json);

  @override
  Map<String, dynamic> toJson(ArticleState state) => state.toJson();
}
