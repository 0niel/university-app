part of 'study_group_page.dart';

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const .fromLTRB(
        AppSpacing.screen,
        24,
        AppSpacing.screen,
        32,
      ),
      child: child.animateEmptyState(),
    );
  }
}
