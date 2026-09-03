part of 'discover_groups_page.dart';

class _DiscoverPlaceholder extends StatelessWidget {
  const _DiscoverPlaceholder({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const .fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        32,
      ),
      child: child.animateEmptyState(),
    );
  }
}
