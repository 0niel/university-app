import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/app_pill_button.dart';
import 'package:flutter/widgets.dart';

enum NinjaPillTone { tonal, secondary, surface, primary, danger }

class NinjaPillButton extends StatelessWidget {
  const NinjaPillButton({
    required this.label,
    super.key,
    this.onPressed,
    this.tone = NinjaPillTone.tonal,
    this.height = AppControlSize.buttonSmall,
    this.horizontalPadding = AppSpacing.fieldGap,
    this.expanded = false,
    this.textStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final NinjaPillTone tone;
  final double height;
  final double horizontalPadding;
  final bool expanded;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch (tone) {
      NinjaPillTone.tonal => (colors.tint, colors.accent),
      NinjaPillTone.secondary => (colors.surface2, colors.ink),
      NinjaPillTone.surface => (colors.surface, colors.ink),
      NinjaPillTone.primary => (colors.accent, colors.onAccent),
      NinjaPillTone.danger => (colors.danger, colors.white),
    };

    return AppPillButton(
      label: label,
      background: background,
      foreground: foreground,
      onPressed: onPressed,
      height: height,
      horizontalPadding: horizontalPadding,
      expanded: expanded,
      textStyle: textStyle,
    );
  }
}
