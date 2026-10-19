import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapSvgColors extends ColorMapper {
  const MapSvgColors(this.colors);

  final AppColors colors;

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    if (color.a == 0) return color;
    final darkest = math.min(color.r, math.min(color.g, color.b));
    final lightest = math.max(color.r, math.max(color.g, color.b));
    if (lightest - darkest > .12) return color;
    if (elementName == 'text' || elementName == 'tspan') return colors.ink;
    if (attributeName == 'stroke') return colors.muted2;
    return lightest < .3 ? colors.surface : colors.surface2;
  }

  @override
  bool operator ==(Object other) =>
      other is MapSvgColors &&
      other.colors.ink == colors.ink &&
      other.colors.surface == colors.surface &&
      other.colors.surface2 == colors.surface2 &&
      other.colors.muted2 == colors.muted2;

  @override
  int get hashCode => Object.hash(
    colors.ink,
    colors.surface,
    colors.surface2,
    colors.muted2,
  );
}
