import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class HomeQuickAction extends StatelessWidget {
  const HomeQuickAction({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    super.key,
  });

  final AppLineIcon icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final tone = colors.accentInk(color);
    return AppServiceTile.icon(
      icon: AppLineIconWidget(icon, color: tone),
      color: color,
      label: label,
      size: 52,
      onTap: onTap,
    );
  }
}
