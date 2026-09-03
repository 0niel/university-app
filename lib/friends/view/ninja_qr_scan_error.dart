import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaQrScanError extends StatelessWidget {
  const NinjaQrScanError({
    required this.title,
    required this.message,
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.dark.canvas,
      child: Center(
        child: Padding(
          padding: const .symmetric(
            horizontal: AppSpacing.screen,
          ),
          child: AppErrorState(
            title: title,
            message: message,
            footnote: null,
            primaryLabel: MaterialLocalizations.of(context).closeButtonLabel,
            onPrimary: () => Navigator.of(context).maybePop(),
          ).animateEmptyState(),
        ),
      ),
    );
  }
}
