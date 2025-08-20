import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template article_introduction}
/// A reusable article introduction block widget.
/// {@endtemplate}
class ArticleIntroduction extends StatelessWidget {
  /// {@macro article_introduction}
  const ArticleIntroduction({
    required this.block,
    required this.categoryName,
    super.key,
  });

  /// The associated [ArticleIntroductionBlock] instance.
  final ArticleIntroductionBlock block;

  /// The name of the category of the associated article.
  final String? categoryName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (block.imageUrl != null && block.imageUrl!.trim().isNotEmpty)
          InlineImage(imageUrl: block.imageUrl!),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: PostContent(
            categoryName: categoryName,
            title: block.title,
            author: block.author,
            publishedAt: block.publishedAt,
          ),
        ),
        const Divider(),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
