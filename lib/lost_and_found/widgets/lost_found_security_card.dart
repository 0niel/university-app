import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class LostFoundSecurityCard extends StatelessWidget {
  const LostFoundSecurityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return AppCard(
      radius: AppRadius.row,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sectionGap,
      ),
      child: Row(
        children: [
          AppIconTile(
            icon: AppLineIcon.pin,
            size: 40,
            background: colors.lectureTint,
            foreground: colors.lecture,
            iconSize: 18,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.lostFoundSecurityTitle,
                  style: AppText.bodyStrong.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  l10n.lostFoundSecuritySub,
                  style: AppText.caption.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
