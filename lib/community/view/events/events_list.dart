part of '../events_view.dart';

class _EventsList extends StatelessWidget {
  const _EventsList({required this.state, super.key});

  final EventsState state;

  @override
  Widget build(BuildContext context) {
    final featured = state.featuredEvent;
    if (featured == null) return const SizedBox.shrink();
    final upcoming = state.upcomingEvents;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FeaturedEventCard(
          event: featured,
          isRsvpPending: state.pendingRsvps.contains(featured.id),
          onRsvp: () => unawaited(_toggleRsvp(context, featured.id)),
        ).animateListItem(),
        if (upcoming.isNotEmpty) ...[
          NinjaSectionTitle(
            title: context.l10n.eventsSectionUpcoming,
            count: upcoming.length,
          ).animateListItem(index: 1),
          for (final (index, event) in upcoming.indexed)
            EventRow(
              event: event,
              isRsvpPending: state.pendingRsvps.contains(event.id),
              onRsvp: () => unawaited(_toggleRsvp(context, event.id)),
            ).animateListItem(key: ValueKey(event.id), index: index + 2),
        ],
      ],
    );
  }

  Future<void> _toggleRsvp(BuildContext context, String eventId) async {
    final succeeded = await context.read<EventsCubit>().toggleRsvp(eventId);
    if (!succeeded && context.mounted) {
      showNinjaToast(
        context,
        message: context.l10n.eventsRsvpError,
        showCheck: false,
      );
    }
  }
}
