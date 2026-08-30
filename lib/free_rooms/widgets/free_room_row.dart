import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'free_until_pill.dart';

class FreeRoomRow extends StatelessWidget {
  const FreeRoomRow({required this.room, super.key});

  final FreeRoom room;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final campus = room.campus ?? '';
    final building = room.building;
    final until = room.freeUntil;
    final freeLabel = until == null
        ? l10n.freeRoomsUntilEndOfDay
        : l10n.freeRoomsFreeUntil(
            DateFormat.Hm(
              Localizations.localeOf(context).languageCode,
            ).format(until.toLocal()),
          );
    final meta = [
      if (building.isNotEmpty) building,
      if (campus.isNotEmpty) l10n.freeRoomsCampus(campus),
    ].join(' · ');

    return Semantics(
      container: true,
      label: '${room.room}, $meta, $freeLabel',
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        padding: const .all(16),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.brandTint,
                borderRadius: .circular(NinjaRadius.control),
              ),
              child: SizedBox.square(
                dimension: NinjaMetrics.minTouchTarget,
                child: Center(
                  child: AppLineIconWidget(.door, color: colors.brand),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  Text(
                    room.room,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: NinjaText.headline.copyWith(color: colors.ink),
                  ),
                  if (meta.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: NinjaText.subtext.copyWith(color: colors.muted),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            AppRowTrailing(child: _FreeUntilPill(label: freeLabel)),
          ],
        ),
      ),
    );
  }
}
