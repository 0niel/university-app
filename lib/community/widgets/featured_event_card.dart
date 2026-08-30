import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'events/event_metadata.dart';
part 'events/event_title.dart';
part 'events/featured_actions.dart';
part 'events/featured_banner.dart';

class FeaturedEventCard extends StatelessWidget {
  const FeaturedEventCard({
    required this.event,
    required this.onRsvp,
    super.key,
    this.isRsvpPending = false,
  });

  final CampusEvent event;
  final VoidCallback onRsvp;
  final bool isRsvpPending;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        8,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.accentSoft,
          borderRadius: BorderRadius.circular(NinjaRadius.card),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FeaturedBanner(emoji: event.emoji),
              const SizedBox(height: 12),
              _EventTitle(title: event.title),
              const SizedBox(height: 6),
              _EventMetadata(event: event),
              const SizedBox(height: 14),
              _FeaturedActions(
                event: event,
                onRsvp: onRsvp,
                isPending: isRsvpPending,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
