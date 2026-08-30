part of '../create_event_sheet.dart';

class _CategoryChoice extends StatelessWidget {
  const _CategoryChoice({
    required this.category,
    required this.isSelected,
    required this.onSelected,
  });

  final EventCategory category;
  final bool isSelected;
  final ValueChanged<EventCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return NinjaChip(
      label: eventCategoryLabel(context.l10n, category),
      selected: isSelected,
      onTap: () => onSelected(category),
    );
  }
}
