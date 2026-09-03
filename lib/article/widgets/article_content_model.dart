import 'package:news_blocks/news_blocks.dart';

class ArticleContentModel {
  const ArticleContentModel({
    required this.title,
    this.source,
    this.categoryId,
    this.publishedAt,
    this.imageUrl,
    this.lead,
    this.body = const <NewsBlock>[],
    this.hashtags = const <String>[],
  });

  factory ArticleContentModel.fromBlocks(
    List<NewsBlock> blocks, {
    String? fallbackTitle,
  }) {
    String? title;
    String? source;
    String? categoryId;
    DateTime? publishedAt;
    String? imageUrl;
    String? lead;
    final body = <NewsBlock>[];
    final texts = <String>[];

    for (final block in blocks) {
      switch (block) {
        case ArticleIntroductionBlock():
          title ??= block.title;
          source ??= block.author;
          categoryId ??= block.categoryId;
          publishedAt ??= block.publishedAt;
          imageUrl ??= block.imageUrl;
        case VideoIntroductionBlock():
          title ??= block.title;
          categoryId ??= block.categoryId;
          body.add(VideoBlock(videoUrl: block.videoUrl));
        case TextLeadParagraphBlock():
          if (lead == null) {
            lead = block.text;
          } else {
            body.add(block);
          }
          texts.add(block.text);
        case ImageBlock():
          if (imageUrl == null) {
            imageUrl = block.imageUrl;
          } else {
            body.add(block);
          }
        case TextParagraphBlock():
          body.add(block);
          texts.add(block.text);
        case TextHeadlineBlock():
          body.add(block);
          texts.add(block.text);
        case TextCaptionBlock():
          body.add(block);
        case HtmlBlock():
          body.add(block);
          texts.add(block.content.replaceAll(RegExp('<[^>]*>'), ' '));
        case VideoBlock():
          body.add(block);
        default:
          break;
      }
    }

    final resolvedTitle = (title ?? '').trim().isEmpty
        ? (fallbackTitle ?? '')
        : title ?? '';
    return ArticleContentModel(
      title: resolvedTitle,
      source: (source ?? '').trim().isEmpty ? null : source,
      categoryId: categoryId,
      publishedAt: publishedAt,
      imageUrl: imageUrl,
      lead: (lead ?? '').trim().isEmpty ? null : lead,
      body: body,
      hashtags: extractHashtags(texts),
    );
  }

  final String title;
  final String? source;
  final String? categoryId;
  final DateTime? publishedAt;
  final String? imageUrl;
  final String? lead;
  final List<NewsBlock> body;
  final List<String> hashtags;

  static final _hashtag = RegExp(r'#[\p{L}\p{N}_\-]+', unicode: true);

  static List<String> extractHashtags(Iterable<String> texts, {int max = 6}) {
    final tags = <String>{};
    for (final text in texts) {
      for (final match in _hashtag.allMatches(text)) {
        final tag = match.group(0);
        if (tag != null && tag.length > 1) tags.add(tag);
        if (tags.length >= max) return tags.toList(growable: false);
      }
    }
    return tags.toList(growable: false);
  }
}
