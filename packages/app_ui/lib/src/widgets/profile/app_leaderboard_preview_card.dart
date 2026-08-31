import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppLeaderboardPreviewCard extends StatelessWidget {
  const AppLeaderboardPreviewCard({required this.entries, super.key});

  final List<AppLeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          for (var index = 0; index < entries.length; index++)
            _buildLeaderboardPreviewRow(
              context,
              entry: entries[index],
              isFirst: index == 0,
            ),
        ],
      ),
    );
  }
}

Widget _buildLeaderboardPreviewRow(
  BuildContext context, {
  required AppLeaderboardEntry entry,
  required bool isFirst,
}) {
  final colors = context.colors;
  final isCurrentUser = entry.isCurrentUser;
  return Container(
    decoration: BoxDecoration(
      color: isCurrentUser ? colors.primary.withValues(alpha: 0.08) : null,
      border: isFirst
          ? null
          : Border(top: BorderSide(color: colors.divider, width: 0.5)),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    child: Row(
      children: [
        SizedBox(
          width: 28,
          child: Text(
            '#${entry.position}',
            style: AppText.caption.copyWith(
              color: isCurrentUser ? colors.primary : colors.deactiveDarker,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
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
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: formatThousands(entry.xp),
                style: AppText.bodyStrong.copyWith(
                  color: colors.active,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              TextSpan(
                text: ' XP',
                style: AppText.captionSmall.copyWith(
                  color: colors.deactiveDarker,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
