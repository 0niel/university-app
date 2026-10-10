import 'dart:convert';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/svg_room_parser.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_canvas.dart';
import 'package:rtu_mirea_app/map/widgets/map_top_bar.dart';

class EntryCampusPreview extends StatefulWidget {
  const EntryCampusPreview({super.key});

  static const viewportSize = Size(390, 350);
  static _CampusFloor? _loadedFloor;
  static final Future<_CampusFloor> _floor = _loadFloor().then((floor) {
    _loadedFloor = floor;
    return floor;
  });

  static Future<void> preload() async {
    await _floor;
  }

  @override
  State<EntryCampusPreview> createState() => _EntryCampusPreviewState();
}

class _EntryCampusPreviewState extends State<EntryCampusPreview> {
  final _query = TextEditingController();
  final ValueNotifier<Matrix4> _camera = ValueNotifier(Matrix4.identity());
  late final Future<_CampusFloor> _floor;

  @override
  void initState() {
    super.initState();
    final cachedFloor = EntryCampusPreview._loadedFloor;
    if (cachedFloor != null) _centerMap(cachedFloor);
    _floor = EntryCampusPreview._floor.then((floor) {
      if (mounted) _centerMap(floor);
      return floor;
    });
  }

  void _centerMap(_CampusFloor floor) {
    const scale = 2.1;
    final center = floor.selectedRoom.path.getBounds().center;
    _camera.value = Matrix4.identity()
      ..scaleByDouble(scale, scale, 1, 1)
      ..setTranslationRaw(
        EntryCampusPreview.viewportSize.width / 2 - center.dx * scale,
        220 - center.dy * scale,
        0,
      );
  }

  @override
  void dispose() {
    _query.dispose();
    _camera.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
    size: EntryCampusPreview.viewportSize,
    child: ColoredBox(
      color: context.colors.canvas,
      child: FutureBuilder<_CampusFloor>(
        future: _floor,
        initialData: EntryCampusPreview._loadedFloor,
        builder: (context, snapshot) {
          final floor = snapshot.data;
          if (floor == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppLineIconWidget(
                    AppLineIcon.map,
                    size: 36,
                    color: context.colors.muted2,
                  ),
                  if (snapshot.hasError) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.l10n.loadingError,
                      style: AppText.caption.copyWith(
                        color: context.colors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }
          return ClipRect(
            child: Stack(
              children: [
                Positioned.fill(
                  child: RepaintBoundary(
                    child: MapFloorCanvas(
                      svgAssetPath: floor.floor.floor.svgPath,
                      svgContent: floor.svg,
                      canvasSize: floor.size,
                      viewportSize: EntryCampusPreview.viewportSize,
                      rooms: floor.rooms,
                      places: floor.places,
                      selectedRoomId: floor.selectedRoom.roomId,
                      showRoomLabels: true,
                      transform: _camera,
                    ),
                  ),
                ),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: MapTopBar(
                    controller: _query,
                    campuses: [floor.campus],
                    selectedCampus: floor.campus,
                    onQueryChanged: (_) {},
                    onCampusSelected: (_) {},
                    onFriends: () {},
                  ),
                ),
                Positioned(
                  right: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                  child: AppTag(
                    label: context.l10n.mapFloorNumber(
                      floor.floor.floor.number,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

typedef _FloorDocument = ({
  String campusId,
  String campusTitle,
  Map<String, Object?> floor,
  List<Map<String, Object?>> places,
});

_FloorDocument _decodeFloor(String source) {
  final document = mapJsonObject(jsonDecode(source));
  final floor = mapJsonRows(document['floors']).firstWhere(
    (floor) => floor['id'] == 'v-78-floor1',
  );
  return (
    campusId: document['id']! as String,
    campusTitle: document['short_title']! as String,
    floor: floor,
    places: mapJsonRows(
      document['rooms'],
    ).where((place) => place['floor_id'] == floor['id']).toList(),
  );
}

Future<_CampusFloor> _loadFloor() async {
  final document = await compute(
    _decodeFloor,
    await rootBundle.loadString(
      'packages/app_ui/assets/maps/pulse/campus_v-78.json',
      cache: false,
    ),
  );
  final floorId = document.floor['id']! as String;
  final svg = document.floor['svg']! as String;
  final floor = MapFloorData.fromJson(document.floor, svgPath: floorId);
  final (rooms, bounds) = await SvgRoomParser(
    onLoadSvg: (_) async => svg,
  ).parseSvg(floorId);
  if (rooms.isEmpty || bounds.isEmpty) {
    throw const FormatException('Campus preview has no room geometry');
  }
  return _CampusFloor(
    campus: CampusModel(
      id: document.campusId,
      displayName: document.campusTitle,
      floors: [floor.floor],
    ),
    floor: floor,
    svg: svg,
    size: bounds.size,
    rooms: rooms,
    places: document.places.map(MapPlaceData.fromJson).toList(),
    selectedRoom: rooms.firstWhere(
      (room) => room.name == 'А-125',
      orElse: () => rooms.first,
    ),
  );
}

class _CampusFloor {
  const _CampusFloor({
    required this.campus,
    required this.floor,
    required this.svg,
    required this.size,
    required this.rooms,
    required this.places,
    required this.selectedRoom,
  });

  final CampusModel campus;
  final MapFloorData floor;
  final String svg;
  final Size size;
  final List<RoomModel> rooms;
  final List<MapPlaceData> places;
  final RoomModel selectedRoom;
}
