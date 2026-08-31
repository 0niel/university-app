part of '../analytics_page.dart';

class _ByTypeCard extends StatelessWidget {
  const _ByTypeCard({required this.stats});

  final AnalyticsStats stats;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return NinjaScheduleSurface(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.analyticsByType,
            style: NinjaText.headline.copyWith(color: colors.ink),
          ),
          const SizedBox(height: 14),
          for (final (type, share) in stats.typeShares) ...[
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  LessonCard.getLessonTypeName(l10n, type),
                  style: NinjaText.subtext.copyWith(color: colors.ink),
                ),
                Text(
                  '${(share * 100).round()}%',
                  style: NinjaText.tabular(
                    NinjaText.subtext.copyWith(color: colors.muted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: .circular(NinjaRadius.pill),
              child: SizedBox(
                height: 8,
                child: Stack(
                  fit: .expand,
                  children: [
                    ColoredBox(color: colors.surfaceAlt),
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
            const SizedBox(height: 12),
          ],
          if (stats.typeShares.isEmpty)
            Text(
              l10n.noData,
              style: NinjaText.subtext.copyWith(color: colors.muted),
            ),
        ],
      ),
    );
  }
}
