import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:rtu_mirea_app/article/article.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ArticleContentItemList extends StatelessWidget {
  const ArticleContentItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final content = context.select<ArticleBloc, List<NewsBlock>>(
      (bloc) => bloc.state.content,
    );

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final block = content.elementAtOrNull(index);
          if (block == null) return const SizedBox.shrink();

          return VisibilityDetector(
            key: ValueKey(block),
            onVisibilityChanged: (visibility) {
              if (!visibility.visibleBounds.isEmpty) {
                context.read<ArticleBloc>().add(
                  ArticleContentSeen(contentIndex: index),
                );
              }
            },
            child: ArticleContentItem(block: block),
          );
        },
        childCount: content.length,
      ),
    );
  }
}
