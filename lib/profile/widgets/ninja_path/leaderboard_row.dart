part of 'leaderboard_tab.dart';

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry, required this.position});

  final LeaderboardEntry entry;
  final int position;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final me = entry.isCurrentUser;
    return Semantics(
      container: true,
      label: '#$position, ${entry.displayName}',
      child: Container(
        margin: const .symmetric(horizontal: 6, vertical: 2),
        padding: const .symmetric(horizontal: 10, vertical: 10),
        constraints: const BoxConstraints(
          minHeight: NinjaMetrics.minTouchTarget,
        ),
        decoration: BoxDecoration(
          color: me ? colors.brandTint : const Color(0x00000000),
          borderRadius: .circular(NinjaRadius.control),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '$position',
                maxLines: 1,
                overflow: .ellipsis,
                style: NinjaText.tabular(
                  NinjaText.microLabel.copyWith(
                    color: me ? colors.brandInk : colors.mutedDark,
                  ),
                ),
              ),
            ),
            NinjaAvatar(initials: ninjaInitials(entry.displayName), size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                entry.displayName,
                maxLines: 2,
                overflow: .ellipsis,
                style: NinjaText.body.copyWith(
                  color: colors.ink,
                  fontWeight: me ? .w700 : .w500,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${entry.xp}',
              maxLines: 1,
              overflow: .ellipsis,
              style: NinjaText.tabular(
                NinjaText.microLabel.copyWith(
                  color: me ? colors.brandInk : colors.mutedDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
