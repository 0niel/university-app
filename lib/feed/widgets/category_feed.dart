import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:rtu_mirea_app/feed/feed.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CategoryFeed extends StatelessWidget {
  const CategoryFeed({
    required this.category,
    this.scrollController,
    super.key,
  });

  final Category category;

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final categoryFeed =
        context.select<FeedBloc, List<NewsBlock>?>(
          (bloc) => bloc.state.feed[category.id],
        ) ??
        [];

    final hasMoreNews =
        context.select<FeedBloc, bool?>(
          (bloc) => bloc.state.hasMoreNews[category.id],
        ) ??
        true;

    final isFailure = context.select<FeedBloc, bool>(
      (bloc) => bloc.state.status == .failure,
    );

    return RefreshIndicator(
      onRefresh: () async => context.read<FeedBloc>().add(
        FeedRefreshRequested(category: category),
      ),
      displacement: 0,
      backgroundColor: context.ninja.surface,
      color: context.ninja.brand,
      child: SelectionArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: _buildSliverItems(
            context,
            categoryFeed,
            hasMoreNews,
            isFailure,
          ),
        ),
      ),
    );
  }

  void _retry(BuildContext context) => context.read<FeedBloc>().add(
    FeedRefreshRequested(category: category),
  );

  List<Widget> _buildSliverItems(
    BuildContext context,
    List<NewsBlock> categoryFeed,
    bool hasMoreNews,
    bool isFailure,
  ) {
    final l10n = context.l10n;
    final sliverList = <Widget>[];

    if (category.id == 'all') {
      sliverList.add(const SliverToBoxAdapter(child: FeedSourcesRail()));
    }

    if (isFailure && categoryFeed.isEmpty) {
      sliverList.add(
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.xlg,
            ),
            child: Center(
              child: NinjaErrorState(
                title: l10n.loadingError,
                message: l10n.feedLoadError,
                retryLabel: l10n.retry,
                onRetry: () => _retry(context),
              ),
            ),
          ),
        ),
      );
      return sliverList;
    }

    for (final block in categoryFeed) {
      sliverList.add(CategoryFeedItem(block: block));
    }

    if (isFailure) {
      sliverList.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.xlg,
            ),
            child: NinjaErrorCard(
              title: l10n.loadingError,
              message: l10n.feedLoadMoreError,
              actionLabel: l10n.retry,
              onAction: () => _retry(context),
            ),
          ),
        ),
      );
    } else if (hasMoreNews) {
      sliverList.add(
        SliverToBoxAdapter(
          child: CategoryFeedLoaderItem(
            key: ValueKey(categoryFeed.length),
            onPresented: () => context.read<FeedBloc>().add(
              FeedRequested(category: category),
            ),
          ),
        ),
      );
    } else if (categoryFeed.isEmpty) {
      sliverList.add(
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: NinjaEmptyState.screen(
              title: l10n.feedEmptyTitle,
              message: l10n.feedEmptyDescription,
              actionLabel: l10n.retry,
              onAction: () => _retry(context),
            ),
          ),
        ),
      );
    }

    return sliverList;
  }
}
