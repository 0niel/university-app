import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/widgets/gamification/xp_text_formatter.dart';
import 'package:flutter/material.dart';

class AppLeaderboardRow extends StatelessWidget {
  const AppLeaderboardRow({
    required this.entry,
    required this.isFirst,
    super.key,
  });

  final AppLeaderboardEntry entry;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCurrentUser = entry.isCurrentUser;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? colors.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        border: isFirst
            ? null
            : Border(top: BorderSide(color: colors.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 26,
            child: Text(
              '#${entry.position}',
              style: AppText.caption.copyWith(
                color: isCurrentUser ? colors.primary : colors.deactiveDarker,
                fontWeight: FontWeight.w700,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 16,
            backgroundColor: colors.primary.withValues(alpha: 0.18),
            child: Text(
              entry.initials,
              style: AppText.captionSmall.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              entry.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body.copyWith(
                color: isCurrentUser ? colors.primary : colors.active,
                fontWeight: isCurrentUser ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            formatXp(entry.xp),
            style: AppText.bodyStrong.copyWith(
              color: colors.active,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
