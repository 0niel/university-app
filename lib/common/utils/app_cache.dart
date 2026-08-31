import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class AppCache {
  const AppCache();

  Future<int> estimateBytes() async {
    var total = 0;
    final directory = await getTemporaryDirectory();
    if (!directory.existsSync()) return 0;
    await for (final entity in directory.list(
      recursive: true,
      followLinks: false,
    )) {
      if (entity is File) {
        try {
          total += await entity.length();
        } on FileSystemException catch (_) {}
      }
    }
    return total;
  }

  Future<void> clear() async {
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
    clearMemoryImageCache();
    await clearDiskCachedImages();
    await DefaultCacheManager().emptyCache();
  }
}
