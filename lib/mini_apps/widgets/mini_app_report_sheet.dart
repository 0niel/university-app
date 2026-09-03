import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_labels.dart';

class MiniAppReportSheet extends StatefulWidget {
  const MiniAppReportSheet({required this.onSubmit, super.key});

  final Future<bool> Function(MiniAppReportReason reason, String details)
  onSubmit;

  @override
  State<MiniAppReportSheet> createState() => _MiniAppReportSheetState();
}

class _MiniAppReportSheetState extends State<MiniAppReportSheet> {
  final _detailsController = TextEditingController();
  MiniAppReportReason _reason = .broken;
  bool _sending = false;
  bool _failed = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_sending) return;
    setState(() {
      _sending = true;
      _failed = false;
    });
    var sent = false;
    try {
      sent = await widget.onSubmit(_reason, _detailsController.text.trim());
    } on Exception {
      sent = false;
    }
    if (!mounted) return;
    if (sent) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _sending = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final reason in MiniAppReportReason.values)
              NinjaChip(
                label: miniAppReportReasonLabel(context, reason),
                selected: _reason == reason,
                onTap: () => setState(() => _reason = reason),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        NinjaInput.multiline(
          controller: _detailsController,
          maxLength: 500,
          maxLines: 3,
          placeholder: l10n.miniAppsReportDetailsHint,
        ),
        const SizedBox(height: AppSpacing.md),
        if (_failed) ...[
          NinjaBanner(title: l10n.miniAppsReportFailure, tone: .danger),
          const SizedBox(height: AppSpacing.md),
        ],
        NinjaButton.destructive(
          label: _sending
              ? l10n.miniAppsReportSending
              : l10n.miniAppsReportSend,
          expanded: true,
          loading: _sending,
          onPressed: _sending ? null : () => unawaited(_send()),
        ),
      ],
    );
  }
}
