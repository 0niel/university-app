part of 'profile_widgets.dart';

class ProfileBadgesRail extends StatelessWidget {
  const ProfileBadgesRail({
    required this.badges,
    required this.totalBadges,
    this.onAll,
    this.onBadge,
    super.key,
  });

  final List<GamificationBadge> badges;
  final int totalBadges;
  final VoidCallback? onAll;
  final VoidCallback? onBadge;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: AppSectionTitle(
            title: l10n.profileAchievements,
            action: totalBadges > 0 ? l10n.profileAllBadges(totalBadges) : null,
            onActionTap: onAll,
            topMargin: 28,
            bottomPadding: 14,
          ),
        ),
        if (badges.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: AppEmptyState.compact(title: l10n.profileBadgesEmpty),
          )
        else
          SizedBox(
            height: badges
                .map((badge) => _heightOf(context, badge))
                .reduce((a, b) => a > b ? a : b),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              itemCount: badges.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) => _BadgeCard(
                badge: badges[index],
                index: index,
                onTap: onBadge,
              ),
            ),
          ),
      ],
    );
  }

  double _heightOf(BuildContext context, GamificationBadge badge) {
    double measure(String text, TextStyle style) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      )..layout(maxWidth: 84);
      final height = painter.height;
      painter.dispose();
      return height;
    }

    final sub = badge.isEarned
        ? badge.description
        : context.l10n.profileBadgeSoon((badge.progress * 100).round());
    return (79 +
            measure(
              badge.name,
              AppText.sans(13, FontWeight.w700, height: 1.2),
            ) +
            measure(sub, AppText.sans(11, FontWeight.w500)))
        .ceilToDouble();
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.badge, required this.index, this.onTap});

  final GamificationBadge badge;
  final int index;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final tones = [
      (colors.practiceTint, colors.practice),
      (colors.lectureTint, colors.lecture),
      (colors.labTint, colors.lab),
    ];
    final (bg, fg) = badge.isEarned
        ? tones[index % tones.length]
        : (colors.surface, colors.muted2);
    final sub = badge.isEarned
        ? badge.description
        : l10n.profileBadgeSoon((badge.progress * 100).round());
    final status = badge.isEarned
        ? l10n.profileBadgeEarned
        : l10n.profileBadgeLocked;
    return Opacity(
      opacity: badge.isEarned ? 1 : 0.6,
      child: AppCard(
        width: 112,
        radius: AppRadius.row,
        color: bg,
        padding: const EdgeInsets.all(AppSpacing.sectionGap),
        onTap: onTap,
        semanticsLabel: '${badge.name}, $status, $sub',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
              ),
              child: AppLineIconWidget(
                AppLineIcon.trophy,
                size: 18,
                color: fg,
                strokeWidth: 2.2,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              badge.name,
              style: AppText.sans(
                13,
                FontWeight.w700,
                height: 1.2,
              ).copyWith(color: colors.ink),
            ),
            const SizedBox(height: 3),
            Text(
              sub,
              style: AppText.sans(
                11,
                FontWeight.w500,
              ).copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
