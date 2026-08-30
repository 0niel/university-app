part of '../create_event_sheet.dart';

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({required this.selected, required this.onSelected});

  final EventCategory selected;
  final ValueChanged<EventCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return NinjaChipRow(
      padding: EdgeInsets.zero,
      children: [
        for (final option in EventCategory.values.where(
          (candidate) => candidate != .all,
        ))
          _CategoryChoice(
            category: option,
            isSelected: option == selected,
            onSelected: onSelected,
          ),
      ],
    );
  }
}
