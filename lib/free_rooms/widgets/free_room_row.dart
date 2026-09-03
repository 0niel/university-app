import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_view_model.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class FreeRoomRow extends StatelessWidget {
  const FreeRoomRow({required this.room, this.onTap, super.key});

  final FreeRoomViewModel room;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final tone = room.urgent ? colors.exam : colors.lecture;
    final untilLabel = room.untilLabel(l10n);

    return AppPressable(
      onTap: onTap,
      pressedScale: 1,
      semanticsLabel: '${room.name}, ${room.subtitle(l10n)}, $untilLabel',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: ExcludeSemantics(
          child: Row(
            children: [
              AppIconTile(
                size: 44,
                radius: AppRadius.tile,
                background: colors.tintOf(tone),
                child: Text(
                  room.tileLabel,
                  style: AppText.sans(
                    13,
                    FontWeight.w800,
                  ).copyWith(color: tone),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          room.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.sans(
                            15.5,
                            FontWeight.w700,
                          ).copyWith(color: colors.ink),
                        ),
                        if (room.booked) ...[
                          _BookedBadge(label: l10n.freeRoomsYourSeat),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      room.subtitle(l10n),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.sans(
                        12.5,
                        FontWeight.w500,
                      ).copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      untilLabel,
                      style: AppText.sans(
                        12,
                        FontWeight.w700,
                        tabular: true,
                      ).copyWith(color: tone),
                    ),
                    if (room.leftLabel(l10n) case final left?) ...[
                      const SizedBox(height: 2),
                      Text(
                        left,
                        style: AppText.sans(
                          11,
                          FontWeight.w500,
                        ).copyWith(color: colors.muted),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookedBadge extends StatelessWidget {
  const _BookedBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.lectureTint,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          label,
          style: AppText.sans(
            10.5,
            FontWeight.w800,
          ).copyWith(color: colors.lecture),
        ),
      ),
    );
  }
}
