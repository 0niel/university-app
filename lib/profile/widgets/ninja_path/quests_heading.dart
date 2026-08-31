part of 'quests_tab.dart';

class _QuestsHeading extends StatelessWidget {
  const _QuestsHeading({required this.title, required this.quests});

  final String title;
  final List<GamificationQuest> quests;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final xpLeft = quests
        .where((quest) => !quest.isCompleted)
        .fold(0, (sum, quest) => sum + quest.xpReward);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: .ellipsis,
            style: NinjaText.title.copyWith(color: colors.ink),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '+$xpLeft XP',
          style: NinjaText.tabular(
            NinjaText.microLabel.copyWith(color: colors.brandInk),
          ),
        ),
      ],
    );
  }
}
