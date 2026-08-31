import 'package:news_blocks/news_blocks.dart' as nb;
import 'package:news_repository/src/data/news_remote_data_source.dart';
import 'package:news_repository/src/mappers/news_feed_item_mapper.dart';
import 'package:news_repository/src/models/news_feed_item.dart';
import 'package:news_repository/src/models/news_responses.dart';
import 'package:news_repository/src/news_failure.dart';

typedef JsonMap = Map<String, Object?>;

/// Maps remote news data to blocks consumed by the application.
class NewsRepository {
  /// Creates an organization-scoped repository.
  const NewsRepository({
    required this.dataSource,
    required this.organizationId,
  });

  /// Remote source used by this repository.
  final NewsRemoteDataSource dataSource;

  /// Organization whose news is exposed.
  final String organizationId;

  /// Loads a feed page.
  Future<FeedResponse> getFeed({
    String? categoryId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await dataSource.fetchFeed(
        organizationId: organizationId,
        category: categoryId ?? '',
        limit: limit,
        offset: offset,
      );
      final items = _decodeList(response, NewsFeedItem.fromJson);
      return FeedResponse(
        feed: _mapCards(items, offset),
        totalCount: _totalCount(items, offset),
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetFeedFailure(error), stackTrace);
    }
  }

  /// Loads available feed categories.
  Future<CategoriesResponse> getCategories() async {
    try {
      final response = await dataSource.fetchCategories(
        organizationId: organizationId,
      );
      final sources = _decodeList(response, NewsSourceItem.fromJson);
      return CategoriesResponse(
        categories: _buildCategories(sources),
        sources: sources,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetCategoriesFailure(error), stackTrace);
    }
  }

  /// Loads the most recent articles used by popular search.
  Future<PopularSearchResponse> popularSearch() async {
    try {
      final response = await getFeed(limit: 10);
      return PopularSearchResponse(articles: response.feed, topics: const []);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(PopularSearchFailure(error), stackTrace);
    }
  }

  /// Finds articles and topics containing [term].
  Future<RelevantSearchResponse> relevantSearch({required String term}) async {
    try {
      final response = await dataSource.fetchFeed(
        organizationId: organizationId,
        category: '',
        limit: 100,
        offset: 0,
      );
      final items = _decodeList(response, NewsFeedItem.fromJson);
      final matches = _searchItems(items, term);
      final categories = await getCategories();
      return RelevantSearchResponse(
        articles: _mapCards(matches, 0),
        topics: _searchTopics(categories.categories, term),
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(RelevantSearchFailure(error), stackTrace);
    }
  }
}

List<T> _decodeList<T>(Object? response, T Function(Map<String, dynamic>) map) {
  if (response is! List<Object?>) {
    throw FormatException('Expected an RPC list, got ${response.runtimeType}');
  }
  return response
      .map((value) {
        return map(_toLegacyJson(_asJsonMap(value)));
      })
      .toList(growable: false);
}

List<nb.NewsBlock> _mapCards(List<NewsFeedItem> items, int offset) {
  return [
    for (final (index, item) in items.indexed)
      mapNewsFeedItem(item, index + offset),
  ];
}

int _totalCount(List<NewsFeedItem> items, int offset) {
  return switch (items) {
    [final first, ...] when first.totalCount > 0 => first.totalCount,
    [] => offset,
    _ => offset + items.length,
  };
}

List<nb.Category> _buildCategories(List<NewsSourceItem> sources) {
  final categories = [const nb.Category(id: 'all', name: 'Все')];
  final sourceTypes = sources.map((source) => source.sourceType).toSet();
  // A type-level tab only helps when several types coexist; with a single
  // type it would duplicate "Все".
  if (sourceTypes.length > 1) {
    for (final type in sourceTypes) {
      categories.add(nb.Category(id: type, name: _sourceTypeName(type)));
    }
  }
  for (final source in sources) {
    categories.add(
      nb.Category(
        id: mapNewsCategoryKey(source.sourceType, source.sourceId),
        name: source.sourceName.trim().isEmpty
            ? '${source.sourceType}/${source.sourceId}'
            : source.sourceName,
      ),
    );
  }
  return categories;
}

String _sourceTypeName(String type) {
  return switch (type) {
    'telegram' => 'Telegram',
    'telegram_stories' => 'Истории',
    'official' => 'Сайт',
    'rss' => 'RSS',
    _ => type,
  };
}

List<NewsFeedItem> _searchItems(List<NewsFeedItem> items, String term) {
  final query = term.trim().toLowerCase();
  if (query.isEmpty) return const [];
  return items
      .where(
        (item) =>
            '${item.title} ${item.newsBlocks}'.toLowerCase().contains(query),
      )
      .take(5)
      .toList(growable: false);
}

List<String> _searchTopics(List<nb.Category> categories, String term) {
  final query = term.trim().toLowerCase();
  if (query.isEmpty) return const [];
  return categories
      .where((category) => category.name.toLowerCase().contains(query))
      .map((category) => category.name)
      .toList(growable: false);
}

/// Returns the stable category key for a source.
String newsCategoryKey(String? sourceType, String? sourceId) {
  return mapNewsCategoryKey(sourceType, sourceId);
}

JsonMap _asJsonMap(Object? value) {
  if (value is! Map<Object?, Object?>) {
    throw FormatException('Expected an RPC row, got ${value.runtimeType}');
  }
  return {
    for (final entry in value.entries)
      if (entry.key case final String key) key: entry.value,
  };
}

Map<String, dynamic> _toLegacyJson(JsonMap value) => Map.from(value);
