import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MiniAppScanError extends StatelessWidget {
  const MiniAppScanError({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.dark.canvas,
      child: Center(
        child: Padding(
          padding: const .all(32),
          child: Text(
            message,
            textAlign: .center,
            style: AppText.body.copyWith(color: context.colors.white),
          ),
        ),
      ),
    );
  }
}
