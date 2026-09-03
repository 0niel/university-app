import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_view_model.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_gallery.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Future<void> showFreeRoomSheet(
  BuildContext context,
  FreeRoomViewModel room, {
  VoidCallback? onRoute,
}) => showAppSheet<void>(
  context,
  child: FreeRoomSheet(room: room, onRoute: onRoute),
);

class FreeRoomSheet extends StatelessWidget {
  const FreeRoomSheet({required this.room, this.onRoute, super.key});

  final FreeRoomViewModel room;
  final VoidCallback? onRoute;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final largeText = MediaQuery.textScalerOf(context).scale(14) > 19;
    final now = DateTime.now();
    final current = FreeRoomViewModel(
      room: room.room,
      now: now,
      floor: room.floor,
      locale: l10n.localeName,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        RoomPhotoGallery(campus: current.campus, roomName: current.name),
        const SizedBox(height: AppSpacing.lg),
        _RoomHeading(room: current, largeText: largeText),
        const SizedBox(height: AppSpacing.sectionGap),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _RoomStat(
                  label: l10n.roomStatFreeFor,
                  value: current.leftLabel(l10n) ?? l10n.freeRoomsUntilEndOfDay,
                ),
              ),
              const SizedBox(width: AppSpacing.cardGap),
              Expanded(
                child: _RoomStat(
                  label: l10n.roomStatFloor,
                  value: room.floor?.toString() ?? l10n.unknown,
                ),
              ),
            ],
          ),
        ),
        if (current.campus.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.cardGap),
          _RoomStat(
            label: l10n.roomStatBuilding,
            value: current.campus,
            compact: true,
          ),
        ],
        if (onRoute != null) ...[
          const SizedBox(height: AppSpacing.sectionGap),
          AppButton.primary(
            label: l10n.roomRoute,
            expanded: true,
            size: AppButtonSize.large,
            onPressed: () {
              Navigator.of(context).pop();
              onRoute!();
            },
          ),
        ],
      ],
    );
  }
}

class _RoomHeading extends StatelessWidget {
  const _RoomHeading({required this.room, required this.largeText});

  final FreeRoomViewModel room;
  final bool largeText;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final floor = room.floor;
    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          room.name,
          style: AppText.serif(28, height: 1).copyWith(color: colors.ink),
        ),
        const SizedBox(height: 6),
        Text(
          floor == null || room.campus.isEmpty
              ? room.subtitle(l10n)
              : l10n.roomMetaFloor(l10n.freeRoomsKind, room.campus, floor),
          style: AppText.sans(
            13,
            FontWeight.w500,
          ).copyWith(color: colors.muted),
        ),
      ],
    );
    final badge = AppBadge(
      label: room.untilTime == null
          ? l10n.roomFreeEndOfDayBadge
          : l10n.roomFreeUntilBadge(room.untilTime!),
      tone: room.urgent ? AppBadgeTone.exam : AppBadgeTone.lecture,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      textStyle: AppText.sans(12, FontWeight.w700),
    );
    if (largeText) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading,
          const SizedBox(height: AppSpacing.gap),
          badge,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: heading),
        const SizedBox(width: AppSpacing.sm),
        Flexible(child: badge),
      ],
    );
  }
}

class _RoomStat extends StatelessWidget {
  const _RoomStat({
    required this.label,
    required this.value,
    this.compact = false,
  });

  final String label;
  final String value;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      radius: AppRadius.field,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sectionGap,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppText.sans(
              11,
              FontWeight.w600,
            ).copyWith(color: colors.muted),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppText.sans(
              compact ? 14 : 18,
              compact ? FontWeight.w600 : FontWeight.w800,
            ).copyWith(color: colors.ink),
          ),
        ],
      ),
    );
  }
}
