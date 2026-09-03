import 'package:news_blocks/news_blocks.dart' as nb;
import 'package:news_repository/src/mappers/news_feed_item_mapper_card_size.dart';
import 'package:news_repository/src/models/news_feed_item.dart';

nb.NewsBlock mapNewsFeedItem(NewsFeedItem item, int position) {
  final blocks = item.newsBlocks;
  final imageUrl = _extractUrl(blocks, const [
    'imageUrl',
    'image_url',
    'coverImageUrl',
    'cover_image_url',
  ]);
  return _buildPost(item, position, imageUrl);
}

nb.NewsBlock _buildPost(NewsFeedItem item, int position, String? imageUrl) {
  final action = nb.NavigateToArticleAction(articleId: item.id);
  final category = mapNewsCategoryKey(item.sourceType, item.sourceId);
  final description = _description(item, position);
  final size = _size(item.newsBlocks, imageUrl, position);
  final common = (
    id: item.id,
    category: category,
    author: item.sourceName,
    publishedAt: item.publishedAt,
    title: item.title,
    description: description,
    action: action,
  );

  return switch ((size, imageUrl)) {
    (NewsFeedItemMapperCardSize.large, final String url) => nb.PostLargeBlock(
      id: common.id,
      categoryId: common.category,
      author: common.author,
      publishedAt: common.publishedAt,
      imageUrl: url,
      title: common.title,
      description: common.description,
      action: common.action,
    ),
    (NewsFeedItemMapperCardSize.medium, final String url) => nb.PostMediumBlock(
      id: common.id,
      categoryId: common.category,
      author: common.author,
      publishedAt: common.publishedAt,
      imageUrl: url,
      title: common.title,
      description: common.description,
      action: common.action,
    ),
    _ => nb.PostSmallBlock(
      id: common.id,
      categoryId: common.category,
      author: common.author,
      publishedAt: common.publishedAt,
      title: common.title,
      description: common.description,
      action: common.action,
      imageUrl: imageUrl,
    ),
  };
}

String? _extractUrl(List<Map<String, dynamic>> blocks, List<String> keys) {
  for (final block in blocks) {
    for (final key in keys) {
      final value = block[key];
      if (value is! String) continue;
      final uri = Uri.tryParse(value.trim());
      if (uri != null &&
          uri.scheme == 'https' &&
          uri.host.isNotEmpty &&
          uri.userInfo.isEmpty &&
          !RegExp(
            r'\.(mp4|webm|mov)$',
            caseSensitive: false,
          ).hasMatch(uri.path)) {
        return uri.toString();
      }
    }
  }
  return null;
}

NewsFeedItemMapperCardSize _size(
  List<Map<String, dynamic>> blocks,
  String? imageUrl,
  int position,
) {
  if (position == 0) return NewsFeedItemMapperCardSize.large;
  final length = _textLength(blocks);
  if (imageUrl != null && length > 600) {
    return NewsFeedItemMapperCardSize.large;
  }
  if ((imageUrl != null && length > 350) || length > 200) {
    return NewsFeedItemMapperCardSize.medium;
  }
  return NewsFeedItemMapperCardSize.small;
}

int _textLength(List<Map<String, dynamic>> blocks) {
  final buffer = StringBuffer();
  for (final block in blocks) {
    for (final key in const ['text', 'title', 'description', 'caption']) {
      final value = block[key];
      if (value is String) buffer.write(value);
    }
    final html = block['content'];
    if (html is String) buffer.write(html.replaceAll(RegExp('<[^>]*>'), ''));
  }
  return buffer.length;
}

String _description(NewsFeedItem item, int position) {
  final limit = position == 0 ? 200 : (position < 3 ? 150 : 100);
  final text = _firstText(item.newsBlocks) ?? item.title;
  return text.length > limit ? '${text.substring(0, limit)}...' : text;
}

String? _firstText(List<Map<String, dynamic>> blocks) {
  for (final block in blocks) {
    final type = block['type'];
    if (type == '__text_paragraph__' || type == '__text_lead_paragraph__') {
      final text = block['text'];
      if (text is String && text.trim().isNotEmpty) return text.trim();
    }
  }
  for (final block in blocks) {
    final type = block['type'];
    if (type == '__article_introduction__' ||
        type == '__slideshow_introduction__') {
      final title = block['title'];
      if (title is String && title.trim().isNotEmpty) return title.trim();
    }
  }
  return null;
}

/// Builds a stable feed category key for an external source.
String mapNewsCategoryKey(String? sourceType, String? sourceId) {
  final type = (sourceType ?? 'social').trim();
  final id = (sourceId ?? '').trim();
  return id.isEmpty ? type : 'source:$type:$id';
}
