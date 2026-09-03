import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class DeadlinesSharedCard extends StatelessWidget {
  const DeadlinesSharedCard({
    required this.shared,
    required this.total,
    super.key,
  });

  final int shared;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return AppCard(
      key: const ValueKey('deadlines-shared-card'),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          AppIconTile(
            icon: AppLineIcon.spark,
            size: 44,
            radius: AppRadius.tile,
            background: colors.labTint,
            foreground: colors.lab,
            iconSize: 20,
          ),
          const SizedBox(width: AppSpacing.sectionGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.deadlinesSharedTitle,
                  style: AppText.cell.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  l10n.deadlinesSharedBody(shared, total),
                  style: AppText.subtext.copyWith(
                    color: colors.muted,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
