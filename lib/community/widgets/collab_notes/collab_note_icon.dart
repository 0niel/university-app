import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CollabNoteIcon extends StatelessWidget {
  const CollabNoteIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      width: 44,
      height: 44,
      alignment: .center,
      decoration: BoxDecoration(
        color: colors.brandTint,
        borderRadius: .circular(NinjaRadius.control),
      ),
      child: AppLineIconWidget(.pencil, size: 18, color: colors.brandInk),
    );
  }
}
