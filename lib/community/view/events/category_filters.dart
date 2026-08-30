part of '../events_view.dart';

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters({required this.selected});

  static const List<EventCategory> _categories = [
    EventCategory.all,
    EventCategory.career,
    EventCategory.sport,
    EventCategory.art,
    EventCategory.science,
  ];

  final EventCategory selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return NinjaFilterBar(
      value: selected.wireName,
      onChanged: (value) => context.read<EventsCubit>().categoryChanged(
        EventCategory.fromWireName(value),
      ),
      items: [
        for (final category in _categories)
          (category.wireName, eventCategoryLabel(l10n, category)),
      ],
    );
  }
}
