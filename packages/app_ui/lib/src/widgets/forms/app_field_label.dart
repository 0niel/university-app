import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppFieldLabel extends StatelessWidget {
  const AppFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.gap),
      child: Text(
        text.toUpperCase(),
        style: AppText.overline.copyWith(
          fontSize: 12,
          letterSpacing: 0.5,
          color: context.colors.deactive,
        ),
      ),
    );
  }
}
