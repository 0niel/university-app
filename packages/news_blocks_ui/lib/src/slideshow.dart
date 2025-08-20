import 'package:app_ui/app_ui.dart' show AppColors, AppSpacing, AppTextStyle;
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template slideshow}
/// A reusable slideshow.
/// {@endtemplate}
class Slideshow extends StatefulWidget {
  /// {@macro slideshow}
  const Slideshow({
    required this.block,
    required this.categoryTitle,
    required this.navigationLabel,
    super.key,
  });

  /// The associated [SlideshowBlock] instance.
  final SlideshowBlock block;

  /// The title of the category.
  final String categoryTitle;

  /// The label displayed between navigation buttons of the [_SlideshowButtons].
  final String navigationLabel;

  @override
  State<Slideshow> createState() => _SlideshowState();
}

class _SlideshowState extends State<Slideshow> {
  final _controller = PageController();

  void _onImageTap(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullscreenImageViewer(
          slides: widget.block.slides,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.background01,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SlideshowCategoryTitle(
            categoryTitle: widget.categoryTitle,
          ),
          _SlideshowHeaderTitle(title: widget.block.title),
          _SlideshowPageView(
            slides: widget.block.slides,
            controller: _controller,
            onImageTap: _onImageTap,
          ),
          _SlideshowButtons(
            totalPages: widget.block.slides.length,
            controller: _controller,
            navigationLabel: widget.navigationLabel,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _SlideshowCategoryTitle extends StatelessWidget {
  const _SlideshowCategoryTitle({
    required this.categoryTitle,
  });

  final String categoryTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const Key('slideshow_categoryTitle'),
      padding: const EdgeInsets.only(left: AppSpacing.lg),
      child: SlideshowCategory(
        isIntroduction: false,
        slideshowText: categoryTitle,
      ),
    );
  }
}

class _SlideshowHeaderTitle extends StatelessWidget {
  const _SlideshowHeaderTitle({
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      key: const Key('slideshow_headerTitle'),
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        bottom: AppSpacing.lg,
      ),
      child: Text(
        title,
        style: AppTextStyle.h5.copyWith(color: colors.active),
      ),
    );
  }
}

class _SlideshowPageView extends StatelessWidget {
  const _SlideshowPageView({
    required this.slides,
    required this.controller,
    required this.onImageTap,
  });

  final List<SlideBlock> slides;
  final PageController controller;
  final void Function(int index) onImageTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        key: const Key('slideshow_pageView'),
        controller: controller,
        itemCount: slides.length,
        itemBuilder: (context, index) => SlideshowItem(
          slide: slides[index],
          onImageTap: () => onImageTap(index),
        ),
      ),
    );
  }
}

/// {@template slideshow_item}
/// A reusable slideshow_item.
/// {@endtemplate}
@visibleForTesting
class SlideshowItem extends StatelessWidget {
  /// {@macro slideshow_item}
  const SlideshowItem({
    required this.slide,
    this.onImageTap,
    super.key,
  });

  /// The slide to be displayed.
  final SlideBlock slide;

  /// Callback when the image is tapped.
  final VoidCallback? onImageTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GestureDetector(
            onTap: onImageTap,
            child: SizedBox.square(
              key: const Key('slideshow_slideshowItemImage'),
              child: Image.network(slide.imageUrl),
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
            style: AppTextStyle.titleM.copyWith(
              color: Theme.of(context).extension<AppColors>()!.white,
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
            style: AppTextStyle.body.copyWith(
              color: Theme.of(context)
                  .extension<AppColors>()!
                  .onSurface
                  .withOpacity(0.8),
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
            style: AppTextStyle.captionL.copyWith(
              color: Theme.of(context)
                  .extension<AppColors>()!
                  .onSurface
                  .withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }
}

class _SlideshowButtons extends StatefulWidget {
  const _SlideshowButtons({
    required this.totalPages,
    required this.controller,
    required this.navigationLabel,
  });

  final int totalPages;
  final PageController controller;
  final String navigationLabel;

  @override
  State<_SlideshowButtons> createState() => _SlideshowButtonsState();
}

class _SlideshowButtonsState extends State<_SlideshowButtons> {
  int _currentPage = 0;
  static const _pageAnimationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    widget.controller.addListener(_onPageChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final navigationBarLabel =
        '${_currentPage + 1} ${widget.navigationLabel} ${widget.totalPages}';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colors.background02.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              key: const Key('slideshow_slideshowButtonsLeft'),
              onPressed: _currentPage > 0
                  ? () {
                      widget.controller.previousPage(
                        duration: _pageAnimationDuration,
                        curve: Curves.easeInOut,
                      );
                    }
                  : null,
              icon: Icon(
                Icons.arrow_back_ios,
                color: _currentPage > 0
                    ? colors.active
                    : colors.onSurface.withOpacity(0.3),
                size: 20,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: colors.background02.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              navigationBarLabel,
              style: AppTextStyle.body.copyWith(
                color: colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colors.background02.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              key: const Key('slideshow_slideshowButtonsRight'),
              onPressed: _currentPage < widget.totalPages - 1
                  ? () {
                      widget.controller.nextPage(
                        duration: _pageAnimationDuration,
                        curve: Curves.easeInOut,
                      );
                    }
                  : null,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: _currentPage < widget.totalPages - 1
                    ? colors.active
                    : colors.onSurface.withOpacity(0.3),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onPageChanged() {
    setState(() {
      _currentPage = widget.controller.page?.toInt() ?? 0;
    });
  }
}
