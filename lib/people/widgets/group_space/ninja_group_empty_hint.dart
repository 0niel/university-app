import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaGroupEmptyHint extends StatelessWidget {
  const NinjaGroupEmptyHint({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .fromLTRB(
      AppSpacing.screen,
      12,
      AppSpacing.screen,
      12,
    ),
    child: Text(
      text,
      style: AppText.caption.copyWith(
        color: context.colors.muted,
        height: 1.45,
      ),
    ),
  );
}
