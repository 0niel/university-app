import 'package:app_ui/app_ui.dart' show AppSpacing;
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

class SlideshowCategoryTitle extends StatelessWidget {
  const SlideshowCategoryTitle({required this.categoryTitle, super.key});

  final String categoryTitle;

  @override
  Widget build(BuildContext context) => Padding(
    key: const Key('slideshow_categoryTitle'),
    padding: const EdgeInsets.only(left: AppSpacing.lg),
    child: SlideshowCategory(
      isIntroduction: false,
      slideshowText: categoryTitle,
    ),
  );
}
