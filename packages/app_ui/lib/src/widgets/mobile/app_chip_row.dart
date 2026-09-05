import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/app_filter_chip.dart';
import 'package:app_ui/src/widgets/app_horizontal_scroll_view.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:flutter/material.dart';

class AppChipRow<T> extends StatelessWidget {
  const AppChipRow({
    required this.items,
    required this.value,
    super.key,
    this.onChanged,
    this.padding = EdgeInsets.zero,
    this.spacing = AppSpacing.xsm,
    this.controller,
  });

  final List<AppChipRowItem<T>> items;
  final T value;
  final ValueChanged<T>? onChanged;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return AppHorizontalScrollView(
      padding: padding,
      controller: controller,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (index, item) in items.indexed) ...[
            if (index > 0) SizedBox(width: spacing),
            AppChip.filter(
              label: item.label,
              leadingIcon: item.icon,
              count: item.count,
              selected: item.value == value,
              onTap:
                  onChanged == null ? null : () => onChanged?.call(item.value),
            ),
          ],
        ],
      ),
    );
  }
}

class AppChipRowItem<T> {
  const AppChipRowItem({
    required this.value,
    required this.label,
    this.icon,
    this.count,
  });

  final T value;
  final String label;
  final AppLineIcon? icon;
  final int? count;
}
