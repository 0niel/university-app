import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class AppMapTiles {
  const AppMapTiles._();

  static const _packageName = 'ninja.mirea.mireaapp';
  static const _userAgent =
      'NinjaMirea ($_packageName; https://mirea.ninja; support@mirea.ninja)';
  static const int maxCacheSizeBytes = 128 * 1024 * 1024;

  static const String urlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String attribution = '© OpenStreetMap contributors';

  static const _darkMap = ColorFilter.matrix(<double>[
    -0.1594,
    -0.5355,
    -0.0541,
    0,
    205,
    -0.1594,
    -0.5355,
    -0.0541,
    0,
    210,
    -0.1594,
    -0.5355,
    -0.0541,
    0,
    220,
    0,
    0,
    0,
    1,
    0,
  ]);
  static const _lightMap = ColorFilter.matrix(<double>[
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  static NetworkTileProvider createTileProvider({
    MapCachingProvider? cachingProvider,
  }) {
    return NetworkTileProvider(
      headers: {'User-Agent': _userAgent},
      silenceExceptions: true,
      attemptDecodeOfHttpErrorResponses: false,
      cachingProvider:
          cachingProvider ??
          BuiltInMapCachingProvider.getOrCreateInstance(
            maxCacheSize: maxCacheSizeBytes,
          ),
    );
  }

  static Widget tileLayer(
    BuildContext context, {
    required TileProvider tileProvider,
  }) {
    final isDark = Theme.of(context).brightness == .dark;
    final layer = TileLayer(
      urlTemplate: urlTemplate,
      tileProvider: tileProvider,
      userAgentPackageName: _packageName,
      subdomains: const [],
      keepBuffer: 1,
      panBuffer: 0,
      tileDisplay: const TileDisplay.fadeIn(
        duration: Duration(milliseconds: 80),
      ),
      evictErrorTileStrategy: EvictErrorTileStrategy.notVisible,
    );
    return RepaintBoundary(
      child: ColoredBox(
        color: isDark ? AppColors.mapCanvasDark : AppColors.mapCanvasLight,
        child: ColorFiltered(
          colorFilter: isDark ? _darkMap : _lightMap,
          child: layer,
        ),
      ),
    );
  }
}
