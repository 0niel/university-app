import 'package:equatable/equatable.dart';

/// Base exception for article operations.
abstract class ArticleFailure with EquatableMixin implements Exception {
  /// Creates a failure that wraps [error].
  const ArticleFailure(this.error);

  /// The error raised by the underlying dependency.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// Thrown when article content cannot be loaded.
class GetArticleFailure extends ArticleFailure {
  /// Creates an article loading failure.
  const GetArticleFailure(super.error);
}

/// Thrown when related articles cannot be loaded.
class GetRelatedArticlesFailure extends ArticleFailure {
  /// Creates a related-article loading failure.
  const GetRelatedArticlesFailure(super.error);
}

/// Thrown when the local article-view count cannot be incremented.
class IncrementArticleViewsFailure extends ArticleFailure {
  /// Creates an article-view increment failure.
  const IncrementArticleViewsFailure(super.error);
}

/// Thrown when the local article-view count cannot be decremented.
class DecrementArticleViewsFailure extends ArticleFailure {
  /// Creates an article-view decrement failure.
  const DecrementArticleViewsFailure(super.error);
}

/// Thrown when local article-view counters cannot be reset.
class ResetArticleViewsFailure extends ArticleFailure {
  /// Creates an article-view reset failure.
  const ResetArticleViewsFailure(super.error);
}

/// Thrown when local article-view counters cannot be loaded.
class FetchArticleViewsFailure extends ArticleFailure {
  /// Creates an article-view loading failure.
  const FetchArticleViewsFailure(super.error);
}

/// Thrown when the total article-view count cannot be incremented.
class IncrementTotalArticleViewsFailure extends ArticleFailure {
  /// Creates a total article-view increment failure.
  const IncrementTotalArticleViewsFailure(super.error);
}

/// Thrown when the total article-view count cannot be loaded.
class FetchTotalArticleViewsFailure extends ArticleFailure {
  /// Creates a total article-view loading failure.
  const FetchTotalArticleViewsFailure(super.error);
}
