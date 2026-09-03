import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (innerContext) => PasswordResetBloc(
        userRepository: innerContext.read(),
      ),
      child: const _PasswordResetView(),
    );
  }
}

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
    final l10n = context.l10n;
    final bloc = context.read<PasswordResetBloc>();
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: BlocListener<PasswordResetBloc, PasswordResetState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status.isSuccess) {
            ToastManager.showSuccess(
              context,
              message: l10n.authPasswordResetSent,
            );
            unawaited(Navigator.of(context).maybePop());
          } else if (state.status.isFailure) {
            ToastManager.showError(
              context,
              message: l10n.authPasswordResetFailed,
            );
          }
        },
        child: AuthPageLayout(
          title: l10n.authPasswordResetTitle,
          titleAccent: l10n.authPasswordResetTitleAccent,
          subtitle: l10n.authPasswordResetSubtitle,
          onBack: () => Navigator.of(context).maybePop(),
          actions: const _PasswordResetButton(),
          child: BlocBuilder<PasswordResetBloc, PasswordResetState>(
            buildWhen: (previous, current) =>
                previous.email != current.email ||
                previous.status != current.status,
            builder: (context, state) {
              final showError = state.email.isNotValid && !state.email.isPure;
              return AppInputField(
                key: const Key('passwordResetPage_emailInput'),
                controller: _emailController,
                enabled: !state.status.isInProgress,
                label: l10n.authYourEmail,
                leadingIcon: AppLineIcon.at,
                placeholder: l10n.loginEmailPlaceholder,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.email],
                onChanged: (value) =>
                    bloc.add(PasswordResetEmailChanged(value)),
                onSubmitted: (_) {
                  if (bloc.state.isValid && !bloc.state.status.isInProgress) {
                    bloc.add(PasswordResetRequested());
                  }
                },
                errorText: showError ? l10n.authInvalidEmail : null,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PasswordResetButton extends StatelessWidget {
  const _PasswordResetButton();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PasswordResetBloc>().state;
    return AppButton.primary(
      key: const Key('passwordResetPage_submitButton'),
      label: context.l10n.authPasswordResetButton,
      size: AppButtonSize.hero,
      expanded: true,
      loading: state.status.isInProgress,
      onPressed: state.isValid
          ? () => context.read<PasswordResetBloc>().add(
              PasswordResetRequested(),
            )
          : null,
    );
  }
}
