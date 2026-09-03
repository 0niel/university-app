import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/article/bloc/article_bloc.dart';
import 'package:rtu_mirea_app/article/cubit/cubit.dart';
import 'package:rtu_mirea_app/article/widgets/widgets.dart';
import 'package:rtu_mirea_app/feed/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({required this.isVideoArticle, super.key});

  final bool isVideoArticle;

  void _toggleSaved(BuildContext context) {
    final id = context.read<ArticleBloc>().id;
    final cubit = context.read<SavedArticlesCubit>();
    final wasSaved = cubit.isSaved(id);
    cubit.toggle(id);
    final l10n = context.l10n;
    if (wasSaved) {
      ToastManager.showInfo(context, message: l10n.articleUnsaved);
    } else {
      ToastManager.showSuccess(context, message: l10n.articleSaved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final articleBloc = context.watch<ArticleBloc>();
    final state = articleBloc.state;
    final saved = context.watch<SavedArticlesCubit>().isSaved(articleBloc.id);
    final uri = state.uri;
    final canShare = uri != null && uri.toString().isNotEmpty;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: BlocListener<ArticleBloc, ArticleState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ArticleStatus.shareFailure) {
            ToastManager.showError(context, message: context.l10n.shareFailed);
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              sliver: SliverToBoxAdapter(
                child: PageActionBar(
                  onBack: () => Navigator.of(context).maybePop(),
                  actions: [
                    AppIconButton(
                      key: const Key('articlePage_saveButton'),
                      icon: const AppLineIconWidget(
                        AppLineIcon.bookmark,
                        size: 20,
                      ),
                      tooltip: saved ? l10n.articleRemoveFromSaved : l10n.save,
                      tone: saved
                          ? AppIconButtonTone.primary
                          : AppIconButtonTone.surface,
                      shape: AppIconButtonShape.circle,
                      onPressed: () => _toggleSaved(context),
                    ),
                    AppIconButton(
                      key: const Key('articlePage_shareButton'),
                      icon: const AppLineIconWidget(
                        AppLineIcon.share,
                        size: 20,
                      ),
                      tooltip: l10n.share,
                      tone: AppIconButtonTone.surface,
                      shape: AppIconButtonShape.circle,
                      onPressed: canShare
                          ? () => context.read<ArticleBloc>().add(
                              ShareRequested(uri: uri),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.contentGap,
                AppSpacing.screen,
                ninjaBottomInset(context) + AppSpacing.lg,
              ),
              sliver: SliverToBoxAdapter(
                child: NinjaStateSwitcher(child: _content(context, state)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context, ArticleState state) {
    final l10n = context.l10n;
    if (state.content.isEmpty) {
      if (state.status == ArticleStatus.failure) {
        return NinjaErrorState(
          key: const Key('articleContent_failure'),
          title: l10n.loadingError,
          message: l10n.failedToLoadArticle,
          retryLabel: l10n.retry,
          onRetry: () =>
              context.read<ArticleBloc>().add(const ArticleRequested()),
        );
      }
      return const ArticleSkeleton(key: Key('articleContent_loading'));
    }
    return SelectionArea(
      key: const Key('articleContent_body'),
      child: ArticleBody(
        model: ArticleContentModel.fromBlocks(
          state.content,
          fallbackTitle: state.title,
        ),
        related: state.relatedArticles,
      ),
    );
  }
}
