import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class DeadlineAddButton extends StatelessWidget {
  const DeadlineAddButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.background,
    this.foreground,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final enabled = onPressed != null;
    final tint = enabled ? (foreground ?? colors.onBrand) : colors.disabled;
    final compact = MediaQuery.textScalerOf(context).scale(14) > 18;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: AppPressable(
        onTap: onPressed,
        haptics: enabled,
        child: AnimatedContainer(
          duration:
              MediaQuery.disableAnimationsOf(context) ||
                  MediaQuery.accessibleNavigationOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          padding: EdgeInsets.symmetric(horizontal: compact ? 0 : 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled ? (background ?? colors.brand) : colors.surfaceAlt,
            borderRadius: BorderRadius.circular(NinjaRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLineIconWidget(AppLineIcon.plus, size: 20, color: tint),
              if (!compact) ...[
                const SizedBox(width: 8),
                Text(
                  label,
                  maxLines: 1,
                  style: NinjaText.buttonSmall.copyWith(color: tint),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
