part of 'profile_page.dart';

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final largeText = scale >= 1.5;
    final grow = (scale - 1).clamp(0, 1);
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: colors.canvas,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            titleSpacing: NinjaMetrics.screenPadding,
            title: const NinjaSkeleton(width: 112, height: 22, radius: 7),
            actions: const [
              NinjaSkeleton.avatar(),
              SizedBox(width: 8),
              NinjaSkeleton.avatar(),
              SizedBox(width: NinjaMetrics.screenPadding),
            ],
          ),
          SliverToBoxAdapter(
            child: Align(
              alignment: .topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Padding(
                  padding: const .fromLTRB(
                    NinjaMetrics.screenPadding,
                    10,
                    NinjaMetrics.screenPadding,
                    32,
                  ),
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      if (largeText) ...[
                        const Center(child: NinjaSkeleton.avatar(size: 64)),
                        const SizedBox(height: 14),
                        const Center(
                          child: NinjaSkeleton(width: 220, height: 28),
                        ),
                        const SizedBox(height: 9),
                        const Center(
                          child: NinjaSkeleton(
                            width: 176,
                            height: 13,
                            radius: 7,
                          ),
                        ),
                      ] else
                        const Row(
                          children: [
                            NinjaSkeleton.avatar(size: 64),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                children: [
                                  NinjaSkeleton(
                                    height: 28,
                                    widthFactor: .78,
                                  ),
                                  SizedBox(height: 9),
                                  NinjaSkeleton(
                                    height: 13,
                                    widthFactor: .6,
                                    radius: 7,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 18),
                      NinjaSkeleton(
                        height: 160 + grow * 120,
                        radius: NinjaRadius.card,
                      ),
                      const SizedBox(height: 10),
                      NinjaSkeleton(
                        height: 76 + grow * 44,
                        radius: NinjaRadius.card,
                      ),
                      const SizedBox(height: 10),
                      NinjaSkeleton(
                        height: 76 + grow * 36,
                        radius: NinjaRadius.card,
                      ),
                      const SizedBox(height: 28),
                      const NinjaSkeleton.bar(height: 22, widthFactor: .32),
                      const SizedBox(height: 10),
                      NinjaSkeleton(
                        height: 140 + grow * 92,
                        radius: NinjaRadius.card,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
