import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceHigh,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text.rich(
        TextSpan(
          style: AppText.caption.copyWith(color: colors.deactive),
          children: [
            const TextSpan(text: 'До топ-'),
            TextSpan(text: '$targetPosition'),
            const TextSpan(text: ' осталось '),
            TextSpan(
              text: '+$xpNeeded XP',
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const TextSpan(text: ' — это 2 дня стрика 🔥'),
          ],
        ),
      ),
    );
  }
}
