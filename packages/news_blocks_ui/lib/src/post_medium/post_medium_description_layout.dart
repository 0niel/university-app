import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template post_medium_description_layout}
/// A reusable post medium news block widget showing post description.
/// {@endtemplate}
class PostMediumDescriptionLayout extends StatelessWidget {
  /// {@macro post_medium_description_layout}
  const PostMediumDescriptionLayout({
    required this.title,
    required this.imageUrl,
    required this.publishedAt,
    this.description,
    this.author,
    this.onShare,
    super.key,
  });

  /// Title of post.
  final String title;

  /// Description of post.
  final String? description;

  /// The date when this post was published.
  final DateTime publishedAt;

  /// The author of this post.
  final String? author;

  /// Called when the share button is tapped.
  final VoidCallback? onShare;

  /// The url of this post image.
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final scale = Theme.of(context).scale;
    final description = this.description;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: scale.space(AppSpacing.md),
        vertical: scale.space(AppSpacing.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              scale.space(AppSpacing.lg),
              scale.space(AppSpacing.md),
              scale.space(AppSpacing.lg),
              scale.space(AppSpacing.sm),
            ),
            child: PostSourceHeader(author: author),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: scale.space(AppSpacing.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.title.copyWith(
                    color: colors.onSurface,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                if (description != null && description.isNotEmpty) ...[
                  SizedBox(height: scale.space(AppSpacing.sm)),
                  Text(
                    description,
                    style: AppText.body.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                SizedBox(height: scale.space(AppSpacing.md)),

                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(scale.radius(12)),
                    child: InlineImage(imageUrl: imageUrl),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(scale.space(AppSpacing.lg)),
            child: PostTimestamp(publishedAt: publishedAt),
          ),
        ],
      ),
    );
  }
}
