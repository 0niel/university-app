import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppRankLadder extends StatelessWidget {
  const AppRankLadder({required this.currentXp, super.key});

  final int currentXp;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentRank = NinjaRank.fromXp(currentXp);
    const ranks = NinjaRank.values;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Лестница рангов',
            style: AppText.caption.copyWith(
              color: colors.deactive,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
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
