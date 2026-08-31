import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/sliver_grid_custom_delegate.dart';

class PostGrid extends StatelessWidget {
  const PostGrid({
    required this.gridGroupBlock,
    required this.categoryName,
    this.isLocked = false,
    this.onPressed,
    super.key,
  });

  final PostGridGroupBlock gridGroupBlock;
  final String? categoryName;
  final bool isLocked;
  final BlockActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (gridGroupBlock.tiles.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    final deviceWidth = MediaQuery.widthOf(context);
    final scale = Theme.of(context).scale;
    final spacing = scale.space(AppSpacing.sm);

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: spacing),
      sliver: SliverGrid(
        gridDelegate: SliverGridCustomDelegate(
          maxCrossAxisExtent: deviceWidth / 2 - spacing,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: 3 / 2,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final block = gridGroupBlock.tiles.elementAtOrNull(index);
          if (block == null) return const SizedBox.shrink();
          if (index == 0) {
            return PostLarge(
              block: block.toPostLargeBlock(),
              categoryName: categoryName,
              isLocked: isLocked,
              onPressed: onPressed,
            );
          }

          return PostMedium(
            block: block.toPostMediumBlock(),
            onPressed: onPressed,
          );
        }, childCount: gridGroupBlock.tiles.length),
      ),
    );
  }
}
