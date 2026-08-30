import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaCommunityCatalogError extends StatelessWidget {
  const NinjaCommunityCatalogError({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
    child: NinjaErrorState(
      title: context.l10n.loadingError,
      message: context.l10n.tryAgain,
      retryLabel: context.l10n.retry,
      onRetry: onRetry,
    ),
  );
}
