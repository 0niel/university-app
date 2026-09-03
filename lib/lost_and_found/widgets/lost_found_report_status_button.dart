import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class LostFoundReportStatusButton extends StatelessWidget {
  const LostFoundReportStatusButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final AppLineIcon icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    return AppPressable(
      onTap: onTap,
      semanticsLabel: label,
      semanticsButton: true,
      semanticsSelected: selected,
      child: AnimatedContainer(
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 180),
        constraints: const BoxConstraints(
          minHeight: AppControlSize.iconButton,
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: selected ? colors.accent : colors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Column(
          children: [
            AppLineIconWidget(
              icon,
              size: 20,
              color: selected ? colors.onAccent : colors.muted,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: AppText.button.copyWith(
                color: selected ? colors.onAccent : colors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
