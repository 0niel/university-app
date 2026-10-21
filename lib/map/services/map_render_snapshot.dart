import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/indoor_route_planner.dart';

class MapRenderSnapshot {
  CampusMapData? _campus;
  List<MapPlaceData> _places = const [];
  final _placesByFloor = <String, List<MapPlaceData>>{};
  IndoorRoute? _route;
  final _segmentsByFloor = <String, List<List<Offset>>>{};

  List<MapPlaceData> placesForFloor(CampusMapData? campus, String floorId) {
    if (!identical(campus, _campus) ||
        !listEquals(campus?.rooms ?? const <MapPlaceData>[], _places)) {
      _campus = campus;
      _places = List.of(campus?.rooms ?? const <MapPlaceData>[]);
      _placesByFloor.clear();
    }
    return _placesByFloor.putIfAbsent(
      floorId,
      () =>
          List.unmodifiable(_places.where((place) => place.floorId == floorId)),
    );
  }

  List<List<Offset>> segmentsForFloor(IndoorRoute? route, String floorId) {
    if (!identical(route, _route)) {
      _route = route;
      _segmentsByFloor.clear();
    }
    return _segmentsByFloor.putIfAbsent(
      floorId,
      () => List.unmodifiable([
        if (route != null)
          for (final segment in route.segmentsForFloor(floorId))
            List<Offset>.unmodifiable([
              for (final node in segment.nodes) Offset(node.x, node.y),
            ]),
      ]),
    );
  }
}
