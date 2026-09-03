import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class LessonEditorTypeChip extends StatelessWidget {
  const LessonEditorTypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: label,
      semanticsSelected: selected,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AppControlSize.touchTarget,
        ),
        padding: const .symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? colors.tint : colors.surface,
          borderRadius: .circular(AppRadius.full),
        ),
        child: Center(
          widthFactor: 1,
          child: Text(
            label,
            style: AppText.body.copyWith(
              fontSize: 13,
              color: selected ? colors.accent : colors.muted,
            ),
          ),
        ),
      ),
    );
  }
}
