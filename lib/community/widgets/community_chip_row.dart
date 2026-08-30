import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CommunityChipRow extends StatelessWidget {
  const CommunityChipRow({
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
        for (final item in items)
          NinjaChip(
            label: item.$2,
            selected: item.$1 == value,
            onTap: () => onChanged(item.$1),
          ),
      ],
    );
  }
}
