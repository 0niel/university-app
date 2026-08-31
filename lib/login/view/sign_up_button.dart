part of 'sign_up_page.dart';

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SignUpBloc>().state;
    return NinjaButton.primary(
      key: const Key('signUpPage_submitButton'),
      label: context.l10n.authSignUpButton,
      size: NinjaButtonSize.large,
      expanded: true,
      loading: state.status.isInProgress,
      onPressed: state.isValid
          ? () => context.read<SignUpBloc>().add(SignUpSubmitted())
          : null,
    );
  }
}
