import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppBriefPill extends StatelessWidget {
  const AppBriefPill({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        text,
        style: AppText.caption.copyWith(
          color: colors.deactive,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
