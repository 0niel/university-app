import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:flutter/material.dart';

part 'app_segmented_control/segment.dart';

const _segmentInset = 6.0;
const double _segmentHitInset =
    (AppControlSize.touchTarget - AppControlSize.segmentHeight) / 2;

class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    required this.options,
    required this.value,
    super.key,
    this.onChanged,
    this.onCanvas = false,
    this.expanded = true,
    this.backgroundColor,
  });

  final List<AppSegmentedOption<T>> options;
  final T value;
  final ValueChanged<T>? onChanged;
  final bool onCanvas;
  final bool expanded;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final enabled = onChanged != null;
    final segments = [
      for (final option in options)
        _Segment<T>(
          option: option,
          selected: option.value == value,
          wrapped: largeText,
          expanded: expanded,
          onTap: enabled ? () => onChanged?.call(option.value) : null,
        ),
    ];

    return Opacity(
      opacity: enabled ? 1 : .5,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs - _segmentHitInset,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? (onCanvas ? colors.surface : colors.canvas),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: largeText
            ? Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: segments,
              )
            : Row(
                mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  for (final (index, segment) in segments.indexed) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.xs),
                    if (expanded) Expanded(child: segment) else segment,
                  ],
                ],
              ),
      ),
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
  final AppLineIcon? icon;
}
