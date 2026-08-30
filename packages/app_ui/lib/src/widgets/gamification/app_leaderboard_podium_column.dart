import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/widgets/gamification/xp_text_formatter.dart';
import 'package:flutter/material.dart';

class AppLeaderboardPodiumColumn extends StatelessWidget {
  const AppLeaderboardPodiumColumn({
    required this.entry,
    required this.height,
    required this.medal,
    required this.avatarSize,
    super.key,
  });

  final AppLeaderboardEntry entry;
  final double height;
  final String medal;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        CircleAvatar(
          radius: avatarSize / 2,
          backgroundColor: colors.primary.withValues(alpha: 0.2),
          child: Text(
            entry.initials,
            style: AppText.heading.copyWith(
              color: colors.primary,
              fontSize: avatarSize * 0.35,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          entry.displayName,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.caption.copyWith(
            color: colors.active,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          formatXp(entry.xp),
          style: AppText.captionSmall.copyWith(
            color: colors.deactiveDarker,
            fontWeight: FontWeight.w600,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),
        Container(
          width: double.infinity,
          height: height,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: medal == '🥇' ? colors.primary : colors.surfaceHigh,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Text(medal, style: const TextStyle(fontSize: 24)),
        ),
      ],
    );
  }
}
