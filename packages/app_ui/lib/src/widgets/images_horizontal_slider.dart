import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImagesHorizontalSlider extends StatelessWidget {
  const ImagesHorizontalSlider({
    required this.images,
    super.key,
    this.semanticLabel,
    this.errorMessage,
    this.onOpen,
  });
  final List<String> images;
  final String? semanticLabel;
  final String? errorMessage;
  final Future<void> Function(String)? onOpen;

  @override
  Widget build(BuildContext context) {
    if (images.length <= 1) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length - 1,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        itemBuilder: (context, index) {
          return GalleryImageItem(
            key: ValueKey('${index + 1}:${images[index + 1]}'),
            imageUrl: images[index + 1],
            galleryImageUrls: images,
            galleryIndex: index + 1,
            semanticLabel: semanticLabel,
            errorMessage: errorMessage,
            onOpen: onOpen,
          );
        },
      ),
    );
  }
}

class GalleryImageItem extends StatefulWidget {
  const GalleryImageItem({
    required this.imageUrl,
    super.key,
    this.semanticLabel,
    this.errorMessage,
    this.onOpen,
    this.galleryImageUrls,
    this.galleryIndex = 0,
  });
  final String imageUrl;
  final String? semanticLabel;
  final String? errorMessage;
  final Future<void> Function(String)? onOpen;
  final List<String>? galleryImageUrls;
  final int galleryIndex;

  @override
  State<GalleryImageItem> createState() => _GalleryImageItemState();
}

class _GalleryImageItemState extends State<GalleryImageItem> {
  bool _isLoading = false;
  final _heroTag = Object();

  Future<void> _openImage(BuildContext context) async {
    if (_isLoading) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final onOpen = widget.onOpen;
      if (onOpen != null) {
        await onOpen(widget.imageUrl);
      } else {
        final images = widget.galleryImageUrls;
        final hasGallery = images != null && images.isNotEmpty;
        final index =
            hasGallery ? widget.galleryIndex.clamp(0, images.length - 1) : 0;
        await Navigator.of(context).push(
          ImagesViewGallery.route(
            imageUrls: hasGallery ? images : [widget.imageUrl],
            initialIndex: index,
            heroTags: {index: _heroTag},
            reducedMotion: MediaQuery.disableAnimationsOf(context) ||
                MediaQuery.accessibleNavigationOf(context),
          ),
        );
      }
    } on Object catch (e, st) {
      log(
        'Failed to open image',
        error: e,
        stackTrace: st,
        name: 'GalleryImageItem',
      );
      if (context.mounted) {
        ToastManager.showError(
          context,
          message: widget.errorMessage ??
              MaterialLocalizations.of(context).alertDialogLabel,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppPressable(
      onTap: _isLoading ? null : () => _openImage(context),
      semanticsLabel: widget.semanticLabel,
      semanticsButton: true,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card),
          color: colors.surface,
        ),
        child: Stack(
          children: [
            Hero(
              tag: _heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  memCacheWidth: 320,
                  maxWidthDiskCache: 640,
                  cacheManager: DefaultCacheManager(),
                  placeholder: (context, url) => const AppStripePlaceholder(
                    child: AppSpinner(),
                  ),
                  errorWidget: (context, url, error) =>
                      const ImagePlaceholder(),
                ),
              ),
            ),
            if (_isLoading && widget.onOpen != null)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  child: ColoredBox(
                    color: colors.canvas.withValues(alpha: 0.85),
                    child: const Center(child: AppSpinner()),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
