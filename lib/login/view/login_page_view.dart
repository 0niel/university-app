part of 'login_page.dart';

class _LoginPageView extends StatefulWidget {
  const _LoginPageView();

  @override
  State<_LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<_LoginPageView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoginBloc>();
    return Scaffold(
      backgroundColor: context.ninja.canvas,
      resizeToAvoidBottomInset: true,
      body: BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status.isFailure) {
            final message = switch (state.errorKind) {
              LoginErrorKind.invalidCredentials =>
                context.l10n.authInvalidCredentials,
              LoginErrorKind.guestUnavailable =>
                context.l10n.authGuestUnavailable,
              LoginErrorKind.generic || null => context.l10n.loginGenericError,
            };
            showNinjaToast(
              context,
              message: message,
              showCheck: false,
            );
          }
        },
        child: AuthPageLayout(
          title: context.l10n.loginWelcomeBack,
          subtitle: context.l10n.loginSubtitle,
          footer: const _LoginPageBottomLinks(),
          child: _LoginPageForm(
            emailController: _emailController,
            passwordController: _passwordController,
            onEmailChanged: (value) => bloc.add(LoginEmailChanged(value)),
            onPasswordChanged: (value) => bloc.add(LoginPasswordChanged(value)),
          ),
        ),
      ),
    );
  }
}
