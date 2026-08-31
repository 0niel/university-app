part of 'mini_apps_moderation_page.dart';

class _ModerationSkeleton extends StatelessWidget {
  const _ModerationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: ListView(
        padding: const .only(bottom: 60),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Padding(
            padding: .fromLTRB(
              NinjaMetrics.screenPadding,
              28,
              NinjaMetrics.screenPadding,
              10,
            ),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 6,
              children: [
                NinjaSkeleton(width: 160, height: 19, radius: 9),
                NinjaSkeleton(width: 220, height: 12, radius: 6),
              ],
            ),
          ),
          for (var i = 0; i < 4; i++) const _PendingCardSkeleton(),
        ],
      ),
    );
  }
}
