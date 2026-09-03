import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class NinjaActionButton extends StatelessWidget {
  const NinjaActionButton({
    required this.label,
    super.key,
    this.onPressed,
    this.tone = NinjaActionTone.ink,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.gap,
    ),
    this.radius = AppRadius.full,
    this.fontSize = 12,
    this.expanded = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final NinjaActionTone tone;
  final EdgeInsets padding;
  final double radius;
  final double fontSize;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final Color? background;
    final Color? borderColor;
    final Color foreground;
    switch (tone) {
      case NinjaActionTone.ink:
        background = colors.ink;
        borderColor = null;
        foreground = colors.canvas;
      case NinjaActionTone.scarlet:
        background = colors.exam;
        borderColor = null;
        foreground = colors.white;
      case NinjaActionTone.surface:
        background = colors.surface2;
        borderColor = null;
        foreground = colors.ink;
      case NinjaActionTone.outline:
        background = colors.surface2;
        borderColor = null;
        foreground = colors.muted;
    }

    final button = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppControlSize.touchTarget),
      child: Container(
        width: expanded ? double.infinity : null,
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(radius),
          border: borderColor == null ? null : Border.all(color: borderColor),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppText.buttonSmall.copyWith(
            fontSize: fontSize,
            color: foreground,
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: AppPressable(onTap: onPressed, child: button),
    );
  }
}

enum NinjaActionTone {
  ink,
  scarlet,
  surface,
  outline,
}
