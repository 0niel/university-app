part of 'schedule_skeleton.dart';

class _ScheduleFilterRowSkeleton extends StatelessWidget {
  const _ScheduleFilterRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: .fromLTRB(
        NinjaMetrics.screenPadding,
        8,
        NinjaMetrics.screenPadding,
        6,
      ),
      child: Row(
        children: [
          Expanded(
            child: NinjaSkeleton(height: 14, widthFactor: .34, radius: 6),
          ),
          SizedBox(width: 10),
          NinjaSkeleton(
            width: 108,
            height: NinjaMetrics.minTouchTarget,
            radius: NinjaRadius.pill,
          ),
        ],
      ),
    );
  }
}
