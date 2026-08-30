part of 'add_schedule_page.dart';

class _EmptyScheduleResults extends StatelessWidget {
  const _EmptyScheduleResults({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            8,
            NinjaMetrics.screenPadding,
            18,
          ),
          child: NinjaEmptyState(
            icon: AppLineIconWidget(
              AppLineIcon.search,
              size: 20,
              color: context.ninja.muted,
            ),
            title: context.l10n.addScheduleNoResults,
          ).animateEmptyState(),
        ),
        _CreateScheduleRow(onTap: onCreate),
      ],
    );
  }
}
