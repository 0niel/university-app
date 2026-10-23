import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/glass/app_glass_lens.dart';
import 'package:app_ui/src/glass/app_glass_style.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:flutter/material.dart';

export 'app_glass_style.dart' show AppGlassRole, AppGlassTone;

class AppGlassSurface extends StatelessWidget {
  const AppGlassSurface({
    required this.child,
    this.borderRadius = AppRadius.dialog,
    this.padding = EdgeInsets.zero,
    this.tint,
    this.color,
    this.tone = AppGlassTone.regular,
    this.role = AppGlassRole.content,
    super.key,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? tint;
  final Color? color;
  final AppGlassTone tone;
  final AppGlassRole role;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final highContrast = MediaQuery.highContrastOf(context);
    final accent = tint ?? colors.accent;
    final base =
        color ??
        (tone == AppGlassTone.accent
            ? Color.alphaBlend(accent.withValues(alpha: .13), colors.surface)
            : colors.surface);
    final background = Color.alphaBlend(base, colors.surface);
    if (role == AppGlassRole.content) {
      final radius = BorderRadius.circular(borderRadius);
      return ClipRRect(
        borderRadius: radius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            borderRadius: radius,
            border: Border.all(
              color: highContrast
                  ? colors.ink.withValues(alpha: .24)
                  : colors.line,
              width: highContrast ? 1 : .75,
            ),
          ),
          child: Padding(padding: padding, child: child),
        ),
      );
    }
    final style = AppGlassStyle.surface(
      colors: colors,
      radius: borderRadius,
      tone: tone,
      highContrast: highContrast,
      role: role,
      tint: accent,
      baseColor: background,
    );
    return AppGlassLens(
      style: style,
      borderRadius: borderRadius,
      fallbackColor: background,
      child: Padding(padding: padding, child: child),
    );
  }
}
