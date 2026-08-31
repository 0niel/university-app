part of '../session_page.dart';

class _SessionSkeleton extends StatelessWidget {
  const _SessionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const NinjaSkeletonGroup(
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          NinjaSkeleton(height: 184, radius: NinjaRadius.card),
          SizedBox(height: 10),
          NinjaSkeleton(height: 76, radius: NinjaRadius.card),
          SizedBox(height: 28),
          NinjaSkeleton(height: 18, widthFactor: 0.4),
          SizedBox(height: 10),
          NinjaSkeleton(height: 132, radius: NinjaRadius.card),
          SizedBox(height: 10),
          NinjaSkeleton(height: 132, radius: NinjaRadius.card),
          SizedBox(height: 10),
          NinjaSkeleton(height: 132, radius: NinjaRadius.card),
        ],
      ),
    );
  }
}
