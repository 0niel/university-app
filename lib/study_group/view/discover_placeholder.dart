part of 'discover_groups_page.dart';

class _DiscoverPlaceholder extends StatelessWidget {
  const _DiscoverPlaceholder({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        32,
      ),
      child: child.animateEmptyState(),
    );
  }
}
