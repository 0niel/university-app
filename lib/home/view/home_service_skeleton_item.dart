part of 'home_services_skeleton.dart';

class _HomeServiceSkeletonItem extends StatelessWidget {
  const _HomeServiceSkeletonItem();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: .min,
      children: [
        NinjaSkeleton(width: 44, height: 44, radius: 13),
        SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: 64,
          child: NinjaSkeleton(height: 10, radius: 5),
        ),
      ],
    );
  }
}
