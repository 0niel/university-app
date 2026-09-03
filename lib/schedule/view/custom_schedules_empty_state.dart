part of 'custom_schedules_page.dart';

class _CustomSchedulesEmptyState extends StatelessWidget {
  const _CustomSchedulesEmptyState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Padding(
      padding: const .only(top: 24),
      child: AppEmptyState(
        title: l10n.customSchedulesEmptyTitle,
        subtitle: l10n.customSchedulesEmptyDesc,
        icon: AppLineIconWidget(
          AppLineIcon.calendar,
          size: 20,
          color: colors.muted,
        ),
        actionLabel: l10n.customSchedulesCreate,
        onAction: onCreate,
      ).animateEmptyState(),
    );
  }
}
