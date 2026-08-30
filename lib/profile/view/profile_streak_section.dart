part of 'profile_page.dart';

class _ProfileStreakSection extends StatelessWidget {
  const _ProfileStreakSection({
    required this.streakDays,
    required this.longestStreak,
    required this.history,
  });

  final int streakDays;
  final int longestStreak;
  final List<bool> history;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final recordLabel = longestStreak <= 0
        ? l10n.profileStreakHint
        : longestStreak > streakDays
        ? l10n.profileStreakRecord(longestStreak, longestStreak - streakDays)
        : l10n.profileStreakRecordBeaten;
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        10,
        NinjaMetrics.screenPadding,
        0,
      ),
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
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: colors.brandTint,
                    borderRadius: .circular(14),
                  ),
                  child: AppLineIconWidget(
                    .bolt,
                    size: 21,
                    color: colors.brandInk,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        l10n.profileStreakDays(streakDays).trim(),
                        style: NinjaText.title.copyWith(color: colors.ink),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        recordLabel,
                        maxLines: 3,
                        overflow: .ellipsis,
                        style: NinjaText.subtext.copyWith(
                          color: colors.mutedDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (history.isNotEmpty) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  for (final (index, active) in history.indexed) ...[
                    if (index > 0) const SizedBox(width: 5),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: active ? colors.brand : colors.surfaceAlt,
                            shape: .circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    l10n.profileStreakDaysAgo(history.length),
                    style: NinjaText.helper.copyWith(color: colors.muted),
                  ),
                  const Spacer(),
                  Text(
                    l10n.profileStreakToday,
                    style: NinjaText.helper.copyWith(color: colors.muted),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
