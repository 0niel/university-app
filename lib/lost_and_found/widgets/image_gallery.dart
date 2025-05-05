import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageGallery extends StatefulWidget {
  final List<String> images;

  const ImageGallery({super.key, required this.images});

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

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
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Stack(
      children: [
        GestureDetector(
          onTap: () => _openFullScreenGallery(context),
          child: Hero(
            tag: 'gallery-hero-${widget.images.hashCode}',
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return Image.network(
                  widget.images[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                        color: appColors.primary,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Icon(Icons.broken_image_rounded, color: appColors.deactive, size: 48));
                  },
                );
              },
            ),
          ),
        ),
        if (widget.images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? appColors.primary : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _openFullScreenGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _FullScreenImageGallery(images: widget.images, initialIndex: _currentIndex)),
    );
  }
}

class _FullScreenImageGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _FullScreenImageGallery({required this.images, required this.initialIndex});

  @override
  State<_FullScreenImageGallery> createState() => _FullScreenImageGalleryState();
}

class _FullScreenImageGalleryState extends State<_FullScreenImageGallery> {
  late int _currentIndex;
  late PageController _pageController;

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
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_currentIndex + 1} / ${widget.images.length}',
          style: AppTextStyle.title.copyWith(color: Colors.white),
        ),
      ),
      body: Hero(
        tag: 'gallery-hero-${widget.images.hashCode}',
        child: PhotoViewGallery.builder(
          pageController: _pageController,
          itemCount: widget.images.length,
          onPageChanged: _onPageChanged,
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.images[index]),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              heroAttributes: PhotoViewHeroAttributes(tag: 'image-$index'),
            );
          },
          loadingBuilder:
              (context, event) => Center(
                child: CircularProgressIndicator(
                  value: event == null ? 0 : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
                  color: appColors.primary,
                ),
              ),
        ),
      ),
    );
  }
}
