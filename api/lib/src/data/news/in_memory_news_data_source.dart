import 'dart:math' as math;

import 'package:news_blocks/news_blocks.dart';
import 'package:university_app_server_api/api.dart';
import 'package:university_app_server_api/src/data/news/models/models.dart';

part 'static_news_data.dart';

/// {@template in_memory_news_data_source}
/// An implementation of [NewsDataSource] which
/// is powered by in-memory news content.
/// {@endtemplate}
class InMemoryNewsDataSource implements NewsDataSource {
  /// {@macro in_memory_news_data_store}
  InMemoryNewsDataSource();

  @override
  Future<Article?> getArticle({
    required String id,
    int limit = 20,
    int offset = 0,
    bool preview = false,
  }) async {
    final result = _newsItems.where((item) => item.post.id == id);
    if (result.isEmpty) return null;
    final articleNewsItem = result.first;
    final article = (preview ? articleNewsItem.contentPreview : articleNewsItem.content)
        .toArticle(title: articleNewsItem.post.title, url: articleNewsItem.url);
    final totalBlocks = article.totalBlocks;
    final normalizedOffset = math.min(offset, totalBlocks);
    final blocks = article.blocks.sublist(normalizedOffset).take(limit).toList();
    return Article(
      title: article.title,
      blocks: blocks,
      totalBlocks: totalBlocks,
      url: article.url,
    );
  }

  @override
  Future<List<NewsBlock>> getPopularArticles() async {
    return popularArticles.map((item) => item.post).toList();
  }

  @override
  Future<List<NewsBlock>> getRelevantArticles({required String term}) async {
    return relevantArticles.map((item) => item.post).toList();
  }

  @override
  Future<List<String>> getRelevantTopics({required String term}) async {
    return relevantTopics;
  }

  @override
  Future<List<String>> getPopularTopics() async => popularTopics;

  @override
  Future<RelatedArticles> getRelatedArticles({
    required String id,
    int limit = 20,
    int offset = 0,
  }) async {
    final result = _newsItems.where((item) => item.post.id == id);
    if (result.isEmpty) return const RelatedArticles.empty();
    final articles = result.first.relatedArticles;
    final totalBlocks = articles.length;
    final normalizedOffset = math.min(offset, totalBlocks);
    final blocks = articles.sublist(normalizedOffset).take(limit).toList();
    return RelatedArticles(blocks: blocks, totalBlocks: totalBlocks);
  }

  @override
  Future<Feed> getFeed({
    required String categoryId,
    int limit = 20,
    int offset = 0,
  }) async {
    final feed = _newsFeedData[categoryId] ?? const Feed(blocks: [], totalBlocks: 0);
    final totalBlocks = feed.totalBlocks;
    final normalizedOffset = math.min(offset, totalBlocks);
    final blocks = feed.blocks.sublist(normalizedOffset).take(limit).toList();
    return Feed(blocks: blocks, totalBlocks: totalBlocks);
  }

  @override
  Future<List<Category>> getCategories() async => _categories;
}
