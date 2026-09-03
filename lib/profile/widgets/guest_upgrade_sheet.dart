import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/models/models.dart';
import 'package:user_repository/user_repository.dart';

Future<void> showGuestUpgradeSheet(BuildContext context) async {
  final user = context.read<AppBloc>().state.user;
  if (!user.isGuest || user.id.isEmpty) return;
  final navigator = Navigator.of(context, rootNavigator: true);
  final saved = await showAppSheet<bool>(
    context,
    title: context.l10n.authGuestUpgradeTitle,
    subtitle: context.l10n.authGuestUpgradeSubtitle,
    child: GuestUpgradeSheet(
      userId: user.id,
      repository: context.read<UserRepository>(),
      onSaved: () => navigator.pop(true),
    ),
  );
  if (saved == true && context.mounted) {
    ToastManager.showSuccess(
      context,
      message: context.l10n.authGuestUpgradeDone,
    );
  }
}

class GuestUpgradeSheet extends StatefulWidget {
  const GuestUpgradeSheet({
    required this.userId,
    required this.repository,
    required this.onSaved,
    super.key,
  });

  final String userId;
  final UserRepository repository;
  final VoidCallback onSaved;

  @override
  State<GuestUpgradeSheet> createState() => _GuestUpgradeSheetState();
}

enum _UpgradeStep { email, code, password }

class _GuestUpgradeSheetState extends State<GuestUpgradeSheet> {
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  _UpgradeStep _step = _UpgradeStep.email;
  var _busy = false;
  var _failed = false;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  bool get _valid => switch (_step) {
    _UpgradeStep.email => Email.dirty(_email.text.trim()).isValid,
    _UpgradeStep.code => RegExp(r'^\d{6}$').hasMatch(_code.text),
    _UpgradeStep.password =>
      Password.dirty(_password.text).isValid &&
          _password.text == _confirmation.text,
  };

  Future<void> _submit() async {
    if (_busy || !_valid) return;
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      switch (_step) {
        case _UpgradeStep.email:
          await widget.repository.linkGuestEmail(
            userId: widget.userId,
            email: _email.text.trim(),
          );
          if (mounted) setState(() => _step = _UpgradeStep.code);
        case _UpgradeStep.code:
          await widget.repository.verifyGuestEmail(
            userId: widget.userId,
            email: _email.text.trim(),
            code: _code.text,
          );
          if (mounted) setState(() => _step = _UpgradeStep.password);
        case _UpgradeStep.password:
          await widget.repository.setAccountPassword(
            userId: widget.userId,
            password: _password.text,
          );
          if (mounted) widget.onSaved();
      }
    } on Exception {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final action = switch (_step) {
      _UpgradeStep.email => l10n.authGuestUpgradeSendCode,
      _UpgradeStep.code => l10n.authGuestUpgradeVerify,
      _UpgradeStep.password => l10n.authGuestUpgradePassword,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_step == _UpgradeStep.email)
          AppInputField(
            key: const ValueKey('guest-upgrade-email'),
            controller: _email,
            enabled: !_busy,
            label: l10n.authYourEmail,
            leadingIcon: AppLineIcon.at,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => unawaited(_submit()),
          ),
        if (_step == _UpgradeStep.code) ...[
          Text(
            l10n.authCheckEmailSubtitle(_email.text.trim()),
            style: AppText.subtext.copyWith(color: context.colors.muted),
          ),
          const SizedBox(height: AppSpacing.md),
          AppInputField(
            key: const ValueKey('guest-upgrade-code'),
            controller: _code,
            enabled: !_busy,
            label: l10n.authCodeFromEmail,
            keyboardType: TextInputType.number,
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => unawaited(_submit()),
          ),
          AppButton.text(
            label: l10n.authYourEmail,
            onPressed: _busy
                ? null
                : () => setState(() {
                    _step = _UpgradeStep.email;
                    _code.clear();
                    _failed = false;
                  }),
          ),
        ],
        if (_step == _UpgradeStep.password) ...[
          AppInputField(
            key: const ValueKey('guest-upgrade-password'),
            controller: _password,
            enabled: !_busy,
            label: l10n.authPasswordLabel,
            leadingIcon: AppLineIcon.lock,
            obscureText: true,
            showPasswordToggle: true,
            showClear: false,
            autofillHints: const [AutofillHints.newPassword],
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          AppInputField(
            key: const ValueKey('guest-upgrade-confirmation'),
            controller: _confirmation,
            enabled: !_busy,
            label: l10n.authConfirmPasswordLabel,
            obscureText: true,
            showPasswordToggle: true,
            showClear: false,
            autofillHints: const [AutofillHints.newPassword],
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => unawaited(_submit()),
          ),
        ],
        if (_failed) ...[
          const SizedBox(height: AppSpacing.md),
          AppBanner(
            message: l10n.authGuestUpgradeError,
            tone: AppBannerTone.danger,
          ),
        ],
        const SizedBox(height: AppSpacing.screen),
        AppButton.primary(
          key: const ValueKey('guest-upgrade-submit'),
          label: action,
          expanded: true,
          loading: _busy,
          onPressed: !_busy && _valid ? () => unawaited(_submit()) : null,
        ),
      ],
    );
  }
}
