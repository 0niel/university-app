part of '../events_view.dart';

class _LoadFailure extends StatelessWidget {
  const _LoadFailure({required this.onRetry, super.key});

  final Future<bool> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        48,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: NinjaErrorState(
        title: l10n.eventsLoadError,
        message: l10n.eventsLoadErrorSub,
        retryLabel: l10n.retry,
        onRetry: () => unawaited(onRetry()),
      ),
    );
  }
}
