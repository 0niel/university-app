import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template post_content}
/// A post widget displaying post content.
/// {@endtemplate}
class PostContent extends StatelessWidget {
  /// {@macro post_content}
  const PostContent({
    required this.title,
    this.publishedAt,
    this.categoryName,
    this.description,
    this.author,
    this.onShare,
    this.isContentOverlaid = false,
    this.isVideoContent = false,
    super.key,
  });

  /// Title of post.
  final String title;

  /// The date when this post was published.
  final DateTime? publishedAt;

  /// Category of post.
  final String? categoryName;

  /// Description of post.
  final String? description;

  /// Author of post.
  final String? author;

  /// Called when the share button is tapped.
  final VoidCallback? onShare;

  /// Whether content is displayed overlaid.
  ///
  /// Defaults to false.
  final bool isContentOverlaid;

  /// Whether content is a part of a video article.
  ///
  /// Defaults to false.
  final bool isVideoContent;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final category = categoryName;
    final hasCategory = category != null && category.isNotEmpty;
    return Padding(
      padding: isContentOverlaid
          ? const EdgeInsets.symmetric(horizontal: AppSpacing.lg)
          : EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              if (hasCategory)
                PostContentCategory(
                  categoryName: categoryName!,
                  isContentOverlaid: isContentOverlaid,
                  isVideoContent: isVideoContent,
                ),
            ],
          ),
          Text(
            title,
            style: AppTextStyle.h5.copyWith(
              color: isContentOverlaid || isVideoContent
                  ? colors.white
                  : colors.active,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (publishedAt != null || author != null || onShare != null) ...[
            const SizedBox(height: AppSpacing.md),
            PostFooter(
              publishedAt: publishedAt,
              author: author,
              onShare: onShare,
              isContentOverlaid: isContentOverlaid,
            ),
          ],
          const SizedBox(height: AppSpacing.xlg + AppSpacing.sm),
        ],
      ),
    );
  }
}
