import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/cubit/events/events_cubit.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/widgets/events/event_card.dart';
import 'package:rtu_mirea_app/community/widgets/events/events_empty_card.dart';
import 'package:rtu_mirea_app/community/widgets/events/events_skeleton.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class EventsBody extends StatelessWidget {
  const EventsBody({
    required this.state,
    required this.filter,
    required this.onRetry,
    required this.onCreate,
    required this.onToggleRsvp,
    super.key,
  });

  final EventsState state;
  final EventsFilter filter;
  final VoidCallback onRetry;
  final VoidCallback onCreate;
  final ValueChanged<CampusEvent> onToggleRsvp;

  @override
  Widget build(BuildContext context) {
    return NinjaStateSwitcher(child: _content(context));
  }

  Widget _content(BuildContext context) {
    final l10n = context.l10n;
    if (state.status == .loading && state.events.isEmpty) {
      return const EventsSkeleton(key: ValueKey('events-loading'));
    }
    if (state.status == .failure && state.events.isEmpty) {
      return NinjaErrorState(
        key: const ValueKey('events-failure'),
        title: l10n.eventsLoadError,
        message: l10n.eventsLoadErrorSub,
        retryLabel: l10n.retry,
        onRetry: onRetry,
      );
    }
    final now = DateTime.now();
    final events = state.events
        .where((event) => filter.matches(event, now))
        .toList(growable: false);
    if (events.isEmpty) {
      return switch (filter) {
        .going => EventsEmptyCard(
          key: const ValueKey('events-empty-going'),
          title: l10n.eventsEmptyGoingTitle,
          subtitle: l10n.eventsEmptyGoingSub,
        ),
        .today => EventsEmptyCard(
          key: const ValueKey('events-empty-today'),
          title: l10n.eventsEmptyTodayTitle,
          subtitle: l10n.eventsEmptySubtitle,
        ),
        .all => NinjaEmptyState(
          key: const ValueKey('events-empty'),
          icon: const AppLineIconWidget(AppLineIcon.calendar, size: 24),
          title: l10n.eventsEmptyTitle,
          message: l10n.eventsEmptySubtitle,
          actionLabel: l10n.eventsCreateCta,
          onAction: onCreate,
        ),
      };
    }
    return Column(
      key: ValueKey('events-list-${filter.name}'),
      children: [
        for (final (index, event) in events.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.cardGap),
          EventCard(
            key: ValueKey(event.id),
            event: event,
            isPending: state.pendingRsvps.contains(event.id),
            onToggleRsvp: () => onToggleRsvp(event),
          ).animateListItem(index: index),
        ],
      ],
    );
  }
}
