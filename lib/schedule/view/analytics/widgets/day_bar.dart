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
    final colors = context.ninja;

    return Column(
      mainAxisAlignment: .end,
      children: [
        if (hours > 0)
          Text(
            hours.toStringAsFixed(hours.truncateToDouble() == hours ? 0 : 1),
            style: NinjaText.tabular(
              NinjaText.helper.copyWith(color: colors.muted),
            ),
          ),
        const SizedBox(height: 6),
        FractionallySizedBox(
          widthFactor: 1,
          child: AnimatedContainer(
            duration: NinjaMotion.of(context, NinjaMotion.slow),
            curve: NinjaMotion.enter,
            height: hours <= 0 ? 0 : (hours / maxHours * 88).clamp(6, 88),
            decoration: BoxDecoration(
              color: hours > 0 ? colors.brand : Colors.transparent,
              borderRadius: .circular(NinjaRadius.pill),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: NinjaText.helper.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}
