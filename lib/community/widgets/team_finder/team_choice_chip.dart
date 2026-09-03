import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TeamChoiceChip extends StatelessWidget {
  const TeamChoiceChip({
    required this.label,
    required this.selected,
    required this.onPressed,
    super.key,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppChip.filter(
      label: label,
      selected: selected,
      enabled: enabled,
      onTap: enabled ? onPressed : null,
    );
  }
}
