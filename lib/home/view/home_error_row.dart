import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class HomeErrorRow extends StatelessWidget {
  const HomeErrorRow({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const .fromLTRB(
        AppSpacing.xl,
        0,
        AppSpacing.xl,
        AppSpacing.xs,
      ),
      child: NinjaErrorCard(
        title: l10n.loadingError,
        message: l10n.lessonDetailsCheckConnection,
        actionLabel: l10n.retry,
        onAction: onRetry,
      ),
    );
  }
}
