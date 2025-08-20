import 'dart:convert';

import 'package:news_blocks/news_blocks.dart';
import 'package:university_app_server_api/api.dart';
import 'package:university_app_server_api/src/redis.dart';

/// A wrapper around a [NewsDataSource] that caches article responses in Redis.
class RedisCachedNewsDataSource implements NewsDataSource {
  RedisCachedNewsDataSource({
    required NewsDataSource delegate,
    required RedisClient redisClient,
    int ttlSeconds = 600,
  })  : _delegate = delegate,
        _redis = redisClient,
        _ttl = ttlSeconds;

  final NewsDataSource _delegate;
  final RedisClient _redis;
  final int _ttl;

  @override
  Future<Article?> getArticle({required String id}) async {
    final key = 'article:$id';
    try {
      final article = await _delegate.getArticle(id: id);
      if (article != null) {
        final payload = json.encode({
          'title': article.title,
          'url': article.url.toString(),
          'blocks': article.blocks.map((b) => b.toJson()).toList(),
        });
        await _redis.command.send_object(['SET', key, payload, 'EX', _ttl]);
      }
      return article;
    } catch (e) {
      final cached = await _redis.command.get(key);
      if (cached is String && cached.isNotEmpty) {
        try {
          final map = json.decode(cached) as Map<String, dynamic>;
          final blocks = (map['blocks'] as List)
              .cast<Map<String, dynamic>>()
              .map(NewsBlock.fromJson)
              .toList();
          return Article(
            title: map['title'] as String? ?? '',
            blocks: blocks,
            totalBlocks: blocks.length,
            url: Uri.tryParse(map['url'] as String? ?? '') ?? Uri(),
          );
        } catch (_) {}
      }
      rethrow;
    }
  }

  @override
  Future<List<String>> getPopularTopics() => _delegate.getPopularTopics();

  @override
  Future<List<String>> getRelevantTopics({required String term}) =>
      _delegate.getRelevantTopics(term: term);

  @override
  Future<List<NewsBlock>> getPopularArticles() =>
      _delegate.getPopularArticles();

  @override
  Future<List<NewsBlock>> getRelevantArticles({required String term}) =>
      _delegate.getRelevantArticles(term: term);

  @override
  Future<RelatedArticles> getRelatedArticles({
    required String id,
    int limit = 20,
    int offset = 0,
  }) =>
      _delegate.getRelatedArticles(id: id, limit: limit, offset: offset);

  @override
  Future<Feed> getFeed({
    required String categoryId,
    int limit = 20,
    int offset = 0,
  }) =>
      _delegate.getFeed(categoryId: categoryId, limit: limit, offset: offset);

  @override
  Future<List<Category>> getCategories() => _delegate.getCategories();
}
