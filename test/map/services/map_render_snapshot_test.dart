import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/services/map_render_snapshot.dart';

void main() {
  test(
    'route render lists retain identity and change with route replacement',
    () {
      final graph = IndoorNavigationGraph(
        nodes: [
          for (var index = 0; index < 3; index++)
            IndoorNavigationNode(
              id: '$index',
              floorId: 'first',
              x: index * 10.0,
              y: 0,
            ),
        ],
        edges: [
          for (var index = 1; index < 3; index++)
            IndoorNavigationEdge(
              id: '$index',
              fromNodeId: '0',
              toNodeId: '$index',
              traversalCost: 1,
            ),
        ],
      );
      final planner = IndoorRoutePlanner(graph);
      final firstRoute = planner
          .findRoute(startNodeId: '0', destinationNodeId: '1')
          .route!;
      final nextRoute = planner
          .findRoute(startNodeId: '0', destinationNodeId: '2')
          .route!;
      final snapshot = MapRenderSnapshot();
      final first = snapshot.segmentsForFloor(firstRoute, 'first');
      expect(snapshot.segmentsForFloor(firstRoute, 'first'), same(first));
      final next = snapshot.segmentsForFloor(nextRoute, 'first');
      expect(next.single.last.dx, 20);
      expect(first.single.last.dx, 10);
      expect(() => first.single.clear(), throwsUnsupportedError);
      expect(snapshot.segmentsForFloor(null, 'first'), isEmpty);
    },
  );
  test(
    'floor render lists stay stable and detect in-place catalog updates',
    () {
      MapPlaceData place(String id, String floor) => MapPlaceData.fromJson({
        'id': id,
        'floor_id': floor,
        'label': id,
      });
      final rooms = [place('one', 'first'), place('two', 'second')];
      final campus = CampusMapData(
        campus: const CampusModel(
          id: 'campus',
          displayName: 'Campus',
          floors: [],
        ),
        floors: const [],
        rooms: rooms,
        graph: const {},
        sourceUrl: '',
        sourceLabel: '',
        revision: 1,
        origin: MapDataOrigin.bundled,
      );
      final snapshot = MapRenderSnapshot();
      final first = snapshot.placesForFloor(campus, 'first');
      expect(snapshot.placesForFloor(campus, 'first'), same(first));
      snapshot.placesForFloor(campus, 'second');
      expect(snapshot.placesForFloor(campus, 'first'), same(first));
      rooms[0] = place('replacement', 'first');
      final updated = snapshot.placesForFloor(campus, 'first');
      expect(updated.single.id, 'replacement');
      expect(updated, isNot(same(first)));
      rooms.add(place('new', 'first'));
      expect(snapshot.placesForFloor(campus, 'first'), hasLength(2));
      expect(snapshot.placesForFloor(null, 'first'), isEmpty);
      expect(first.clear, throwsUnsupportedError);
      expect(first.single.id, 'one');
    },
  );
}
