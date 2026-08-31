import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppChipRow<T> extends StatelessWidget {
  const AppChipRow({
    required this.items,
    required this.value,
    super.key,
    this.onChanged,
    this.padding = EdgeInsets.zero,
  });

  final List<AppChipRowItem<T>> items;
  final T value;
  final ValueChanged<T>? onChanged;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: padding,
        child: Row(
          children: [
            for (final (index, item) in items.indexed) ...[
              _buildChipRowButton(
                context: context,
                item: item,
                selected: item.value == value,
                onTap: () => onChanged?.call(item.value),
              ),
              if (index < items.length - 1) const SizedBox(width: 6),
            ],
          ],
        ),
      );
}

class AppChipRowItem<T> {
  const AppChipRowItem({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final IconData? icon;
}

Widget _buildChipRowButton<T>({
  required BuildContext context,
  required AppChipRowItem<T> item,
  required bool selected,
  required VoidCallback onTap,
}) {
  final colors = context.colors;
  return Material(
    color: selected ? colors.primary : colors.surface,
    borderRadius: BorderRadius.circular(AppRadius.full),
    clipBehavior: Clip.antiAlias,
    child: AppPressable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                size: AppIconSize.xs,
                color: selected ? colors.onAccent : colors.deactive,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              item.label,
              style: AppText.button.copyWith(
                color: selected ? colors.onAccent : colors.deactive,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
