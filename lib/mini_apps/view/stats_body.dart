part of 'mini_app_stats_page.dart';

class _StatsBody extends StatelessWidget {
  const _StatsBody({required this.app, required this.stats, super.key});

  final MiniApp app;
  final List<MiniAppDailyStat> stats;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final launches = stats.fold(0, (a, s) => a + s.launches);
    final users = stats.fold(0, (a, s) => a + s.uniqueUsers);
    return ListView(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        ninjaBottomInset(context) + AppSpacing.lg,
      ),
      children: [
        _TotalsStrip(
          children: [
            _TotalCard(
              icon: AppLineIcon.bolt,
              value: '$launches',
              label: l10n.miniAppsStatsLaunches,
            ),
            _TotalCard(
              icon: AppLineIcon.people,
              value: '$users',
              label: l10n.miniAppsStatsUsers,
            ),
            _TotalCard(
              icon: AppLineIcon.star,
              value: app.ratingCount > 0
                  ? app.ratingAvg.toStringAsFixed(1)
                  : '—',
              label: l10n.miniAppsStatsRating,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        NinjaCard(
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: 260,
            child: Padding(
              padding: const .fromLTRB(12, 24, 24, 14),
              child: _StatsChart(stats: stats),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.gap),
        Wrap(
          alignment: .center,
          spacing: 16,
          runSpacing: 8,
          children: [
            _LegendDot(color: colors.ink, label: l10n.miniAppsStatsLaunches),
            _LegendDot(color: colors.accent, label: l10n.miniAppsStatsUsers),
          ],
        ),
      ],
    );
  }
}
