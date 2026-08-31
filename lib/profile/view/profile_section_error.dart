part of 'profile_page.dart';

class _ProfileSectionError extends StatelessWidget {
  const _ProfileSectionError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        10,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: NinjaErrorCard(
        title: l10n.loadingError,
        message: l10n.profileSectionLoadFailed,
        actionLabel: l10n.tryAgain,
        onAction: onRetry,
      ),
    );
  }
}
