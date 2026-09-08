import 'package:flutter/foundation.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/indoor_navigation_graph.dart';
import 'package:rtu_mirea_app/map/services/map_navigation_landmarks.dart';

class PreparedMapNavigation {
  PreparedMapNavigation._({required this.graph, required this.byFloor});

  final IndoorNavigationGraph? graph;
  final Map<String, List<MapNavigationLandmark>> byFloor;
}

Future<PreparedMapNavigation> prepareMapNavigation(CampusMapData campus) =>
    compute(
      _prepareMapNavigation,
      (
        campus.graph,
        [for (final place in campus.rooms) place.raw],
      ),
      debugLabel: 'Prepare map navigation',
    );

PreparedMapNavigation _prepareMapNavigation(
  (Map<String, Object?>, List<Map<String, Object?>>) input,
) {
  try {
    final graph = IndoorNavigationGraph.fromJson(input.$1);
    final byFloor = <String, List<MapNavigationLandmark>>{};
    for (final landmark in mapNavigationLandmarks(
      graph,
      places: input.$2.map(MapPlaceData.fromJson),
    )) {
      (byFloor[landmark.place.floorId] ??= []).add(landmark);
    }
    return PreparedMapNavigation._(
      graph: graph,
      byFloor: Map.unmodifiable({
        for (final entry in byFloor.entries)
          entry.key: List<MapNavigationLandmark>.unmodifiable(entry.value),
      }),
    );
  } on FormatException {
    return PreparedMapNavigation._(graph: null, byFloor: const {});
  }
}
