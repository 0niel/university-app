import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/widgets/map_pill_button.dart';

class MapRoomSheet extends StatelessWidget {
  const MapRoomSheet({required this.room, super.key});

  final RoomModel room;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final name = room.name.isEmpty ? room.roomId : room.name;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Container(
          padding: const .all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(NinjaRadius.card),
          ),
          child: Row(
            children: [
              Container(
                width: NinjaMetrics.minTouchTarget,
                height: NinjaMetrics.minTouchTarget,
                alignment: .center,
                decoration: BoxDecoration(
                  color: colors.surfaceAlt,
                  shape: .circle,
                ),
                child: AppLineIconWidget(
                  .door,
                  size: 20,
                  color: colors.brandInk,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: NinjaText.headline.copyWith(color: colors.ink),
                    ),
                    if (room.roomId != name) ...[
                      const SizedBox(height: 3),
                      Text(
                        room.roomId,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: NinjaText.subtext.copyWith(color: colors.muted),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        MapPillButton(
          label: context.l10n.findSchedule,
          onTap: () => Navigator.of(context).pop(true),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
