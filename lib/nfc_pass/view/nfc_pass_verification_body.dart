import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';

class NfcPassVerificationBody extends StatefulWidget {
  const NfcPassVerificationBody({
    required this.state,
    required this.onEnterCode,
    required this.onResend,
    super.key,
  });

  final NfcPassState state;
  final VoidCallback onEnterCode;
  final VoidCallback onResend;

  @override
  State<NfcPassVerificationBody> createState() =>
      _NfcPassVerificationBodyState();
}

class _NfcPassVerificationBodyState extends State<NfcPassVerificationBody> {
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    _scheduleRetry();
  }

  @override
  void didUpdateWidget(NfcPassVerificationBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.verificationRetryAt !=
        widget.state.verificationRetryAt) {
      _scheduleRetry();
    }
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    final retryAt = widget.state.verificationRetryAt;
    if (retryAt == null) return;
    final delay = retryAt.difference(DateTime.now());
    if (delay <= Duration.zero) return;
    _retryTimer = Timer(delay, () {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = widget.state;
    final retryAt = state.verificationRetryAt?.toLocal();
    final waiting = retryAt?.isAfter(DateTime.now()) ?? false;
    final message = switch (state.verificationIssue) {
      .wrongCode => l10n.nfcPassWrongCode,
      .nfcError => l10n.nfcPassIssuanceFailed,
      .requestFailed => l10n.nfcPassVerificationUnconfirmed,
      null =>
        state.status == .codeSent
            ? l10n.nfcPassCodeSentDescription
            : l10n.nfcPassCodeAlreadyRequested,
    };
    final formats = MaterialLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NinjaEmptyState(
          icon: const AppLineIconWidget(AppLineIcon.mail),
          title: state.status == .codeSent
              ? l10n.nfcPassCodeSentTitle
              : l10n.nfcPassVerificationTitle,
          message: message,
          actionLabel: l10n.nfcPassEnterCodeButton,
          onAction: widget.onEnterCode,
        ).animateEmptyState(),
        if (waiting) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.nfcPassNextCodeTime,
            style: AppText.body,
            textAlign: TextAlign.center,
          ),
          Text(
            '${formats.formatCompactDate(retryAt!)} '
            '${formats.formatTimeOfDay(TimeOfDay.fromDateTime(retryAt))}',
            style: AppText.body.copyWith(color: context.colors.muted),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        AppButton.secondary(
          label: l10n.nfcPassResendCode,
          onPressed: waiting ? null : widget.onResend,
        ),
      ],
    );
  }
}
