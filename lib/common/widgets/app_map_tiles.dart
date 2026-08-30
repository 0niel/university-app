import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class AppMapTiles {
  const AppMapTiles._();

  static const _userAgent = 'university-app';

  static const String attribution = '© CARTO · © OpenStreetMap';

  static const ColorFilter _softenDark = ColorFilter.matrix(<double>[
    0.90,
    0,
    0,
    0,
    24,
    0,
    0.90,
    0,
    0,
    24,
    0,
    0,
    0.95,
    0,
    30,
    0,
    0,
    0,
    1,
    0,
  ]);

  static Widget tileLayer(BuildContext context) {
    final isDark = Theme.of(context).brightness == .dark;
    return isDark ? _carto(context, 'dark_all') : _carto(context, 'voyager');
  }

  static TileLayer _carto(BuildContext context, String style) {
    final softenDark = style == 'dark_all';
    return TileLayer(
      urlTemplate:
          'https://{s}.basemaps.cartocdn.com/rastertiles/$style/{z}/{x}/{y}{r}.png',
      subdomains: const ['a', 'b', 'c', 'd'],
      userAgentPackageName: _userAgent,
      retinaMode: RetinaMode.isHighDensity(context),
      maxNativeZoom: 20,
      tileBuilder: softenDark
          ? (context, tileWidget, tile) =>
                ColorFiltered(colorFilter: _softenDark, child: tileWidget)
          : null,
    );
  }
}
