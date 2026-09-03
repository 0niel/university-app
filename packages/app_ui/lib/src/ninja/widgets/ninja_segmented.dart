import 'package:app_ui/src/widgets/app_segmented_control.dart';
import 'package:flutter/material.dart';

class NinjaSegmented<T> extends StatelessWidget {
  const NinjaSegmented({
    required this.segments,
    required this.value,
    super.key,
    this.onChanged,
    this.expanded = true,
    this.onCanvas = false,
  });

  final List<NinjaSegment<T>> segments;
  final T value;
  final ValueChanged<T>? onChanged;
  final bool expanded;
  final bool onCanvas;

  @override
  Widget build(BuildContext context) {
    return AppSegmentedControl<T>(
      value: value,
      onChanged: onChanged,
      expanded: expanded,
      onCanvas: onCanvas,
      options: [
        for (final segment in segments)
          AppSegmentedOption(value: segment.value, label: segment.label),
      ],
    );
  }
}

class NinjaSegment<T> {
  const NinjaSegment({required this.value, required this.label});

  final T value;
  final String label;
}

typedef AppSegmented<T> = NinjaSegmented<T>;

typedef AppSegment<T> = NinjaSegment<T>;
