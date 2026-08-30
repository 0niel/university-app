import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class MapPanelLayout {
  const MapPanelLayout({
    required this.collapsedExtent,
    required this.expandedExtent,
    required this.collapsedPixels,
    required this.canvasTopInset,
  });

  factory MapPanelLayout.from(MediaQueryData media) {
    final scale = media.textScaler.scale(1).clamp(1.0, 2.0);
    final searchHeight = 52 + (scale - 1) * 18;
    final collapsedPixels = 174 + (scale - 1) * 54 + media.padding.bottom;
    final height = math.max(media.size.height, 1);
    final collapsedExtent = (collapsedPixels / height).clamp(
      .16,
      .52,
    );
    final preferredExpanded = scale >= 1.6 ? .88 : .68;
    final expandedExtent = math
        .max(
          preferredExpanded,
          collapsedExtent + .2,
        )
        .clamp(collapsedExtent, .94);
    return MapPanelLayout(
      collapsedExtent: collapsedExtent,
      expandedExtent: expandedExtent,
      collapsedPixels: collapsedExtent * height,
      canvasTopInset: media.padding.top + searchHeight + 28,
    );
  }

  final double collapsedExtent;
  final double expandedExtent;
  final double collapsedPixels;
  final double canvasTopInset;
}
