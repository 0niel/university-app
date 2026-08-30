import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaGroupEmptyHint extends StatelessWidget {
  const NinjaGroupEmptyHint({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .fromLTRB(
      NinjaMetrics.screenPadding,
      12,
      NinjaMetrics.screenPadding,
      12,
    ),
    child: Text(
      text,
      style: NinjaText.helper.copyWith(
        color: context.ninja.muted,
        height: 1.45,
      ),
    ),
  );
}
