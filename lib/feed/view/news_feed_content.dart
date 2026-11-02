import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/feed/bloc/feed_bloc.dart';
import 'package:rtu_mirea_app/feed/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';

class NewsFeedContent extends StatelessWidget {
  const NewsFeedContent({required this.category, super.key});

  final Category category;

  void _retry(BuildContext context) => context.read<FeedBloc>().add(
    FeedRefreshRequested(category: category),
  );

  void _request(BuildContext context) => context.read<FeedBloc>().add(
    FeedRequested(category: category),
  );

  void _open(BuildContext context, PostBlock post) =>
      ArticleRoute(articleId: post.id).push<void>(context);

  String _source(BuildContext context, PostBlock post) =>
      context.read<CategoriesBloc>().state.getCategoryName(post.categoryId) ??
      post.author;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<FeedBloc>().state;
    final loaded = state.feed.containsKey(category.id);
    final posts = feedPosts(state.feed[category.id]);
    final hasMore = state.hasMoreNews[category.id] ?? true;
    final isFailure = state.status == FeedStatus.failure;

    if (isFailure && posts.isEmpty) {
      return SliverToBoxAdapter(
        child: NinjaErrorState(
          key: const Key('newsFeed_failure'),
          title: l10n.loadingError,
          message: l10n.feedLoadError,
          retryLabel: l10n.retry,
          onRetry: () => _retry(context),
        ),
      );
    }

    if (!loaded) {
      return SliverToBoxAdapter(
        child: FeedLoaderItem(
          key: const Key('newsFeed_loading'),
          hero: true,
          onPresented: () => _request(context),
        ),
      );
    }

    if (posts.isEmpty && !hasMore) {
      return SliverToBoxAdapter(
        child: NinjaEmptyState(
          key: const Key('newsFeed_empty'),
          title: l10n.feedEmptyTitle,
          message: l10n.feedEmptyDescription,
          actionLabel: l10n.retry,
          onAction: () => _retry(context),
        ),
      );
    }

    return SliverList.builder(
      itemCount: posts.length + (isFailure || hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == posts.length) {
          return isFailure
              ? Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.gap),
                  child: NinjaErrorCard(
                    title: l10n.loadingError,
                    message: l10n.feedLoadMoreError,
                    actionLabel: l10n.retry,
                    onAction: () => _retry(context),
                  ),
                )
              : FeedLoaderItem(
                  key: ValueKey('newsFeed_more_${posts.length}'),
                  onPresented: () => _request(context),
                );
        }
        final post = posts[index];
        if (index == 0) {
          return FeedHeroPost(
            key: const Key('newsFeed_hero'),
            title: post.title,
            source: _source(context, post),
            meta: feedRelativeTime(l10n, post.publishedAt),
            lead: post.description,
            imageUrl: post.imageUrl,
            onTap: () => _open(context, post),
          );
        }
        final colors = context.colors;
        final first = index == 1;
        final last = index == posts.length - 1;
        final radius = BorderRadius.vertical(
          top: first ? const Radius.circular(AppRadius.card) : Radius.zero,
          bottom: last ? const Radius.circular(AppRadius.card) : Radius.zero,
        );
        final side = AppSurfaceStyle.outline(context).left;
        return DecoratedBox(
          key: ValueKey('newsFeed_group_${post.id}'),
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border(
              left: side,
              right: side,
              top: first ? side : BorderSide.none,
              bottom: last ? side : BorderSide.none,
            ),
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: ColoredBox(
              color: colors.surface,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FeedPostRow(
                    key: ValueKey('newsFeed_row_${post.id}'),
                    title: post.title,
                    source: _source(context, post),
                    meta: feedRelativeTime(l10n, post.publishedAt),
                    imageUrl: post.imageUrl,
                    onTap: () => _open(context, post),
                  ),
                  if (!last)
                    AppDivider(
                      color: colors.line.withValues(
                        alpha: colors.line.a * (colors.isDark ? .62 : .75),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
