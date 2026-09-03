import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/community/models/event_category.dart';
import 'package:rtu_mirea_app/community/widgets/event_category_style.dart';
import 'package:rtu_mirea_app/community/widgets/events/event_layout.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    required this.event,
    required this.onToggleRsvp,
    super.key,
    this.isPending = false,
  });

  final CampusEvent event;
  final VoidCallback onToggleRsvp;
  final bool isPending;

  static String formatWhen(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    final local = date.toLocal();
    final day = DateFormat('EEE d MMM', locale).format(local);
    final time = DateFormat.Hm(locale).format(local);
    final capitalized = day.isEmpty
        ? day
        : '${day[0].toUpperCase()}${day.substring(1)}';
    return '$capitalized · $time';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final category = EventCategory.fromWireName(event.category);
    final color = eventCategoryColor(colors, category);
    final meta = [
      formatWhen(context, event.startsAt),
      if (event.place.isNotEmpty) event.place,
    ].join(' · ');
    return AppCard(
      radius: AppRadius.row,
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.row),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: EventLayout.coverHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const AppStripePlaceholder(),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: _Pill(
                      label: eventCategoryLabel(l10n, category),
                      background: colors.tintOf(color),
                      foreground: color,
                      style: AppText.microBold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sectionGap,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: AppText.sans(
                      16,
                      FontWeight.w700,
                      height: 1.25,
                    ).copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    meta,
                    style: AppText.subtext.copyWith(color: colors.muted),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.eventsGoingCount(event.goingCount),
                          style: AppText.subtextStrong.copyWith(
                            color: colors.muted,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.gap),
                      _RsvpPill(
                        isGoing: event.isGoing,
                        isPending: isPending,
                        onPressed: onToggleRsvp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.background,
    required this.foreground,
    required this.style,
  });

  final String label;
  final Color background;
  final Color foreground;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.gap,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(label, style: style.copyWith(color: foreground)),
    );
  }
}

class _RsvpPill extends StatelessWidget {
  const _RsvpPill({
    required this.isGoing,
    required this.isPending,
    required this.onPressed,
  });

  final bool isGoing;
  final bool isPending;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final label = isGoing ? l10n.eventsGoingChecked : l10n.eventsRsvp;
    final background = isGoing ? colors.lecture : colors.accent;
    final foreground = colors.white;
    return AppPressState(
      enabled: !isPending,
      onTap: () {
        unawaited(HapticFeedback.lightImpact());
        onPressed();
      },
      semanticsLabel: label,
      semanticsButton: true,
      semanticsSelected: isGoing,
      builder: (context, {required pressed}) => AnimatedOpacity(
        duration: const Duration(milliseconds: 120),
        opacity: pressed ? .82 : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: EventLayout.rsvpTouchPadding,
          ),
          child: Container(
            key: const Key('eventCard_rsvpSurface'),
            constraints: const BoxConstraints(
              minHeight: EventLayout.rsvpHeight,
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: isPending
                ? AppButtonSpinner(
                    color: foreground,
                    trackColor: foreground.withValues(alpha: .35),
                  )
                : Text(
                    label,
                    style: AppText.labelStrong.copyWith(color: foreground),
                  ),
          ),
        ),
      ),
    );
  }
}
