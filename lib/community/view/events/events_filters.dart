import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class EventsFilters extends StatelessWidget {
  const EventsFilters({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final EventsFilter value;
  final ValueChanged<EventsFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = {
      EventsFilter.all: l10n.eventsFilterAll,
      EventsFilter.today: l10n.eventsFilterToday,
      EventsFilter.going: l10n.eventsFilterGoing,
    };
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final filter in EventsFilter.values)
          AppChip.filter(
            label: labels[filter] ?? '',
            selected: filter == value,
            onTap: () => onChanged(filter),
          ),
      ],
    );
  }
}
