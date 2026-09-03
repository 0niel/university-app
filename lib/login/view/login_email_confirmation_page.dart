import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';

class LoginEmailConfirmationPage extends StatelessWidget {
  const LoginEmailConfirmationPage({required this.email, super.key});

  final String email;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (innerContext) => LoginWithEmailLinkBloc(
        userRepository: innerContext.read(),
      ),
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        body: AuthPageLayout(
          title: l10n.authCheckEmailTitle,
          titleAccent: l10n.authCheckEmailTitleAccent,
          subtitle: l10n.authCheckEmailSubtitle(email),
          step: 2,
          totalSteps: 2,
          onBack: () => Navigator.of(context).maybePop(),
          child: _LoginEmailConfirmationForm(email: email),
        ),
      ),
    );
  }
}

class _LoginEmailConfirmationForm extends StatefulWidget {
  const _LoginEmailConfirmationForm({required this.email});

  final String email;

  @override
  State<_LoginEmailConfirmationForm> createState() =>
      _LoginEmailConfirmationFormState();
}

class _LoginEmailConfirmationFormState
    extends State<_LoginEmailConfirmationForm> {
  var _attempt = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.watch<LoginWithEmailLinkBloc>().state.status;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppFieldLabel(l10n.authCodeFromEmail),
        AppCodeInput(
          key: ValueKey('loginEmailConfirmation_code_$_attempt'),
          autofocus: true,
          enabled:
              status != LoginWithEmailLinkStatus.loading &&
              status != LoginWithEmailLinkStatus.success,
          onCompleted: (code) {
            context.read<LoginWithEmailLinkBloc>().add(
              LoginWithEmailCodeSubmitted(email: widget.email, code: code),
            );
          },
        ),
        const SizedBox(height: 18),
        _LoginEmailConfirmationStatus(
          onRetry: () {
            context.read<LoginWithEmailLinkBloc>().add(
              const LoginWithEmailCodeResetRequested(),
            );
            setState(() => _attempt++);
          },
        ),
      ],
    );
  }
}

class _LoginEmailConfirmationStatus extends StatelessWidget {
  const _LoginEmailConfirmationStatus({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return BlocBuilder<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return NinjaStateSwitcher(
          child: switch (state.status) {
            LoginWithEmailLinkStatus.loading => Row(
              key: const ValueKey('loginEmailConfirmation_checking'),
              children: [
                const AppSpinner(size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.authCheckingCode,
                    style: AppText.subtext.copyWith(color: colors.muted),
                  ),
                ),
              ],
            ),
            LoginWithEmailLinkStatus.failure => AppBanner(
              key: const ValueKey('loginEmailConfirmation_failure'),
              message: l10n.authInvalidCode,
              tone: AppBannerTone.danger,
              actionLabel: l10n.retry,
              onAction: onRetry,
            ),
            LoginWithEmailLinkStatus.initial ||
            LoginWithEmailLinkStatus.success => const SizedBox.shrink(
              key: ValueKey('loginEmailConfirmation_idle'),
            ),
          },
        );
      },
    );
  }
}
