part of 'quests_tab.dart';

class _NinjaQuestCard extends StatelessWidget {
  const _NinjaQuestCard({required this.quest});

  final GamificationQuest quest;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final done = quest.isCompleted;
    final fraction = quest.target > 0
        ? (quest.progress / quest.target).clamp(0.0, 1.0)
        : 0.0;
    return Padding(
      padding: const .only(bottom: 8),
      child: Container(
        padding: const .all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Row(
              crossAxisAlignment: .start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: done ? colors.brandTint : colors.surfaceAlt,
                    borderRadius: .circular(11),
                  ),
                  child: done
                      ? NinjaCheckMark(size: 14, color: colors.brandInk)
                      : Text(
                          quest.emoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    quest.title,
                    maxLines: 3,
                    overflow: .ellipsis,
                    style: NinjaText.headline.copyWith(color: colors.ink),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '+${quest.xpReward} XP',
                  style: NinjaText.tabular(
                    NinjaText.microLabel.copyWith(
                      color: done ? colors.brandInk : colors.mutedDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ProfileProgressBar(
              value: fraction,
              label: '${quest.progress} / ${quest.target}',
            ),
          ],
        ),
      ),
    );
  }
}
