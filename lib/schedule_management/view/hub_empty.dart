part of 'schedule_management_page.dart';

class _HubEmpty extends StatelessWidget {
  const _HubEmpty({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        24,
        AppSpacing.screen,
        24,
      ),
      children: [
        NinjaEmptyState(
          icon: AppLineIconWidget(
            AppLineIcon.calendar,
            color: context.colors.muted,
          ),
          title: l10n.scheduleHubEmptyTitle,
          message: l10n.scheduleHubEmptySubtitle,
          actionLabel: l10n.add,
          onAction: onAdd,
        ).animateEmptyState(),
      ],
    );
  }
}
