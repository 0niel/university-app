part of 'mini_apps_moderation_page.dart';

class _ModerationSkeleton extends StatelessWidget {
  const _ModerationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: ListView(
        padding: EdgeInsets.only(
          bottom: ninjaBottomInset(context) + AppSpacing.lg,
        ),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Padding(
            padding: .fromLTRB(
              AppSpacing.screen,
              28,
              AppSpacing.screen,
              10,
            ),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 6,
              children: [
                NinjaSkeleton(
                  width: 160,
                  height: 19,
                  radius: AppRadius.skeleton,
                ),
                NinjaSkeleton(
                  width: 220,
                  height: 12,
                  radius: AppRadius.focusOutline,
                ),
              ],
            ),
          ),
          for (var i = 0; i < 4; i++) const _PendingCardSkeleton(),
        ],
      ),
    );
  }
}
