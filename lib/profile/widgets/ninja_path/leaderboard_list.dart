part of 'leaderboard_tab.dart';

class _LeaderboardList extends StatelessWidget {
  const _LeaderboardList({required this.entries, super.key});

  final List<LeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.ninja.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const .symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            for (final (index, entry) in entries.indexed)
              _LeaderboardRow(
                entry: entry,
                position: index + 1,
              ).animateListItem(index: index),
          ],
        ),
      ),
    );
  }
}
