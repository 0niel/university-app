import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/widgets/gamification/app_ninja_rank_stat.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rank = NinjaRank.fromXp(xp);
    final nextRank = rank.next;
    final into = xpIntoLevel(xp);
    final progress = (into / kXpPerLevel).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.15,
                child: AppNinjaMark(
                  size: 140,
                  color: colors.onAccent,
                  spin: true,
                  cutout: false,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rankLabel,
                style: AppText.overline.copyWith(
                  color: colors.onAccent.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(rank.emoji, style: const TextStyle(fontSize: 30)),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      rank.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.display.copyWith(
                        color: colors.onAccent,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$into XP',
                    style: AppText.caption.copyWith(
                      color: colors.onAccent.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (nextRank != null)
                    Text(
                      '→ ${nextRank.name} · $kXpPerLevel',
                      style: AppText.caption.copyWith(
                        color: colors.onAccent.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 8,
                  child: Stack(
                    children: [
                      Container(
                        color: colors.onAccent.withValues(alpha: 0.25),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(color: colors.onAccent),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  AppNinjaRankStat(
                    value: '$badgeCount',
                    label: badgesLabel,
                    color: colors.onAccent,
                  ),
                  const SizedBox(width: 16),
                  AppNinjaRankStat(
                    value: '🔥 $streakDays',
                    label: streakLabel,
                    color: colors.onAccent,
                  ),
                  const SizedBox(width: 16),
                  AppNinjaRankStat(
                    value: _formatNumber(shurikens),
                    label: shurikensLabel,
                    color: colors.onAccent,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatNumber(int n) {
    if (n >= 1000) {
      final s = n.toString();
      final split = s.length - 3;
      return '${s.substring(0, split)} ${s.substring(split)}';
    }
    return n.toString();
  }
}
