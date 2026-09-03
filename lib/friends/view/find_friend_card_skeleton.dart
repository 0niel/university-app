part of 'ninja_find_friends_results_skeleton.dart';

class _FindFriendCardSkeleton extends StatelessWidget {
  const _FindFriendCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        10,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        child: const Padding(
          padding: .all(16),
          child: Row(
            children: [
              NinjaSkeleton.avatar(),
              SizedBox(width: AppSpacing.sectionGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 6,
                  children: [
                    NinjaSkeleton.bar(height: 13, widthFactor: 0.62),
                    NinjaSkeleton.bar(height: 10, widthFactor: 0.44),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.gap),
              NinjaSkeleton(width: 88, height: 44, radius: AppRadius.full),
            ],
          ),
        ),
      ),
    );
  }
}
