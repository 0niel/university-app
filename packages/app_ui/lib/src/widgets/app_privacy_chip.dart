import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppPrivacyChip extends StatelessWidget {
  const AppPrivacyChip({
    required this.icon,
    required this.label,
    super.key,
  });

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: colors.success.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, size: 13, color: colors.success),
          const SizedBox(width: 6),
          Text(
            '$icon $label',
            style: AppText.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.success,
            ),
          ),
        ],
      ),
    );
  }
}
