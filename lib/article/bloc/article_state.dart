part of 'article_bloc.dart';

@freezed
abstract class ArticleState with _$ArticleState {
  const factory ArticleState({
    @Default(ArticleStatus.initial) ArticleStatus status,
    String? title,
    @NewsBlocksConverter() @Default(<NewsBlock>[]) List<NewsBlock> content,
    @Default(0) int contentSeenCount,
    @NewsBlocksConverter()
    @Default(<NewsBlock>[])
    List<NewsBlock> relatedArticles,
    Uri? uri,
    @Default(false) bool hasReachedArticleViewsLimit,
    @Default(false) bool showInterstitialAd,
  }) = _ArticleState;

  factory ArticleState.fromJson(Map<String, dynamic> json) =>
      _$ArticleStateFromJson(json);
}
