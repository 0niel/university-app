part of 'login_page.dart';

class _LoginPageBottomLinks extends StatelessWidget {
  const _LoginPageBottomLinks();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: [
        NinjaButton.text(
          key: const Key('loginPage_signUpLink'),
          onPressed: () => const SignUpRoute().push<void>(context),
          label: context.l10n.createAccount,
          size: NinjaButtonSize.medium,
        ),
        NinjaButton.text(
          key: const Key('loginPage_emailCodeButton'),
          onPressed: () => const LoginWithEmailRoute().push<void>(context),
          label: context.l10n.loginWithCode,
          size: NinjaButtonSize.medium,
        ),
      ],
    );
  }
}
