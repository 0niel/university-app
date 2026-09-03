import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

Color? parseMiniAppHexColor(String? hex) {
  if (hex == null) return null;
  final value = hex.replaceFirst('#', '');
  final digits = value.length == 6 ? 'FF$value' : value;
  if (digits.length != 8) return null;
  final parsed = int.tryParse(digits, radix: 16);
  return parsed == null ? null : Color(parsed);
}

AppAccent? miniAppAccentFor(String? hex) {
  final color = parseMiniAppHexColor(hex);
  if (color == null) return null;
  AppAccent? best;
  var bestDistance = double.infinity;
  for (final accent in AppAccent.values) {
    final candidate = AppColors.accentColor(accent, isDark: false);
    final distance = math.sqrt(
      math.pow(candidate.r - color.r, 2) +
          math.pow(candidate.g - color.g, 2) +
          math.pow(candidate.b - color.b, 2),
    );
    if (distance < bestDistance) {
      bestDistance = distance;
      best = accent;
    }
  }
  return best;
}

class MiniAppAccentTheme extends StatelessWidget {
  const MiniAppAccentTheme({
    required this.accentColor,
    required this.child,
    super.key,
  });

  final String? accentColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final accent = miniAppAccentFor(accentColor);
    if (accent == null) return child;
    final theme = Theme.of(context);
    final colors = theme.colors;
    if (colors.accent == AppColors.accentColor(accent, isDark: colors.isDark)) {
      return child;
    }
    return Theme(
      data: AppTheme.generateTheme(colors.withAccent(accent), theme.brightness),
      child: child,
    );
  }
}
