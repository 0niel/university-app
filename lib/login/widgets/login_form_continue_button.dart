part of 'login_form.dart';

class _LoginFormContinueButton extends StatelessWidget {
  const _LoginFormContinueButton();

  @override
  Widget build(BuildContext context) {
    return NinjaButton.primary(
      key: const Key('loginForm_emailLogin_appButton'),
      onPressed: () => const LoginWithEmailRoute().go(context),
      label: context.l10n.authContinueWithEmail,
      size: NinjaButtonSize.large,
      expanded: true,
    );
  }
}
