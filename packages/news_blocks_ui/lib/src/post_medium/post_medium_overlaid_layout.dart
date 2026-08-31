import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template post_medium_overlaid_layout}
/// A reusable post medium widget that overlays the post content on the image.
/// {@endtemplate}
class PostMediumOverlaidLayout extends StatelessWidget {
  /// {@macro post_medium_overlaid_layout}
  const PostMediumOverlaidLayout({
    required this.title,
    required this.imageUrl,
    required this.publishedAt,
    super.key,
  });

  /// Title of post.
  final String title;

  /// The url of this post image displayed in overlay.
  final String imageUrl;

  /// The date when this post was published.
  final DateTime publishedAt;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final scale = Theme.of(context).scale;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: scale.space(AppSpacing.md),
        vertical: scale.space(AppSpacing.sm),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(scale.radius(16)),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            OverlaidImage(
              imageUrl: imageUrl,
              gradientColor: const Color(0xFF000000).withValues(alpha: 0.7),
            ),
            Padding(
              padding: EdgeInsets.all(scale.space(AppSpacing.lg)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.title.copyWith(
                      color: colors.white,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: scale.space(AppSpacing.sm)),
                  PostTimestamp(
                    publishedAt: publishedAt,
                    isContentOverlaid: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
