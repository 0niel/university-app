part of 'profile_page.dart';

class _ProfileAchievementTile extends StatelessWidget {
  const _ProfileAchievementTile({required this.badge, required this.onTap});

  final GamificationBadge badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final earned = badge.isEarned;
    final percent = (badge.progress * 100).round().clamp(0, 99);
    return Semantics(
      button: true,
      label: badge.name,
      value: earned
          ? '${l10n.profileBadgeEarned}, ${badge.category}'
          : '${l10n.profileBadgeLocked}, $percent%',
      child: AppPressable(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(NinjaRadius.card),
          ),
          child: Padding(
            padding: const .all(16),
            child: Row(
              crossAxisAlignment: .start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: earned ? colors.brandTint : colors.surfaceAlt,
                    borderRadius: .circular(14),
                  ),
                  child: earned
                      ? Text(
                          badge.emoji,
                          style: const TextStyle(
                            fontFamilyFallback: [
                              'Noto Color Emoji',
                              'Segoe UI Emoji',
                            ],
                            fontSize: 22,
                          ),
                        )
                      : AppLineIconWidget(
                          .lock,
                          size: 18,
                          color: colors.mutedDark,
                        ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      Text(
                        badge.name,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: NinjaText.headline.copyWith(color: colors.ink),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        badge.description,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: NinjaText.subtext.copyWith(
                          color: colors.mutedDark,
                        ),
                      ),
                      const Spacer(),
                      ProfileProgressBar(
                        value: badge.progress.clamp(0.0, 1.0),
                        label: earned ? badge.category : '$percent%',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
