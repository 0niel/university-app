part of 'profile_page.dart';

class _ProfileAchievementsEmpty extends StatelessWidget {
  const _ProfileAchievementsEmpty({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
      child: NinjaEmptyState(
        icon: AppLineIconWidget(
          AppLineIcon.trophy,
          color: context.ninja.muted,
        ),
        title: l10n.ninjaPathNoData,
        actionLabel: l10n.ninjaPathTitle,
        onAction: onTap,
      ).animateEmptyState(),
    );
  }
}
