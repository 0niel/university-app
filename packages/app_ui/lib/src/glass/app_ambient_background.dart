import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/glass/app_glass_theme.dart';
import 'package:flutter/material.dart';

class AppAmbientBackground extends StatelessWidget {
  const AppAmbientBackground({
    required this.child,
    this.accentColor,
    super.key,
  });

  final Widget child;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = accentColor ?? colors.accent;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.canvas,
        gradient: !AppGlassTheme.of(context).enabled
            ? null
            : RadialGradient(
                center: const Alignment(.7, -1.05),
                radius: 1.25,
                colors: [
                  Color.alphaBlend(
                    accent.withValues(alpha: colors.isDark ? .13 : .075),
                    colors.canvas,
                  ),
                  colors.canvas,
                ],
                stops: const [0, .85],
              ),
      ),
      child: child,
    );
  }
}
