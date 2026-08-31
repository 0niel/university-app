import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/models/models.dart';

part 'room_finder_empty.dart';
part 'room_row.dart';

class MapRoomFinder extends StatefulWidget {
  const MapRoomFinder({required this.rooms, super.key});

  final List<RoomModel> rooms;

  @override
  State<MapRoomFinder> createState() => _MapRoomFinderState();
}

class _MapRoomFinderState extends State<MapRoomFinder> {
  final _controller = TextEditingController();
  String _query = '';
  String _group = _allGroups;

  static const _allGroups = '*';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static String _displayName(RoomModel room) =>
      room.name.isEmpty ? room.roomId : room.name;

  static String _groupOf(RoomModel room) {
    final name = _displayName(room).trim();
    return name.isEmpty ? '?' : name[0].toUpperCase();
  }

  List<String> _groups() {
    final groups = <String>{for (final room in widget.rooms) _groupOf(room)};
    final list = groups.toList()..sort();
    return list.take(8).toList();
  }

  List<RoomModel> _matches() {
    final query = _query.trim().toLowerCase();
    return widget.rooms.where((room) {
      if (_group != _allGroups && _groupOf(room) != _group) return false;
      if (query.isEmpty) return true;
      return room.name.toLowerCase().contains(query) ||
          room.roomId.toLowerCase().contains(query);
    }).toList()..sort(
      (first, second) => _displayName(first).compareTo(_displayName(second)),
    );
  }

  void _reset() {
    _controller.clear();
    setState(() {
      _query = '';
      _group = _allGroups;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rooms = _matches();
    final groups = _groups();
    final listHeight = (MediaQuery.heightOf(context) * 0.44).clamp(
      240.0,
      420.0,
    );
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
          child: NinjaInput(
            controller: _controller,
            autofocus: true,
            placeholder: l10n.mapRoomSearchHint,
            leadingIcon: const AppLineIconWidget(.search, size: 20),
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        if (groups.length > 1) ...[
          const SizedBox(height: 12),
          NinjaChipRow(
            children: [
              NinjaChip(
                label: l10n.all,
                selected: _group == _allGroups,
                onTap: () => setState(() => _group = _allGroups),
              ),
              for (final group in groups)
                NinjaChip(
                  label: group,
                  selected: _group == group,
                  onTap: () => setState(() => _group = group),
                ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        SizedBox(
          height: listHeight,
          child: NinjaStateSwitcher(
            child: rooms.isEmpty
                ? _RoomFinderEmpty(
                    key: const ValueKey('map-room-finder-empty'),
                    onReset: _reset,
                  )
                : ListView.separated(
                    key: const ValueKey('map-room-finder-list'),
                    physics: const BouncingScrollPhysics(),
                    padding: const .symmetric(
                      horizontal: NinjaMetrics.screenPadding,
                    ),
                    itemCount: rooms.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => _RoomRow(
                      room: rooms[index],
                      onTap: () => Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pop(rooms[index]),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
