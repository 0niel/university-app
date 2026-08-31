import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

part 'app_segmented_control/segment.dart';

class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    required this.options,
    required this.value,
    super.key,
    this.onChanged,
  });

  final List<AppSegmentedOption<T>> options;
  final T value;
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) {
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final segments = [
      for (final option in options)
        _Segment(
          option: option,
          selected: option.value == value,
          expanded: largeText,
          onTap: onChanged == null ? null : () => onChanged?.call(option.value),
        ),
    ];

    if (largeText) {
      return Wrap(spacing: 8, runSpacing: 8, children: segments);
    }
    return Row(
      children: [
        for (var index = 0; index < segments.length; index++) ...[
          if (index > 0) const SizedBox(width: 8),
          Expanded(child: segments[index]),
        ],
      ],
    );
  }
}

class AppSegmentedOption<T> {
  const AppSegmentedOption({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final IconData? icon;
}
