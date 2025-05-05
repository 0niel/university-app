import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:open_filex/open_filex.dart';

class ImagesHorizontalSlider extends StatelessWidget {
  const ImagesHorizontalSlider({required this.images, super.key});
  final List<String> images;

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
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemBuilder: (context, index) {
          return GalleryImageItem(imageUrl: images[index + 1]);
        },
      ),
    );
  }
}

class GalleryImageItem extends StatefulWidget {
  const GalleryImageItem({required this.imageUrl, super.key});
  final String imageUrl;

  @override
  State<GalleryImageItem> createState() => _GalleryImageItemState();
}

class _GalleryImageItemState extends State<GalleryImageItem> {
  bool _isLoading = false;

  Future<void> _openImageInSystemGallery(BuildContext context) async {
    if (_isLoading) return;

    try {
      setState(() {
        _isLoading = true;
      });

      // Use the DefaultCacheManager to get the file
      final file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
      await OpenFilex.open(file.path, type: 'image/jpeg');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось открыть изображение: $e'), backgroundColor: Colors.red),
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
    final colors = Theme.of(context).extension<AppColors>()!;

    return GestureDetector(
      onTap: () => _openImageInSystemGallery(context),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: colors.primary.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                memCacheWidth: 320, // Optimize memory usage
                maxWidthDiskCache: 640, // Optimize disk usage
                // Set cache lifetime to 1 day (implicitly handled by CacheManager)
                cacheManager: DefaultCacheManager(),
                placeholder: (context, url) => ColoredBox(
                  color: colors.background03,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => ColoredBox(
                  color: colors.background03,
                  child: Center(child: Icon(Icons.broken_image_rounded, color: colors.deactive)),
                ),
              ),
            ),
            if (_isLoading)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ColoredBox(
                    color: colors.background03.withOpacity(0.7),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: colors.white,
                              ),),
                          const SizedBox(height: 8),
                          Text(
                            'Открытие...',
                            style: AppTextStyle.body.copyWith(
                              color: colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
