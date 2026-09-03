part of 'ninja_friends_panel.dart';

class _FriendRowSkeleton extends StatelessWidget {
  const _FriendRowSkeleton();

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
                    NinjaSkeleton.bar(height: 13, widthFactor: 0.56),
                    NinjaSkeleton.bar(height: 10, widthFactor: 0.4),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.gap),
              Column(
                crossAxisAlignment: .end,
                spacing: 5,
                children: [
                  NinjaSkeleton(
                    width: 54,
                    height: 24,
                    radius: AppRadius.full,
                  ),
                  NinjaSkeleton(
                    width: 34,
                    height: 11,
                    radius: AppRadius.skeletonThin,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
