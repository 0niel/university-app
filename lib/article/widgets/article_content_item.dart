import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide Image, Spacer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ArticleContentItem extends StatelessWidget {
  const ArticleContentItem({required this.block, super.key});

  final NewsBlock block;

  @override
  Widget build(BuildContext context) {
    final newsBlock = block;

    if (newsBlock is DividerHorizontalBlock) {
      return const SizedBox(height: AppSpacing.xlg);
    } else if (newsBlock is SpacerBlock) {
      return Spacer(block: newsBlock);
    } else if (newsBlock is ImageBlock) {
      return Image(
        block: newsBlock,
        semanticLabel: context.l10n.articleImage,
      );
    } else if (newsBlock is VideoBlock) {
      return Video(block: newsBlock);
    } else if (newsBlock is TextCaptionBlock) {
      final colors = context.ninja;
      return TextCaption(
        block: newsBlock,
        colorValues: {
          .normal: colors.ink,
          .light: colors.muted,
        },
      );
    } else if (newsBlock is TextHeadlineBlock) {
      return TextHeadline(block: newsBlock);
    } else if (newsBlock is TextLeadParagraphBlock) {
      return TextLeadParagraph(block: newsBlock);
    } else if (newsBlock is TextParagraphBlock) {
      return TextParagraph(block: newsBlock);
    } else if (newsBlock is ArticleIntroductionBlock) {
      final categoryName = context.read<CategoriesBloc>().state.getCategoryName(
        newsBlock.categoryId,
      );
      return ArticleIntroduction(block: newsBlock, categoryName: categoryName);
    } else if (newsBlock is VideoIntroductionBlock) {
      final categoryName = context.read<CategoriesBloc>().state.getCategoryName(
        newsBlock.categoryId,
      );
      return VideoIntroduction(block: newsBlock, categoryName: categoryName);
    } else if (newsBlock is BannerAdBlock) {
      return const SizedBox();
    } else if (newsBlock is NewsletterBlock) {
      return const SizedBox();
    } else if (newsBlock is HtmlBlock) {
      return Html(block: newsBlock);
    } else if (newsBlock is TrendingStoryBlock) {
      return TrendingStory(block: newsBlock, title: context.l10n.trending);
    } else if (newsBlock is SlideshowIntroductionBlock) {
      return SlideshowIntroduction(
        block: newsBlock,
        slideshowText: context.l10n.slideshow,
        onPressed: (action) => _onContentItemAction(context, action),
      );
    }
    return const SizedBox();
  }

  Future<void> _onContentItemAction(
    BuildContext context,
    BlockAction action,
  ) async {
    if (action is NavigateToSlideshowAction) {
      await context.push<void>(
        '/slideshow',
        extra: {'slideshow': action.slideshow, 'articleId': action.articleId},
      );
    }
  }
}
