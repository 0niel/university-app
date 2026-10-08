import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  var _showForm = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  void _hideForm() {
    if (context.read<LoginBloc>().state.status.isInProgress) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _showForm = false);
  }

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
          if (_showForm && state.status.isSuccess) {
            TextInput.finishAutofillContext();
          }
        },
        child: PopScope(
          canPop: !_showForm,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && _showForm) _hideForm();
          },
          child: _showForm
              ? AuthPageLayout(
                  key: const ValueKey('login_credentials'),
                  title: l10n.loginWelcomeBack,
                  titleAccent: l10n.loginWelcomeBackAccent,
                  subtitle: l10n.loginSubtitle,
                  onBack: _hideForm,
                  leading: const AppEntryEmblem(icon: AppLineIcon.lock),
                  actions: const _LoginPageActions(),
                  child: AutofillGroup(
                    onDisposeAction: AutofillContextAction.cancel,
                    child: _LoginPageForm(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      passwordFocusNode: _passwordFocusNode,
                      onEmailChanged: (value) =>
                          bloc.add(LoginEmailChanged(value)),
                      onPasswordChanged: (value) =>
                          bloc.add(LoginPasswordChanged(value)),
                    ),
                  ),
                )
              : _LoginWelcome(
                  onSignIn: () => setState(() => _showForm = true),
                ),
        ),
      ),
    );
  }
}

class _LoginWelcome extends StatelessWidget {
  const _LoginWelcome({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<LoginBloc>().state;
    final busy = state.status.isInProgress;
    return AuthPageLayout(
      key: const ValueKey('login_welcome'),
      showBack: Navigator.of(context).canPop(),
      large: true,
      title: l10n.entryWelcomeTitle,
      titleAccent: l10n.entryWelcomeAccent,
      subtitle: l10n.entryWelcomeSubtitle,
      visual: const EntryFeaturePreview(feature: EntryFeature.schedule),
      actions: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton.primary(
            key: const Key('loginPage_startButton'),
            label: l10n.loginSubmit,
            size: AppButtonSize.hero,
            expanded: true,
            onPressed: busy ? null : onSignIn,
            trailingIcon: const AppLineIconWidget(AppLineIcon.arrowRight),
          ),
          const SizedBox(height: 10),
          AppButton.secondary(
            key: const Key('loginPage_signUpLink'),
            label: l10n.createAccount,
            size: AppButtonSize.large,
            expanded: true,
            onPressed: busy
                ? null
                : () => const SignUpRoute().push<void>(context),
          ),
          AppButton.text(
            key: const Key('loginPage_guestButton'),
            label: l10n.loginGuest,
            tooltip: l10n.entryGuestHint,
            size: AppButtonSize.large,
            expanded: true,
            loading: busy,
            onPressed: busy
                ? null
                : () =>
                      context.read<LoginBloc>().add(ContinueAsGuestRequested()),
          ),
        ],
      ),
      child: const SizedBox.shrink(),
    );
  }
}
