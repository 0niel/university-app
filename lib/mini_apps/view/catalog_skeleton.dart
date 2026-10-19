part of 'mini_apps_catalog.dart';

class _CatalogSkeleton extends StatelessWidget {
  const _CatalogSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: Column(
        children: [
          if (!_CatalogLayout.compactHeight(context)) ...[
            const _CatalogSectionLabelSkeleton(width: 132),
            SizedBox(
              height: _RecentMiniApps.height(context),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screen,
                ),
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.xs),
                itemBuilder: (context, _) => SizedBox(
                  width: _RecentMiniApps.width(context),
                  child: Column(
                    children: [
                      const NinjaSkeleton(
                        width: 52,
                        height: 52,
                        radius: AppRadius.field,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      NinjaSkeleton(
                        width: 60,
                        height: MediaQuery.textScalerOf(context).scale(12),
                        radius: AppRadius.skeletonThin,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      NinjaSkeleton(
                        width: 42,
                        height: MediaQuery.textScalerOf(context).scale(12),
                        radius: AppRadius.skeletonThin,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            const _CatalogSectionLabelSkeleton(width: 96),
          ] else
            const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < 6; i++)
            const Padding(
              padding: .fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                AppSpacing.sm,
              ),
              child: MiniAppCardSkeleton(),
            ),
        ],
      ),
    );
  }
}
