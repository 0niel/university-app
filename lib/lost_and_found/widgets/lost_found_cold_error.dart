import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class LostFoundColdError extends StatelessWidget {
  const LostFoundColdError({required this.onRetry, super.key});

  final Future<bool> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NinjaMetrics.screenPadding,
      ),
      child: NinjaErrorState(
        title: l10n.lostFoundLoadError,
        message: l10n.lostFoundLoadErrorSub,
        retryLabel: l10n.retry,
        onRetry: () => unawaited(onRetry()),
      ),
    );
  }
}
