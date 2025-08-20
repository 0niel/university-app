import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/article/article.dart';
import 'package:rtu_mirea_app/feed/feed.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ArticleTrailingContent extends StatelessWidget {
  const ArticleTrailingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final relatedArticles = context.select(
      (ArticleBloc bloc) => bloc.state.relatedArticles,
    );

    return MultiSliver(
      children: [
        if (relatedArticles.isNotEmpty) ...[
          SliverPadding(
            padding: const EdgeInsets.only(
              top: AppSpacing.xlg,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                context.l10n.relatedArticles,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
          ...relatedArticles.map(
            (articleBlock) => CategoryFeedItem(block: articleBlock),
          ),
        ],
        const ArticleTrailingShadow(),
      ],
    );
  }
}

@visibleForTesting
class ArticleTrailingShadow extends StatelessWidget {
  const ArticleTrailingShadow({super.key});

  static const _gradientHeight = 256.0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Positioned(
      top: -_gradientHeight,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            height: _gradientHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.white.withOpacity(0),
                  colors.white.withOpacity(1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
