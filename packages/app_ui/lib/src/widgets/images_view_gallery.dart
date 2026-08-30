import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// {@template images_view_gallery}
/// A full-screen, zoomable, swipeable photo viewer for [imageUrls] with a
/// tap-to-toggle app bar, starting at [initialIndex].
/// {@endtemplate}
class ImagesViewGallery extends StatefulWidget {
  /// {@macro images_view_gallery}
  const ImagesViewGallery({
    required this.imageUrls,
    super.key,
    this.initialIndex,
  });

  final List<String> imageUrls;
  final int? initialIndex;

  @override
  State<ImagesViewGallery> createState() => _ImagesViewGalleryState();
}

class _ImagesViewGalleryState extends State<ImagesViewGallery> {
  late bool _appBarVisible;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _appBarVisible = true;

    _pageController = PageController();
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
      appBar: _appBarVisible
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text('Просмотр изображений'),
            )
          : null,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () => setState(_toggleAppBarVisibility),
        child: Stack(
          children: [
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.imageUrls[index]),
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  minScale: PhotoViewComputedScale.contained * 0.6,
                  maxScale: PhotoViewComputedScale.covered * 5.9,
                  heroAttributes: PhotoViewHeroAttributes(
                    tag: widget.imageUrls[index],
                  ),
                );
              },
              itemCount: widget.imageUrls.length,
              loadingBuilder: (context, event) {
                final total = event?.expectedTotalBytes;
                return Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : total == null
                              ? null
                              : event.cumulativeBytesLoaded / total,
                    ),
                  ),
                );
              },
              backgroundDecoration: widget.imageUrls.length == 1
                  ? BoxDecoration(color: Theme.of(context).colors.background01)
                  : null,
              pageController: _pageController,
            ),
          ],
        ),
      ),
    );
  }
}
