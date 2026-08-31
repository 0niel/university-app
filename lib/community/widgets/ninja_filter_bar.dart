import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaFilterBar extends StatelessWidget {
  const NinjaFilterBar({
    required this.items,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final List<(String, String)> items;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return NinjaChipRow(
      children: [
        for (final (key, label) in items)
          NinjaChip(
            label: label,
            selected: key == value,
            onTap: () => onChanged(key),
          ),
      ],
    );
  }
}
