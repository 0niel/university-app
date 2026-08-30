import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MiniAppIconTile extends StatelessWidget {
  const MiniAppIconTile({
    required this.emoji,
    required this.accent,
    super.key,
    this.size = 44,
  });

  final String emoji;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: .circular(NinjaRadius.button),
      ),
      alignment: .center,
      child: Text(
        emoji,
        style: TextStyle(fontSize: size * 0.5, height: 1),
      ),
    );
  }
}
