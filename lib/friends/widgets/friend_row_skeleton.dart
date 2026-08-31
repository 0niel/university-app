part of 'ninja_friends_panel.dart';

class _FriendRowSkeleton extends StatelessWidget {
  const _FriendRowSkeleton();

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
                    NinjaSkeleton.bar(height: 13, widthFactor: 0.56),
                    NinjaSkeleton.bar(height: 10, widthFactor: 0.4),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: .end,
                spacing: 5,
                children: [
                  NinjaSkeleton(
                    width: 54,
                    height: 24,
                    radius: NinjaRadius.pill,
                  ),
                  NinjaSkeleton(width: 34, height: 11, radius: 5),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
