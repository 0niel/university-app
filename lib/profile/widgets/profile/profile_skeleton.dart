part of 'profile_widgets.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final level = levelFromXp(0);
    return NinjaSkeletonGroup(
      semanticsLabel: l10n.loadingContent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.md),
            AppFeatureCard.identity(
              key: const ValueKey('profile-identity-skeleton'),
              leading: const NinjaSkeleton.avatar(size: 76),
              trailing: const NinjaSkeleton(
                width: 44,
                height: 44,
                radius: AppRadius.row,
              ),
              title: AppSkeletonText(
                sample: l10n.profileStudentFallback,
                widthFactor: .8,
              ),
              subtitle: const AppSkeletonText(widthFactor: .55),
            ),
            const SizedBox(height: AppSpacing.screen),
            AppProgressCard(
              key: const ValueKey('profile-level-skeleton'),
              title: AppSkeletonText(
                sample: l10n.profileRankXp(
                  rankLabel(l10n, 0),
                  profileNumber(0),
                ),
                widthFactor: .75,
              ),
              value: AppSkeletonText(sample: l10n.profileLevel(level)),
              emblem: const NinjaSkeleton(
                width: 51,
                height: 51,
                radius: AppRadius.field,
              ),
              progress: const NinjaSkeleton(height: 7, radius: AppRadius.full),
              supporting: AppSkeletonText(
                sample: l10n.profileXpToLevelStreak(
                  profileNumber(kXpPerLevel),
                  level + 1,
                  0,
                ),
              ),
              metadata: AppSkeletonText(
                sample: l10n.profileGroupPlaceUnknown,
                widthFactor: .6,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppGlassSurface(
              key: const ValueKey('profile-activity-skeleton'),
              tone: AppGlassTone.subtle,
              padding: const EdgeInsets.all(AppSpacing.screen),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DefaultTextStyle.merge(
                    style: AppText.title,
                    child: AppSkeletonText(
                      sample: l10n.profileStreakDays(0).trim(),
                      widthFactor: .45,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DefaultTextStyle.merge(
                    style: AppText.caption,
                    child: const AppSkeletonText(widthFactor: .65),
                  ),
                  const SizedBox(height: AppSpacing.fieldGap),
                  for (var row = 0; row < 7; row++) ...[
                    if (row != 0) const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        for (var column = 0; column < 12; column++) ...[
                          if (column != 0) const SizedBox(width: AppSpacing.xs),
                          const Expanded(
                            child: NinjaSkeleton(
                              height: 9,
                              radius: AppRadius.xxs,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xlg),
            DefaultTextStyle.merge(
              style: AppText.section,
              child: AppSkeletonText(
                sample: l10n.profileWeekQuests,
                widthFactor: .5,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const NinjaSkeleton(height: 140, radius: AppRadius.dialog),
          ],
        ),
      ),
    );
  }
}
