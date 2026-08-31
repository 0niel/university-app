import 'dart:async';

import 'package:app_ui/app_ui.dart' show AppSpacing, ThemeDataColorsX;
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/fullscreen_image_viewer.dart';
import 'package:news_blocks_ui/src/slideshow_category_title.dart';
import 'package:news_blocks_ui/src/slideshow_header_title.dart';
import 'package:news_blocks_ui/src/slideshow_navigation.dart';
import 'package:news_blocks_ui/src/slideshow_page_view.dart';

export 'fullscreen_image_viewer.dart';
export 'slideshow_item.dart';

class Slideshow extends StatefulWidget {
  const Slideshow({
    required this.block,
    required this.categoryTitle,
    required this.navigationLabel,
    super.key,
  });

  final SlideshowBlock block;
  final String categoryTitle;
  final String navigationLabel;

  @override
  State<Slideshow> createState() => _SlideshowState();
}

class _SlideshowState extends State<Slideshow> {
  final _controller = PageController();

  void _onImageTap(int index) {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<Widget>(
          builder:
              (_) => FullscreenImageViewer(
                slides: widget.block.slides,
                initialIndex: index,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    return Scaffold(
      backgroundColor: colors.background01,
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideshowCategoryTitle(categoryTitle: widget.categoryTitle),
            SlideshowHeaderTitle(title: widget.block.title),
            SlideshowPageView(
              slides: widget.block.slides,
              controller: _controller,
              onImageTap: _onImageTap,
            ),
            SlideshowNavigation(
              totalPages: widget.block.slides.length,
              controller: _controller,
              navigationLabel: widget.navigationLabel,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
