import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

class PostLarge extends StatelessWidget {
  const PostLarge({
    required this.block,
    required this.categoryName,
    required this.isLocked,
    this.onPressed,
    super.key,
  });

  final PostLargeBlock block;
  final String? categoryName;
  final bool isLocked;
  final BlockActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scale = Theme.of(context).scale;
    final action = block.action;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: scale.space(AppSpacing.md),
        vertical: scale.space(AppSpacing.sm),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(scale.radius(16)),
          onTap:
              block.hasNavigationAction && action != null
                  ? () => onPressed?.call(action)
                  : null,
          child: PostLargeContainer(
            isContentOverlaid: block.isContentOverlaid,
            children: [
              if (!block.isContentOverlaid)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    scale.space(AppSpacing.lg),
                    scale.space(AppSpacing.md),
                    scale.space(AppSpacing.lg),
                    scale.space(AppSpacing.sm),
                  ),
                  child: PostSourceHeader(
                    author: block.author,
                    fallbackTitle: categoryName ?? 'Новости',
                  ),
                ),
              PostLargeImage(
                isContentOverlaid: block.isContentOverlaid,
                imageUrl: block.imageUrl,
                isLocked: isLocked,
              ),
              PostContent(
                author: block.author,
                categoryName: categoryName,
                publishedAt: block.publishedAt,
                title: block.title,
                isContentOverlaid: block.isContentOverlaid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
