part of 'discover_groups_page.dart';

class _NinjaDiscoverGroupsSkeleton extends StatelessWidget {
  const _NinjaDiscoverGroupsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      child: ListView.builder(
        padding: const .only(bottom: 32),
        itemCount: 6,
        itemBuilder: (context, index) => const Padding(
          padding: .fromLTRB(
            NinjaMetrics.screenPadding,
            0,
            NinjaMetrics.screenPadding,
            10,
          ),
          child: NinjaSkeleton(height: 78, radius: NinjaRadius.card),
        ),
      ),
    );
  }
}
