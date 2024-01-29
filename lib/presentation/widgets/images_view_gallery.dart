import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class ImagesViewGallery extends StatefulWidget {
  const ImagesViewGallery({
    Key? key,
    required this.imageUrls,
    this.initialIndex,
  }) : super(key: key);

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
    _appBarVisible = true;

    _pageController = PageController();

    super.initState();
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
              title: const Text(
                "Просмотр изображений",
              ),
            )
          : null,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () => setState(() {
          _toggleAppBarVisibility();
        }),
        child: Stack(
          children: [
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.imageUrls[index]),
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  minScale: PhotoViewComputedScale.contained * 0.6,
                  maxScale: PhotoViewComputedScale.covered * 5.9,
                  heroAttributes: PhotoViewHeroAttributes(tag: widget.imageUrls[index]),
                );
              },
              itemCount: widget.imageUrls.length,
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                  ),
                ),
              ),
              backgroundDecoration:
                  widget.imageUrls.length == 1 ? BoxDecoration(color: AppTheme.colorsOf(context).background01) : null,
              pageController: _pageController,
            ),
          ],
        ),
      ),
    );
  }
}
