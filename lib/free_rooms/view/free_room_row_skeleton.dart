part of 'free_rooms_view.dart';

class _FreeRoomRowSkeleton extends StatelessWidget {
  const _FreeRoomRowSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      padding: const .all(16),
      child: const Row(
        children: [
          NinjaSkeleton(
            width: NinjaMetrics.minTouchTarget,
            height: NinjaMetrics.minTouchTarget,
            radius: NinjaRadius.control,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                NinjaSkeleton.bar(widthFactor: 0.42, height: 16),
                SizedBox(height: 8),
                NinjaSkeleton.bar(height: 11, widthFactor: 0.3),
              ],
            ),
          ),
          SizedBox(width: 12),
          NinjaSkeleton(width: 76, height: 26, radius: NinjaRadius.pill),
        ],
      ),
    );
  }
}
