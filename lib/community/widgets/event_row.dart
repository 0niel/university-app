import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/community/models/event_category.dart';
import 'package:rtu_mirea_app/community/widgets/event_category_style.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'events/event_date.dart';
part 'events/event_stats.dart';
part 'events/event_summary.dart';
part 'events/rsvp_pill.dart';

class EventRow extends StatelessWidget {
  const EventRow({
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
    final category = EventCategory.fromWireName(event.category);
    final compact = MediaQuery.textScalerOf(context).scale(14) > 19;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(NinjaRadius.card),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.brandTint,
                      borderRadius: BorderRadius.circular(NinjaRadius.control),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 9,
                      ),
                      child: _EventDate(event: event, color: colors.brandInk),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _EventSummary(event: event, category: category),
                  ),
                  if (!compact) ...[
                    const SizedBox(width: 10),
                    _RsvpPill(
                      isGoing: event.isGoing,
                      isPending: isRsvpPending,
                      onPressed: onRsvp,
                    ),
                  ],
                ],
              ),
              if (compact) ...[
                const SizedBox(height: 12),
                _RsvpPill(
                  isGoing: event.isGoing,
                  isPending: isRsvpPending,
                  onPressed: onRsvp,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
