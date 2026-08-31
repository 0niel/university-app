import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MultiSelectChip<T> extends StatelessWidget {
  const MultiSelectChip({
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
    required this.labelBuilder,
    super.key,
    this.chipColorBuilder,
    this.selectedColor,
    this.unselectedColor,
    this.borderRadius = 12.0,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.maxItems,
    this.direction = Axis.horizontal,
    this.icon,
    this.isSingleSelect = false,
    this.label,
  });

  final List<T> items;

  final List<T> selectedItems;

  final void Function(List<T>) onSelectionChanged;

  final String Function(T item) labelBuilder;

  final Color? Function(T item)? chipColorBuilder;

  final Color? selectedColor;

  final Color? unselectedColor;

  final double borderRadius;

  final double spacing;

  final double runSpacing;

  final int? maxItems;

  final Axis direction;

  final IconData? icon;

  final bool isSingleSelect;

  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final defaultSelectedColor = colors.primary;
    final defaultUnselectedColor = colors.background03;
    final maxItems = this.maxItems;
    final label = this.label;

    final displayedItems = maxItems != null && items.length > maxItems
        ? items.sublist(0, maxItems)
        : items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: AppText.bodyStrong.copyWith(
              color: colors.active,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
        ],
        Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          direction: direction,
          children: displayedItems.map((item) {
            final isSelected = selectedItems.contains(item);
            final itemColor = chipColorBuilder?.call(item);

            final activeColor =
                selectedColor ?? itemColor ?? defaultSelectedColor;
            final inactiveColor = unselectedColor ?? defaultUnselectedColor;

            void handleSelected() {
              final selected = !isSelected;
              var newSelectedItems = <T>[...selectedItems];

              if (isSingleSelect) {
                if (selected) {
                  newSelectedItems = [item];
                } else {
                  newSelectedItems = [];
                }
              } else {
                if (selected) {
                  newSelectedItems.add(item);
                } else {
                  newSelectedItems.remove(item);
                }
              }

              onSelectionChanged(newSelectedItems);
            }

            return AppPressable(
              onTap: handleSelected,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? activeColor.withValues(alpha: 0.15)
                      : inactiveColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: isSelected ? activeColor : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 16,
                        color: isSelected ? activeColor : colors.deactive,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      labelBuilder(item),
                      style: AppText.caption.copyWith(
                        color: isSelected ? activeColor : colors.deactive,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (maxItems != null && items.length > maxItems) ...[
          const SizedBox(height: 8),
          Text(
            'Ещё ${items.length - maxItems} элемент(ов)',
            style: AppText.caption.copyWith(
              color: colors.deactive,
            ),
          ),
        ],
      ],
    );
  }
}
