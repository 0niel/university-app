import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_ninja_mark.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:app_ui/src/widgets/gamification/app_ninja_rank_stat.dart';
import 'package:app_ui/src/widgets/gamification/ninja_rank.dart';
import 'package:app_ui/src/widgets/profile/profile_xp.dart';
import 'package:flutter/widgets.dart';

class AppNinjaRankHero extends StatelessWidget {
  const AppNinjaRankHero({
    required this.xp,
    required this.level,
    required this.badgeCount,
    required this.streakDays,
    required this.shurikens,
    required this.rankLabel,
    required this.badgesLabel,
    required this.streakLabel,
    required this.shurikensLabel,
    super.key,
    this.onShare,
    this.shareLabel = 'Поделиться',
  });

  final int xp;
  final int level;
  final int badgeCount;
  final int streakDays;
  final int shurikens;
  final String rankLabel;
  final String badgesLabel;
  final String streakLabel;
  final String shurikensLabel;
  final VoidCallback? onShare;
  final String shareLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rank = NinjaRank.fromXp(xp);
    final nextRank = rank.next;
    final into = xpIntoLevel(xp);
    final progress = (into / kXpPerLevel).clamp(0.0, 1.0);
    final onAccent = colors.onAccent;
    final share = onShare;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.accent,
        borderRadius: BorderRadius.circular(AppRadius.hero),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: IgnorePointer(
              child: Opacity(
                opacity: .15,
                child: AppNinjaMark(
                  size: 140,
                  color: onAccent,
                  spin: true,
                  cutout: false,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      rankLabel,
                      style: AppText.overline.copyWith(
                        color: onAccent.withValues(alpha: .8),
                      ),
                    ),
                  ),
                  if (share != null)
                    AppPressable(
                      onTap: share,
                      semanticsLabel: shareLabel,
                      semanticsButton: true,
                      child: Container(
                        width: AppControlSize.iconButton,
                        height: AppControlSize.iconButton,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: onAccent.withValues(alpha: .16),
                          shape: BoxShape.circle,
                        ),
                        child: AppLineIconWidget(
                          AppLineIcon.share,
                          size: AppIconSize.md,
                          color: onAccent,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Text(
                    rank.emoji,
                    style: const TextStyle(fontSize: 30, height: 1),
                  ),
                  const SizedBox(width: AppSpacing.gap),
                  Flexible(
                    child: Text(
                      rank.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.display.copyWith(color: onAccent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.fieldGap),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$into XP',
                    style: AppText.tabular(AppText.captionStrong).copyWith(
                      color: onAccent.withValues(alpha: .8),
                    ),
                  ),
                  if (nextRank != null)
                    Text(
                      '${nextRank.name} · $kXpPerLevel',
                      style: AppText.tabular(AppText.captionStrong).copyWith(
                        color: onAccent.withValues(alpha: .8),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.bar),
                child: SizedBox(
                  height: 6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(color: onAccent.withValues(alpha: .25)),
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: ColoredBox(color: onAccent),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  AppNinjaRankStat(
                    value: '$badgeCount',
                    label: badgesLabel,
                    color: onAccent,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  AppNinjaRankStat(
                    value: '$streakDays',
                    label: streakLabel,
                    color: onAccent,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  AppNinjaRankStat(
                    value: formatThousands(shurikens),
                    label: shurikensLabel,
                    color: onAccent,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
