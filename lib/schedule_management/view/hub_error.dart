part of 'schedule_management_page.dart';

class _HubError extends StatelessWidget {
  const _HubError({required this.onRetry});

  final void Function(BuildContext context) onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        24,
        NinjaMetrics.screenPadding,
        24,
      ),
      children: [
        NinjaErrorState(
          title: l10n.failedToLoadSchedules,
          message: l10n.checkInternetConnection,
          retryLabel: l10n.retry,
          onRetry: () => onRetry(context),
        ).animateEmptyState(),
      ],
    );
  }
}
