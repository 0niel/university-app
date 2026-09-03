import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:rtu_mirea_app/navigation/navigation.dart';

part 'login_page_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (innerContext) => LoginBloc(
        userRepository: innerContext.read(),
      ),
      child: const _LoginPageView(),
    );
  }
}

class _LoginPageView extends StatefulWidget {
  const _LoginPageView();

  @override
  State<_LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<_LoginPageView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onFailure(BuildContext context, LoginState state) {
    final message = switch (state.errorKind) {
      LoginErrorKind.invalidCredentials => context.l10n.authInvalidCredentials,
      LoginErrorKind.guestUnavailable => context.l10n.authGuestUnavailable,
      LoginErrorKind.generic || null => context.l10n.loginGenericError,
    };
    ToastManager.showError(context, message: message);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<LoginBloc>();
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status.isFailure) _onFailure(context, state);
        },
        child: AuthPageLayout(
          title: l10n.loginWelcomeBack,
          titleAccent: l10n.loginWelcomeBackAccent,
          subtitle: l10n.loginSubtitle,
          showBack: Navigator.of(context).canPop(),
          onBack: () => Navigator.of(context).maybePop(),
          actions: const _LoginPageActions(),
          child: _LoginPageForm(
            emailController: _emailController,
            passwordController: _passwordController,
            passwordFocusNode: _passwordFocusNode,
            onEmailChanged: (value) => bloc.add(LoginEmailChanged(value)),
            onPasswordChanged: (value) => bloc.add(LoginPasswordChanged(value)),
          ),
        ),
      ),
    );
  }
}
