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

  /// Список всех доступных элементов
  final List<T> items;

  /// Список выбранных элементов
  final List<T> selectedItems;

  /// Вызывается при изменении выбора
  final Function(List<T>) onSelectionChanged;

  /// Функция для создания текста чипа
  final String Function(T item) labelBuilder;

  /// Функция для создания цвета чипа (опционально)
  final Color? Function(T item)? chipColorBuilder;

  /// Цвет выбранного чипа
  final Color? selectedColor;

  /// Цвет невыбранного чипа
  final Color? unselectedColor;

  /// Радиус скругления чипов
  final double borderRadius;

  /// Горизонтальный отступ между чипами
  final double spacing;

  /// Вертикальный отступ между строками чипов
  final double runSpacing;

  /// Максимальное количество отображаемых чипов
  final int? maxItems;

  /// Направление списка чипов
  final Axis direction;

  /// Иконка для чипов (опционально)
  final IconData? icon;

  /// Если true, можно выбрать только один элемент
  final bool isSingleSelect;

  /// Заголовок для группы чипов (опционально)
  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final defaultSelectedColor = colors.primary;
    final defaultUnselectedColor = colors.background03;

    // Применяем ограничение количества элементов, если задано
    final displayedItems = maxItems != null && items.length > maxItems! ? items.sublist(0, maxItems) : items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyle.titleS.copyWith(
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

            // Для выбранного чипа используем заданный цвет или цвет элемента, или цвет по умолчанию
            final activeColor = selectedColor ?? itemColor ?? defaultSelectedColor;
            // Для невыбранного чипа используем заданный цвет или прозрачный фон
            final inactiveColor = unselectedColor ?? defaultUnselectedColor;

            return ChoiceChip(
              label: Text(
                labelBuilder(item),
                style: AppTextStyle.captionL.copyWith(
                  color: isSelected ? activeColor : colors.deactive,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              avatar: icon != null
                  ? Icon(
                      icon,
                      size: 16,
                      color: isSelected ? activeColor : colors.deactive,
                    )
                  : null,
              selected: isSelected,
              selectedColor: activeColor.withOpacity(0.15),
              backgroundColor: inactiveColor.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side: BorderSide(
                  color: isSelected ? activeColor : Colors.transparent,
                  width: 1.5,
                ),
              ),
              onSelected: (selected) {
                var newSelectedItems = <T>[...selectedItems];

                // Для режима единственного выбора
                if (isSingleSelect) {
                  if (selected) {
                    newSelectedItems = [item];
                  } else {
                    newSelectedItems = [];
                  }
                } else {
                  // Для множественного выбора
                  if (selected) {
                    newSelectedItems.add(item);
                  } else {
                    newSelectedItems.remove(item);
                  }
                }

                onSelectionChanged(newSelectedItems);
              },
            );
          }).toList(),
        ),

        // Показываем "Ещё X элементов" если есть ограничение
        if (maxItems != null && items.length > maxItems!) ...[
          const SizedBox(height: 8),
          Text(
            'Ещё ${items.length - maxItems!} элемент(ов)',
            style: AppTextStyle.captionL.copyWith(
              color: colors.deactive,
            ),
          ),
        ],
      ],
    );
  }
}
