import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImagesViewGallery extends StatefulWidget {
  const ImagesViewGallery({
    required this.imageUrls,
    super.key,
    this.initialIndex,
    this.title,
  });

  final List<String> imageUrls;
  final int? initialIndex;
  final String? title;

  @override
  State<ImagesViewGallery> createState() => _ImagesViewGalleryState();
}

class _ImagesViewGalleryState extends State<ImagesViewGallery> {
  late bool _appBarVisible;
  late PageController _pageController;
  late int _index;

  int _clampIndex(int index) => widget.imageUrls.isEmpty
      ? 0
      : index.clamp(0, widget.imageUrls.length - 1);

  @override
  void initState() {
    super.initState();
    _appBarVisible = true;

    _index = _clampIndex(widget.initialIndex ?? 0);
    _pageController = PageController(initialPage: _index);
  }

  @override
  void didUpdateWidget(ImagesViewGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _clampIndex(
      widget.initialIndex != oldWidget.initialIndex ||
              (oldWidget.imageUrls.isEmpty && widget.imageUrls.isNotEmpty)
          ? widget.initialIndex ?? 0
          : _index,
    );
    if (next != _index) {
      _index = next;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients) {
          _pageController.jumpToPage(_index);
        }
      });
    }
  }

  void _toggleAppBarVisibility() {
    _appBarVisible = !_appBarVisible;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: GestureDetector(
        onTap: () => setState(_toggleAppBarVisibility),
        child: Stack(
          children: [
            if (widget.imageUrls.isEmpty)
              const Positioned.fill(child: ImagePlaceholder())
            else
              PhotoViewGallery.builder(
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(widget.imageUrls[index]),
                    initialScale: PhotoViewComputedScale.contained * 0.8,
                    minScale: PhotoViewComputedScale.contained * 0.6,
                    maxScale: PhotoViewComputedScale.covered * 5.9,
                    heroAttributes: PhotoViewHeroAttributes(
                      tag: '$index:${widget.imageUrls[index]}',
                    ),
                    errorBuilder: (context, error, stackTrace) =>
                        const ImagePlaceholder(),
                  );
                },
                itemCount: widget.imageUrls.length,
                loadingBuilder: (context, event) =>
                    const Center(child: AppSpinner()),
                backgroundDecoration:
                    BoxDecoration(color: context.colors.canvas),
                pageController: _pageController,
                onPageChanged: (index) => setState(() => _index = index),
              ),
            if (_appBarVisible)
              Align(
                alignment: Alignment.topCenter,
                child: AppInnerHeader(
                  title: widget.title ??
                      '${widget.imageUrls.isEmpty ? 0 : _index + 1} / '
                          '${widget.imageUrls.length}',
                  backSemanticsLabel:
                      MaterialLocalizations.of(context).backButtonTooltip,
                  onBack: () => Navigator.of(context).maybePop(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
