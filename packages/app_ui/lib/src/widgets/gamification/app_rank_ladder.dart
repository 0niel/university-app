import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_card.dart';
import 'package:app_ui/src/widgets/gamification/app_rank_connector_line.dart';
import 'package:app_ui/src/widgets/gamification/app_rank_node.dart';
import 'package:app_ui/src/widgets/gamification/ninja_rank.dart';
import 'package:flutter/widgets.dart';

class AppRankLadder extends StatelessWidget {
  const AppRankLadder({
    required this.currentXp,
    super.key,
    this.title = 'Лестница рангов',
  });

  final int currentXp;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentRank = NinjaRank.fromXp(currentXp);
    const ranks = NinjaRank.values;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: AppText.sectionSmall.copyWith(color: colors.ink)),
          const SizedBox(height: AppSpacing.sectionGap),
          Row(
            children: [
              for (var index = 0; index < ranks.length; index++) ...[
                AppRankNode(
                  rank: ranks[index],
                  isActive: ranks[index] == currentRank,
                  isDone: ranks[index].xpThreshold < currentRank.xpThreshold,
                ),
                if (index < ranks.length - 1)
                  Expanded(
                    child: AppRankConnectorLine(
                      filled:
                          ranks[index].xpThreshold < currentRank.xpThreshold,
                    ),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
