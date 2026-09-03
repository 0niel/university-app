import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/feed/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';

class ArticleRelated extends StatelessWidget {
  const ArticleRelated({required this.related, super.key});

  final List<NewsBlock> related;

  @override
  Widget build(BuildContext context) {
    final posts = feedPosts(related);
    if (posts.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;
    final categories = context.read<CategoriesBloc>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(title: l10n.relatedArticles),
        AppListGroup(
          children: [
            for (final post in posts)
              FeedPostRow(
                key: ValueKey('article_related_${post.id}'),
                title: post.title,
                source:
                    categories.getCategoryName(post.categoryId) ?? post.author,
                meta: feedRelativeTime(l10n, post.publishedAt),
                imageUrl: post.imageUrl,
                onTap: () =>
                    ArticleRoute(articleId: post.id).push<void>(context),
              ),
          ],
        ),
      ],
    );
  }
}
