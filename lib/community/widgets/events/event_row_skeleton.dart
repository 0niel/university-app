part of '../events_skeleton.dart';

class _EventRowSkeleton extends StatelessWidget {
  const _EventRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _NinjaEventSkeletonCard(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NinjaSkeleton(width: 58, height: 58, radius: NinjaRadius.control),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NinjaSkeleton(height: 16, widthFactor: 0.7),
                  SizedBox(height: 6),
                  NinjaSkeleton.bar(height: 11, widthFactor: 0.5),
                  SizedBox(height: 8),
                  NinjaSkeleton.bar(height: 10, widthFactor: 0.35),
                ],
              ),
            ),
            SizedBox(width: 10),
            NinjaSkeleton(width: 78, height: 44, radius: NinjaRadius.pill),
          ],
        ),
      ),
    );
  }
}
