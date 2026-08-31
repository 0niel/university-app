import 'dart:developer';

import 'package:article_repository/src/article_failure.dart';
import 'package:article_repository/src/article_models.dart';
import 'package:clock/clock.dart';
import 'package:news_blocks/news_blocks.dart' as nb;
import 'package:news_repository/news_repository.dart' as news;
import 'package:storage/storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'article_storage.dart';

typedef JsonMap = Map<String, Object?>;

/// {@template article_repository}
/// A repository that manages article data.
/// {@endtemplate}
class ArticleRepository {
  /// {@macro article_repository}
  const ArticleRepository({
    required SupabaseClient supabase,
    required String organizationId,
    required ArticleStorage storage,
  }) : _supabase = supabase,
       _organizationId = organizationId,
       _storage = storage;

  final SupabaseClient _supabase;
  final String _organizationId;
  final ArticleStorage _storage;

  /// Loads article content by ID.
  Future<ArticleResponse> getArticle({
    required String id,
  }) async {
    try {
      final res = await _supabase.rpc<Object?>(
        'get_news_article',
        params: {'p_id': id, 'p_organization_id': _organizationId},
      );
      final row = _asJsonMap(res);

      final blocks = <nb.NewsBlock>[];
      final rawBlocks = row['newsBlocks'];
      if (rawBlocks is List) {
        for (final raw in rawBlocks.whereType<Map<Object?, Object?>>()) {
          try {
            final block = nb.NewsBlock.fromJson(_toLegacyJson(_asJsonMap(raw)));
            if (block is! nb.UnknownBlock) blocks.add(block);
          } on Object catch (e, st) {
            // Broad on purpose: a single malformed block (bad JSON shape) can
            // throw TypeError — skip it and keep the rest of the article.
            log(
              'Skipping malformed news block',
              error: e,
              stackTrace: st,
              name: 'ArticleRepository',
            );
          }
        }
      }

      final hasIntroductionBlock = switch (blocks) {
        [nb.ArticleIntroductionBlock() || nb.VideoIntroductionBlock(), ...] =>
          true,
        _ => false,
      };
      if (!hasIntroductionBlock) {
        blocks.insert(
          0,
          nb.ArticleIntroductionBlock(
            categoryId: news.newsCategoryKey(
              row['sourceType'] as String?,
              row['sourceId'] as String?,
            ),
            author: row['sourceName'] as String? ?? '',
            publishedAt:
                DateTime.tryParse(row['publishedAt'] as String? ?? '') ??
                DateTime.now(),
            title: row['title'] as String? ?? '',
          ),
        );
      }

      return ArticleResponse(
        title: row['title'] as String? ?? '',
        content: blocks,
        url: Uri.tryParse(row['originalUrl'] as String? ?? '') ?? Uri(),
      );
    } catch (error, stackTrace) {
      // Broad on purpose: dynamic RPC payload casts can throw TypeError, not
      // just Exception — wrap everything into the domain failure.
      Error.throwWithStackTrace(GetArticleFailure(error), stackTrace);
    }
  }

  /// Requests related articles.
  ///
  /// Supported parameters:
  /// * [id] - Article id for which related content is requested.
  /// * [limit] - The number of results to return.
  /// * [offset] - The (zero-based) offset of the first item
  /// in the collection to return.
  Future<RelatedArticlesResponse> getRelatedArticles({
    required String id,
    int? limit,
    int? offset,
  }) async {
    try {
      final res = await _supabase.rpc<Object?>(
        'get_news_feed',
        params: {
          'p_organization_id': _organizationId,
          'p_category': '',
          'p_limit': 100,
          'p_offset': 0,
        },
      );
      final rows =
          res is List
              ? res.whereType<Map<Object?, Object?>>().map(_asJsonMap).toList()
              : <JsonMap>[];
      final base = rows.where((r) => r['id'] == id).firstOrNull;
      if (base == null) {
        return const RelatedArticlesResponse(
          relatedArticles: [],
          totalCount: 0,
        );
      }
      final related =
          rows
              .where((r) => r['id'] != id && _areRelated(base, r))
              .skip(offset ?? 0)
              .take(limit ?? 20)
              .toList();
      final blocks = <nb.NewsBlock>[
        for (final (i, row) in related.indexed)
          news.mapNewsFeedItem(
            news.NewsFeedItem.fromJson(_toLegacyJson(row)),
            i + 1,
          ),
      ];
      return RelatedArticlesResponse(
        relatedArticles: blocks,
        totalCount: blocks.length,
      );
    } catch (error, stackTrace) {
      // Broad on purpose: dynamic RPC payload casts can throw TypeError, not
      // just Exception — wrap everything into the domain failure.
      Error.throwWithStackTrace(GetRelatedArticlesFailure(error), stackTrace);
    }
  }

  static bool _areRelated(JsonMap a, JsonMap b) {
    if (a['sourceType'] == b['sourceType']) return true;
    Set<String> words(JsonMap row) =>
        (row['title'] as String? ?? '')
            .toLowerCase()
            .split(RegExp(r'\s+'))
            .where((w) => w.length > 3)
            .toSet();
    return words(a).intersection(words(b)).length >= 2;
  }

  /// Increments the number of article views by 1.
  Future<void> incrementArticleViews() async {
    try {
      final currentArticleViews = await _storage.fetchArticleViews();
      await _storage.setArticleViews(currentArticleViews + 1);
    } catch (error, stackTrace) {
      // Broad on purpose: storage may surface non-Exception errors on corrupt
      // data — wrap everything into the domain failure (failure pattern).
      Error.throwWithStackTrace(
        IncrementArticleViewsFailure(error),
        stackTrace,
      );
    }
  }

  /// Decrements the number of article views by 1.
  Future<void> decrementArticleViews() async {
    try {
      final currentArticleViews = await _storage.fetchArticleViews();
      await _storage.setArticleViews(currentArticleViews - 1);
    } catch (error, stackTrace) {
      // Broad on purpose: storage may surface non-Exception errors on corrupt
      // data — wrap everything into the domain failure (failure pattern).
      Error.throwWithStackTrace(
        DecrementArticleViewsFailure(error),
        stackTrace,
      );
    }
  }

  /// Resets the number of article views.
  Future<void> resetArticleViews() async {
    try {
      await Future.wait([
        _storage.setArticleViews(0),
        _storage.setArticleViewsResetDate(clock.now()),
      ]);
    } catch (error, stackTrace) {
      // Broad on purpose: storage may surface non-Exception errors on corrupt
      // data — wrap everything into the domain failure (failure pattern).
      Error.throwWithStackTrace(ResetArticleViewsFailure(error), stackTrace);
    }
  }

  /// Fetches the number of article views.
  Future<ArticleViews> fetchArticleViews() async {
    try {
      late int views;
      late DateTime? resetAt;
      await Future.wait([
        (() async => views = await _storage.fetchArticleViews())(),
        (() async => resetAt = await _storage.fetchArticleViewsResetDate())(),
      ]);
      return ArticleViews(views: views, resetAt: resetAt);
    } catch (error, stackTrace) {
      // Broad on purpose: storage may surface non-Exception errors on corrupt
      // data — wrap everything into the domain failure (failure pattern).
      Error.throwWithStackTrace(FetchArticleViewsFailure(error), stackTrace);
    }
  }

  /// Increments the number of total article views by 1.
  Future<void> incrementTotalArticleViews() async {
    try {
      final totalArticleViews = await _storage.fetchTotalArticleViews();
      await _storage.setTotalArticleViews(totalArticleViews + 1);
    } catch (error, stackTrace) {
      // Broad on purpose: storage may surface non-Exception errors on corrupt
      // data — wrap everything into the domain failure (failure pattern).
      Error.throwWithStackTrace(
        IncrementTotalArticleViewsFailure(error),
        stackTrace,
      );
    }
  }

  /// Fetches the number of total article views.
  Future<int> fetchTotalArticleViews() async {
    try {
      return await _storage.fetchTotalArticleViews();
    } catch (error, stackTrace) {
      // Broad on purpose: storage may surface non-Exception errors on corrupt
      // data — wrap everything into the domain failure (failure pattern).
      Error.throwWithStackTrace(
        FetchTotalArticleViewsFailure(error),
        stackTrace,
      );
    }
  }
}

JsonMap _asJsonMap(Object? value) {
  if (value is! Map<Object?, Object?>) {
    throw FormatException(
      'Expected a JSON object, received ${value.runtimeType}',
    );
  }
  return {
    for (final entry in value.entries)
      if (entry.key case final String key) key: entry.value,
  };
}

// The news packages retain json_serializable's legacy
// `Map<String, dynamic>` API.
Map<String, dynamic> _toLegacyJson(JsonMap value) => Map.from(value);
