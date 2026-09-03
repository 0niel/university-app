import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (innerContext) => SignUpBloc(
        userRepository: innerContext.read(),
      ),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<SignUpBloc>();
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: BlocListener<SignUpBloc, SignUpState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status.isSuccess) {
            LoginEmailConfirmationRoute(email: state.email.value).go(context);
          } else if (state.status.isFailure) {
            ToastManager.showError(context, message: l10n.authSignUpFailed);
          }
        },
        child: AuthPageLayout(
          title: l10n.authSignUpTitle,
          titleAccent: l10n.authSignUpTitleAccent,
          subtitle: l10n.authAnyEmailHint,
          onBack: () => Navigator.of(context).maybePop(),
          actions: const _SignUpButton(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<SignUpBloc, SignUpState>(
                buildWhen: (previous, current) =>
                    previous.email != current.email ||
                    previous.status != current.status,
                builder: (context, state) {
                  final showError =
                      state.email.isNotValid && !state.email.isPure;
                  return AppInputField(
                    key: const Key('signUpPage_emailInput'),
                    controller: _emailController,
                    enabled: !state.status.isInProgress,
                    label: l10n.authYourEmail,
                    leadingIcon: AppLineIcon.at,
                    placeholder: l10n.loginEmailPlaceholder,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    onChanged: (value) => bloc.add(SignUpEmailChanged(value)),
                    onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                    errorText: showError ? l10n.authInvalidEmail : null,
                  );
                },
              ),
              const SizedBox(height: 12),
              BlocBuilder<SignUpBloc, SignUpState>(
                buildWhen: (previous, current) =>
                    previous.password != current.password ||
                    previous.status != current.status,
                builder: (context, state) {
                  final showError =
                      state.password.isNotValid && !state.password.isPure;
                  return AppInputField(
                    key: const Key('signUpPage_passwordInput'),
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    enabled: !state.status.isInProgress,
                    label: l10n.authPasswordLabel,
                    leadingIcon: AppLineIcon.lock,
                    placeholder: '••••••••',
                    obscureText: true,
                    showPasswordToggle: true,
                    showClear: false,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    onChanged: (value) =>
                        bloc.add(SignUpPasswordChanged(value)),
                    onSubmitted: (_) => _confirmFocusNode.requestFocus(),
                    errorText: showError
                        ? l10n.authPasswordMinLength(Password.minLength)
                        : null,
                  );
                },
              ),
              const SizedBox(height: 12),
              BlocBuilder<SignUpBloc, SignUpState>(
                buildWhen: (previous, current) =>
                    previous.confirmedPassword != current.confirmedPassword ||
                    previous.status != current.status,
                builder: (context, state) {
                  final showError =
                      state.confirmedPassword.isNotValid &&
                      !state.confirmedPassword.isPure;
                  return AppInputField(
                    key: const Key('signUpPage_confirmPasswordInput'),
                    controller: _confirmController,
                    focusNode: _confirmFocusNode,
                    enabled: !state.status.isInProgress,
                    label: l10n.authConfirmPasswordLabel,
                    leadingIcon: AppLineIcon.lock,
                    placeholder: '••••••••',
                    obscureText: true,
                    showPasswordToggle: true,
                    showClear: false,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
                    onChanged: (value) =>
                        bloc.add(SignUpConfirmPasswordChanged(value)),
                    onSubmitted: (_) {
                      if (bloc.state.isValid &&
                          !bloc.state.status.isInProgress) {
                        bloc.add(SignUpSubmitted());
                      }
                    },
                    errorText: showError ? l10n.authPasswordsDontMatch : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SignUpBloc>().state;
    return AppButton.primary(
      key: const Key('signUpPage_submitButton'),
      label: context.l10n.authSignUpButton,
      size: AppButtonSize.hero,
      expanded: true,
      loading: state.status.isInProgress,
      onPressed: state.isValid
          ? () => context.read<SignUpBloc>().add(SignUpSubmitted())
          : null,
    );
  }
}
