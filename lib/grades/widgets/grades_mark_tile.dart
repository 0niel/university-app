import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class GradesMarkTile extends StatelessWidget {
  const GradesMarkTile({required this.value, super.key, this.size = 32});

  final int value;
  final double size;

  static (Color, Color) palette(AppColors colors, int value) => switch (value) {
    5 => (colors.lectureTint, colors.lecture),
    4 => (colors.tint, colors.accent),
    _ => (colors.warnTint, colors.warn),
  };

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = palette(context.colors, value);
    return Semantics(
      label: context.l10n.gradesMarkSemantics(value),
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          '$value',
          style: AppText.sans(14, FontWeight.w800).copyWith(color: foreground),
        ),
      ),
    );
  }
}
