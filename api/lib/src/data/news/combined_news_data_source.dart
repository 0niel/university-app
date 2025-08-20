import 'dart:math' as math;

import 'package:news_blocks/news_blocks.dart';
import 'package:supabase/supabase.dart';
import 'package:university_app_server_api/api.dart' as api;

final _logger = api.getLogger('CombinedNewsDataSource');

/// {@template combined_news_data_source}
/// A news data source that combines news with social media content.
/// {@endtemplate}
class CombinedNewsDataSource implements api.NewsDataSource {
  /// {@macro combined_news_data_source}
  CombinedNewsDataSource({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  final Map<String, api.Article> _articleCache = {};

  Future<List<Map<String, dynamic>>> _getNewsItems({
    int limit = 20,
    int offset = 0,
    String? category,
  }) async {
    try {
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

      if (category != null && category != 'all') {
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

      final response = await query
          .order('published_at', ascending: false)
          .range(offset, offset + limit - 1);

      final list = (response as List).cast<Map<String, dynamic>>();
      return list;
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to fetch social news',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  @override
  Future<api.Article?> getArticle({
    required String id,
  }) async {
    try {
      var fullArticle = _articleCache[id];

      if (fullArticle == null) {
        final response = await _supabaseClient
            .from('social_news_items')
            .select()
            .eq('id', id)
            .maybeSingle();
        if (response == null) {
          return null;
        }

        fullArticle = _convertToFullArticle(response);
        _articleCache[id] = fullArticle;
      }

      return fullArticle;
    } catch (e, stackTrace) {
      _logger.e('Failed to get article $id', error: e, stackTrace: stackTrace);
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
    final publishedAt = json['published_at'] != null
        ? DateTime.parse(json['published_at'] as String)
        : DateTime.now();

    final blocks = <NewsBlock>[];

    if (newsBlocksJson != null && newsBlocksJson.isNotEmpty) {
      for (final blockJson in newsBlocksJson) {
        try {
          blocks.add(NewsBlock.fromJson(blockJson as Map<String, dynamic>));
        } catch (e) {
          _logger.w('Failed to parse news block', error: e);
        }
      }
    }

    var hasIntroBlock = false;
    if (blocks.isNotEmpty) {
      final firstBlock = blocks.first;
      hasIntroBlock = firstBlock is ArticleIntroductionBlock ||
          firstBlock is VideoIntroductionBlock;
    }

    if (!hasIntroBlock) {
      blocks.insert(
        0,
        ArticleIntroductionBlock(
          categoryId: _composeCategoryKey(sourceType, sourceId),
          author: sourceName ?? '',
          publishedAt: publishedAt,
          title: title,
        ),
      );
    } else {
      final first = blocks.first;
      if (first is ArticleIntroductionBlock &&
          (first.imageUrl == null || first.imageUrl!.trim().isEmpty)) {
        blocks[0] = ArticleIntroductionBlock(
          categoryId: first.categoryId,
          author: first.author,
          publishedAt: first.publishedAt,
          title: first.title,
        );
      }

      // De-duplicate body when it repeats the intro title
      if (blocks.length >= 2 &&
          blocks[0] is ArticleIntroductionBlock &&
          blocks[1] is TextLeadParagraphBlock) {
        final intro = blocks[0] as ArticleIntroductionBlock;
        final lead = blocks[1] as TextLeadParagraphBlock;
        final t = intro.title.trim();
        final body = lead.text.trim();

        if (t.isNotEmpty && body.isNotEmpty) {
          if (body == t) {
            blocks.removeAt(1);
          } else if (body.startsWith(t)) {
            final trimmed = body.substring(t.length).trimLeft();
            blocks[1] = TextLeadParagraphBlock(text: trimmed);
          }
        }
      }
    }

    return api.Article(
      title: title,
      blocks: blocks,
      totalBlocks: blocks.length,
      url: Uri.tryParse(originalUrl) ?? Uri(),
    );
  }

  @override
  Future<List<NewsBlock>> getPopularArticles() async {
    try {
      final items = await _getNewsItems();
      final blocks = <NewsBlock>[];
      for (var i = 0; i < math.min(10, items.length); i++) {
        final size = _determinePostSize(items[i], i);
        final block = _createPostBlock(items[i], size: size);
        if (block != null) blocks.add(block);
      }
      return blocks;
    } catch (e) {
      _logger.e('Failed to get popular articles', error: e);
      return [];
    }
  }

  @override
  Future<List<NewsBlock>> getRelevantArticles({required String term}) async {
    try {
      final items = await _getNewsItems(limit: 100);
      final relevantItems = items.where((item) {
        final searchableText =
            '${item['title']} ${_extractTextFromBlocks(item['news_blocks'])}';
        return searchableText.toLowerCase().contains(term.toLowerCase());
      }).toList();

      final blocks = <NewsBlock>[];
      for (var i = 0; i < relevantItems.take(20).length; i++) {
        final item = relevantItems.elementAt(i);
        final size = _determinePostSize(item, i);
        final block = _createPostBlock(item, size: size);
        if (block != null) blocks.add(block);
      }
      return blocks;
    } catch (e) {
      _logger.e('Failed to get relevant articles', error: e);
      return [];
    }
  }

  @override
  Future<List<String>> getRelevantTopics({required String term}) async {
    final categories = await getCategories();
    final matchingCategories = categories
        .where((cat) => cat.name.toLowerCase().contains(term.toLowerCase()))
        .map((cat) => cat.name)
        .toList();
    return matchingCategories;
  }

  @override
  Future<List<String>> getPopularTopics() async {
    return [];
  }

  @override
  Future<api.RelatedArticles> getRelatedArticles({
    required String id,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final items = await _getNewsItems(limit: 200);
      final baseItem = items.firstWhere(
        (item) => item['id'] == id,
        orElse: () => {},
      );
      if (baseItem.isEmpty) {
        return const api.RelatedArticles(blocks: [], totalBlocks: 0);
      }
      final relatedItems = items
          .where((item) => item['id'] != id && _areItemsRelated(baseItem, item))
          .toList();
      final totalBlocks = relatedItems.length;
      final normalizedOffset = math.min(offset, totalBlocks);
      final paginatedItems =
          relatedItems.sublist(normalizedOffset).take(limit).toList();

      final blocks = <NewsBlock>[];
      for (var i = 0; i < paginatedItems.length; i++) {
        final item = paginatedItems[i];
        final size = _determinePostSize(item, i + offset);
        final block = _createPostBlock(item, size: size);
        if (block != null) blocks.add(block);
      }

      return api.RelatedArticles(blocks: blocks, totalBlocks: totalBlocks);
    } catch (e) {
      _logger.e('Failed to get related articles', error: e);
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
      final normalizedCategoryId = (categoryId.isEmpty) ? 'all' : categoryId;
      final items = await _getNewsItems(
        limit: math.min(200, limit * 5),
        offset: offset,
        category: normalizedCategoryId == 'all' ? null : normalizedCategoryId,
      );

      final blocks = <NewsBlock>[];
      for (var i = 0; i < items.length; i++) {
        final size = _determinePostSize(items[i], i + offset);
        final block = _createPostBlock(items[i], size: size);
        if (block != null) blocks.add(block);
        if (blocks.length >= limit) break;
      }

      final hasMore = items.length > blocks.length;
      final totalApprox = offset + blocks.length + (hasMore ? 1 : 0);
      return api.Feed(blocks: blocks, totalBlocks: totalApprox);
    } catch (e) {
      _logger.e('Failed to generate feed', error: e);
      return const api.Feed(blocks: [], totalBlocks: 0);
    }
  }

  @override
  Future<List<api.Category>> getCategories() async {
    final categories = <api.Category>[]
      ..add(const api.Category(id: 'all', name: 'Все'));

    try {
      final sourcesRaw = await _supabaseClient
          .from('social_news_sources')
          .select('source_type,source_id,source_name,is_active')
          .eq('is_active', true)
          .order('source_type')
          .order('source_name');

      final sources = (sourcesRaw as List).cast<Map<String, dynamic>>();
      final typeOrder = <String>[];
      final typeToSources = <String, List<Map<String, dynamic>>>{};

      for (final m in sources) {
        final st = (m['source_type'] as String?)?.trim();
        final sid = (m['source_id'] as String?)?.trim();
        if (st == null || st.isEmpty || sid == null || sid.isEmpty) continue;

        if (!typeOrder.contains(st)) typeOrder.add(st);
        typeToSources.putIfAbsent(st, () => <Map<String, dynamic>>[]).add(m);
      }

      for (final st in typeOrder) {
        categories.add(api.Category(id: st, name: st));
        final sourcesForType =
            typeToSources[st] ?? const <Map<String, dynamic>>[];
        for (final m in sourcesForType) {
          final sid = (m['source_id'] as String?)?.trim();
          final sname = (m['source_name'] as String?)?.trim();
          if (sid == null || sid.isEmpty) continue;
          final id = 'source:$st:$sid';
          final name = (sname == null || sname.isEmpty) ? '$st/$sid' : sname;
          categories.add(api.Category(id: id, name: name));
        }
      }
    } catch (_) {}

    return categories;
  }

  NewsBlock? _createPostBlock(
    Map<String, dynamic> item, {
    required String size,
  }) {
    final id = item['id'] as String;
    final title = item['title'] as String? ?? '';
    final sourceType = item['source_type'] as String? ?? 'social';
    final sourceId = item['source_id'] as String?;
    final sourceName = item['source_name'] as String? ?? '';
    final publishedAtStr = item['published_at'] as String?;
    final publishedAt = publishedAtStr != null
        ? DateTime.parse(publishedAtStr)
        : DateTime.now();

    final blocks = (item['news_blocks'] as List?)?.cast<Map<String, dynamic>>();
    String? imageUrl;
    String? description;

    if (blocks != null && blocks.isNotEmpty) {
      imageUrl = _extractImageUrl(item);

      for (final block in blocks) {
        final type = block['type'] as String?;
        if (description == null &&
            (type == TextParagraphBlock.identifier ||
                type == TextLeadParagraphBlock.identifier)) {
          description = (block['text'] as String?)?.trim();
        }
      }

      if (description == null || description.isEmpty) {
        final introBlock = blocks.firstWhere(
          (b) {
            final type = b['type'] as String?;
            return type == ArticleIntroductionBlock.identifier ||
                type == SlideshowIntroductionBlock.identifier;
          },
          orElse: () => const <String, dynamic>{},
        );
        if (introBlock.isNotEmpty) {
          description = (introBlock['title'] as String?)?.trim();
        }
      }
    }

    description ??= _generateDescription(item);

    final maxDescLength =
        size == 'large' ? 200 : (size == 'medium' ? 150 : 100);
    if (description.length > maxDescLength) {
      description = '${description.substring(0, maxDescLength)}...';
    }

    var isVideoOnly = false;
    if (blocks != null) {
      var containsVideo = false;
      var containsText = false;
      for (final block in blocks) {
        final type = block['type'] as String?;
        if (type == VideoBlock.identifier ||
            type == VideoIntroductionBlock.identifier) {
          containsVideo = true;
        }
        if (type == TextParagraphBlock.identifier ||
            type == TextLeadParagraphBlock.identifier ||
            type == HtmlBlock.identifier) {
          containsText = true;
        }
      }
      isVideoOnly = containsVideo && !containsText;
    }

    if (isVideoOnly) {
      final feedVideoUrl = _extractVideoUrl(item);
      if (feedVideoUrl != null && feedVideoUrl.isNotEmpty) {
        return VideoBlock(videoUrl: feedVideoUrl);
      }
    }

    final categoryKey = _composeCategoryKey(sourceType, sourceId);

    final effectiveSize = size;

    switch (effectiveSize) {
      case 'large':
        if (imageUrl != null && imageUrl.isNotEmpty) {
          return PostLargeBlock(
            id: id,
            categoryId: categoryKey,
            author: sourceName,
            publishedAt: publishedAt,
            imageUrl: imageUrl,
            title: title,
            description: description,
            action: NavigateToArticleAction(articleId: id),
          );
        } else {
          return PostSmallBlock(
            id: id,
            categoryId: categoryKey,
            author: sourceName,
            publishedAt: publishedAt,
            title: title,
            description: description,
            action: NavigateToArticleAction(articleId: id),
          );
        }
      case 'medium':
        if (imageUrl != null && imageUrl.isNotEmpty) {
          return PostMediumBlock(
            id: id,
            categoryId: categoryKey,
            author: sourceName,
            publishedAt: publishedAt,
            imageUrl: imageUrl,
            title: title,
            description: description,
            action: NavigateToArticleAction(articleId: id),
          );
        } else {
          return PostSmallBlock(
            id: id,
            categoryId: categoryKey,
            author: sourceName,
            publishedAt: publishedAt,
            title: title,
            description: description,
            action: NavigateToArticleAction(articleId: id),
          );
        }
      default:
        return PostSmallBlock(
          id: id,
          categoryId: categoryKey,
          author: sourceName,
          publishedAt: publishedAt,
          title: title,
          description: description,
          action: NavigateToArticleAction(articleId: id),
          imageUrl: imageUrl,
        );
    }
  }

  String _determinePostSize(Map<String, dynamic> item, int position) {
    final blocks = (item['news_blocks'] as List?)?.cast<Map<String, dynamic>>();
    if (blocks == null || blocks.isEmpty) return 'small';

    final hasImage = _extractImageUrl(item) != null;
    final totalTextContent = _extractTotalTextContent(item);
    final contentLength = totalTextContent.length;

    if (position == 0) return 'large';

    if (hasImage && contentLength > 600) {
      return 'large';
    } else if (hasImage && contentLength > 350) {
      return 'medium';
    } else if (contentLength > 200) {
      return 'medium';
    } else {
      return 'small';
    }
  }

  String? _extractImageUrl(Map<String, dynamic> item) {
    final blocks = (item['news_blocks'] as List?)?.cast<Map<String, dynamic>>();
    if (blocks == null || blocks.isEmpty) return null;

    for (final block in blocks) {
      final blockType = block['type'] as String?;
      if (blockType == ArticleIntroductionBlock.identifier) {
        final imageUrl =
            block['imageUrl'] as String? ?? block['image_url'] as String?;
        if (imageUrl != null && imageUrl.trim().isNotEmpty) {
          return imageUrl;
        }
      } else if (blockType == SlideshowIntroductionBlock.identifier) {
        final coverImage = block['coverImageUrl'] as String? ??
            block['cover_image_url'] as String? ??
            block['imageUrl'] as String? ??
            block['image_url'] as String?;
        if (coverImage != null && coverImage.trim().isNotEmpty) {
          return coverImage;
        }
      }
    }

    for (final block in blocks) {
      final imageUrl = block['imageUrl'] as String? ??
          block['image_url'] as String? ??
          block['coverImageUrl'] as String? ??
          block['cover_image_url'] as String?;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        return imageUrl;
      }
    }
    return null;
  }

  String _generateDescription(Map<String, dynamic> item) {
    final blocks = (item['news_blocks'] as List?)?.cast<Map<String, dynamic>>();
    if (blocks == null || blocks.isEmpty) {
      return '';
    }

    final textParts = <String>[];
    for (final block in blocks) {
      final text = block['text'] as String?;
      if (text != null && text.isNotEmpty) {
        textParts.add(text);
      }
    }

    if (textParts.isEmpty) {
      return '';
    }

    return textParts.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _extractTotalTextContent(Map<String, dynamic> item) {
    final blocks = (item['news_blocks'] as List?)?.cast<Map<String, dynamic>>();
    if (blocks == null || blocks.isEmpty) {
      return '';
    }

    final textParts = <String>[];

    for (final block in blocks) {
      final text = block['text'] as String?;
      final title = block['title'] as String?;
      final description = block['description'] as String?;
      final caption = block['caption'] as String?;
      final html = block['content'] as String?;

      if (text != null && text.isNotEmpty) {
        textParts.add(text);
      }
      if (title != null && title.isNotEmpty) {
        textParts.add(title);
      }
      if (description != null && description.isNotEmpty) {
        textParts.add(description);
      }
      if (caption != null && caption.isNotEmpty) {
        textParts.add(caption);
      }
      if (html != null && html.isNotEmpty) {
        final htmlText = _extractTextFromHtml(html);
        if (htmlText.isNotEmpty) {
          textParts.add(htmlText);
        }
      }
    }

    if (textParts.isEmpty) {
      return '';
    }

    return textParts.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _extractTextFromHtml(String html) {
    return html.replaceAll(RegExp('<[^>]*>'), '').trim();
  }

  String? _extractVideoUrl(Map<String, dynamic> item) {
    final blocks = (item['news_blocks'] as List?)?.cast<Map<String, dynamic>>();
    if (blocks == null || blocks.isEmpty) return null;
    for (final block in blocks) {
      final type = block['type'] as String?;
      if (type == VideoBlock.identifier ||
          type == VideoIntroductionBlock.identifier) {
        final videoUrl = block['video_url'] as String?;
        if (videoUrl != null && videoUrl.isNotEmpty) return videoUrl;
      }
    }
    return null;
  }

  String _extractTextFromBlocks(dynamic blocks) {
    if (blocks == null || blocks is! List) return '';

    final textParts = <String>[];
    for (final block in blocks.cast<dynamic>()) {
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

  bool _areItemsRelated(
    Map<String, dynamic> item1,
    Map<String, dynamic> item2,
  ) {
    if (item1['source_type'] == item2['source_type']) return true;

    final title1 = (item1['title'] as String? ?? '').toLowerCase();
    final title2 = (item2['title'] as String? ?? '').toLowerCase();

    final words1 =
        title1.split(RegExp(r'\s+')).where((w) => w.length > 3).toSet();
    final words2 =
        title2.split(RegExp(r'\s+')).where((w) => w.length > 3).toSet();

    final commonWords = words1.intersection(words2);
    return commonWords.length >= 2;
  }
}

String _composeCategoryKey(String? sourceType, String? sourceId) {
  final st = (sourceType ?? 'social').trim();
  final sid = (sourceId ?? '').trim();
  if (sid.isNotEmpty) {
    return 'source:$st:$sid';
  }
  return st;
}
