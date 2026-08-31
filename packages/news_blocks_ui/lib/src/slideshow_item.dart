import 'package:app_ui/app_ui.dart' show AppSpacing, AppText, ThemeDataColorsX;
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';

@visibleForTesting
class SlideshowItem extends StatelessWidget {
  const SlideshowItem({required this.slide, this.onImageTap, super.key});

  final SlideBlock slide;
  final VoidCallback? onImageTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTap: onImageTap,
          child: SizedBox.square(
            key: const Key('slideshow_slideshowItemImage'),
            child: Hero(
              tag: slide.imageUrl,
              child: Image.network(
                slide.imageUrl,
                fit: BoxFit.cover,
                semanticLabel: slide.caption,
              ),
            ),
          ),
        ),
      ),
      Padding(
        key: const Key('slideshow_slideshowItemCaption'),
        padding: const EdgeInsets.only(
          left: AppSpacing.lg,
          top: AppSpacing.lg,
          right: AppSpacing.lg,
        ),
        child: Text(
          slide.caption,
          style: AppText.heading.copyWith(
            color: Theme.of(context).colors.white,
          ),
        ),
      ),
      Padding(
        key: const Key('slideshow_slideshowItemDescription'),
        padding: const EdgeInsets.only(
          left: AppSpacing.lg,
          top: AppSpacing.lg,
          right: AppSpacing.lg,
        ),
        child: Text(
          slide.description,
          style: AppText.body.copyWith(
            color: Theme.of(context).colors.onSurface.withValues(alpha: 0.8),
            height: 1.45,
          ),
        ),
      ),
      Padding(
        key: const Key('slideshow_slideshowItemPhotoCredit'),
        padding: const EdgeInsets.only(
          left: AppSpacing.lg,
          top: AppSpacing.xxxs,
        ),
        child: Text(
          slide.photoCredit,
          style: AppText.caption.copyWith(
            color: Theme.of(context).colors.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    ],
  );
}
