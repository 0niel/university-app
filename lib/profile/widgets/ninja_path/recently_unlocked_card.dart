part of 'badges_tab.dart';

class _RecentlyUnlockedCard extends StatelessWidget {
  const _RecentlyUnlockedCard({required this.badge});

  final GamificationBadge badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      padding: const .all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: .center,
            decoration: BoxDecoration(
              color: colors.tint,
              borderRadius: .circular(AppRadius.tile),
            ),
            child: Text(badge.emoji, style: const TextStyle(fontSize: 21)),
          ),
          const SizedBox(width: AppSpacing.sectionGap),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  l10n.profileBadgeUnlocked,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: AppText.captionSmall.copyWith(color: colors.accent),
                ),
                const SizedBox(height: 3),
                Text(
                  badge.name,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: AppText.headline.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '+${badge.shurikenReward} ${l10n.ninjaRankShurikens}',
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: AppText.caption
                      .copyWith(color: colors.muted)
                      .copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
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
