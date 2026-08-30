import 'dart:async';

import 'package:ads_ui/ads_ui.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart' show Video;
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_hero_post.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_meta.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_post_row.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_section_header.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CategoryFeedItem extends StatelessWidget {
  const CategoryFeedItem({required this.block, super.key});

  final NewsBlock block;

  @override
  Widget build(BuildContext context) {
    final blocks = _expand(block);
    if (blocks.isEmpty) return const SliverToBoxAdapter(child: SizedBox());
    final reduceMotion =
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
        (MediaQuery.maybeAccessibleNavigationOf(context) ?? false);
    return SliverList.builder(
      itemCount: blocks.length,
      itemBuilder: (context, index) {
        final child = _buildBlock(context, blocks[index]);
        if (reduceMotion) return child;
        return child
            .animate()
            .fadeIn(duration: 250.ms, curve: Curves.easeOut)
            .moveY(begin: 12, end: 0, duration: 250.ms, curve: Curves.easeOut);
      },
    );
  }

  List<NewsBlock> _expand(NewsBlock candidate) => switch (candidate) {
    PostGridGroupBlock(:final tiles) => tiles,
    _ => [candidate],
  };

  Widget _buildBlock(BuildContext context, NewsBlock feedBlock) {
    return switch (feedBlock) {
      DividerHorizontalBlock() => const SizedBox(height: AppSpacing.md),
      SpacerBlock(:final spacing) => SizedBox(height: _spacing(spacing)),
      SectionHeaderBlock(:final action) => FeedSectionHeader(
        title: feedBlock.title,
        actionLabel: action == null ? null : context.l10n.communitiesAll,
        onAction: () => _onAction(context, action),
      ),
      PostLargeBlock() => _hero(context, feedBlock),
      PostMediumBlock() => _row(context, feedBlock),
      PostSmallBlock() => _row(context, feedBlock),
      PostGridTileBlock() => _row(context, feedBlock),
      VideoBlock() => Video(block: feedBlock),
      BannerAdBlock() => BannerAd(
        block: feedBlock,
        adFailedToLoadTitle: context.l10n.errorLoadingAds,
      ),
      _ => const SizedBox(),
    };
  }

  Widget _hero(BuildContext context, PostLargeBlock post) {
    final category = _categoryName(context, post.categoryId);
    return FeedHeroPost(
      title: post.title,
      imageUrl: post.imageUrl,
      badgeLabel: category.isEmpty ? null : category,
      meta: feedMetaLine(context.l10n, publishedAt: post.publishedAt),
      onTap: () => _onAction(context, post.action),
    );
  }

  Widget _row(BuildContext context, PostBlock post) {
    return FeedPostRow(
      title: post.title,
      imageUrl: post.imageUrl,
      meta: feedMetaLine(
        context.l10n,
        categoryName: _categoryName(context, post.categoryId),
        publishedAt: post.publishedAt,
      ),
      onTap: () => _onAction(context, post.action),
    );
  }

  double _spacing(Spacing spacing) => switch (spacing) {
    Spacing.extraSmall => 4,
    Spacing.small => 8,
    Spacing.medium => 16,
    Spacing.large => 24,
    Spacing.veryLarge => 32,
    Spacing.extraLarge => 40,
  };

  String _categoryName(BuildContext context, String categoryId) {
    return context.read<CategoriesBloc>().state.getCategoryName(categoryId) ??
        '';
  }

  void _onAction(BuildContext context, BlockAction? blockAction) {
    switch (blockAction) {
      case NavigateToArticleAction(:final articleId) ||
          NavigateToVideoArticleAction(:final articleId):
        unawaited(context.push('/feed/article/$articleId'));
      case NavigateToFeedCategoryAction(:final category):
        context.read<CategoriesBloc>().add(
          CategorySelected(category: category),
        );
      default:
        break;
    }
  }
}
