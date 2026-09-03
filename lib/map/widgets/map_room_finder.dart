import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/models/models.dart';

class MapRoomFinder extends StatefulWidget {
  const MapRoomFinder({required this.rooms, super.key});

  final List<RoomModel> rooms;

  @override
  State<MapRoomFinder> createState() => _MapRoomFinderState();
}

class _MapRoomFinderState extends State<MapRoomFinder> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim().toLowerCase();
    final rooms = widget.rooms.where(
      (room) =>
          room.name.toLowerCase().contains(query) ||
          room.roomId.toLowerCase().contains(query),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSearchField(
          controller: _controller,
          hintText: context.l10n.mapRoomSearchHint,
          onChanged: (_) => setState(() {}),
          onClear: () => setState(() {}),
        ),
        const SizedBox(height: 12),
        AppListGroup(
          children: [
            for (final room in rooms)
              AppListRow(
                title: room.name.isEmpty ? room.roomId : room.name,
                onTap: () => Navigator.of(context).pop(room),
              ),
          ],
        ),
        if (rooms.isEmpty)
          NinjaEmptyState(
            title: context.l10n.mapNoRoomsTitle,
            message: context.l10n.mapNoRoomsMessage,
          ),
      ],
    );
  }
}
