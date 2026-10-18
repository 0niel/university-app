import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:rtu_mirea_app/login/widgets/password_reset_code_step.dart';
import 'package:rtu_mirea_app/login/widgets/password_reset_email_step.dart';
import 'package:rtu_mirea_app/login/widgets/password_reset_feedback.dart';
import 'package:rtu_mirea_app/login/widgets/password_reset_password_step.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({this.initialEmail = '', super.key});

  final String initialEmail;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (innerContext) => PasswordResetBloc(
        userRepository: innerContext.read(),
        initialEmail: initialEmail,
      ),
      child: const _PasswordResetView(),
    );
  }
}

class _PasswordResetView extends StatelessWidget {
  const _PasswordResetView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<PasswordResetBloc>();
    return BlocConsumer<PasswordResetBloc, PasswordResetState>(
      listenWhen: (previous, current) =>
          previous.step != current.step && current.step == .complete,
      listener: (context, state) {
        FocusScope.of(context).unfocus();
        ToastManager.showSuccess(
          context,
          message: l10n.authPasswordResetComplete,
        );
        final router = GoRouter.maybeOf(context);
        if (router != null) {
          router.go('/auth');
        } else {
          unawaited(Navigator.of(context).maybePop());
        }
      },
      builder: (context, state) {
        void back() {
          if (state.step == .code && !state.isBusy) {
            bloc.add(const PasswordResetEmailEntryRequested());
          } else {
            unawaited(Navigator.of(context).maybePop());
          }
        }

        return PopScope(
          canPop: state.step != .code || state.isBusy,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) back();
          },
          child: Scaffold(
            backgroundColor: context.colors.canvas,
            body: AuthPageLayout(
              title: switch (state.step) {
                .email => l10n.authPasswordResetTitle,
                .code => l10n.authCheckEmailTitle,
                .password || .complete => l10n.authPasswordResetNewTitle,
              },
              titleAccent: switch (state.step) {
                .email => l10n.authPasswordResetTitleAccent,
                .code => l10n.authCheckEmailTitleAccent,
                .password || .complete => l10n.authPasswordResetNewTitleAccent,
              },
              subtitle: switch (state.step) {
                .email => l10n.authPasswordResetSubtitle,
                .code => l10n.authPasswordResetCodeSubtitle(state.email.value),
                .password || .complete => l10n.authPasswordResetNewSubtitle,
              },
              leading: AppEntryEmblem(
                icon: state.step == .code
                    ? AppLineIcon.message
                    : AppLineIcon.lock,
              ),
              step: state.step == .complete ? 3 : state.step.index + 1,
              totalSteps: 3,
              contentIdentity: state.step,
              onBack: back,
              actions: const _PasswordResetButton(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  switch (state.step) {
                    .email => const PasswordResetEmailStep(),
                    .code => const PasswordResetCodeStep(),
                    .password => const PasswordResetPasswordStep(),
                    .complete => AppBanner(
                      message: l10n.authPasswordResetComplete,
                      tone: AppBannerTone.success,
                    ),
                  },
                  if (state.error != null) ...[
                    const SizedBox(height: 18),
                    PasswordResetFeedback(error: state.error!),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PasswordResetButton extends StatelessWidget {
  const _PasswordResetButton();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PasswordResetBloc>().state;
    final l10n = context.l10n;
    final canSubmit =
        state.isValid &&
        !state.isBusy &&
        (state.step != .email || state.canResend);
    return AppButton.primary(
      key: const Key('passwordResetPage_submitButton'),
      label: switch (state.step) {
        .email =>
          state.resendSeconds > 0
              ? l10n.authPasswordResetResendAfter(state.resendSeconds)
              : l10n.authPasswordResetButton,
        .code => l10n.authPasswordResetVerifyCode,
        .password || .complete => l10n.authPasswordResetSavePassword,
      },
      size: AppButtonSize.hero,
      expanded: true,
      loading: state.isBusy,
      onPressed: canSubmit
          ? () {
              context.read<PasswordResetBloc>().add(switch (state.step) {
                .email => PasswordResetRequested(),
                .code => const PasswordResetCodeSubmitted(),
                .password || .complete => const PasswordResetSubmitted(),
              });
            }
          : null,
    );
  }
}
