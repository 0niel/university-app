part of 'leaderboard_tab.dart';

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry, required this.position});

  final LeaderboardEntry entry;
  final int position;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final me = entry.isCurrentUser;
    return Semantics(
      container: true,
      label: '#$position, ${entry.displayName}',
      child: Container(
        margin: const .symmetric(
          horizontal: AppSpacing.xsm,
          vertical: AppSpacing.xxs,
        ),
        padding: const .symmetric(
          horizontal: AppSpacing.gap,
          vertical: AppSpacing.gap,
        ),
        constraints: const BoxConstraints(
          minHeight: AppControlSize.iconButton,
        ),
        decoration: BoxDecoration(
          color: me ? colors.tint : const Color.fromARGB(0, 0, 0, 0),
          borderRadius: .circular(AppRadius.field),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '$position',
                maxLines: 1,
                overflow: .ellipsis,
                style: AppText.captionSmall
                    .copyWith(
                      color: me ? colors.accent : colors.muted,
                    )
                    .copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
              ),
            ),
            AppAvatar(name: entry.displayName, size: 40),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                entry.displayName,
                maxLines: 2,
                overflow: .ellipsis,
                style: AppText.body.copyWith(
                  color: colors.ink,
                  fontWeight: me ? .w700 : .w500,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.gap),
            Text(
              '${entry.xp}',
              maxLines: 1,
              overflow: .ellipsis,
              style: AppText.captionSmall
                  .copyWith(
                    color: me ? colors.accent : colors.muted,
                  )
                  .copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
            ),
          ],
        ),
      ),
    );
  }
}
