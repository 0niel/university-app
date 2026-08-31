part of 'sign_up_page.dart';

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final bloc = context.read<SignUpBloc>();
    final universityConfig = context.read<UniversityConfig>();
    return Scaffold(
      backgroundColor: colors.canvas,
      body: BlocListener<SignUpBloc, SignUpState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status.isSuccess) {
            LoginEmailConfirmationRoute(email: state.email.value).go(context);
          } else if (state.status.isFailure) {
            showNinjaToast(
              context,
              message: l10n.authSignUpFailed,
              showCheck: false,
            );
          }
        },
        child: AuthPageLayout(
          title: l10n.authSignUpTitle,
          subtitle: l10n.authSignUpSubtitle(
            universityConfig.emailDomainHint,
          ),
          showBack: true,
          onBack: () => Navigator.of(context).maybePop(),
          compact: true,
          child: Column(
            crossAxisAlignment: .stretch,
            mainAxisSize: .min,
            children: [
              BlocBuilder<SignUpBloc, SignUpState>(
                buildWhen: (previous, current) =>
                    previous.email != current.email,
                builder: (context, state) {
                  final showError =
                      state.email.isNotValid && !state.email.isPure;
                  return NinjaInput(
                    key: const Key('signUpPage_emailInput'),
                    controller: _emailController,
                    leadingIcon: const AppLineIconWidget(AppLineIcon.at),
                    placeholder: universityConfig.emailPlaceholder,
                    keyboardType: .emailAddress,
                    textInputAction: .next,
                    autofillHints: const [AutofillHints.email],
                    onChanged: (value) => bloc.add(SignUpEmailChanged(value)),
                    errorText: showError
                        ? l10n.authEmailDomainError(
                            universityConfig.emailDomainHint,
                          )
                        : null,
                  );
                },
              ),
              const SizedBox(height: 12),
              BlocBuilder<SignUpBloc, SignUpState>(
                buildWhen: (previous, current) =>
                    previous.password != current.password,
                builder: (context, state) {
                  final showError =
                      state.password.isNotValid && !state.password.isPure;
                  return NinjaInput(
                    key: const Key('signUpPage_passwordInput'),
                    controller: _passwordController,
                    leadingIcon: const AppLineIconWidget(AppLineIcon.lock),
                    placeholder: '••••••••',
                    obscureText: true,
                    clearable: false,
                    autofillHints: const [AutofillHints.newPassword],
                    onChanged: (value) =>
                        bloc.add(SignUpPasswordChanged(value)),
                    errorText: showError
                        ? l10n.authPasswordMinLength(Password.minLength)
                        : null,
                  );
                },
              ),
              const SizedBox(height: 12),
              BlocBuilder<SignUpBloc, SignUpState>(
                buildWhen: (previous, current) =>
                    previous.confirmedPassword != current.confirmedPassword,
                builder: (context, state) {
                  final showError =
                      state.confirmedPassword.isNotValid &&
                      !state.confirmedPassword.isPure;
                  return NinjaInput(
                    key: const Key('signUpPage_confirmPasswordInput'),
                    controller: _confirmController,
                    leadingIcon: const AppLineIconWidget(AppLineIcon.lock),
                    placeholder: '••••••••',
                    obscureText: true,
                    clearable: false,
                    autofillHints: const [AutofillHints.newPassword],
                    onChanged: (value) =>
                        bloc.add(SignUpConfirmPasswordChanged(value)),
                    errorText: showError ? l10n.authPasswordsDontMatch : null,
                  );
                },
              ),
              const SizedBox(height: 24),
              const _SignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}
