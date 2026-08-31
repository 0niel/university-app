import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class JoinByCodeSheet extends StatefulWidget {
  const JoinByCodeSheet({required this.onJoin, super.key});

  final Future<bool> Function(String code) onJoin;

  @override
  State<JoinByCodeSheet> createState() => _JoinByCodeSheetState();
}

class _JoinByCodeSheetState extends State<JoinByCodeSheet> {
  final _code = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final code = _code.text.trim();
    if (code.isEmpty || _saving) return;
    setState(() => _saving = true);
    try {
      final ok = await widget.onJoin(code);
      if (!mounted) return;
      if (ok) {
        Navigator.of(context).pop(true);
      } else {
        setState(() => _saving = false);
      }
    } on Exception catch (error, stackTrace) {
      log(
        'Study group join failed',
        error: error,
        stackTrace: stackTrace,
        name: 'JoinByCodeSheet',
      );
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      spacing: 18,
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        NinjaInput(
          controller: _code,
          autofocus: true,
          maxLength: 12,
          inputFormatters: const [UpperCaseTextFormatter()],
          textInputAction: .done,
          onSubmitted: (_) => unawaited(_save()),
          placeholder: l10n.studyGroupCodeHint,
        ),
        NinjaButton.primary(
          label: _saving ? l10n.studyGroupJoining : l10n.studyGroupJoinButton,
          expanded: true,
          size: NinjaButtonSize.large,
          onPressed: _saving ? null : () => unawaited(_save()),
        ),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  const UpperCaseTextFormatter();
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
