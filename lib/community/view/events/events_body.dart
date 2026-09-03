import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/community/cubit/events/events_cubit.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/widgets/events/event_card.dart';
import 'package:rtu_mirea_app/community/widgets/events/event_layout.dart';
import 'package:rtu_mirea_app/community/widgets/events/events_skeleton.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class EventsBody extends StatelessWidget {
  const EventsBody({
    required this.state,
    required this.filter,
    required this.onRetry,
    required this.onCreate,
    required this.onToggleRsvp,
    required this.onOpen,
    super.key,
  });

  final EventsState state;
  final EventsFilter filter;
  final VoidCallback onRetry;
  final VoidCallback onCreate;
  final ValueChanged<CampusEvent> onToggleRsvp;
  final ValueChanged<CampusEvent> onOpen;

  @override
  Widget build(BuildContext context) {
    return AppStateSwitcher(child: _content(context));
  }

  Widget _content(BuildContext context) {
    final l10n = context.l10n;
    if (state.status == .loading && state.events.isEmpty) {
      return const EventsSkeleton(key: ValueKey('events-loading'));
    }
    if (state.status == .failure && state.events.isEmpty) {
      return AppErrorState(
        key: const ValueKey('events-failure'),
        title: l10n.eventsLoadError,
        message: l10n.eventsLoadErrorSub,
        primaryLabel: l10n.retry,
        onPrimary: onRetry,
      );
    }
    final now = DateTime.now();
    final matching = state.events
        .where((event) => filter.matches(event, now))
        .toList();
    if (filter == .past) {
      matching.sort((a, b) => b.startsAt.compareTo(a.startsAt));
    }
    if (matching.isEmpty) {
      return switch (filter) {
        .going => AppEmptyState(
          key: const ValueKey('events-empty-going'),
          title: l10n.eventsEmptyGoingTitle,
          subtitle: l10n.eventsEmptyGoingSub,
        ),
        .today => AppEmptyState(
          key: const ValueKey('events-empty-today'),
          title: l10n.eventsEmptyTodayTitle,
          subtitle: l10n.eventsEmptySubtitle,
        ),
        .past => AppEmptyState(
          key: const ValueKey('events-empty-past'),
          title: l10n.eventsEmptyTitle,
          subtitle: l10n.eventsEmptyPastSub,
        ),
        .all => AppEmptyState(
          key: const ValueKey('events-empty'),
          lineIcon: AppLineIcon.calendar,
          title: l10n.eventsEmptyTitle,
          subtitle: l10n.eventsEmptySubtitle,
          actionLabel: l10n.eventsCreateCta,
          onAction: onCreate,
        ),
      };
    }

    final groups = _groupByDay(matching);
    return Column(
      key: ValueKey('events-list-${filter.name}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (groupIndex, group) in groups.indexed) ...[
          if (groupIndex > 0) const SizedBox(height: AppSpacing.sectionGap),
          AppOverline(_dayLabel(context, group.key, now), topPadding: 0),
          for (final (index, event) in group.value.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.cardGap),
            EventCard(
              key: ValueKey(event.id),
              event: event,
              isPending: state.pendingRsvps.contains(event.id),
              isPast: isEventPast(event, now),
              onToggleRsvp: () => onToggleRsvp(event),
              onTap: () => onOpen(event),
            ).animateListItem(index: index),
          ],
        ],
      ],
    );
  }

  List<MapEntry<DateTime, List<CampusEvent>>> _groupByDay(
    List<CampusEvent> events,
  ) {
    final map = <DateTime, List<CampusEvent>>{};
    for (final event in events) {
      final day = DateTime(
        event.startsAt.year,
        event.startsAt.month,
        event.startsAt.day,
      );
      map.putIfAbsent(day, () => []).add(event);
    }
    return map.entries.toList();
  }

  String _dayLabel(BuildContext context, DateTime day, DateTime now) {
    final l10n = context.l10n;
    final today = DateTime(now.year, now.month, now.day);
    if (isSameCalendarDay(day, today)) return l10n.eventsFilterToday;
    if (isSameCalendarDay(day, today.add(const Duration(days: 1)))) {
      return l10n.pickerTomorrow;
    }
    if (isSameCalendarDay(day, today.subtract(const Duration(days: 1)))) {
      return l10n.eventsDayYesterday;
    }
    final locale = Localizations.localeOf(context).toString();
    final formatted = DateFormat('EEE, d MMMM', locale).format(day);
    return formatted.isEmpty
        ? formatted
        : '${formatted[0].toUpperCase()}${formatted.substring(1)}';
  }
}
