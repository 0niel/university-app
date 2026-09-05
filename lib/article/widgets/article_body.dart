import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:rtu_mirea_app/article/widgets/article_block_view.dart';
import 'package:rtu_mirea_app/article/widgets/article_content_model.dart';
import 'package:rtu_mirea_app/article/widgets/article_media.dart';
import 'package:rtu_mirea_app/article/widgets/article_related.dart';
import 'package:rtu_mirea_app/article/widgets/article_source_card.dart';
import 'package:rtu_mirea_app/feed/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ArticleBody extends StatelessWidget {
  const ArticleBody({
    required this.model,
    super.key,
    this.related = const <NewsBlock>[],
    this.sourceUri,
  });

  final ArticleContentModel model;
  final List<NewsBlock> related;
  final Uri? sourceUri;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final source = model.source;
    final publishedAt = model.publishedAt;
    final lead = model.lead;
    final cover = articleImageUrl(model.imageUrl, sourceUri: sourceUri);
    final gallery = articleGallery(
      cover: model.imageUrl,
      blocks: model.body,
      sourceUri: sourceUri,
    );
    final metaStyle = AppText.subtextStrong.copyWith(color: colors.muted);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (source != null || publishedAt != null)
          Row(
            children: [
              if (source != null) ...[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.tint,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.gap,
                      vertical: 5,
                    ),
                    child: Text(
                      source,
                      key: const Key('article_sourcePill'),
                      style: metaStyle.copyWith(color: colors.accent),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              if (publishedAt != null)
                Expanded(
                  child: Text(
                    _timeAgo(l10n, publishedAt),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: metaStyle,
                  ),
                ),
            ],
          ),
        const SizedBox(height: AppSpacing.sectionGap),
        AppBalancedText(
          model.title,
          key: const Key('article_title'),
          style: AppText.displayCompact.copyWith(
            color: colors.ink,
            height: 1.12,
          ),
        ),
        if (lead != null) ...[
          const SizedBox(height: AppSpacing.sectionGap),
          Text(
            lead,
            style: AppText.lead.copyWith(color: colors.muted, height: 1.5),
          ),
        ],
        if (cover != null) ...[
          const SizedBox(height: AppSpacing.screen),
          FeedImage(
            key: const Key('article_cover'),
            imageUrl: cover,
            gallery: gallery,
            radius: AppRadius.card,
            height: 220,
            width: double.infinity,
          ),
        ],
        if (model.body.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.screen),
          for (var i = 0; i < model.body.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sectionGap),
            ArticleBlockView(
              block: model.body[i],
              gallery: gallery,
              sourceUri: sourceUri,
            ),
          ],
        ],
        if (model.hashtags.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xlg),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in model.hashtags) _HashtagPill(label: tag),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.contentGap),
        ArticleSourceCard(
          sourceName: source ?? model.title,
          categoryId: model.categoryId,
        ),
        ArticleRelated(related: related),
      ],
    );
  }

  String _timeAgo(AppLocalizations l10n, DateTime publishedAt) {
    final relative = feedRelativeTime(l10n, publishedAt);
    if (relative == l10n.newsTimeYesterday || relative == l10n.newsTimeNow) {
      return relative;
    }
    return l10n.articleTimeAgo(relative);
  }
}

class _HashtagPill extends StatelessWidget {
  const _HashtagPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Text(
          label,
          style: AppText.subtextStrong.copyWith(color: colors.muted),
        ),
      ),
    );
  }
}
