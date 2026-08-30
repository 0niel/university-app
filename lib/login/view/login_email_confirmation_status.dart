part of 'login_email_confirmation_page.dart';

class _LoginEmailConfirmationStatus extends StatelessWidget {
  const _LoginEmailConfirmationStatus({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return BlocBuilder<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return NinjaStateSwitcher(
          child: switch (state.status) {
            .loading => Row(
              key: const ValueKey('loginEmailConfirmation_checking'),
              children: [
                const NinjaSpinner(size: 18),
                const SizedBox(width: 10),
                Text(
                  l10n.authCheckingCode,
                  style: NinjaText.subtext.copyWith(color: colors.mutedDark),
                ),
              ],
            ),
            .failure => NinjaErrorCard(
              key: const ValueKey('loginEmailConfirmation_failure'),
              title: l10n.authInvalidCode,
              message: l10n.tryAgain,
              actionLabel: l10n.retry,
              onAction: onRetry,
            ),
            .initial || .success => const SizedBox.shrink(
              key: ValueKey('loginEmailConfirmation_idle'),
            ),
          },
        );
      },
    );
  }
}
