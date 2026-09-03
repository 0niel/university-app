import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart' show Video;
import 'package:rtu_mirea_app/article/widgets/article_html.dart';
import 'package:rtu_mirea_app/feed/widgets/widgets.dart';

class ArticleBlockView extends StatelessWidget {
  const ArticleBlockView({required this.block, super.key});

  final NewsBlock block;

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
        imageUrl: imageUrl,
        radius: AppRadius.card,
        height: 220,
        width: double.infinity,
      ),
      VideoBlock() => ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Video(block: block),
      ),
      HtmlBlock(:final content) => ArticleHtml(content: content),
      _ => const SizedBox.shrink(),
    };
  }
}
