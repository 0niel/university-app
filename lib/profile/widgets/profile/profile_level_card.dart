part of 'profile_widgets.dart';

class ProfileLevelCard extends StatelessWidget {
  const ProfileLevelCard({
    required this.xp,
    required this.streakDays,
    this.groupRank,
    this.onTap,
    super.key,
  });

  final int xp;
  final int streakDays;
  final int? groupRank;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final level = levelFromXp(xp);
    final progress = (xpIntoLevel(xp) / kXpPerLevel).clamp(0.0, 1.0);
    final left = kXpPerLevel - xpIntoLevel(xp);
    final groupRank = this.groupRank;
    final title = l10n.profileRankXp(rankLabel(l10n, xp), profileNumber(xp));
    final place = groupRank == null
        ? l10n.profileGroupPlaceUnknown
        : l10n.profileGroupPlace(groupRank);
    final footer = l10n.profileXpToLevelStreak(
      profileNumber(left),
      level + 1,
      streakDays,
    );
    return AppCard(
      tinted: true,
      radius: AppRadius.lg,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sectionGap,
        AppSpacing.md,
        AppSpacing.sectionGap,
        AppSpacing.md,
      ),
      onTap: onTap,
      semanticsLabel: '$title, $place, $footer',
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.accent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$level',
              style: AppText.sans(
                15,
                FontWeight.w800,
              ).copyWith(color: colors.onAccent),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      title,
                      style: AppText.compactStrong.copyWith(
                        color: colors.ink,
                        height: 17 / 13.5,
                      ),
                    ),
                    Text(
                      place,
                      style: AppText.compact.copyWith(
                        color: colors.muted,
                        height: 17 / 13.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                NinjaProgressBar(
                  value: progress,
                  height: 4,
                  color: colors.accent,
                  trackColor: colors.surface,
                ),
                const SizedBox(height: 5),
                Text(
                  footer,
                  style: AppText.sans(
                    11.5,
                    FontWeight.w400,
                    height: 15 / 11.5,
                  ).copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
