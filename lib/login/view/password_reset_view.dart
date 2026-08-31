part of 'password_reset_page.dart';

class _PasswordResetView extends StatefulWidget {
  const _PasswordResetView();

  @override
  State<_PasswordResetView> createState() => _PasswordResetViewState();
}

class _PasswordResetViewState extends State<_PasswordResetView> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final bloc = context.read<PasswordResetBloc>();
    final universityConfig = context.read<UniversityConfig>();
    return Scaffold(
      backgroundColor: colors.canvas,
      body: BlocListener<PasswordResetBloc, PasswordResetState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status.isSuccess) {
            showNinjaToast(context, message: l10n.authPasswordResetSent);
            unawaited(Navigator.of(context).maybePop());
          } else if (state.status.isFailure) {
            showNinjaToast(
              context,
              message: l10n.authPasswordResetFailed,
              showCheck: false,
            );
          }
        },
        child: AuthPageLayout(
          title: l10n.authPasswordResetTitle,
          subtitle: l10n.authPasswordResetSubtitle,
          showBack: true,
          onBack: () => Navigator.of(context).maybePop(),
          compact: true,
          child: Column(
            crossAxisAlignment: .stretch,
            mainAxisSize: .min,
            children: [
              BlocBuilder<PasswordResetBloc, PasswordResetState>(
                buildWhen: (previous, current) =>
                    previous.email != current.email,
                builder: (context, state) {
                  final showError =
                      state.email.isNotValid && !state.email.isPure;
                  return NinjaInput(
                    key: const Key('passwordResetPage_emailInput'),
                    controller: _emailController,
                    leadingIcon: const AppLineIconWidget(AppLineIcon.at),
                    placeholder: universityConfig.emailPlaceholder,
                    keyboardType: .emailAddress,
                    textInputAction: .done,
                    autofillHints: const [AutofillHints.email],
                    onChanged: (value) =>
                        bloc.add(PasswordResetEmailChanged(value)),
                    errorText: showError
                        ? l10n.authEmailDomainError(
                            universityConfig.emailDomainHint,
                          )
                        : null,
                  );
                },
              ),
              const SizedBox(height: 24),
              const _PasswordResetButton(),
            ],
          ),
        ),
      ),
    );
  }
}
