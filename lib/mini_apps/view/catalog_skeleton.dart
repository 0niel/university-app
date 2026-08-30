part of 'mini_apps_page.dart';

class _CatalogSkeleton extends StatelessWidget {
  const _CatalogSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final tile = textScale >= 1.6 ? 58.0 : 52.0;
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: ListView(
        padding: const .only(bottom: 120),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const _CatalogSectionLabelSkeleton(width: 132),
          SizedBox(
            height: textScale >= 1.6 ? 138 : 102,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: NinjaMetrics.screenPadding,
              ),
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (_, _) => SizedBox(
                width: textScale >= 1.6 ? 108 : 76,
                child: Column(
                  children: [
                    NinjaSkeleton(
                      width: tile,
                      height: tile,
                      radius: NinjaRadius.control,
                    ),
                    const SizedBox(height: 8),
                    const NinjaSkeleton(width: 52, height: 10, radius: 5),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const _CatalogSectionLabelSkeleton(width: 96),
          for (var i = 0; i < 6; i++)
            const Padding(
              padding: .fromLTRB(
                NinjaMetrics.screenPadding,
                0,
                NinjaMetrics.screenPadding,
                10,
              ),
              child: MiniAppCardSkeleton(),
            ),
        ],
      ),
    );
  }
}
