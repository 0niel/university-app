part of '../create_event_sheet.dart';

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({required this.selected, required this.onSelected});

  final EventCategory selected;
  final ValueChanged<EventCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppChipRow<EventCategory>(
      value: selected,
      onChanged: onSelected,
      items: [
        for (final category in EventCategory.values.where(
          (candidate) => candidate != .all,
        ))
          AppChipRowItem(
            value: category,
            label: eventCategoryLabel(l10n, category),
          ),
      ],
    );
  }
}
