import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:open_file/open_file.dart';
import 'package:rtu_mirea_app/presentation/widgets/image_placeholder.dart';

class ImagesHorizontalSlider extends StatelessWidget {
  const ImagesHorizontalSlider({Key? key, required this.images}) : super(key: key);

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          images.length,
          (index) {
            final cacheKey = base64Encode(utf8.encode(images[index]));
            return GestureDetector(
              onTap: () async {
                final DefaultCacheManager manager = DefaultCacheManager();
                final fileInfo = await manager.getFileFromCache(cacheKey);
                if (fileInfo != null) {
                  OpenFile.open(fileInfo.file.path);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    imageUrl: images[index],
                    height: 112,
                    width: 158,
                    fit: BoxFit.cover,
                    cacheKey: cacheKey,
                    placeholder: (context, url) => const ImagePlaceholder(),
                  ),
                ),
              ),
            );
          },
        )..add(
            const SizedBox(width: 18),
          ), // Right padding for the outermost element
      ),
    );
  }
}
