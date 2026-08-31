import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppRankConnectorLine extends StatelessWidget {
  const AppRankConnectorLine({required this.filled, super.key});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 3,
      margin: const EdgeInsets.only(bottom: 18, left: 6, right: 6),
      decoration: BoxDecoration(
        color: filled ? colors.primary : colors.surfaceHigh,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
