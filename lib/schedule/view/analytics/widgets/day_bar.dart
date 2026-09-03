part of '../analytics_page.dart';

class _DayBar extends StatelessWidget {
  const _DayBar({
    required this.label,
    required this.hours,
    required this.maxHours,
  });

  final String label;
  final double hours;
  final double maxHours;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisAlignment: .end,
      children: [
        if (hours > 0)
          Text(
            hours.toStringAsFixed(hours.truncateToDouble() == hours ? 0 : 1),
            style: AppText.tabular(
              AppText.captionSmall.copyWith(color: colors.muted),
            ),
          ),
        const SizedBox(height: AppSpacing.xsm),
        FractionallySizedBox(
          widthFactor: 1,
          child: AnimatedContainer(
            duration: NinjaMotion.of(context, NinjaMotion.slow),
            curve: NinjaMotion.enter,
            height: hours <= 0 ? 0 : (hours / maxHours * 88).clamp(6, 88),
            decoration: BoxDecoration(
              color: hours > 0 ? colors.accent : Colors.transparent,
              borderRadius: .circular(AppRadius.full),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xsm),
        Text(
          label,
          style: AppText.captionSmall.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}
