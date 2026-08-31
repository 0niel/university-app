part of 'login_with_email_form.dart';

class _LoginWithEmailFormNextButton extends StatelessWidget {
  const _LoginWithEmailFormNextButton();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;
    return NinjaButton.primary(
      key: const Key('loginWithEmailForm_nextButton'),
      label: context.l10n.authNext,
      size: NinjaButtonSize.large,
      expanded: true,
      loading: state.status.isInProgress,
      onPressed: state.isEmailValid
          ? () => context.read<LoginBloc>().add(EmailLinkRequested())
          : null,
    );
  }
}
