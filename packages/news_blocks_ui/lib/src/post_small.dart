import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template post_small}
/// A compact news card.
/// {@endtemplate}
class PostSmall extends StatelessWidget {
  /// {@macro post_small}
  const PostSmall({required this.block, this.onPressed, super.key});

  /// The associated [PostSmallBlock] instance.
  final PostSmallBlock block;

  /// Called when the block is tapped.
  final BlockActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scale = Theme.of(context).scale;
    final imageUrl = block.imageUrl;
    final action = block.action;
    final callback = onPressed;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: scale.space(AppSpacing.md),
        vertical: scale.space(AppSpacing.sm),
      ),
      child: InkWell(
        onTap:
            action == null || callback == null ? null : () => callback(action),
        child: Padding(
          padding: EdgeInsets.all(scale.space(AppSpacing.md)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostSourceHeader(author: block.author),
              SizedBox(height: scale.space(AppSpacing.sm)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTextContent(context)),
                  if (imageUrl != null && imageUrl.trim().isNotEmpty) ...[
                    SizedBox(width: scale.space(AppSpacing.md)),
                    _buildImage(context, imageUrl),
                  ],
                ],
              ),
              SizedBox(height: scale.space(AppSpacing.xs)),
              PostTimestamp(publishedAt: block.publishedAt, iconSize: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    final colors = Theme.of(context).colors;
    final description = block.description;

    final content =
        description != null && description.isNotEmpty
            ? description
            : block.title;

    return Text(
      content,
      style: AppText.body.copyWith(color: colors.onSurface, height: 1.4),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildImage(BuildContext context, String imageUrl) {
    final colors = Theme.of(context).colors;
    final scale = Theme.of(context).scale;
    final imageSize = scale.size(64);

    return ClipRRect(
      borderRadius: BorderRadius.circular(scale.radius(8)),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => Container(
              width: imageSize,
              height: imageSize,
              color: colors.surfaceHigh,
              child: Icon(
                Icons.image_outlined,
                color: colors.onSurface.withValues(alpha: 0.4),
                size: scale.icon(24),
              ),
            ),
        errorWidget:
            (context, url, error) => Container(
              width: imageSize,
              height: imageSize,
              color: colors.surfaceLow,
              child: Icon(
                Icons.broken_image_outlined,
                color: colors.onSurface.withValues(alpha: 0.4),
                size: scale.icon(24),
              ),
            ),
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 150),
      ),
    );
  }
}
