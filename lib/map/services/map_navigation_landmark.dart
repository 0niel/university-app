import 'package:rtu_mirea_app/map/data/map_data_models.dart';

class MapNavigationLandmark {
  MapNavigationLandmark({
    required this.place,
    required Iterable<String> nodeIds,
    required Iterable<String> outgoingFloorIds,
    required this.closed,
  }) : nodeIds = Set.unmodifiable(nodeIds),
       outgoingFloorIds = Set.unmodifiable(outgoingFloorIds);

  final MapPlaceData place;
  final Set<String> nodeIds;
  final Set<String> outgoingFloorIds;
  final bool closed;
}
