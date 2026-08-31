part of '../schedule_page.dart';

class _ScheduleUnavailable extends StatelessWidget {
  const _ScheduleUnavailable({
    required this.failed,
    required this.onRetry,
    required this.onConfigure,
  });

  final bool failed;
  final VoidCallback onRetry;
  final VoidCallback onConfigure;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        NinjaMetrics.screenPadding,
      ),
      child: Center(
        child: failed
            ? NinjaErrorState(
                title: l10n.error,
                message: l10n.scheduleLoadError,
                retryLabel: l10n.retry,
                onRetry: onRetry,
              ).animateEmptyState()
            : NinjaEmptyState(
                title: l10n.noActiveGroupTitle,
                message: l10n.noActiveGroupSubtitle,
                actionLabel: l10n.servicesConfigure,
                onAction: onConfigure,
              ).animateEmptyState(),
      ),
    );
  }
}
