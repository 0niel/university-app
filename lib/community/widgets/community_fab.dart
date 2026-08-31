import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CommunityFab extends StatelessWidget {
  const CommunityFab({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon = AppLineIcon.plus,
  });

  final String label;
  final AppLineIcon icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return NinjaFab(
      icon: AppLineIconWidget(
        icon,
        size: 24,
        color: onPressed == null ? colors.disabled : colors.onInk,
      ),
      tooltip: label,
      onPressed: onPressed,
    );
  }
}
