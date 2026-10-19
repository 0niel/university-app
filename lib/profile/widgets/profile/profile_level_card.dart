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
    return AppProgressCard(
      onTap: onTap,
      semanticsLabel: '$title, $place, $footer',
      title: Text(title),
      value: Text(l10n.profileLevel(level)),
      emblem: AppIconTile(
        icon: AppLineIcon.trophy,
        size: 25 + AppSpacing.actionInset * 2,
        radius: AppRadius.field,
        background: colors.tint,
        foreground: colors.accent,
        iconSize: 25,
      ),
      progress: NinjaProgressBar(
        value: progress,
        height: 7,
        color: colors.accent,
        trackColor: colors.accent.withValues(alpha: .1),
      ),
      supporting: Text(footer),
      metadata: Text(place),
    );
  }
}
