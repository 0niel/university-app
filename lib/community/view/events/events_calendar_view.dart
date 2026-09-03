import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/community/cubit/events/events_cubit.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/widgets/event_category_style.dart';
import 'package:rtu_mirea_app/community/widgets/events/event_card.dart';
import 'package:rtu_mirea_app/community/widgets/events/event_layout.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class EventsCalendarView extends StatefulWidget {
  const EventsCalendarView({
    required this.state,
    required this.onToggleRsvp,
    required this.onOpen,
    super.key,
  });

  final EventsState state;
  final ValueChanged<CampusEvent> onToggleRsvp;
  final ValueChanged<CampusEvent> onOpen;

  @override
  State<EventsCalendarView> createState() => _EventsCalendarViewState();
}

class _EventsCalendarViewState extends State<EventsCalendarView> {
  late DateTime _month = _monthOf(DateTime.now());
  late DateTime _selectedDay = _dayOf(DateTime.now());

  static DateTime _monthOf(DateTime date) => DateTime(date.year, date.month);

  static DateTime _dayOf(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  List<CampusEvent> _eventsOn(DateTime day) => widget.state.events
      .where((event) => isSameCalendarDay(event.startsAt, day))
      .toList();

  List<Color> _dotsFor(BuildContext context, DateTime day) {
    final colors = context.colors;
    return [
      for (final event in _eventsOn(day).take(4))
        eventCategoryColor(
          colors,
          EventCategory.fromWireName(event.category),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final dayEvents = _eventsOn(_selectedDay)
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCalendarMonth(
          key: const ValueKey('events-calendar-month'),
          month: _month,
          today: now,
          selectedDay: _selectedDay,
          onMonthChanged: (month) => setState(() => _month = _monthOf(month)),
          onDaySelected: (day) => setState(() {
            _selectedDay = _dayOf(day);
            _month = _monthOf(day);
          }),
          dotsForDay: (day) => _dotsFor(context, day),
        ),
        const SizedBox(height: AppSpacing.cardGap),
        AppOverline(_selectedDayLabel(context, now), topPadding: 0),
        if (dayEvents.isEmpty)
          AppEmptyState.compact(
            key: const ValueKey('events-calendar-empty'),
            title: l10n.eventsCalendarEmptyTitle,
          )
        else
          for (final (index, event) in dayEvents.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.cardGap),
            EventCard(
              key: ValueKey(event.id),
              event: event,
              isPending: widget.state.pendingRsvps.contains(event.id),
              isPast: isEventPast(event, now),
              onToggleRsvp: () => widget.onToggleRsvp(event),
              onTap: () => widget.onOpen(event),
            ),
          ],
      ],
    );
  }

  String _selectedDayLabel(BuildContext context, DateTime now) {
    final l10n = context.l10n;
    final today = _dayOf(now);
    if (isSameCalendarDay(_selectedDay, today)) return l10n.eventsFilterToday;
    if (isSameCalendarDay(_selectedDay, today.add(const Duration(days: 1)))) {
      return l10n.pickerTomorrow;
    }
    final locale = Localizations.localeOf(context).toString();
    final formatted = DateFormat('EEEE, d MMMM', locale).format(_selectedDay);
    return formatted.isEmpty
        ? formatted
        : '${formatted[0].toUpperCase()}${formatted.substring(1)}';
  }
}
