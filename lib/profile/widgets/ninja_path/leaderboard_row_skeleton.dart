part of 'ninja_path_skeleton.dart';

class _LeaderboardRowSkeleton extends StatelessWidget {
  const _LeaderboardRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: .symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: NinjaSkeleton(
              width: 16,
              height: 12,
              radius: AppRadius.focusOutline,
            ),
          ),
          NinjaSkeleton.avatar(size: 32),
          SizedBox(width: AppSpacing.md),
          Expanded(child: NinjaSkeleton.bar(height: 13, widthFactor: 0.6)),
          SizedBox(width: AppSpacing.gap),
          NinjaSkeleton(width: 40, height: 12, radius: AppRadius.focusOutline),
        ],
      ),
    );
  }
}
