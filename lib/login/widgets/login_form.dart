import 'package:app_ui/app_ui.dart' show AppSpacing, Assets, PrimaryButton;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/login/login.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status.isLoggedIn) {
          Navigator.of(context).pop();
        }
      },
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('Login failed')));
          }
        },
        child: const _LoginContent(),
      ),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight * .75),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxlg),
            children: [
              const _LoginTitleAndCloseButton(),
              const SizedBox(height: AppSpacing.sm),
              const _LoginSubtitle(),
              const SizedBox(height: AppSpacing.lg),
              _ContinueWithEmailLoginButton(),
            ],
          ),
        );
      },
    );
  }
}

class _LoginTitleAndCloseButton extends StatelessWidget {
  const _LoginTitleAndCloseButton();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: Text('Login', style: Theme.of(context).textTheme.displaySmall),
        ),
        IconButton(
          key: const Key('loginForm_closeModal_iconButton'),
          constraints: const BoxConstraints.tightFor(width: 24, height: 36),
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}

class _LoginSubtitle extends StatelessWidget {
  const _LoginSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text('Login to continue', style: Theme.of(context).textTheme.titleMedium);
  }
}

class _ContinueWithEmailLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      key: const Key('loginForm_emailLogin_appButton'),
      onPressed: () => Navigator.of(context).push<void>(LoginWithEmailPage.route()),
      text: 'Continue with email',
    );
  }
}
