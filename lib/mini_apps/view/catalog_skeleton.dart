part of 'mini_apps_page.dart';

class _CatalogSkeleton extends StatelessWidget {
  const _CatalogSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: Padding(
        padding: EdgeInsets.only(bottom: _CatalogLayout.bottomInset(context)),
        child: Column(
          children: [
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
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, _) => const NinjaSkeleton(
                  width: 260,
                  height: 80,
                  radius: AppRadius.field,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.gap),
            const _CatalogSectionLabelSkeleton(width: 96),
            for (var i = 0; i < 6; i++)
              const Padding(
                padding: .fromLTRB(
                  AppSpacing.screen,
                  0,
                  AppSpacing.screen,
                  10,
                ),
                child: MiniAppCardSkeleton(),
              ),
          ],
        ),
      ),
    );
  }
}
