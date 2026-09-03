import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_placeholder.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/models/models.dart';

class MapRoomSheet extends StatelessWidget {
  const MapRoomSheet({required this.room, super.key});

  final RoomModel room;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const RoomPhotoPlaceholder(),
      const SizedBox(height: AppSpacing.lg),
      Text(
        room.name.isEmpty ? room.roomId : room.name,
        style: AppText.serif(28, height: 1).copyWith(color: context.colors.ink),
      ),
      const SizedBox(height: AppSpacing.sectionGap),
      AppBanner(message: context.l10n.roomAvailabilityUnknown),
      const SizedBox(height: AppSpacing.sectionGap),
      AppButton.primary(
        label: context.l10n.search,
        expanded: true,
        size: AppButtonSize.large,
        onPressed: () => Navigator.of(context).pop(true),
      ),
    ],
  );
}
