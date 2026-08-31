import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TeamChoiceChip extends StatelessWidget {
  const TeamChoiceChip({
    required this.label,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return NinjaChip(label: label, selected: selected, onTap: onPressed);
  }
}
