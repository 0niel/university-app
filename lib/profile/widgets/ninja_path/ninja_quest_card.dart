part of 'quests_tab.dart';

class _NinjaQuestCard extends StatelessWidget {
  const _NinjaQuestCard({required this.quest});

  final GamificationQuest quest;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final done = quest.isCompleted;
    final fraction = quest.target > 0
        ? (quest.progress / quest.target).clamp(0.0, 1.0)
        : 0.0;
    return Padding(
      padding: const .only(bottom: 8),
      child: Container(
        padding: const .all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(AppRadius.card),
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
                    color: done ? colors.tint : colors.surface2,
                    borderRadius: .circular(AppRadius.badge),
                  ),
                  child: done
                      ? AppCheckMark(size: 14, color: colors.accent)
                      : Text(
                          quest.emoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    quest.title,
                    maxLines: 3,
                    overflow: .ellipsis,
                    style: AppText.headline.copyWith(color: colors.ink),
                  ),
                ),
                const SizedBox(width: AppSpacing.gap),
                Text(
                  '+${quest.xpReward} XP',
                  style: AppText.captionSmall
                      .copyWith(
                        color: done ? colors.accent : colors.muted,
                      )
                      .copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
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
