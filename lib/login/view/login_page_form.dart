part of 'login_page.dart';

class _LoginPageForm extends StatelessWidget {
  const _LoginPageForm({
    required this.emailController,
    required this.passwordController,
    required this.onEmailChanged,
    required this.onPasswordChanged,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      children: [
        BlocBuilder<LoginBloc, LoginState>(
          buildWhen: (previous, current) => previous.email != current.email,
          builder: (context, state) {
            final showError = state.email.isNotValid && !state.email.isPure;
            return NinjaInput(
              key: const Key('loginPage_emailInput'),
              controller: emailController,
              leadingIcon: const AppLineIconWidget(AppLineIcon.at),
              placeholder: context.l10n.loginEmailPlaceholder,
              keyboardType: .emailAddress,
              textInputAction: .next,
              autofillHints: const [AutofillHints.email],
              onChanged: onEmailChanged,
              errorText: showError ? context.l10n.loginEmailError : null,
            );
          },
        ),
        const SizedBox(height: 12),
        BlocBuilder<LoginBloc, LoginState>(
          buildWhen: (previous, current) =>
              previous.password != current.password,
          builder: (context, state) {
            final showError =
                state.password.isNotValid && !state.password.isPure;
            return NinjaInput(
              key: const Key('loginPage_passwordInput'),
              controller: passwordController,
              leadingIcon: const AppLineIconWidget(AppLineIcon.lock),
              placeholder: '••••••••',
              obscureText: true,
              clearable: false,
              autofillHints: const [AutofillHints.password],
              onChanged: onPasswordChanged,
              onSubmitted: (_) {
                if (context.read<LoginBloc>().state.isValid) {
                  context.read<LoginBloc>().add(LoginWithPasswordSubmitted());
                }
              },
              errorText: showError
                  ? context.l10n.loginPasswordError(Password.minLength)
                  : null,
            );
          },
        ),
        const SizedBox(height: 4),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: NinjaButton.text(
            key: const Key('loginPage_forgotPassword'),
            onPressed: () => const PasswordResetRoute().push<void>(context),
            label: context.l10n.loginForgotPassword,
            size: NinjaButtonSize.medium,
          ),
        ),
        const SizedBox(height: 12),
        const _LoginPageSubmitButton(),
      ],
    );
  }
}
