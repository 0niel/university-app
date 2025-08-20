import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template post_small}
/// A reusable post small news block widget.
/// {@endtemplate}
class PostSmall extends StatelessWidget {
  /// {@macro post_small}
  const PostSmall({required this.block, this.onPressed, super.key});

  /// The size of this post image.
  static const _imageSize = 100.0;

  /// The associated [PostSmallBlock] instance.
  final PostSmallBlock block;

  /// An optional callback which is invoked when the action is triggered.
  /// A [Uri] from the associated [BlockAction] is provided to the callback.
  final BlockActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final imageUrl = block.imageUrl;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (block.hasNavigationAction) onPressed?.call(block.action!);
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null && imageUrl.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.lg),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: _imageSize,
                      height: _imageSize,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => ColoredBox(
                        color: Theme.of(context)
                                .extension<AppColors>()
                                ?.surfaceHigh ??
                            const Color(0xFFF2F2F2),
                      ),
                      errorWidget: (context, url, error) => ColoredBox(
                        color: Theme.of(context)
                                .extension<AppColors>()
                                ?.surfaceLow ??
                            const Color(0xFFEAEAEA),
                      ),
                      fadeInDuration: const Duration(milliseconds: 200),
                      fadeOutDuration: const Duration(milliseconds: 150),
                    ),
                  ),
                ),
              Flexible(
                child: PostSmallContent(
                  title: block.title,
                  publishedAt: block.publishedAt,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// {@template post_small_content}
/// The content of [PostSmall].
/// {@endtemplate}
@visibleForTesting
class PostSmallContent extends StatelessWidget {
  /// {@macro post_small_content}
  const PostSmallContent({
    required this.title,
    required this.publishedAt,
    super.key,
  });

  /// The title of this post.
  final String title;

  /// The date when this post was published.
  final DateTime publishedAt;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.titleM.copyWith(
            color: colors.active,
            height: 1.3,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.md),
        PostFooter(
          publishedAt: publishedAt,
        ),
      ],
    );
  }
}
