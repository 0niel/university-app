import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';

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
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final currentSlide = widget.slides.elementAtOrNull(_currentIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.8),
        foregroundColor: colors.white,
        elevation: 0,
        leading: AppIconButton(
          icon: const Icon(Icons.close),
          foregroundColor: colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${_currentIndex + 1} / ${widget.slides.length}',
          style: AppText.body.copyWith(color: colors.white),
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.slides.length,
            itemBuilder: (context, index) {
              final slide = widget.slides.elementAtOrNull(index);
              if (slide == null) return const SizedBox.shrink();
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: Center(
                  child: Image.network(
                    slide.imageUrl,
                    fit: BoxFit.contain,
                    semanticLabel: slide.caption,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      final expectedTotalBytes =
                          loadingProgress.expectedTotalBytes;
                      return Center(
                        child: CircularProgressIndicator(
                          value:
                              expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      expectedTotalBytes
                                  : null,
                          color: colors.white,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.error_outline,
                          color: colors.white,
                          size: 48,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          if (currentSlide != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.black.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentSlide.caption,
                      style: AppText.heading.copyWith(
                        color: colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      currentSlide.description,
                      style: AppText.body.copyWith(
                        color: colors.white.withValues(alpha: 0.9),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      currentSlide.photoCredit,
                      style: AppText.caption.copyWith(
                        color: colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
