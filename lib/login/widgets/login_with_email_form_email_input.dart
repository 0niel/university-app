part of 'login_with_email_form.dart';

class _LoginWithEmailFormEmailInput extends StatefulWidget {
  const _LoginWithEmailFormEmailInput();

  @override
  State<_LoginWithEmailFormEmailInput> createState() =>
      _LoginWithEmailFormEmailInputState();
}

class _LoginWithEmailFormEmailInputState
    extends State<_LoginWithEmailFormEmailInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;
    final universityConfig = context.read<UniversityConfig>();
    return NinjaInput(
      key: const Key('loginWithEmailForm_emailInput_textField'),
      controller: _controller,
      label: context.l10n.authYourEmail,
      placeholder: universityConfig.emailDomainHint,
      leadingIcon: const AppLineIconWidget(AppLineIcon.at),
      keyboardType: .emailAddress,
      textInputAction: .done,
      autofillHints: const [AutofillHints.email],
      onChanged: (email) =>
          context.read<LoginBloc>().add(LoginEmailChanged(email)),
      errorText: !state.email.isPure && !state.email.isValid
          ? context.l10n.authInvalidEmail
          : null,
    );
  }
}
