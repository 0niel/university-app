import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppProfileStat {
  const AppProfileStat({required this.value, required this.label});

  final String value;

  final String label;
}

class AppProfileStatsStrip extends StatelessWidget {
  const AppProfileStatsStrip({required this.stats, super.key});

  final List<AppProfileStat> stats;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          for (final (index, stat) in stats.indexed) ...[
            if (index != 0)
              Container(width: 1, height: 34, color: colors.divider),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stat.value,
                    maxLines: 1,
                    style: AppText.tabular(AppText.title).copyWith(
                      color: colors.active,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.captionSmall.copyWith(
                      color: colors.deactiveDarker,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
