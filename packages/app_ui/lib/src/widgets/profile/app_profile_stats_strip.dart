import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_card.dart';
import 'package:app_ui/src/widgets/app_divider.dart';
import 'package:flutter/widgets.dart';

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

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          for (final (index, stat) in stats.indexed) ...[
            if (index != 0) const AppVerticalDivider(height: 34),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    stat.value,
                    maxLines: 1,
                    style: AppText.metric.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    stat.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.captionSmall.copyWith(color: colors.muted),
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
