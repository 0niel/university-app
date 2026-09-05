import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart' show Video;
import 'package:rtu_mirea_app/article/widgets/article_html.dart';
import 'package:rtu_mirea_app/article/widgets/article_media.dart';
import 'package:rtu_mirea_app/feed/widgets/widgets.dart';

class ArticleBlockView extends StatelessWidget {
  const ArticleBlockView({
    required this.block,
    super.key,
    this.gallery = const [],
    this.sourceUri,
  });

  final NewsBlock block;
  final List<String> gallery;
  final Uri? sourceUri;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final block = this.block;
    return switch (block) {
      TextParagraphBlock(:final text) => Text(
        text,
        style: AppText.paragraph.copyWith(color: colors.ink, height: 1.55),
      ),
      TextLeadParagraphBlock(:final text) => Text(
        text,
        style: AppText.lead.copyWith(color: colors.muted, height: 1.5),
      ),
      TextHeadlineBlock(:final text) => Text(
        text,
        style: AppText.title.copyWith(color: colors.ink, height: 1.25),
      ),
      TextCaptionBlock(:final text, :final color) => Text(
        text,
        style: AppText.subtext.copyWith(
          color: color == TextCaptionColor.light ? colors.muted2 : colors.muted,
          height: 1.4,
        ),
      ),
      ImageBlock(:final imageUrl) => FeedImage(
        imageUrl: articleImageUrl(imageUrl, sourceUri: sourceUri),
        gallery: gallery,
        radius: AppRadius.card,
        height: 220,
        width: double.infinity,
      ),
      VideoBlock() => ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Video(block: block),
      ),
      HtmlBlock(:final content) => ArticleHtml(
        content: content,
        sourceUri: sourceUri,
        gallery: gallery,
      ),
      SlideshowBlock(:final slides) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sectionGap,
        children: [
          for (final slide in slides)
            ArticleBlockView(
              block: slide,
              gallery: gallery,
              sourceUri: sourceUri,
            ),
        ],
      ),
      SlideBlock(
        :final imageUrl,
        :final caption,
        :final description,
        :final photoCredit,
      ) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.sm,
          children: [
            FeedImage(
              imageUrl: articleImageUrl(imageUrl, sourceUri: sourceUri),
              gallery: gallery,
              radius: AppRadius.card,
              height: 220,
              width: double.infinity,
            ),
            if (caption.isNotEmpty) Text(caption, style: AppText.subtextStrong),
            if (description.isNotEmpty)
              Text(description, style: AppText.paragraph),
            if (photoCredit.isNotEmpty)
              Text(
                photoCredit,
                style: AppText.caption.copyWith(color: colors.muted),
              ),
          ],
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
