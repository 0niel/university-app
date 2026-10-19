import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/glass/app_glass_lens.dart';
import 'package:app_ui/src/glass/app_glass_style.dart';
import 'package:flutter/material.dart';

class AppGlassHighlight extends StatelessWidget {
  const AppGlassHighlight({
    required this.child,
    this.borderRadius = 999,
    super.key,
  });

  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppGlassLens(
      borderRadius: borderRadius,
      fallbackColor: colors.tint,
      style: AppGlassStyle.surface(
        colors: colors,
        radius: borderRadius,
        tone: AppGlassTone.regular,
        highContrast: MediaQuery.highContrastOf(context),
        role: AppGlassRole.control,
        selected: true,
      ),
      child: child,
    );
  }
}
