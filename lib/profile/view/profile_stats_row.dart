part of 'profile_page.dart';

class _ProfileStatsRow extends StatelessWidget {
  const _ProfileStatsRow({
    required this.xp,
    required this.shurikens,
    required this.earnedBadges,
    required this.totalBadges,
    required this.onAllBadges,
  });

  final int xp;
  final int shurikens;
  final int earnedBadges;
  final int totalBadges;
  final VoidCallback onAllBadges;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final level = l10n.profileLevel(levelFromXp(xp));
    final rank = NinjaRank.fromXp(xp);
    final next = rank.next;
    final currentBase = rank.xpThreshold;
    final target = next?.xpThreshold ?? xp;
    final span = target - currentBase;
    final progress = span <= 0
        ? 1.0
        : ((xp - currentBase) / span).clamp(0.0, 1.0);
    final remaining = next == null ? 0 : next.xpThreshold - xp;

    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        18,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: Semantics(
        container: true,
        label: '$level, ${profileNumber(xp)} XP',
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(NinjaRadius.card),
          ),
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Row(
                crossAxisAlignment: .start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          level,
                          style: NinjaText.title.copyWith(color: colors.ink),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          next == null
                              ? l10n.profileMaxRank
                              : l10n.profileRankNextXp(remaining, next.name),
                          maxLines: 3,
                          overflow: .ellipsis,
                          style: NinjaText.subtext.copyWith(
                            color: colors.mutedDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (textScale < 1.3) ...[
                    const SizedBox(width: 12),
                    NinjaBadge(rank.name),
                  ],
                ],
              ),
              if (textScale >= 1.3) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: .centerLeft,
                  child: NinjaBadge(rank.name),
                ),
              ],
              const SizedBox(height: 16),
              ProfileProgressBar(
                value: progress,
                label: '${(progress * 100).round()}%',
              ),
              const SizedBox(height: 16),
              _ProfileMetrics(
                stacked: textScale >= 1.3,
                metrics: [
                  (.bolt, profileNumber(xp), 'XP', null),
                  (
                    .spark,
                    profileNumber(shurikens),
                    l10n.homeShurikens,
                    null,
                  ),
                  (
                    .trophy,
                    totalBadges > 0
                        ? '$earnedBadges / $totalBadges'
                        : '$earnedBadges',
                    l10n.profileStatBadges,
                    onAllBadges,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef _ProfileMetricData = (AppLineIcon, String, String, VoidCallback?);
