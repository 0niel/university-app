import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:rtu_mirea_app/article/article.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ArticleContent extends StatelessWidget {
  const ArticleContent({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((ArticleBloc bloc) => bloc.state.status);
    final categoriesStatus = context.select(
      (CategoriesBloc bloc) => bloc.state.status,
    );

    /// Show loader while categories are loading as articles may need to consume
    /// them
    if (status == ArticleStatus.initial ||
        categoriesStatus == CategoriesStatus.initial) {
      return const ArticleContentLoaderItem(
        key: Key('articleContent_empty_loaderItem'),
      );
    }

    return BlocListener<ArticleBloc, ArticleState>(
      listener: (context, state) {
        if (state.status == ArticleStatus.failure && state.content.isEmpty) {
          showDialog<void>(
            context: context,
            builder:
                (context) => Dialog(
                  child: FailureScreen(
                    title: context.l10n.loadingError,
                    description: context.l10n.failedToLoadArticle,
                    icon: Icons.error_outline,
                    buttonText: context.l10n.retry,
                    onButtonPressed: () {
                      context.read<ArticleBloc>().add(const ArticleRequested());
                      Navigator.of(context).pop();
                    },
                  ),
                ),
          );
        } else if (state.status == ArticleStatus.shareFailure) {
          _handleShareFailure(context);
        }
      },
      child: SelectionArea(
        child: CustomScrollView(
          slivers: [
            const ArticleContentItemList(),
            const ArticleTrailingContent(),
          ],
        ),
      ),
    );
  }

  void _handleShareFailure(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          key: const Key('articleContent_shareFailure_snackBar'),
          content: Text(context.l10n.shareFailed),
        ),
      );
  }
}

class ArticleContentItemList extends StatelessWidget {
  const ArticleContentItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final content = context.select((ArticleBloc bloc) => bloc.state.content);
    final uri = context.select((ArticleBloc bloc) => bloc.state.uri);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildArticleItem(context, index, content, uri),
        childCount: content.length,
      ),
    );
  }

  Widget _buildArticleItem(
    BuildContext context,
    int index,
    List<NewsBlock> content,
    Uri? uri,
  ) {
    final block = content[index];

    return VisibilityDetector(
      key: ValueKey(block),
      onVisibilityChanged: (visibility) {
        if (!visibility.visibleBounds.isEmpty) {
          context.read<ArticleBloc>().add(
            ArticleContentSeen(contentIndex: index),
          );
        }
      },
      child: ArticleContentItem(
        block: block,
        onSharePressed:
            uri != null && uri.toString().isNotEmpty
                ? () =>
                    context.read<ArticleBloc>().add(ShareRequested(uri: uri))
                : null,
      ),
    );
  }
}
