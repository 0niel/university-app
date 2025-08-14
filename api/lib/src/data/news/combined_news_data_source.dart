import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:supabase/supabase.dart';
import 'package:university_app_server_api/api.dart' as api;

/// {@template combined_news_data_source}
/// A news data source that intelligently combines news with social media
/// content using sophisticated algorithmic feed generation for an excellent
/// user experience.
/// {@endtemplate}
class CombinedNewsDataSource implements api.NewsDataSource {
  /// {@macro combined_news_data_source}
  CombinedNewsDataSource({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  // Cache for article content to avoid repeated DB calls
  final Map<String, api.Article> _articleCache = {};

  // Cache for UI labels to avoid repeated DB calls
  final Map<String, String> _labelCache = {};

  Future<String?> _getLabel(String key, {String? locale}) async {
    final cacheKey = locale == null ? key : '$key@$locale';
    if (_labelCache.containsKey(cacheKey)) return _labelCache[cacheKey];

    try {
      final params = <String, dynamic>{'in_key': key, if (locale != null) 'in_locale': locale};
      final rpc = await _supabaseClient.rpc<String>('ui_get_label', params: params);
      if (rpc.isNotEmpty) {
        _labelCache[cacheKey] = rpc;
        return rpc;
      }
    } catch (_) {}

    try {
      final query = _supabaseClient.from('ui_labels').select('text').eq('key', key).maybeSingle();
      final data = await query;
      if (data is Map<String, dynamic>) {
        final value = data['text'] as String?;
        if (value != null && value.isNotEmpty) {
          _labelCache[cacheKey] = value;
          return value;
        }
      }
    } catch (_) {}

    return null;
  }

  String _formatLabel(String template, Map<String, String> vars) {
    var result = template;
    vars.forEach((k, v) {
      result = result.replaceAll('{$k}', v);
    });
    return result;
  }

  Future<List<Map<String, dynamic>>> _getNewsItems({
    int limit = 20,
    int offset = 0,
    String? category,
  }) async {
    try {
      try {
        final params = <String, dynamic>{
          'in_limit': limit,
          'in_offset': offset,
          if (category != null) 'in_category': category,
        };
        final ranked = await _supabaseClient.rpc<List<dynamic>>('rank_social_news_items', params: params);
        if (ranked.isNotEmpty) {
          return List<Map<String, dynamic>>.from(ranked.cast<Map<String, dynamic>>());
        }
      } catch (_) {}

      var query = _supabaseClient.from('social_news_items').select('''
            id,
            title,
            original_url,
            news_blocks,
            source_type,
            source_id,
            source_name,
            published_at,
            external_id
          ''');

      if (category != null && category != 'all' && category != 'top') {
        if (category.startsWith('source:')) {
          final parts = category.split(':');
          if (parts.length >= 3) {
            final cType = parts[1];
            final cId = parts.sublist(2).join(':');
            query = query.eq('source_type', cType).eq('source_id', cId);
          }
        } else {
          query = query.eq('source_type', category);
        }
      }

      final response = await query.order('published_at', ascending: false).range(offset, offset + limit - 1);

      final list = (response as List).cast<Map<String, dynamic>>();
      return list;
    } catch (e, stackTrace) {
      print('Error getting social news: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  @override
  Future<api.Article?> getArticle({
    required String id,
    int limit = 20,
    int offset = 0,
    bool preview = false,
  }) async {
    if (_articleCache.containsKey(id)) {
      final cached = _articleCache[id]!;
      if (!preview) {
        return cached;
      }
    }

    try {
      final response = await _supabaseClient.from('social_news_items').select().eq('id', id).single();

      final article = _convertToFullArticle(response);

      _articleCache[id] = article;

      if (preview) {
        // Return only preview blocks for preview mode
        final previewBlocks = article.blocks.take(2).toList();
        return api.Article(
          title: article.title,
          blocks: previewBlocks,
          totalBlocks: article.totalBlocks,
          url: article.url,
        );
      }

      return article;
    } catch (e) {
      print('Error getting article $id: $e');
      return null;
    }
  }

  api.Article _convertToFullArticle(Map<String, dynamic> json) {
    final title = json['title'] as String? ?? '';
    final originalUrl = json['original_url'] as String? ?? '';
    final newsBlocksJson = json['news_blocks'] as List<dynamic>?;
    final sourceType = json['source_type'] as String?;
    final sourceId = json['source_id'] as String?;
    final sourceName = json['source_name'] as String?;
    final publishedAt = json['published_at'] != null ? DateTime.parse(json['published_at'] as String) : DateTime.now();

    final blocks = <NewsBlock>[];

    if (newsBlocksJson != null && newsBlocksJson.isNotEmpty) {
      for (final blockJson in newsBlocksJson) {
        try {
          final normalized = _normalizeBlockKeys(blockJson as Map<String, dynamic>);
          blocks.add(NewsBlock.fromJson(normalized));
        } catch (e) {
          print('Error parsing news block: $e');
        }
      }
    }

    if (blocks.isEmpty || blocks.first is! ArticleIntroductionBlock) {
      blocks.insert(
        0,
        ArticleIntroductionBlock(
          categoryId: _composeCategoryKey(sourceType, sourceId),
          author: sourceName ?? '',
          publishedAt: publishedAt,
          title: title,
        ),
      );
    }

    _enhanceArticleContent(blocks, json);

    return api.Article(
      title: title,
      blocks: blocks,
      totalBlocks: blocks.length,
      url: Uri.tryParse(originalUrl) ?? Uri(),
    );
  }

  Future<void> _enhanceArticleContent(List<NewsBlock> blocks, Map<String, dynamic> data) async {
    final relatedArticles = _findRelatedArticles(data);
    if (relatedArticles.isNotEmpty && blocks.length > 3) {
      blocks.add(const DividerHorizontalBlock());
      final relatedTitle = await _getLabel('section.related');
      if (relatedTitle != null && relatedTitle.isNotEmpty) {
        blocks.add(SectionHeaderBlock(title: relatedTitle));
      }

      for (final related in relatedArticles.take(2)) {
        blocks.add(related);
      }
    }

    // Add newsletter block for longer articles
    if (blocks.length > 5) {
      final newsletterIndex = blocks.length ~/ 2;
      blocks.insert(newsletterIndex, const SpacerBlock(spacing: Spacing.medium));
      blocks.insert(newsletterIndex + 1, const NewsletterBlock());
      blocks.insert(newsletterIndex + 2, const SpacerBlock(spacing: Spacing.medium));
    }

    // Add trending story at the end if applicable
    final trendingStory = _getTrendingStoryForCategory(data['source_type'] as String?);
    if (trendingStory != null) {
      blocks.add(const DividerHorizontalBlock());
      blocks.add(trendingStory);
    }
  }

  List<PostBlock> _findRelatedArticles(Map<String, dynamic> currentArticle) {
    // TODO(Oniel): Implement related articles
    return [];
  }

  TrendingStoryBlock? _getTrendingStoryForCategory(String? category) {
    // TODO(Oniel): Implement trending story
    return null;
  }

  @override
  Future<List<NewsBlock>> getPopularArticles() async {
    try {
      final items = await _getNewsItems(limit: 50);
      final scoredItems = await _rankItems(items);

      final popularBlocks = <NewsBlock>[];

      final popularTitle = await _getLabel('section.popular_now');
      if (popularTitle != null && popularTitle.isNotEmpty) {
        popularBlocks.add(SectionHeaderBlock(title: popularTitle));
      }

      for (var i = 0; i < math.min(10, scoredItems.length); i++) {
        final item = scoredItems[i];
        final block = _createPostBlock(item, size: i == 0 ? 'large' : (i < 3 ? 'medium' : 'small'));
        if (block != null) {
          popularBlocks.add(block);

          if (i < scoredItems.length - 1) {
            popularBlocks.add(const SpacerBlock(spacing: Spacing.small));
          }
        }
      }

      return popularBlocks;
    } catch (e) {
      print('Error getting popular articles: $e');
      return [];
    }
  }

  @override
  Future<List<NewsBlock>> getRelevantArticles({required String term}) async {
    try {
      final items = await _getNewsItems(limit: 100);
      final relevantItems = items.where((item) {
        final searchableText = '${item['title']} ${_extractTextFromBlocks(item['news_blocks'])}';
        return searchableText.toLowerCase().contains(term.toLowerCase());
      }).toList();

      final relevantBlocks = <NewsBlock>[];

      if (relevantItems.isNotEmpty) {
        final template = await _getLabel('section.search_results');
        final title = template == null || template.isEmpty ? null : _formatLabel(template, {'term': term});
        if (title != null && title.isNotEmpty) {
          relevantBlocks.add(SectionHeaderBlock(title: title));
        }
      }

      for (final item in relevantItems.take(20)) {
        final block = _createPostBlock(item, size: 'small');
        if (block != null) {
          relevantBlocks.add(block);
        }
      }

      return relevantBlocks;
    } catch (e) {
      print('Error getting relevant articles: $e');
      return [];
    }
  }

  @override
  Future<List<String>> getRelevantTopics({required String term}) async {
    try {
      final res = await _supabaseClient.rpc<List<dynamic>>('get_relevant_topics', params: {'in_term': term});
      if (res.isNotEmpty) {
        return res.cast<String>();
      }
    } catch (_) {}

    final categories = await getCategories();
    final matchingCategories =
        categories.where((cat) => cat.name.toLowerCase().contains(term.toLowerCase())).map((cat) => cat.name).toList();
    return matchingCategories;
  }

  @override
  Future<List<String>> getPopularTopics() async {
    try {
      final res = await _supabaseClient.rpc<List<dynamic>>('get_popular_topics');
      if (res.isNotEmpty) {
        return res.cast<String>();
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<api.RelatedArticles> getRelatedArticles({
    required String id,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      try {
        final res = await _supabaseClient.rpc<List<dynamic>>(
          'get_related_news_items',
          params: {
            'in_article_id': id,
            'in_limit': limit,
            'in_offset': offset,
          },
        );
        if (res.isNotEmpty) {
          final blocks = <NewsBlock>[];
          for (final item in res.cast<Map<String, dynamic>>()) {
            final block = _createPostBlock(item, size: 'small');
            if (block != null) blocks.add(block);
          }
          return api.RelatedArticles(blocks: blocks, totalBlocks: blocks.length);
        }
      } catch (_) {}

      final items = await _getNewsItems(limit: 200);
      final baseItem = items.firstWhereOrNull((item) => item['id'] == id);
      if (baseItem == null) return const api.RelatedArticles(blocks: [], totalBlocks: 0);
      final relatedItems = items.where((item) => item['id'] != id && _areItemsRelated(baseItem, item)).toList();
      final totalBlocks = relatedItems.length;
      final normalizedOffset = math.min(offset, totalBlocks);
      final paginatedItems = relatedItems.sublist(normalizedOffset).take(limit).toList();

      final blocks = <NewsBlock>[];
      for (final item in paginatedItems) {
        final block = _createPostBlock(item, size: 'small');
        if (block != null) {
          blocks.add(block);
        }
      }

      return api.RelatedArticles(blocks: blocks, totalBlocks: totalBlocks);
    } catch (e) {
      print('Error getting related articles: $e');
      return const api.RelatedArticles(blocks: [], totalBlocks: 0);
    }
  }

  @override
  Future<api.Feed> getFeed({
    required String categoryId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final normalizedCategoryId = (categoryId.isEmpty) ? 'top' : categoryId;
      final items = await _getNewsItems(
        limit: math.min(200, limit * 5),
        category: normalizedCategoryId == 'all' || normalizedCategoryId == 'top' ? null : normalizedCategoryId,
      );

      final feedBlocks = await _generateSmartFeed(
        items,
        categoryId: normalizedCategoryId,
        requestedLimit: limit,
      );

      final totalBlocks = feedBlocks.length;
      final normalizedOffset = math.min(offset, totalBlocks);
      final paginatedBlocks = feedBlocks.sublist(normalizedOffset).take(limit).toList();

      return api.Feed(blocks: paginatedBlocks, totalBlocks: totalBlocks);
    } catch (e) {
      print('Error generating feed: $e');
      return const api.Feed(blocks: [], totalBlocks: 0);
    }
  }

  @override
  Future<List<api.Category>> getCategories() async {
    final categories = <api.Category>[];

    Future<api.Category> _build(String id) async {
      final name = await _getLabel('category.$id');
      return api.Category(id: id, name: (name == null || name.isEmpty) ? id : name);
    }

    categories.addAll(
      await Future.wait([
        _build('top'),
        _build('all'),
        _build('mirea'),
        _build('telegram'),
        _build('vk'),
      ]),
    );

    try {
      final sourcesRaw = await _supabaseClient
          .from('social_news_sources')
          .select('source_type,source_id,source_name,is_active')
          .eq('is_active', true)
          .order('source_type')
          .order('source_name');

      final sources = (sourcesRaw as List).cast<Map<String, dynamic>>();
      for (final m in sources) {
        final st = (m['source_type'] as String?)?.trim();
        final sid = (m['source_id'] as String?)?.trim();
        final sname = (m['source_name'] as String?)?.trim();
        if (st != null && st.isNotEmpty && sid != null && sid.isNotEmpty) {
          final id = 'source:$st:$sid';
          final name = sname == null || sname.isEmpty ? '$st/$sid' : sname;
          categories.add(api.Category(id: id, name: name));
        }
      }
    } catch (_) {}

    return categories;
  }

  Future<List<NewsBlock>> _generateSmartFeed(
    List<Map<String, dynamic>> items, {
    required int requestedLimit,
    String? categoryId,
  }) async {
    if (items.isEmpty) return [];

    final feedBlocks = <NewsBlock>[];
    final isTopFeed = categoryId == null || categoryId == 'top';

    final scoredItems = _scoreAndSortItems(items);

    feedBlocks.add(const SpacerBlock(spacing: Spacing.small));

    final feedTitle = await _getFeedTitle(categoryId);
    if (feedTitle != null && feedTitle.isNotEmpty) {
      feedBlocks.add(SectionHeaderBlock(title: feedTitle));
    }

    if (isTopFeed) {
      await _generateTopFeed(feedBlocks, scoredItems);
    } else {
      await _generateCategoryFeed(feedBlocks, scoredItems, categoryId);
    }

    feedBlocks.add(const SpacerBlock(spacing: Spacing.medium));

    return feedBlocks;
  }

  Future<void> _generateTopFeed(List<NewsBlock> feedBlocks, List<Map<String, dynamic>> items) async {
    if (items.isEmpty) return;

    final stories = _extractStoryIntroductions(items);
    if (stories.isNotEmpty) {
      final storiesTitle = await _getLabel('section.stories');
      if (storiesTitle != null && storiesTitle.isNotEmpty) {
        feedBlocks.add(SectionHeaderBlock(title: storiesTitle));
      }
      for (final s in stories.take(10)) {
        feedBlocks.add(s);
        feedBlocks.add(const SpacerBlock(spacing: Spacing.small));
      }
      feedBlocks.add(const SpacerBlock(spacing: Spacing.small));
    }

    // 1. Hero article
    final heroItem = items.first;
    final heroBlock = _createPostBlock(heroItem, size: 'large');
    if (heroBlock != null) {
      feedBlocks.add(heroBlock);
      feedBlocks.add(const SpacerBlock(spacing: Spacing.small));
    }

    // 2. Small ad after hero
    feedBlocks.add(const BannerAdBlock(size: BannerSize.normal));
    feedBlocks.add(const SpacerBlock(spacing: Spacing.small));

    // 3. Trending section
    if (items.length > 1) {
      final trendingTitle = await _getLabel('section.trending');
      if (trendingTitle != null && trendingTitle.isNotEmpty) {
        feedBlocks.add(SectionHeaderBlock(title: trendingTitle));
      }

      final trendingItems = items.skip(1).take(3).toList();
      for (var i = 0; i < trendingItems.length; i++) {
        final block = _createPostBlock(trendingItems[i], size: i == 0 ? 'medium' : 'small');
        if (block != null) {
          feedBlocks.add(block);
          if (i < trendingItems.length - 1) {
            feedBlocks.add(const SpacerBlock(spacing: Spacing.small));
          }
        }
      }
    }

    // 4. Large ad
    feedBlocks
      ..add(const SpacerBlock(spacing: Spacing.medium))
      ..add(const BannerAdBlock(size: BannerSize.large))
      ..add(const SpacerBlock(spacing: Spacing.small));

    // 5. Category sections
    final categorizedItems = _groupItemsByCategory(items.skip(4).toList());

    for (final entry in categorizedItems.entries.take(3)) {
      final category = entry.key;
      final categoryItems = entry.value;

      if (categoryItems.length >= 2) {
        final categoryInfo = await _getCategoryInfo(category);
        feedBlocks.add(
          SectionHeaderBlock(
            title: categoryInfo.name,
            action: NavigateToFeedCategoryAction(category: categoryInfo),
          ),
        );

        // First item as medium
        final firstBlock = _createPostBlock(categoryItems.first, size: 'medium');
        if (firstBlock != null) {
          feedBlocks.add(firstBlock);
          feedBlocks.add(const SpacerBlock(spacing: Spacing.small));
        }

        // Grid for remaining items if category has many items
        if (categoryItems.length >= 4) {
          final gridBlocks =
              categoryItems.skip(1).take(4).map(_createPostGridTile).whereType<PostGridTileBlock>().toList();

          if (gridBlocks.isNotEmpty) {
            feedBlocks
              ..add(
                PostGridGroupBlock(
                  categoryId: category,
                  tiles: gridBlocks,
                ),
              )
              ..add(const SpacerBlock(spacing: Spacing.medium));
          }
        } else {
          // Just add remaining as small posts
          for (final item in categoryItems.skip(1).take(2)) {
            final block = _createPostBlock(item, size: 'small');
            if (block != null) {
              feedBlocks.add(block);
              feedBlocks.add(const SpacerBlock(spacing: Spacing.small));
            }
          }
        }

        if (entry.key == categorizedItems.keys.first) {
          feedBlocks.add(const NewsletterBlock());
          feedBlocks.add(const SpacerBlock(spacing: Spacing.medium));
        }

        feedBlocks.add(const DividerHorizontalBlock());
        feedBlocks.add(const SpacerBlock(spacing: Spacing.small));
      }
    }

    // 6. Final ad
    feedBlocks.add(const BannerAdBlock(size: BannerSize.extraLarge));
  }

  Future<void> _generateCategoryFeed(
    List<NewsBlock> feedBlocks,
    List<Map<String, dynamic>> items,
    String categoryId,
  ) async {
    if (items.isEmpty) return;

    for (var i = 0; i < math.min(2, items.length); i++) {
      final block = _createPostBlock(items[i], size: i == 0 ? 'large' : 'medium');
      if (block != null) {
        feedBlocks.add(block);
        feedBlocks.add(const SpacerBlock(spacing: Spacing.small));
      }
    }

    feedBlocks.add(const BannerAdBlock(size: BannerSize.large));
    feedBlocks.add(const SpacerBlock(spacing: Spacing.small));

    if (items.length > 2) {
      final categoryInfo = await _getCategoryInfo(categoryId);
      final template = await _getLabel('section.popular_in');
      final headerTitle = template == null || template.isEmpty
          ? categoryInfo.name
          : _formatLabel(template, {'name': categoryInfo.name});
      feedBlocks.add(SectionHeaderBlock(title: headerTitle));

      for (var i = 2; i < math.min(4, items.length); i++) {
        final block = _createPostBlock(items[i], size: 'medium');
        if (block != null) {
          feedBlocks.add(block);
          feedBlocks.add(const SpacerBlock(spacing: Spacing.small));
        }
      }
    }

    // Newsletter
    feedBlocks.add(const SpacerBlock(spacing: Spacing.small));
    feedBlocks.add(const NewsletterBlock());
    feedBlocks.add(const SpacerBlock(spacing: Spacing.small));

    // Remaining items
    if (items.length > 4) {
      feedBlocks.add(const BannerAdBlock(size: BannerSize.normal));
      feedBlocks.add(const SpacerBlock(spacing: Spacing.small));

      final gridCandidates = items.skip(4).where(_hasImage).take(4).toList();

      if (gridCandidates.length >= 4) {
        final moreTitle = await _getLabel('section.more_news');
        if (moreTitle != null && moreTitle.isNotEmpty) {
          feedBlocks.add(SectionHeaderBlock(title: moreTitle));
        }

        final gridBlocks = gridCandidates.map(_createPostGridTile).whereType<PostGridTileBlock>().toList();

        feedBlocks.add(
          PostGridGroupBlock(
            categoryId: categoryId,
            tiles: gridBlocks,
          ),
        );
      } else {
        for (final item in items.skip(4).take(6)) {
          final block = _createPostBlock(item, size: 'small');
          if (block != null) {
            feedBlocks.add(block);
            feedBlocks.add(const SpacerBlock(spacing: Spacing.small));
          }
        }
      }
    }
  }

  List<Map<String, dynamic>> _scoreAndSortItems(List<Map<String, dynamic>> items) {
    return items
        .map((item) {
          final score = _calculateItemScore(item);
          return {'item': item, 'score': score};
        })
        .sorted((a, b) => (b['score']! as double).compareTo(a['score']! as double))
        .map((e) => e['item']! as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> _rankItems(List<Map<String, dynamic>> items) async {
    try {
      final ids = items.map((e) => e['id']).whereType<String>().toList();
      final res = await _supabaseClient.rpc<List<dynamic>>('rank_items_by_ids', params: {'in_ids': ids});
      if (res.isNotEmpty) {
        final idToScore = <String, double>{};
        for (final row in res.cast<Map<String, dynamic>>()) {
          final id = row['id'] as String?;
          final score = (row['score'] as num?)?.toDouble();
          if (id != null && score != null) idToScore[id] = score;
        }
        final sorted = items
            .map((it) => {'item': it, 'score': idToScore[it['id'] as String?] ?? 0.0})
            .sorted((a, b) => (b['score']! as double).compareTo(a['score']! as double))
            .map((e) => e['item']! as Map<String, dynamic>)
            .toList();
        return sorted;
      }
    } catch (_) {}
    return _scoreAndSortItems(items);
  }

  double _calculateItemScore(Map<String, dynamic> item) {
    var score = 0.0;

    final publishedAtStr = item['published_at'] as String?;
    if (publishedAtStr != null) {
      final publishedAt = DateTime.parse(publishedAtStr);
      final hoursAgo = DateTime.now().difference(publishedAt).inHours;
      score += math.max(0, 168 - hoursAgo) / 168 * 50; // 50 points max for items within a week
    }

    final sourceType = item['source_type'] as String?;
    switch (sourceType) {
      case 'mirea':
        score += 30; // Official news gets priority
      case 'telegram':
        score += 20;
      case 'vk':
        score += 15;
    }

    final blocks = item['news_blocks'] as List?;
    if (blocks != null) {
      score += blocks.length * 2; // More blocks = more comprehensive

      final hasImages = blocks.any(
        (b) =>
            b['type'] == '__image__' ||
            (b['imageUrl'] != null && b['imageUrl'].toString().isNotEmpty) ||
            (b['image_url'] != null && b['image_url'].toString().isNotEmpty),
      );

      final hasVideo = blocks.any((b) => b['type'] == '__video__' || b['type'] == '__video_introduction__');

      final hasSlideshow = blocks.any((b) => b['type'] == '__slideshow__' || b['type'] == '__slideshow_introduction__');

      if (hasImages) score += 15;
      if (hasVideo) score += 20;
      if (hasSlideshow) score += 25;
    }

    final title = item['title'] as String?;
    if (title != null) {
      if (title.length > 20 && title.length < 100) score += 10;
      if (title.contains('МИРЭА') || title.contains('РТУ')) score += 5;
    }

    return score;
  }

  PostBlock? _createPostBlock(Map<String, dynamic> item, {required String size}) {
    final id = item['id'] as String;
    final title = item['title'] as String? ?? '';
    final sourceType = item['source_type'] as String? ?? 'social';
    final sourceId = item['source_id'] as String?;
    final sourceName = item['source_name'] as String? ?? '';
    final publishedAtStr = item['published_at'] as String?;
    final publishedAt = publishedAtStr != null ? DateTime.parse(publishedAtStr) : DateTime.now();

    final blocks = item['news_blocks'] as List?;
    String? imageUrl;
    String? description;

    if (blocks != null && blocks.isNotEmpty) {
      imageUrl = _extractImageUrl(item);

      for (final block in blocks) {
        final blockMap = block as Map<String, dynamic>;
        if (description == null && blockMap['type'] == '__text_paragraph__') {
          description = blockMap['text'] as String?;
        }
      }

      if (description == null) {
        final introBlock = blocks.firstWhereOrNull((b) => (b as Map)['type'] == '__article_introduction__');
        if (introBlock != null) {
          final introMap = introBlock as Map<String, dynamic>;
          description = introMap['title'] as String?;
        }
      }
    }

    description ??= _generateDescription(item);

    final maxDescLength = size == 'large' ? 200 : (size == 'medium' ? 150 : 100);
    if (description.length > maxDescLength) {
      description = '${description.substring(0, maxDescLength)}...';
    }

    final action = NavigateToArticleAction(articleId: id);

    final categoryKey = _composeCategoryKey(sourceType, sourceId);

    switch (size) {
      case 'large':
        return PostLargeBlock(
          id: id,
          categoryId: categoryKey,
          author: sourceName,
          publishedAt: publishedAt,
          imageUrl: imageUrl ?? '',
          title: title,
          description: description,
          action: action,
        );
      case 'medium':
        return PostMediumBlock(
          id: id,
          categoryId: categoryKey,
          author: sourceName,
          publishedAt: publishedAt,
          imageUrl: imageUrl ?? '',
          title: title,
          description: description,
          action: action,
        );
      default:
        return PostSmallBlock(
          id: id,
          categoryId: categoryKey,
          author: sourceName,
          publishedAt: publishedAt,
          imageUrl: imageUrl ?? '',
          title: title,
          description: description,
          action: action,
        );
    }
  }

  PostGridTileBlock? _createPostGridTile(Map<String, dynamic> item) {
    final id = item['id'] as String;
    final title = item['title'] as String? ?? 'Без заголовка';
    final sourceType = item['source_type'] as String? ?? 'social';
    final sourceId = item['source_id'] as String?;
    final sourceName = item['source_name'] as String? ?? 'Unknown';
    final publishedAtStr = item['published_at'] as String?;
    final publishedAt = publishedAtStr != null ? DateTime.parse(publishedAtStr) : DateTime.now();

    final imageUrl = _extractImageUrl(item);
    if (imageUrl == null || imageUrl.isEmpty) return null;

    return PostGridTileBlock(
      id: id,
      categoryId: _composeCategoryKey(sourceType, sourceId),
      author: sourceName,
      publishedAt: publishedAt,
      imageUrl: imageUrl,
      title: title,
      action: NavigateToArticleAction(articleId: id),
    );
  }

  String? _extractImageUrl(Map<String, dynamic> item) {
    final blocks = item['news_blocks'] as List?;
    if (blocks == null || blocks.isEmpty) return null;

    for (final block in blocks) {
      final blockMap = block as Map<String, dynamic>;
      final imageUrl = blockMap['imageUrl'] as String? ??
          blockMap['image_url'] as String? ??
          blockMap['coverImageUrl'] as String? ??
          blockMap['cover_image_url'] as String?;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        return imageUrl;
      }
    }
    return null;
  }

  bool _hasImage(Map<String, dynamic> item) {
    final imageUrl = _extractImageUrl(item);
    return imageUrl != null && imageUrl.isNotEmpty;
  }

  String _generateDescription(Map<String, dynamic> item) {
    final blocks = item['news_blocks'] as List?;
    if (blocks == null || blocks.isEmpty) {
      return '';
    }

    // Try to extract text from blocks
    final textParts = <String>[];
    for (final block in blocks) {
      final blockMap = block as Map<String, dynamic>;
      final text = blockMap['text'] as String?;
      if (text != null && text.isNotEmpty) {
        textParts.add(text);
      }
    }

    if (textParts.isEmpty) {
      return '';
    }

    return textParts.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _extractTextFromBlocks(dynamic blocks) {
    if (blocks == null || blocks is! List) return '';

    final textParts = <String>[];
    for (final block in blocks) {
      if (block is Map<String, dynamic>) {
        final text = block['text'] as String?;
        final title = block['title'] as String?;
        final description = block['description'] as String?;

        if (text != null) textParts.add(text);
        if (title != null) textParts.add(title);
        if (description != null) textParts.add(description);
      }
    }

    return textParts.join(' ');
  }

  Map<String, List<Map<String, dynamic>>> _groupItemsByCategory(List<Map<String, dynamic>> items) {
    final grouped = <String, List<Map<String, dynamic>>>{};

    for (final item in items) {
      final sourceType = (item['source_type'] as String?) ?? 'other';
      final sourceId = (item['source_id'] as String?) ?? '';
      final key = sourceId.isNotEmpty ? 'source:$sourceType:$sourceId' : sourceType;
      grouped.putIfAbsent(key, () => []).add(item);
    }

    final sortedEntries = grouped.entries.toList()..sort((a, b) => b.value.length.compareTo(a.value.length));

    return Map.fromEntries(sortedEntries);
  }

  bool _areItemsRelated(Map<String, dynamic> item1, Map<String, dynamic> item2) {
    if (item1['source_type'] == item2['source_type']) return true;

    final title1 = (item1['title'] as String? ?? '').toLowerCase();
    final title2 = (item2['title'] as String? ?? '').toLowerCase();

    final words1 = title1.split(RegExp(r'\s+')).where((w) => w.length > 3).toSet();
    final words2 = title2.split(RegExp(r'\s+')).where((w) => w.length > 3).toSet();

    final commonWords = words1.intersection(words2);
    return commonWords.length >= 2;
  }

  Future<String?> _getFeedTitle(String? categoryId) async {
    if (categoryId == null || categoryId.isEmpty) {
      final lbl = await _getLabel('feed.title.top');
      return lbl ?? '';
    }

    final safeKey = categoryId.replaceAll(':', '.');
    final byId = await _getLabel('feed.title.$safeKey');
    if (byId != null && byId.isNotEmpty) return byId;

    final categoryInfo = await _getCategoryInfo(categoryId);
    return categoryInfo.name;
  }

  Future<api.Category> _getCategoryInfo(String categoryId) async {
    final categories = await getCategories();
    return categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => api.Category(id: categoryId, name: categoryId),
    );
  }

  List<SlideshowIntroductionBlock> _extractStoryIntroductions(List<Map<String, dynamic>> items) {
    final result = <SlideshowIntroductionBlock>[];
    for (final item in items) {
      final blocks = item['news_blocks'] as List?;
      if (blocks == null) continue;
      for (final b in blocks) {
        if (b is Map<String, dynamic> && b['type'] == '__slideshow_introduction__') {
          try {
            final parsed = NewsBlock.fromJson(b);
            if (parsed is SlideshowIntroductionBlock) {
              result.add(parsed);
            }
          } catch (_) {}
          break;
        }
      }
    }
    return result;
  }
}

Map<String, dynamic> _normalizeBlockKeys(Map<String, dynamic> original) {
  final mapped = <String, dynamic>{};
  original.forEach((key, value) {
    switch (key) {
      case 'category_id':
        mapped['categoryId'] = value;
      case 'published_at':
        mapped['publishedAt'] = value;
      case 'image_url':
        mapped['imageUrl'] = value;
      case 'video_url':
        mapped['videoUrl'] = value;
      case 'cover_image_url':
        mapped['coverImageUrl'] = value;
      case 'is_content_overlaid':
        mapped['isContentOverlaid'] = value;
      case 'photo_credit':
        mapped['photoCredit'] = value;
      default:
        mapped[key] = value;
    }
  });
  return mapped;
}

String _composeCategoryKey(String? sourceType, String? sourceId) {
  final st = (sourceType ?? 'social').trim();
  final sid = (sourceId ?? '').trim();
  if (sid.isNotEmpty) {
    return 'source:$st:$sid';
  }
  return st;
}
