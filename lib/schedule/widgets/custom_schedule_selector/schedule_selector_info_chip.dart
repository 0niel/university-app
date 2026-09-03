import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ScheduleSelectorInfoChip extends StatelessWidget {
  const ScheduleSelectorInfoChip({
    required this.label,
    required this.color,
    required this.icon,
    super.key,
  });

  final String label;
  final Color color;
  final AppLineIcon icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: .min,
        spacing: AppSpacing.xsm,
        children: [
          AppLineIconWidget(icon, size: 15, color: color),
          Text(
            label,
            style: AppText.captionSmall.copyWith(color: colors.muted),
          ),
        ],
      ),
    );
  }
}
