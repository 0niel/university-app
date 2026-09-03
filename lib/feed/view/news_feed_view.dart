import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/feed/bloc/feed_bloc.dart';
import 'package:rtu_mirea_app/feed/view/news_feed_content.dart';
import 'package:rtu_mirea_app/feed/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NewsFeedView extends StatelessWidget {
  const NewsFeedView({super.key});

  void _select(BuildContext context, FeedSourceRailItem item) {
    final categoriesBloc = context.read<CategoriesBloc>();
    final category = feedCategoryFor(
      categoriesBloc.state,
      id: item.id,
      name: item.name,
    );
    categoriesBloc.add(CategorySelected(category: category));
    final feedBloc = context.read<FeedBloc>();
    if (!feedBloc.state.feed.containsKey(category.id)) {
      feedBloc.add(FeedRequested(category: category));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final categoriesState = context.watch<CategoriesBloc>().state;
    final category =
        categoriesState.selectedCategory ??
        Category(id: feedAllCategoryId, name: l10n.all);
    final items = [
      FeedSourceRailItem(
        id: feedAllCategoryId,
        name: l10n.all,
        abbr: l10n.newsSourceAllAbbr,
      ),
      for (final source in categoriesState.sources)
        FeedSourceRailItem(
          id: feedSourceKey(source),
          name: feedSourceName(source),
          abbr: feedAbbreviation(feedSourceName(source)),
          avatarUrl: source.avatarUrl,
        ),
    ];

    return RefreshIndicator(
      color: colors.accent,
      backgroundColor: colors.surface,
      onRefresh: () async => context.read<FeedBloc>().add(
        FeedRefreshRequested(category: category),
      ),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            sliver: SliverToBoxAdapter(
              child: PageActionBar(
                title: l10n.news,
                onBack: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.contentGap),
              child: FeedSourcesRail(
                items: items,
                selectedId: category.id,
                semanticsLabel: l10n.newsSourcesSemantics,
                onSelected: (item) => _select(context, item),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.contentGap,
              AppSpacing.screen,
              AppSpacing.xxlg,
            ),
            sliver: NewsFeedContent(
              key: ValueKey('newsFeed_${category.id}'),
              category: category,
            ),
          ),
        ],
      ),
    );
  }
}
