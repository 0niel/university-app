import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_filter_chip.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:flutter/material.dart';

class MultiSelectChip<T> extends StatelessWidget {
  const MultiSelectChip({
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
    required this.labelBuilder,
    super.key,
    this.chipColorBuilder,
    this.spacing = AppSpacing.sm,
    this.runSpacing = AppSpacing.sm,
    this.maxItems,
    this.icon,
    this.isSingleSelect = false,
    this.label,
    this.overflowLabelBuilder,
  });

  final List<T> items;
  final List<T> selectedItems;
  final void Function(List<T>) onSelectionChanged;
  final String Function(T item) labelBuilder;
  final Color? Function(T item)? chipColorBuilder;
  final double spacing;
  final double runSpacing;
  final int? maxItems;
  final AppLineIcon? icon;
  final bool isSingleSelect;
  final String? label;
  final String Function(int hidden)? overflowLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final maxItems = this.maxItems;
    final label = this.label;
    final displayed = maxItems != null && items.length > maxItems
        ? items.sublist(0, maxItems)
        : items;
    final hidden = maxItems == null ? 0 : items.length - maxItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label, style: AppText.bodyStrong.copyWith(color: colors.ink)),
          const SizedBox(height: AppSpacing.md),
        ],
        Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: [
            for (final item in displayed)
              AppChip(
                label: labelBuilder(item),
                leadingIcon: icon,
                color: chipColorBuilder?.call(item),
                selected: selectedItems.contains(item),
                onTap: () => _toggle(item),
              ),
          ],
        ),
        if (hidden > 0) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            overflowLabelBuilder?.call(hidden) ?? '+$hidden',
            style: AppText.caption.copyWith(color: colors.muted),
          ),
        ],
      ],
    );
  }

  void _toggle(T item) {
    final selected = !selectedItems.contains(item);
    if (isSingleSelect) {
      onSelectionChanged(selected ? [item] : <T>[]);
      return;
    }
    final next = <T>[...selectedItems];
    if (selected) {
      next.add(item);
    } else {
      next.remove(item);
    }
    onSelectionChanged(next);
  }
}
