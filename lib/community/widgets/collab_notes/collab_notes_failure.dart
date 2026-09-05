import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CollabNotesFailure extends StatelessWidget {
  const CollabNotesFailure({required this.onRetry, super.key});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      children: [
        const SizedBox(height: AppSpacing.xxxlg),
        AppErrorState(
          lineIcon: AppLineIcon.alert,
          title: context.l10n.collabNotesLoadError,
          message: context.l10n.collabNotesLoadErrorSubtitle,
          primaryLabel: context.l10n.retry,
          onPrimary: () => unawaited(onRetry()),
        ),
      ],
    );
  }
}
