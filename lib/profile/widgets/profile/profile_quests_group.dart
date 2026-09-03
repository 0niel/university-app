part of 'profile_widgets.dart';

class ProfileQuestsGroup extends StatelessWidget {
  const ProfileQuestsGroup({required this.quests, super.key});

  final List<GamificationQuest> quests;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final daily = quests.isNotEmpty && quests.every((quest) => quest.isDaily);
    final bars = [colors.accent, colors.lecture, colors.lab];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionTitle(
          title: daily ? l10n.profileQuestsOfDay : l10n.profileWeekQuests,
          meta: daily ? null : l10n.profileUntilSunday,
          topMargin: 28,
          bottomPadding: 14,
        ),
        if (quests.isEmpty)
          AppEmptyState.compact(title: l10n.profileQuestsEmpty)
        else
          AppListGroup(
            children: [
              for (final (index, quest) in quests.indexed)
                _QuestRow(quest: quest, barColor: bars[index % bars.length]),
            ],
          ),
      ],
    );
  }
}

class _QuestRow extends StatelessWidget {
  const _QuestRow({required this.quest, required this.barColor});

  final GamificationQuest quest;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final target = quest.target <= 0 ? 1 : quest.target;
    final done = quest.isCompleted ? target : quest.progress.clamp(0, target);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sectionGap,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  quest.title,
                  style: AppText.cell.copyWith(
                    color: colors.ink,
                    height: 18 / 14.5,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l10n.profileQuestXp(quest.xpReward),
                style: AppText.sans(
                  12,
                  FontWeight.w800,
                ).copyWith(color: colors.accent),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: NinjaProgressBar(
                  value: done / target,
                  height: 5,
                  color: barColor,
                ),
              ),
              const SizedBox(width: AppSpacing.gap),
              Text(
                l10n.profileQuestProgress(done, target),
                style: AppText.sans(
                  12,
                  FontWeight.w600,
                  height: 16 / 12,
                  tabular: true,
                ).copyWith(color: colors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
