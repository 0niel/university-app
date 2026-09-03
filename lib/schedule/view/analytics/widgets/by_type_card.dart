part of '../analytics_page.dart';

class _ByTypeCard extends StatelessWidget {
  const _ByTypeCard({required this.stats});

  final AnalyticsStats stats;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return AppCard(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.analyticsByType,
            style: AppText.headline.copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          for (final (type, share) in stats.typeShares) ...[
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    LessonCard.getLessonTypeName(l10n, type),
                    style: AppText.subtext.copyWith(color: colors.ink),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${(share * 100).round()}%',
                  style: AppText.tabular(
                    AppText.subtext.copyWith(color: colors.muted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xsm),
            ClipRRect(
              borderRadius: .circular(AppRadius.full),
              child: SizedBox(
                height: AppSpacing.sm,
                child: Stack(
                  fit: .expand,
                  children: [
                    ColoredBox(color: colors.surface2),
                    FractionallySizedBox(
                      alignment: .centerLeft,
                      widthFactor: share.clamp(0.0, 1.0),
                      child: ColoredBox(
                        color: LessonCard.getColorByTypeFor(context, type),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          if (stats.typeShares.isEmpty)
            Text(
              l10n.noData,
              style: AppText.subtext.copyWith(color: colors.muted),
            ),
        ],
      ),
    );
  }
}
