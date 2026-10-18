import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/bloc/password_reset_bloc.dart';

class PasswordResetEmailStep extends StatefulWidget {
  const PasswordResetEmailStep({super.key});

  @override
  State<PasswordResetEmailStep> createState() => _PasswordResetEmailStepState();
}

class _PasswordResetEmailStepState extends State<PasswordResetEmailStep> {
  late final _controller = TextEditingController(
    text: context.read<PasswordResetBloc>().state.email.value,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PasswordResetBloc>().state;
    final bloc = context.read<PasswordResetBloc>();
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppInputField(
          key: const Key('passwordResetPage_emailInput'),
          controller: _controller,
          readOnly: state.isBusy,
          label: l10n.authYourEmail,
          leadingIcon: AppLineIcon.at,
          placeholder: l10n.loginEmailPlaceholder,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          enableSuggestions: false,
          onChanged: (value) => bloc.add(PasswordResetEmailChanged(value)),
          onSubmitted: (_) {
            if (state.email.isValid && state.canResend) {
              bloc.add(PasswordResetRequested());
            }
          },
          validateOnBlur: true,
          errorText: !state.email.isPure && state.email.isNotValid
              ? l10n.authInvalidEmail
              : null,
        ),
        const SizedBox(height: 12),
        AppButton.text(
          key: const Key('passwordResetPage_haveCodeButton'),
          label: l10n.authPasswordResetHaveCode,
          expanded: true,
          onPressed: state.email.isValid && !state.isBusy
              ? () => bloc.add(const PasswordResetCodeEntryRequested())
              : null,
        ),
      ],
    );
  }
}
