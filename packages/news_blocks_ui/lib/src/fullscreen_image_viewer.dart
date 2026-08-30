import 'package:app_ui/app_ui.dart'
    show AppIconButton, AppSpacing, AppText, ThemeDataColorsX;
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullscreenImageViewer extends StatefulWidget {
  const FullscreenImageViewer({
    required this.slides,
    required this.initialIndex,
    super.key,
  });

  final List<SlideBlock> slides;
  final int initialIndex;

  @override
  State<FullscreenImageViewer> createState() => _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<FullscreenImageViewer> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final backgroundColor = colors.background01.withValues(alpha: 0.95);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            PhotoViewGallery.builder(
              pageController: _pageController,
              scrollPhysics: const BouncingScrollPhysics(),
              itemCount: widget.slides.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              builder: (_, index) {
                final slide = widget.slides[index];
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(slide.imageUrl),
                  heroAttributes: PhotoViewHeroAttributes(tag: slide.imageUrl),
                  minScale: PhotoViewComputedScale.contained,
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 3,
                );
              },
              loadingBuilder: (_, event) {
                final expectedTotalBytes = event?.expectedTotalBytes;
                return Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      value:
                          event == null || expectedTotalBytes == null
                              ? null
                              : event.cumulativeBytesLoaded /
                                  expectedTotalBytes,
                    ),
                  ),
                );
              },
              backgroundDecoration: BoxDecoration(color: backgroundColor),
            ),
            Positioned(
              left: 16,
              top: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.background02.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppIconButton(
                  icon: const Icon(Icons.close),
                  foregroundColor: colors.white,
                  backgroundColor: Colors.transparent,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: colors.background02.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / ${widget.slides.length}',
                    style: AppText.body.copyWith(
                      color: colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
