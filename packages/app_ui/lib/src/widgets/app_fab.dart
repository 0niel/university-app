import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:app_ui/src/widgets/app_tooltip.dart';
import 'package:flutter/material.dart';

class AppFab extends StatelessWidget {
  const AppFab({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
  }) : label = null;

  const AppFab.extended({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
  });

  final AppLineIcon icon;
  final String? label;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null;
    final background =
        backgroundColor ?? (enabled ? colors.accent : colors.canvas);
    final foreground =
        foregroundColor ?? (enabled ? colors.onAccent : colors.muted2);
    final labelText = label;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);

    Widget fab = AppPressState(
      onTap: onPressed,
      pressedScale: 0.95,
      semanticsLabel: tooltip ?? labelText,
      semanticsButton: true,
      builder: (context, {required pressed}) => AnimatedContainer(
        duration:
            reduceMotion ? Duration.zero : const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        height: AppControlSize.fab,
        width: labelText == null ? AppControlSize.fab : null,
        padding: labelText == null
            ? null
            : const EdgeInsets.symmetric(horizontal: AppSpacing.contentGap),
        decoration: BoxDecoration(
          color: pressed ? background.withValues(alpha: .82) : background,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLineIconWidget(
              icon,
              size: labelText == null ? 24 : 20,
              color: foreground,
              strokeWidth: 2.4,
            ),
            if (labelText != null) ...[
              const SizedBox(width: AppSpacing.gap),
              Text(
                labelText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.buttonLarge.copyWith(color: foreground),
              ),
            ],
          ],
        ),
      ),
    );

    if (tooltip != null) fab = AppTooltipAnchor(message: tooltip!, child: fab);
    return fab;
  }
}
