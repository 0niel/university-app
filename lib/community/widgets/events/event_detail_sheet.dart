import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/community/models/event_category.dart';
import 'package:rtu_mirea_app/community/widgets/emoji_tile.dart';
import 'package:rtu_mirea_app/community/widgets/event_category_style.dart';
import 'package:rtu_mirea_app/community/widgets/events/event_layout.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:share_plus/share_plus.dart';

enum EventDetailAction { edit, delete }

Future<EventDetailAction?> showEventDetailSheet(
  BuildContext context, {
  required CampusEvent event,
}) {
  return showAppSheet<EventDetailAction>(
    context,
    title: event.title,
    child: _EventDetailBody(event: event),
  );
}

Future<void> _shareEvent(BuildContext context, CampusEvent event) {
  final parts = [
    event.title,
    eventTimeRange(context, event),
    if (event.place.isNotEmpty) event.place,
  ];
  return SharePlus.instance.share(ShareParams(text: parts.join(' · ')));
}

class _EventDetailBody extends StatelessWidget {
  const _EventDetailBody({required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final category = EventCategory.fromWireName(event.category);
    final showMap = looksLikeCampusRoom(event.place);
    final description = event.description.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
                mainAxisSize: MainAxisSize.min,
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
                    eventTimeRange(context, event),
                    style: AppText.subtextStrong.copyWith(color: colors.ink),
                  ),
                  if (event.place.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      event.place,
                      style: AppText.subtext.copyWith(color: colors.muted),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Text(
          description.isEmpty ? l10n.eventsDetailDescriptionEmpty : description,
          style: AppText.body.copyWith(
            color: description.isEmpty ? colors.muted2 : colors.ink,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Row(
          children: [
            if (showMap) ...[
              Expanded(
                child: AppButton.secondary(
                  label: l10n.eventsDetailMap,
                  icon: const AppLineIconWidget(AppLineIcon.map),
                  onPressed: () => unawaited(context.push('/services/map')),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: AppButton.secondary(
                label: l10n.share,
                icon: const AppLineIconWidget(AppLineIcon.share),
                onPressed: () => unawaited(_shareEvent(context, event)),
              ),
            ),
          ],
        ),
        if (event.isMine) ...[
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton.tonal(
                  label: l10n.eventsEdit,
                  onPressed: () =>
                      Navigator.of(context).pop(EventDetailAction.edit),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton.destructiveOutline(
                  label: l10n.delete,
                  onPressed: () =>
                      Navigator.of(context).pop(EventDetailAction.delete),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
