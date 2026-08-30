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
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: label,
      semanticsSelected: selected,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: NinjaMetrics.minTouchTarget,
        ),
        padding: const .symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? colors.brandTint : colors.surface,
          borderRadius: .circular(NinjaRadius.pill),
        ),
        child: Center(
          widthFactor: 1,
          child: Text(
            label,
            style: NinjaText.body.copyWith(
              fontSize: 13,
              color: selected ? colors.brandInk : colors.mutedDark,
            ),
          ),
        ),
      ),
    );
  }
}
