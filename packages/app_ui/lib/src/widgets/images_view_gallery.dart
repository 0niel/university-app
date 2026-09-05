import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagesViewGallery extends StatefulWidget {
  const ImagesViewGallery({
    required this.imageUrls,
    super.key,
    this.initialIndex,
    this.title,
    this.heroTags = const {},
  });

  final List<String> imageUrls;
  final int? initialIndex;
  final String? title;
  final Map<int, Object> heroTags;

  static Route<void> route({
    required List<String> imageUrls,
    int? initialIndex,
    String? title,
    Map<int, Object> heroTags = const {},
    bool reducedMotion = false,
  }) =>
      PageRouteBuilder<void>(
        opaque: false,
        transitionDuration:
            reducedMotion ? Duration.zero : const Duration(milliseconds: 240),
        reverseTransitionDuration:
            reducedMotion ? Duration.zero : const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ImagesViewGallery(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
          title: title,
          heroTags: heroTags,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: animation,
          child: child,
        ),
      );

  @override
  State<ImagesViewGallery> createState() => _ImagesViewGalleryState();
}

class _ImagesViewGalleryState extends State<ImagesViewGallery> {
  late bool _appBarVisible;
  late AppImagePageController _pageController;
  late int _index;
  final _heroScope = Object();
  final _dismissProgress = ValueNotifier<double>(0);
  bool _pageMoving = false;
  bool _closing = false;

  int _clampIndex(int index) => widget.imageUrls.isEmpty
      ? 0
      : index.clamp(0, widget.imageUrls.length - 1);

  @override
  void initState() {
    super.initState();
    _appBarVisible = true;

    _index = _clampIndex(widget.initialIndex ?? 0);
    _pageController = AppImagePageController(initialPage: _index);
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
    setState(() => _appBarVisible = !_appBarVisible);
  }

  Future<void> _showPage(int index) async {
    if (_closing ||
        _pageMoving ||
        !_pageController.hasClients ||
        index < 0 ||
        index >= widget.imageUrls.length) {
      return;
    }
    _pageMoving = true;
    _dismissProgress.value = 0;
    try {
      if (MediaQuery.disableAnimationsOf(context) ||
          MediaQuery.accessibleNavigationOf(context)) {
        _pageController.jumpToPage(index);
      } else {
        await _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
        );
      }
    } finally {
      _pageMoving = false;
    }
  }

  Future<void> _close() async {
    if (_closing) return;
    _closing = true;
    final popped = await Navigator.of(context).maybePop();
    if (!popped && mounted) _closing = false;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dismissProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: ValueListenableBuilder<double>(
                valueListenable: _dismissProgress,
                builder: (context, progress, child) => ColoredBox(
                  key: const ValueKey('gallery-backdrop'),
                  color: Colors.black.withValues(alpha: 1 - progress),
                ),
              ),
            ),
            if (widget.imageUrls.isEmpty)
              const Positioned.fill(child: ImagePlaceholder())
            else
              PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ExcludeFocus(
                    excluding: index != _index,
                    child: HeroMode(
                      enabled: index == _index,
                      child: AppZoomableImage(
                        key: ValueKey('$index:${widget.imageUrls[index]}'),
                        imageProvider:
                            CachedNetworkImageProvider(widget.imageUrls[index]),
                        heroTag: widget.heroTags[index] ??
                            (_heroScope, index, widget.imageUrls[index]),
                        onTap: _toggleAppBarVisibility,
                        onDismissed: () => unawaited(_close()),
                        onPrevious: index > 0
                            ? () => unawaited(_showPage(index - 1))
                            : null,
                        onNext: index < widget.imageUrls.length - 1
                            ? () => unawaited(_showPage(index + 1))
                            : null,
                        onHorizontalDragStart: _pageController.beginImageDrag,
                        onHorizontalDragUpdate: _pageController.updateImageDrag,
                        onHorizontalDragEnd: (velocity) =>
                            _pageController.endImageDrag(
                          velocity,
                          reducedMotion:
                              MediaQuery.disableAnimationsOf(context) ||
                                  MediaQuery.accessibleNavigationOf(context),
                        ),
                        onDismissProgress: (progress) {
                          if (mounted && index == _index) {
                            _dismissProgress.value = progress;
                          }
                        },
                        loadingBuilder: (context, event) =>
                            const Center(child: AppSpinner()),
                        errorBuilder: (context, error, stackTrace) =>
                            const ImagePlaceholder(),
                      ),
                    ),
                  );
                },
                itemCount: widget.imageUrls.length,
                onPageChanged: (index) {
                  _dismissProgress.value = 0;
                  setState(() => _index = index);
                },
              ),
            if (_appBarVisible)
              Align(
                alignment: Alignment.topCenter,
                child: ValueListenableBuilder<double>(
                  valueListenable: _dismissProgress,
                  builder: (_, progress, child) => IgnorePointer(
                    ignoring: progress > .1,
                    child: Opacity(opacity: 1 - progress, child: child),
                  ),
                  child: AppInnerHeader(
                    title: widget.title ??
                        '${widget.imageUrls.isEmpty ? 0 : _index + 1} / '
                            '${widget.imageUrls.length}',
                    backSemanticsLabel:
                        MaterialLocalizations.of(context).backButtonTooltip,
                    onBack: () => unawaited(_close()),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
