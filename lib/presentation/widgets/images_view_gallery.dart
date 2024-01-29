import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
  late bool _isDissmissibleDisabled;
  late PageController _pageController;
  late PhotoViewScaleStateController _scaleStateController;

  @override
  void initState() {
    _appBarVisible = true;
    _isDissmissibleDisabled = false;
    _pageController = PageController();
    _scaleStateController = PhotoViewScaleStateController();
    _scaleStateController.outputScaleStateStream.listen((event) {
      if (!mounted) return;
      if (event == PhotoViewScaleState.initial) {
        setState(() {
          _isDissmissibleDisabled = false;
        });
      } else {
        setState(() {
          _isDissmissibleDisabled = true;
        });
      }
    });
    super.initState();
  }

  void _toggleAppBarVisibility() {
    _appBarVisible = !_appBarVisible;
    _isDissmissibleDisabled = !_isDissmissibleDisabled;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scaleStateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      disabled: _isDissmissibleDisabled,
      onDismissed: () => context.pop(),
      onDragStart: () => {
        setState(() {
          _appBarVisible = false;
        })
      },
      isFullScreen: false,
      direction: DismissiblePageDismissDirection.vertical,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appBarVisible
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  "Просмотр изображений",
                ),
              )
            : null,
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () => setState(() {
            _toggleAppBarVisibility();
          }),
          child: Stack(
            children: [
              PhotoViewGestureDetectorScope(
                axis: Axis.vertical,
                child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      scaleStateController: _scaleStateController,
                      imageProvider: NetworkImage(widget.imageUrls[index]),
                      initialScale: PhotoViewComputedScale.contained * 0.8,
                      minScale: PhotoViewComputedScale.contained * 0.6,
                      maxScale: PhotoViewComputedScale.covered * 5.9,
                      heroAttributes:
                          PhotoViewHeroAttributes(tag: widget.imageUrls[index]),
                    );
                  },
                  itemCount: widget.imageUrls.length,
                  loadingBuilder: (context, event) => Center(
                    child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded /
                                event.expectedTotalBytes!,
                      ),
                    ),
                  ),
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.transparent),
                  pageController: _pageController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
