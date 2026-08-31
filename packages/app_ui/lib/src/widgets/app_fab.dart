import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppFab extends StatelessWidget {
  const AppFab({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
  }) : label = null;

  const AppFab.extended({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
    this.tooltip,
  });

  final AppLineIcon icon;
  final String? label;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final labelText = label;
    if (labelText == null) {
      return AppPressable(
        pressedScale: 0.95,
        onTap: onPressed,
        child: FloatingActionButton(
          heroTag: null,
          onPressed: onPressed,
          tooltip: tooltip,
          backgroundColor: colors.primary,
          foregroundColor: colors.onAccent,
          elevation: 0,
          highlightElevation: 0,
          child: AppLineIconWidget(icon, color: colors.onAccent),
        ),
      );
    }
    return AppPressable(
      pressedScale: 0.95,
      onTap: onPressed,
      child: FloatingActionButton.extended(
        heroTag: null,
        onPressed: onPressed,
        tooltip: tooltip,
        backgroundColor: colors.primary,
        foregroundColor: colors.onAccent,
        elevation: 0,
        highlightElevation: 0,
        icon: AppLineIconWidget(icon, size: 20, color: colors.onAccent),
        label: Text(
          labelText,
          style: AppText.button.copyWith(color: colors.onAccent),
        ),
      ),
    );
  }
}
