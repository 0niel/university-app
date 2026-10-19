import 'dart:ui';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/navigation/floor_georeference.dart';

class GeographicFloorPlan {
  const GeographicFloorPlan({
    required this.svg,
    required this.size,
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    this.rooms = const [],
    this.places = const [],
    this.syntheticRoomIds = const {},
    this.georeference,
  });

  final String svg;
  final Size size;
  final LatLng topLeft;
  final LatLng topRight;
  final LatLng bottomLeft;
  final List<RoomModel> rooms;
  final List<MapPlaceData> places;
  final Set<String> syntheticRoomIds;
  final MapGeoreferenceData? georeference;

  String get alignmentNote => switch (georeference?.status) {
    'community' => 'Привязка сообщества',
    'needs_review' => 'Привязка ожидает проверки',
    _ => 'Привязка приблизительная',
  };

  LatLngBounds get geographicBounds {
    final reference = FloorGeoreference([
      FloorGeoAnchor(
        x: 0,
        y: 0,
        latitude: topLeft.latitude,
        longitude: topLeft.longitude,
      ),
      FloorGeoAnchor(
        x: size.width,
        y: 0,
        latitude: topRight.latitude,
        longitude: topRight.longitude,
      ),
      FloorGeoAnchor(
        x: 0,
        y: size.height,
        latitude: bottomLeft.latitude,
        longitude: bottomLeft.longitude,
      ),
    ]);
    final visibleRooms = rooms.where((room) {
      final center = room.path.getBounds().center;
      return georeference?.isReliableAt(center.dx, center.dy) ?? true;
    }).toList();
    final bounds = visibleRooms.isEmpty
        ? Offset.zero & size
        : visibleRooms
              .map((room) => room.path.getBounds())
              .reduce(
                (current, next) => current.expandToInclude(next),
              );
    return LatLngBounds.fromPoints([
      for (final point in [
        bounds.topLeft,
        bounds.topRight,
        bounds.bottomLeft,
        bounds.bottomRight,
      ])
        (() {
          final location = reference.pixelToGeographic(point.dx, point.dy);
          return LatLng(location.latitude, location.longitude);
        })(),
    ]);
  }
}
