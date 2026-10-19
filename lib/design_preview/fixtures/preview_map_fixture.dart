import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';

abstract final class PreviewMapFixture {
  static final campus = CampusMapData(
    campus: const CampusModel(
      id: 'preview-campus',
      displayName: 'В-78',
      floors: [],
    ),
    floors: [
      MapFloorData.fromJson({'id': 'preview-floor', 'level': 1}, svgPath: ''),
    ],
    rooms: [
      MapPlaceData.fromJson({
        'id': 'start',
        'floor_id': 'preview-floor',
        'label': 'А-101',
        'x': 10,
        'y': 10,
      }),
      MapPlaceData.fromJson({
        'id': 'finish',
        'floor_id': 'preview-floor',
        'label': 'А-118',
        'x': 80,
        'y': 80,
      }),
    ],
    graph: {
      'nodes': [
        {
          'id': 'start',
          'floor_id': 'preview-floor',
          'room_id': 'start',
          'x': 10,
          'y': 10,
        },
        {'id': 'turn', 'floor_id': 'preview-floor', 'x': 80, 'y': 10},
        {
          'id': 'finish',
          'floor_id': 'preview-floor',
          'room_id': 'finish',
          'x': 80,
          'y': 80,
        },
      ],
      'edges': [
        {
          'id': 'first',
          'from_node_id': 'start',
          'to_node_id': 'turn',
          'distance_meters': 30,
        },
        {
          'id': 'second',
          'from_node_id': 'turn',
          'to_node_id': 'finish',
          'distance_meters': 30,
        },
      ],
    },
    sourceUrl: '',
    sourceLabel: '',
    revision: 1,
    origin: MapDataOrigin.bundled,
  );
  static final IndoorRoute route = IndoorRoutePlanner(
    IndoorNavigationGraph.fromJson(campus.graph),
  ).findRoute(startNodeId: 'start', destinationNodeId: 'finish').route!;
}
