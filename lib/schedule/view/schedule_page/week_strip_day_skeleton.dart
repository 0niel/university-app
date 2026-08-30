part of 'schedule_week_strip_skeleton.dart';

class _WeekStripDaySkeleton extends StatelessWidget {
  const _WeekStripDaySkeleton({
    required this.label,
    required this.day,
    required this.today,
    required this.colors,
  });

  final String label;
  final DateTime day;
  final bool today;
  final NinjaColors colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: today ? colors.brand : Colors.transparent,
        borderRadius: .circular(NinjaRadius.control),
      ),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: .ellipsis,
            style: NinjaText.microLabel.copyWith(
              color: today ? colors.onBrand : colors.mutedDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${day.day}',
            maxLines: 1,
            style: NinjaText.tabular(
              NinjaText.headline.copyWith(
                color: today ? colors.onBrand : colors.ink,
              ),
            ),
          ),
          const SizedBox(height: 3),
          const SizedBox(width: 4, height: 4),
        ],
      ),
    );
  }
}
