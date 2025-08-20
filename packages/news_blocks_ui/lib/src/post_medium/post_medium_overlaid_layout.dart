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
    super.key,
  });

  /// Title of post.
  final String title;

  /// The url of this post image displayed in overlay.
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          OverlaidImage(
            imageUrl: imageUrl,
            gradientColor: const Color(0xFF000000).withOpacity(0.7),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              title,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.titleM.copyWith(
                color: colors.white,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
