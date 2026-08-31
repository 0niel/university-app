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
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const .symmetric(
            horizontal: NinjaMetrics.screenPadding,
          ),
          child: NinjaErrorState(
            title: title,
            message: message,
          ).animateEmptyState(),
        ),
      ),
    );
  }
}
