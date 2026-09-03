import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/profile_progress_bar.dart';

part 'hero_stat.dart';

class NinjaPathHero extends StatelessWidget {
  const NinjaPathHero({
    required this.xp,
    required this.badgeCount,
    required this.streakDays,
    required this.shurikens,
    super.key,
  });

  final int xp;
  final int badgeCount;
  final int streakDays;
  final int shurikens;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final rank = NinjaRank.fromXp(xp);
    final progress = (xpIntoLevel(xp) / kXpPerLevel).clamp(0.0, 1.0);
    final stacked = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final stats = [
      ('$badgeCount', l10n.ninjaRankBadges),
      ('$streakDays', l10n.ninjaRankStreak),
      ('$shurikens', l10n.ninjaRankShurikens),
    ];

    return Semantics(
      container: true,
      label: '${l10n.ninjaRankRow(levelFromXp(xp))}, ${rank.name}',
      child: Container(
        padding: const .all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.tint2,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Text(
              l10n.ninjaRankRow(levelFromXp(xp)),
              maxLines: 2,
              overflow: .ellipsis,
              style: AppText.captionSmall.copyWith(
                color: colors.muted,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              rank.name,
              maxLines: 1,
              overflow: .ellipsis,
              style: AppText.displaySmall.copyWith(color: colors.ink),
            ),
            const SizedBox(height: AppSpacing.lg),
            ProfileProgressBar(
              value: progress,
              label: '${(progress * 100).round()}%',
              pastel: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (stacked)
              Column(
                crossAxisAlignment: .stretch,
                children: [
                  for (final (index, stat) in stats.indexed) ...[
                    if (index > 0) const SizedBox(height: AppSpacing.sm),
                    _HeroStat(value: stat.$1, label: stat.$2),
                  ],
                ],
              )
            else
              Row(
                crossAxisAlignment: .start,
                children: [
                  for (final (index, stat) in stats.indexed) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.gap),
                    Expanded(
                      child: _HeroStat(value: stat.$1, label: stat.$2),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}
