import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/slideshow_item.dart';

class SlideshowPageView extends StatelessWidget {
  const SlideshowPageView({
    required this.slides,
    required this.controller,
    required this.onImageTap,
    super.key,
  });

  final List<SlideBlock> slides;
  final PageController controller;
  final ValueChanged<int> onImageTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: PageView.builder(
      key: const Key('slideshow_pageView'),
      controller: controller,
      itemCount: slides.length,
      itemBuilder:
          (_, index) => SlideshowItem(
            slide: slides[index],
            onImageTap: () => onImageTap(index),
          ),
    ),
  );
}
