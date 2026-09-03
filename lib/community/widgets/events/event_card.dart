import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/community/models/event_category.dart';
import 'package:rtu_mirea_app/community/widgets/emoji_tile.dart';
import 'package:rtu_mirea_app/community/widgets/event_category_style.dart';
import 'package:rtu_mirea_app/community/widgets/events/event_layout.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    required this.event,
    required this.onToggleRsvp,
    required this.onTap,
    super.key,
    this.isPending = false,
    this.isPast = false,
  });

  final CampusEvent event;
  final VoidCallback onToggleRsvp;
  final VoidCallback onTap;
  final bool isPending;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final category = EventCategory.fromWireName(event.category);
    final meta = [
      eventTimeRange(context, event),
      if (event.place.isNotEmpty) event.place,
    ].join(' · ');
    final extraGoing = math.max(0, event.goingCount - event.goingNames.length);

    return AppCard(
      radius: AppRadius.row,
      onTap: onTap,
      semanticsLabel: event.title,
      child: Opacity(
        opacity: isPast ? .6 : 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EmojiTile(
                  emoji: event.emoji,
                  size: EventLayout.emojiTileSize,
                  emojiSize: 22,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: AppSpacing.xsm,
                        runSpacing: AppSpacing.xsm,
                        children: [
                          AppTag(
                            label: eventCategoryLabel(l10n, category),
                            tone: eventCategoryTagTone(category),
                          ),
                          if (event.isMine) AppTag(label: l10n.eventsMineBadge),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        event.title,
                        style: AppText.sans(
                          16,
                          FontWeight.w700,
                          height: 1.25,
                        ).copyWith(color: colors.ink),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        meta,
                        style: AppText.subtext.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                if (event.goingNames.isNotEmpty) ...[
                  AppAvatarStack(
                    names: event.goingNames,
                    size: 26,
                    maxVisible: 3,
                    extra: extraGoing,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    l10n.eventsGoingCount(event.goingCount),
                    style: AppText.subtextStrong.copyWith(color: colors.muted),
                  ),
                ),
                const SizedBox(width: AppSpacing.gap),
                _RsvpPill(
                  isGoing: event.isGoing,
                  isPending: isPending,
                  enabled: !isPast,
                  onPressed: onToggleRsvp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RsvpPill extends StatelessWidget {
  const _RsvpPill({
    required this.isGoing,
    required this.isPending,
    required this.enabled,
    required this.onPressed,
  });

  final bool isGoing;
  final bool isPending;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final label = isGoing ? l10n.eventsGoingChecked : l10n.eventsRsvp;
    final background = !enabled
        ? colors.surface2
        : isGoing
        ? colors.lecture
        : colors.accent;
    final foreground = !enabled ? colors.muted2 : colors.white;
    return AppPressState(
      enabled: enabled && !isPending,
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
