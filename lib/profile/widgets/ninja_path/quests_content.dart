part of 'quests_tab.dart';

class _QuestsContent extends StatelessWidget {
  const _QuestsContent({required this.daily, required this.weekly, super.key});

  final List<GamificationQuest> daily;
  final List<GamificationQuest> weekly;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        if (daily.isNotEmpty) ...[
          _QuestsHeading(title: l10n.ninjaPathToday, quests: daily),
          const SizedBox(height: 12),
          for (final quest in daily) _NinjaQuestCard(quest: quest),
          if (weekly.isNotEmpty) const SizedBox(height: 20),
        ],
        if (weekly.isNotEmpty) ...[
          _QuestsHeading(title: l10n.ninjaPathThisWeek, quests: weekly),
          const SizedBox(height: 12),
          for (final quest in weekly) _NinjaQuestCard(quest: quest),
        ],
      ],
    );
  }
}
