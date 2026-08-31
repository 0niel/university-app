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
  final bool isContentOverlaid;

  /// Whether content is a part of a video article.
  final bool isVideoContent;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final scale = Theme.of(context).scale;
    final category = categoryName;

    return Padding(
      padding:
          isContentOverlaid
              ? EdgeInsets.all(scale.space(AppSpacing.lg))
              : EdgeInsets.fromLTRB(
                scale.space(AppSpacing.lg),
                scale.space(AppSpacing.sm),
                scale.space(AppSpacing.lg),
                scale.space(AppSpacing.lg),
              ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isContentOverlaid && category != null && category.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: scale.space(AppSpacing.sm)),
              child: PostContentCategory(
                categoryName: category,
                isContentOverlaid: true,
                isVideoContent: isVideoContent,
              ),
            ),
          Text(
            title,
            style: AppText.title.copyWith(
              color:
                  isContentOverlaid || isVideoContent
                      ? colors.white
                      : colors.onSurface,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
            maxLines: isContentOverlaid ? 3 : 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (publishedAt != null || author != null || onShare != null) ...[
            SizedBox(height: scale.space(AppSpacing.md)),
            PostTimestamp(
              publishedAt: publishedAt ?? DateTime.now(),
              isContentOverlaid: isContentOverlaid || isVideoContent,
            ),
          ],
          if (!isContentOverlaid) SizedBox(height: scale.space(AppSpacing.sm)),
        ],
      ),
    );
  }
}
