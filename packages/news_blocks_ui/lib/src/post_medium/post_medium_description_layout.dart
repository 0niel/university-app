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
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InlineImage(imageUrl: imageUrl),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.titleM.copyWith(
                        color: colors.active,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (description != null && description!.isNotEmpty)
                      Text(
                        description!,
                        style: AppTextStyle.body.copyWith(
                          color: colors.onSurface.withOpacity(0.7),
                          height: 1.45,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          PostFooter(
            publishedAt: publishedAt,
            author: author,
            onShare: onShare,
          ),
        ],
      ),
    );
  }
}
