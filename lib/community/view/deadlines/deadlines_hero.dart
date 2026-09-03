import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class DeadlinesHero extends StatelessWidget {
  const DeadlinesHero({required this.done, required this.total, super.key});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final ratio = total == 0 ? 0.0 : done / total;
    final percent = (ratio * 100).round();
    return AppCard(
      key: const ValueKey('deadlines-hero'),
      tinted: true,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
        vertical: 18,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.deadlinesClosedSemester,
                  style: AppText.captionSmall.copyWith(color: colors.muted),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text.rich(
                  TextSpan(
                    text: '$done ',
                    children: [
                      TextSpan(
                        text: l10n.deadlinesOfTotal(total),
                        style: AppText.serif(16).copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                  style: AppText.serif(28, height: 1.1).copyWith(
                    color: colors.ink,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppProgressBar(
                  value: ratio,
                  height: 8,
                  color: colors.accent,
                  trackColor: colors.surface,
                ),
                const SizedBox(height: 6),
                Text(
                  '$percent%',
                  textAlign: TextAlign.right,
                  style: AppText.captionSmall.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
