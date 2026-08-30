part of '../events_skeleton.dart';

class _FeaturedEventSkeleton extends StatelessWidget {
  const _FeaturedEventSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _NinjaEventSkeletonCard(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                NinjaSkeleton(
                  width: 44,
                  height: 44,
                  radius: NinjaRadius.control,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: NinjaSkeleton.bar(height: 11, widthFactor: 0.3),
                ),
              ],
            ),
            SizedBox(height: 12),
            NinjaSkeleton(height: 18, widthFactor: 0.65),
            SizedBox(height: 8),
            NinjaSkeleton.bar(height: 11, widthFactor: 0.45),
            SizedBox(height: 14),
            Row(
              children: [
                NinjaSkeleton(
                  width: 120,
                  height: 48,
                  radius: NinjaRadius.pill,
                ),
                SizedBox(width: 12),
                NinjaSkeleton.avatar(size: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
