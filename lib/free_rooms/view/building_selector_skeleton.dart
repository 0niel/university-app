part of 'free_rooms_view.dart';

class _BuildingSelectorSkeleton extends StatelessWidget {
  const _BuildingSelectorSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: .only(bottom: 18),
      child: NinjaChipRow(
        children: [
          NinjaSkeleton(
            width: 112,
            height: NinjaMetrics.minTouchTarget,
            radius: NinjaRadius.pill,
          ),
          NinjaSkeleton(
            width: 88,
            height: NinjaMetrics.minTouchTarget,
            radius: NinjaRadius.pill,
          ),
          NinjaSkeleton(
            width: 74,
            height: NinjaMetrics.minTouchTarget,
            radius: NinjaRadius.pill,
          ),
        ],
      ),
    );
  }
}
