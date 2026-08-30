part of 'article_repository.dart';

/// Local storage for article view counters.
class ArticleStorage {
  /// Creates storage backed by [storage].
  const ArticleStorage({required Storage storage}) : _storage = storage;

  final Storage _storage;

  /// Sets the number of article views in Storage.
  Future<void> setArticleViews(int views) => _storage.write(
    key: ArticleStorageKeys.articleViews,
    value: views.toString(),
  );

  /// Fetches the number of article views from Storage.
  Future<int> fetchArticleViews() async {
    final articleViews = await _storage.read(
      key: ArticleStorageKeys.articleViews,
    );
    return articleViews != null ? int.parse(articleViews) : 0;
  }

  /// Sets the reset date of the number of article views in Storage.
  Future<void> setArticleViewsResetDate(DateTime date) => _storage.write(
    key: ArticleStorageKeys.articleViewsResetAt,
    value: date.toIso8601String(),
  );

  /// Fetches the reset date of the number of article views from Storage.
  Future<DateTime?> fetchArticleViewsResetDate() async {
    final resetDate = await _storage.read(
      key: ArticleStorageKeys.articleViewsResetAt,
    );
    return resetDate != null ? DateTime.parse(resetDate) : null;
  }

  /// Sets the number of total article views.
  Future<void> setTotalArticleViews(int count) => _storage.write(
    key: ArticleStorageKeys.totalArticleViews,
    value: count.toString(),
  );

  /// Fetches the number of total article views value from storage.
  Future<int> fetchTotalArticleViews() async {
    final count = await _storage.read(
      key: ArticleStorageKeys.totalArticleViews,
    );
    return int.tryParse(count ?? '') ?? 0;
  }
}

abstract class ArticleStorageKeys {
  static const articleViews = '__article_views_storage_key__';
  static const articleViewsResetAt = '__article_views_reset_at_storage_key__';
  static const totalArticleViews = '__total_article_views_key__';
}
