import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/bloc/password_reset_bloc.dart';
import 'package:rtu_mirea_app/login/models/models.dart';

class PasswordResetPasswordStep extends StatefulWidget {
  const PasswordResetPasswordStep({super.key});

  @override
  State<PasswordResetPasswordStep> createState() =>
      _PasswordResetPasswordStepState();
}

class _PasswordResetPasswordStepState extends State<PasswordResetPasswordStep> {
  late final _password = TextEditingController(
    text: context.read<PasswordResetBloc>().state.password.value,
  );
  late final _confirmedPassword = TextEditingController(
    text: context.read<PasswordResetBloc>().state.confirmedPassword.value,
  );
  final _confirmFocus = FocusNode();

  @override
  void dispose() {
    _password.dispose();
    _confirmedPassword.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<PasswordResetBloc>().state;
    final bloc = context.read<PasswordResetBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppInputField(
          key: const Key('passwordResetPage_passwordInput'),
          controller: _password,
          autofocus: true,
          readOnly: state.isBusy,
          label: l10n.authPasswordResetNewTitle,
          leadingIcon: AppLineIcon.lock,
          obscureText: true,
          showPasswordToggle: true,
          showClear: false,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.next,
          onChanged: (value) => bloc.add(PasswordResetPasswordChanged(value)),
          onSubmitted: (_) => _confirmFocus.requestFocus(),
          validateOnBlur: true,
          errorText: !state.password.isPure && state.password.isNotValid
              ? l10n.authPasswordMinLength(Password.minLength)
              : null,
        ),
        const SizedBox(height: 12),
        AppInputField(
          key: const Key('passwordResetPage_confirmPasswordInput'),
          controller: _confirmedPassword,
          focusNode: _confirmFocus,
          readOnly: state.isBusy,
          label: l10n.authConfirmPasswordLabel,
          leadingIcon: AppLineIcon.lock,
          obscureText: true,
          showPasswordToggle: true,
          showClear: false,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.done,
          onChanged: (value) =>
              bloc.add(PasswordResetConfirmPasswordChanged(value)),
          onSubmitted: (_) {
            if (state.isValid && !state.isBusy) {
              bloc.add(const PasswordResetSubmitted());
            }
          },
          validateOnBlur: true,
          errorText:
              !state.confirmedPassword.isPure &&
                  state.confirmedPassword.isNotValid
              ? l10n.authPasswordsDontMatch
              : null,
        ),
      ],
    );
  }
}
