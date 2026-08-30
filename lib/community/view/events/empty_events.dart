part of '../events_view.dart';

class _EmptyEvents extends StatelessWidget {
  const _EmptyEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        40,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: NinjaEmptyState.screen(
        icon: const AppLineIconWidget(AppLineIcon.calendar, size: 24),
        title: l10n.eventsEmptyTitle,
        message: l10n.eventsEmptySubtitle,
        actionLabel: l10n.eventsCreateCta,
        onAction: () => unawaited(_createEvent(context)),
      ).animateEmptyState(),
    );
  }
}
