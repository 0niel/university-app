import 'dart:ui';

import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/services/map_label_layout.dart';

class MapPlaceAnchor {
  const MapPlaceAnchor(this.point, {this.detachedService = false});

  final Offset? point;
  final bool detachedService;
}

MapPlaceAnchor resolveMapPlaceAnchor(
  Path path, {
  required Size floorSize,
  MapPlaceData? place,
}) {
  if (place != null &&
      place.x.isFinite &&
      place.y.isFinite &&
      floorSize.width.isFinite &&
      floorSize.height.isFinite &&
      floorSize.width > 0 &&
      floorSize.height > 0 &&
      place.x >= 0 &&
      place.y >= 0 &&
      place.x <= floorSize.width &&
      place.y <= floorSize.height) {
    final point = Offset(place.x, place.y);
    final inside = path.contains(point);
    if (place.kind != 'room' && place.kind != 'classroom') {
      return MapPlaceAnchor(point, detachedService: !inside);
    }
    if (inside) return MapPlaceAnchor(point);
  }
  return MapPlaceAnchor(mapInteriorLabelAnchor(path));
}
