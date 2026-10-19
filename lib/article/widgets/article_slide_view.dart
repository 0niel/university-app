import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:rtu_mirea_app/article/widgets/article_media.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_image.dart';

class ArticleSlideView extends StatelessWidget {
  const ArticleSlideView({
    required this.slide,
    super.key,
    this.gallery = const [],
    this.sourceUri,
  });

  final SlideBlock slide;
  final List<String> gallery;
  final Uri? sourceUri;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.sm,
    children: [
      FeedImage(
        imageUrl: articleImageUrl(slide.imageUrl, sourceUri: sourceUri),
        gallery: gallery,
        radius: AppRadius.card,
        height: 220,
        width: double.infinity,
      ),
      if (slide.caption.isNotEmpty)
        Text(slide.caption, style: AppText.subtextStrong),
      if (slide.description.isNotEmpty)
        Text(slide.description, style: AppText.paragraph),
      if (slide.photoCredit.isNotEmpty)
        Text(
          slide.photoCredit,
          style: AppText.caption.copyWith(color: context.colors.muted),
        ),
    ],
  );
}
