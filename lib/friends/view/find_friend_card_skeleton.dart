part of 'ninja_find_friends_results_skeleton.dart';

class _FindFriendCardSkeleton extends StatelessWidget {
  const _FindFriendCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.ninja.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: const Padding(
          padding: .all(16),
          child: Row(
            children: [
              NinjaSkeleton.avatar(),
              SizedBox(width: 14),
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
              SizedBox(width: 10),
              NinjaSkeleton(width: 88, height: 44, radius: NinjaRadius.pill),
            ],
          ),
        ),
      ),
    );
  }
}
