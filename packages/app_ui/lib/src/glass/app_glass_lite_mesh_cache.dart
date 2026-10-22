import 'package:app_ui/src/glass/app_glass_lite_mesh.dart';
import 'package:flutter/painting.dart';

class AppGlassLiteMeshCache {
  AppGlassLiteMeshCache({this.maxEntries = 32, this.maxBytes = 2 * 1024 * 1024})
    : assert(maxEntries > 0, 'maxEntries must be positive'),
      assert(maxBytes > 0, 'maxBytes must be positive');

  static final shared = AppGlassLiteMeshCache();

  final int maxEntries;
  final int maxBytes;
  final _entries =
      <({Size size, double radius, double alpha}), AppGlassLiteMesh>{};
  var _byteSize = 0;

  int get entryCount => _entries.length;
  int get byteSize => _byteSize;

  AppGlassLiteMesh? obtain({
    required Size size,
    required double radius,
    required double borderAlpha,
  }) {
    final alpha = borderAlpha.clamp(.0, 1.0);
    final key = (size: size, radius: radius, alpha: alpha);
    final cached = _entries.remove(key);
    if (cached != null) {
      _entries[key] = cached;
      return cached;
    }
    final mesh = AppGlassLiteMesh.build(
      size: size,
      radius: radius,
      borderAlpha: borderAlpha,
    );
    if (mesh == null || mesh.byteSize > maxBytes) return mesh;
    while (_entries.isNotEmpty &&
        (_entries.length >= maxEntries ||
            _byteSize + mesh.byteSize > maxBytes)) {
      final oldestKey = _entries.keys.firstOrNull;
      if (oldestKey == null) break;
      final oldest = _entries.remove(oldestKey)!;
      _byteSize -= oldest.byteSize;
    }
    _entries[key] = mesh;
    _byteSize += mesh.byteSize;
    return mesh;
  }
}
