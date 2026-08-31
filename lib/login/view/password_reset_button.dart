part of 'password_reset_page.dart';

class _PasswordResetButton extends StatelessWidget {
  const _PasswordResetButton();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PasswordResetBloc>().state;
    return NinjaButton.primary(
      key: const Key('passwordResetPage_submitButton'),
      label: context.l10n.authPasswordResetButton,
      size: NinjaButtonSize.large,
      expanded: true,
      loading: state.status.isInProgress,
      onPressed: state.isValid
          ? () => context.read<PasswordResetBloc>().add(
              PasswordResetRequested(),
            )
          : null,
    );
  }
}
