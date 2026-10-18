import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/bloc/password_reset_bloc.dart';

class PasswordResetCodeStep extends StatefulWidget {
  const PasswordResetCodeStep({super.key});

  @override
  State<PasswordResetCodeStep> createState() => _PasswordResetCodeStepState();
}

class _PasswordResetCodeStepState extends State<PasswordResetCodeStep> {
  late final _controller = TextEditingController(
    text: context.read<PasswordResetBloc>().state.code,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<PasswordResetBloc>().state;
    final bloc = context.read<PasswordResetBloc>();
    return BlocListener<PasswordResetBloc, PasswordResetState>(
      listenWhen: (previous, current) =>
          previous.code.isNotEmpty && current.code.isEmpty,
      listener: (_, _) => _controller.clear(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppFieldLabel(l10n.authCodeFromEmail),
          AppCodeInput(
            key: const Key('passwordResetPage_codeInput'),
            controller: _controller,
            autofocus: true,
            readOnly: state.isBusy,
            onChanged: (value) => bloc.add(PasswordResetCodeChanged(value)),
            onCompleted: (_) => bloc.add(const PasswordResetCodeSubmitted()),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.authPasswordResetCodeHint,
            style: AppText.subtext.copyWith(color: context.colors.muted),
          ),
          const SizedBox(height: 12),
          AppButton.text(
            key: const Key('passwordResetPage_resendButton'),
            label: state.resendSeconds > 0
                ? l10n.authPasswordResetResendAfter(state.resendSeconds)
                : l10n.authPasswordResetResend,
            expanded: true,
            onPressed: state.canResend
                ? () => bloc.add(PasswordResetRequested())
                : null,
          ),
        ],
      ),
    );
  }
}
