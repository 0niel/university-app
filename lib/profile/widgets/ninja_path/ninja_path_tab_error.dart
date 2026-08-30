import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaPathTabError extends StatelessWidget {
  const NinjaPathTabError({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return NinjaErrorState(
      title: l10n.ninjaPathLoadError,
      message: l10n.profileSectionLoadFailed,
      retryLabel: l10n.tryAgain,
      onRetry: onRetry,
    );
  }
}
