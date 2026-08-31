part of 'badges_tab.dart';

class _RecentlyUnlockedCard extends StatelessWidget {
  const _RecentlyUnlockedCard({required this.badge});

  final GamificationBadge badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: .center,
            decoration: BoxDecoration(
              color: colors.brandTint,
              borderRadius: .circular(14),
            ),
            child: Text(badge.emoji, style: const TextStyle(fontSize: 21)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  l10n.profileBadgeUnlocked,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: NinjaText.microLabel.copyWith(color: colors.brandInk),
                ),
                const SizedBox(height: 3),
                Text(
                  badge.name,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: NinjaText.headline.copyWith(color: colors.ink),
                ),
                const SizedBox(height: 2),
                Text(
                  '+${badge.shurikenReward} ${l10n.ninjaRankShurikens}',
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: NinjaText.tabular(
                    NinjaText.helper.copyWith(color: colors.mutedDark),
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
