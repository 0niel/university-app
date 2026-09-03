import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_card.dart';
import 'package:flutter/widgets.dart';

class AppLeaderboardMotivation extends StatelessWidget {
  const AppLeaderboardMotivation({
    required this.xpNeeded,
    required this.targetPosition,
    super.key,
  });

  final int xpNeeded;
  final int targetPosition;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      color: colors.surface2,
      radius: AppRadius.banner,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sectionGap,
      ),
      child: Text.rich(
        TextSpan(
          style: AppText.subtext.copyWith(color: colors.muted, height: 1.4),
          children: [
            const TextSpan(text: 'До топ-'),
            TextSpan(text: '$targetPosition'),
            const TextSpan(text: ' осталось '),
            TextSpan(
              text: '+$xpNeeded XP',
              style: AppText.subtextBold.copyWith(color: colors.accent),
            ),
            const TextSpan(text: ' — это 2 дня стрика'),
          ],
        ),
      ),
    );
  }
}
