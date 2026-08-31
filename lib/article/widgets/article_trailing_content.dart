import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:rtu_mirea_app/article/article.dart';
import 'package:rtu_mirea_app/feed/feed.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ArticleTrailingContent extends StatelessWidget {
  const ArticleTrailingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final relatedArticles = context.select<ArticleBloc, List<NewsBlock>>(
      (bloc) => bloc.state.relatedArticles,
    );

    return MultiSliver(
      children: [
        if (relatedArticles.isNotEmpty) ...[
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: FeedSectionHeader(title: context.l10n.relatedArticles),
          ),
          ...relatedArticles.map(
            (articleBlock) => CategoryFeedItem(block: articleBlock),
          ),
        ],
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.paddingOf(context).bottom + 32),
        ),
      ],
    );
  }
}
