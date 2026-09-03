part of 'login_page.dart';

class _LoginPageForm extends StatelessWidget {
  const _LoginPageForm({
    required this.emailController,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.onEmailChanged,
    required this.onPasswordChanged,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<LoginBloc, LoginState>(
          buildWhen: (previous, current) =>
              previous.email != current.email ||
              previous.status != current.status,
          builder: (context, state) {
            final showError = state.email.isNotValid && !state.email.isPure;
            return AppInputField(
              key: const Key('loginPage_emailInput'),
              controller: emailController,
              enabled: !state.status.isInProgress,
              label: l10n.authYourEmail,
              leadingIcon: AppLineIcon.at,
              placeholder: l10n.loginEmailPlaceholder,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              onChanged: onEmailChanged,
              onSubmitted: (_) => passwordFocusNode.requestFocus(),
              errorText: showError ? l10n.loginEmailError : null,
            );
          },
        ),
        const SizedBox(height: 12),
        BlocBuilder<LoginBloc, LoginState>(
          buildWhen: (previous, current) =>
              previous.password != current.password ||
              previous.status != current.status,
          builder: (context, state) {
            final showError =
                state.password.isNotValid && !state.password.isPure;
            return AppInputField(
              key: const Key('loginPage_passwordInput'),
              controller: passwordController,
              focusNode: passwordFocusNode,
              enabled: !state.status.isInProgress,
              label: l10n.authPasswordLabel,
              leadingIcon: AppLineIcon.lock,
              placeholder: '••••••••',
              obscureText: true,
              showPasswordToggle: true,
              showClear: false,
              autofillHints: const [AutofillHints.password],
              onChanged: onPasswordChanged,
              onSubmitted: (_) {
                final bloc = context.read<LoginBloc>();
                if (bloc.state.isValid && !bloc.state.status.isInProgress) {
                  bloc.add(LoginWithPasswordSubmitted());
                }
              },
              errorText: showError
                  ? l10n.loginPasswordError(Password.minLength)
                  : null,
            );
          },
        ),
        const SizedBox(height: 4),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: AppButton.text(
            key: const Key('loginPage_forgotPassword'),
            label: l10n.loginForgotPassword,
            size: AppButtonSize.small,
            onPressed: () => const PasswordResetRoute().push<void>(context),
          ),
        ),
      ],
    );
  }
}

class _LoginPageActions extends StatelessWidget {
  const _LoginPageActions();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final state = context.watch<LoginBloc>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton.primary(
          key: const Key('loginPage_submitButton'),
          label: l10n.loginSubmit,
          size: AppButtonSize.hero,
          expanded: true,
          loading: state.status.isInProgress,
          onPressed: state.isValid
              ? () =>
                    context.read<LoginBloc>().add(LoginWithPasswordSubmitted())
              : null,
        ),
        const SizedBox(height: 10),
        AppButton.text(
          key: const Key('loginPage_emailCodeButton'),
          label: l10n.loginWithCode,
          size: AppButtonSize.large,
          expanded: true,
          foregroundColor: colors.muted,
          onPressed: state.status.isInProgress
              ? null
              : () => const LoginWithEmailRoute().push<void>(context),
        ),
        AppButton.text(
          key: const Key('loginPage_signUpLink'),
          label: l10n.createAccount,
          size: AppButtonSize.large,
          expanded: true,
          foregroundColor: colors.muted,
          onPressed: state.status.isInProgress
              ? null
              : () => const SignUpRoute().push<void>(context),
        ),
        AppButton.secondary(
          key: const Key('loginPage_guestButton'),
          label: l10n.loginGuest,
          size: AppButtonSize.large,
          expanded: true,
          onPressed: state.status.isInProgress
              ? null
              : () => context.read<LoginBloc>().add(ContinueAsGuestRequested()),
        ),
      ],
    );
  }
}
