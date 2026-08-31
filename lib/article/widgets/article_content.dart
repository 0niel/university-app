import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/article/article.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ArticleContent extends StatelessWidget {
  const ArticleContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ArticleBloc, ArticleState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == .shareFailure) _handleShareFailure(context);
      },
      builder: (context, state) =>
          NinjaStateSwitcher(child: _content(context, state)),
    );
  }

  Widget _content(BuildContext context, ArticleState state) {
    if (state.content.isEmpty) {
      if (state.status == .initial || state.status == .loading) {
        return const ArticleContentLoaderItem(
          key: Key('articleContent_empty_loaderItem'),
        );
      }
      if (state.status == .failure) {
        return Padding(
          key: const Key('articleContent_failure'),
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            40,
            NinjaMetrics.screenPadding,
            0,
          ),
          child: NinjaErrorState(
            title: context.l10n.loadingError,
            message: context.l10n.failedToLoadArticle,
            retryLabel: context.l10n.retry,
            onRetry: () =>
                context.read<ArticleBloc>().add(const ArticleRequested()),
          ).animateEmptyState(),
        );
      }
    }

    return const SelectionArea(
      key: Key('articleContent_body'),
      child: CustomScrollView(
        slivers: [
          ArticleContentItemList(),
          ArticleTrailingContent(),
        ],
      ),
    );
  }

  void _handleShareFailure(BuildContext context) {
    showNinjaToast(
      context,
      message: context.l10n.shareFailed,
      showCheck: false,
    );
  }
}
