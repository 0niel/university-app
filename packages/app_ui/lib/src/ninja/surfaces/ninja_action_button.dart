import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class NinjaActionButton extends StatelessWidget {
  const NinjaActionButton({
    required this.label,
    super.key,
    this.onPressed,
    this.tone = NinjaActionTone.ink,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.radius = NinjaRadius.button,
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
    final colors = context.ninja;
    final Color? background;
    final Color? borderColor;
    final Color foreground;
    switch (tone) {
      case NinjaActionTone.ink:
        background = colors.ink;
        borderColor = null;
        foreground = colors.onInk;
      case NinjaActionTone.scarlet:
        background = colors.scarlet;
        borderColor = null;
        foreground = colors.onScarlet;
      case NinjaActionTone.surface:
        background = colors.surfaceAlt;
        borderColor = null;
        foreground = colors.ink;
      case NinjaActionTone.outline:
        background = null;
        borderColor = colors.line;
        foreground = colors.mutedDark;
    }

    final button = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: NinjaMetrics.minTouchTarget),
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
          style: TextStyle(
            fontFamily: NinjaText.family,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
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
