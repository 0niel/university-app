part of 'knowledge_bank_list_skeleton.dart';

class _MaterialCardSkeleton extends StatelessWidget {
  const _MaterialCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          NinjaSkeleton(width: 44, height: 44, radius: AppRadius.tile),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NinjaSkeleton.bar(widthFactor: .45, height: 11.5),
                SizedBox(height: 3),
                NinjaSkeleton.bar(widthFactor: .88, height: 14.5),
                SizedBox(height: 3),
                NinjaSkeleton.bar(widthFactor: .7),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          NinjaSkeleton(width: 16, height: 16),
        ],
      ),
    );
  }
}
