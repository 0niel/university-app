part of 'mini_app_stats_page.dart';

class _StatsSkeleton extends StatelessWidget {
  const _StatsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: ListView(
        padding: const .fromLTRB(20, 20, 20, 24),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _TotalsStrip(
            children: [
              for (var index = 0; index < 3; index++)
                const Padding(
                  padding: .symmetric(horizontal: 16, vertical: 22),
                  child: Column(
                    spacing: 8,
                    children: [
                      NinjaSkeleton(width: 44, height: 20),
                      NinjaSkeleton(width: 36, height: 11),
                    ],
                  ),
                ),
            ],
          ),
          const Padding(
            padding: .fromLTRB(
              0,
              20,
              0,
              0,
            ),
            child: NinjaSkeletonMedia(height: 220, radius: NinjaRadius.card),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: .center,
            spacing: 16,
            children: [
              for (var index = 0; index < 2; index++)
                Row(
                  mainAxisSize: .min,
                  spacing: 6,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        shape: .circle,
                      ),
                    ),
                    const NinjaSkeleton(width: 52, height: 11),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
