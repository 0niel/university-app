part of '../deadlines_body.dart';

class _LoadFailure extends StatelessWidget {
  const _LoadFailure({required this.onRetry});

  final Future<bool> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.ninja.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: NinjaErrorState(
          title: context.l10n.deadlinesLoadError,
          message: context.l10n.deadlinesLoadErrorSubtitle,
          retryLabel: context.l10n.retry,
          onRetry: () => unawaited(onRetry()),
        ),
      ),
    );
  }
}
