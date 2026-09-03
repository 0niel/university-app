import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/discourse_post_overview/bloc/post_overview_bloc.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/ninja_forum_avatar.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_comments_section.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_formatting.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_html.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_metrics.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_skeleton.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'post_author_header.dart';

class PostOverviewBody extends StatelessWidget {
  const PostOverviewBody({required this.postId, super.key});

  final int postId;

  Future<void> _refresh(BuildContext context) async {
    final bloc = context.read<PostOverviewBloc>();
    if (bloc.isClosed) return;
    final completed = bloc.stream
        .where((state) => state.status != .loading)
        .take(1)
        .drain<void>();
    bloc.add(PostRequested(postId: postId));
    await completed;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostOverviewBloc, PostOverviewState>(
      builder: (context, state) {
        final post = state.post;
        if (state.status == .loading && post == null) {
          return const PostOverviewSkeleton();
        }
        if (post != null) {
          return RefreshIndicator(
            color: context.colors.accent,
            backgroundColor: context.colors.surface2,
            onRefresh: () => _refresh(context),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                if (state.status == .failure)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      AppSpacing.md,
                      AppSpacing.screen,
                      AppSpacing.zero,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: AppBanner(
                        message: context.l10n.postDetailLoadError,
                        tone: AppBannerTone.warn,
                        actionLabel: context.l10n.retry,
                        onAction: () => context.read<PostOverviewBloc>().add(
                          PostRequested(postId: postId),
                        ),
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.md,
                    AppSpacing.screen,
                    AppSpacing.zero,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _PostAuthorHeader(post: post),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.xlg,
                    AppSpacing.screen,
                    AppSpacing.zero,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: SelectionArea(
                      child: PostOverviewHtml(data: post.cooked),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.section,
                    AppSpacing.screen,
                    ninjaBottomInset(context) + AppSpacing.lg,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: PostOverviewCommentsSection(
                      comments: state.comments,
                      loadFailed: state.status == .commentsFailure,
                      onRetry: () => context.read<PostOverviewBloc>().add(
                        PostRequested(postId: postId),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screen,
          ),
          children: [
            NinjaErrorState(
              title: context.l10n.postDetailLoadError,
              retryLabel: context.l10n.retry,
              onRetry: () => context.read<PostOverviewBloc>().add(
                PostRequested(postId: postId),
              ),
            ),
          ],
        );
      },
    );
  }
}
