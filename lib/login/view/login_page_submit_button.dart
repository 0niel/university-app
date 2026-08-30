part of 'login_page.dart';

class _LoginPageSubmitButton extends StatelessWidget {
  const _LoginPageSubmitButton();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;
    return NinjaButton.primary(
      key: const Key('loginPage_submitButton'),
      label: context.l10n.loginSubmit,
      size: NinjaButtonSize.large,
      expanded: true,
      loading: state.status.isInProgress,
      onPressed: state.isValid
          ? () => context.read<LoginBloc>().add(LoginWithPasswordSubmitted())
          : null,
    );
  }
}
