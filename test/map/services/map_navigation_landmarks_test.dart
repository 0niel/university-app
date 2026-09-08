import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/indoor_navigation_graph.dart';
import 'package:rtu_mirea_app/map/services/map_navigation_landmarks.dart';

IndoorNavigationNode node(
  String id,
  String floorId, {
  String? kind,
  String? roomId,
  double x = 10,
  double y = 20,
  bool closed = false,
}) => IndoorNavigationNode(
  id: id,
  floorId: floorId,
  x: x,
  y: y,
  kind: kind,
  roomId: roomId,
  closed: closed,
);

IndoorNavigationEdge edge(
  String from,
  String to, {
  bool bidirectional = false,
  bool closed = false,
  IndoorEdgeKind kind = IndoorEdgeKind.stairs,
}) => IndoorNavigationEdge(
  id: '$from-$to',
  fromNodeId: from,
  toNodeId: to,
  kind: kind,
  traversalCost: 20,
  bidirectional: bidirectional,
  closed: closed,
);

void main() {
  test('derives connectors from edges without room or node categories', () {
    final graph = IndoorNavigationGraph(
      nodes: [node('a', 'one'), node('b', 'two')],
      edges: [edge('a', 'b')],
    );
    final landmarks = mapNavigationLandmarks(graph);
    expect(landmarks, hasLength(2));
    expect(landmarks.first.place.kind, 'stairs');
    expect(landmarks.first.place.label, 'Лестница');
    expect(landmarks.first.nodeIds, {'a'});
    expect(landmarks.first.outgoingFloorIds, {'two'});
    expect(landmarks.last.outgoingFloorIds, isEmpty);
    expect(landmarks.first.place.x, 10);
    expect(landmarks.first.place.y, 20);
  });

  test('deduplicates coordinates only within the same floor and kind', () {
    final graph = IndoorNavigationGraph(
      nodes: [
        node('b', 'one', kind: 'staircase'),
        node('a', 'one', kind: 'stairs'),
        node('nearby', 'one', kind: 'stairs', x: 10.01),
        node('lift', 'one', kind: 'lift'),
        node('up', 'two', kind: 'stairs'),
        node('down', 'zero', kind: 'stairs'),
      ],
      edges: [
        edge('a', 'up', bidirectional: true),
        edge('b', 'down', bidirectional: true),
      ],
    );
    final landmarks = mapNavigationLandmarks(graph);
    expect(landmarks, hasLength(5));
    final merged = landmarks.singleWhere((item) => item.nodeIds.contains('a'));
    expect(merged.nodeIds, {'a', 'b'});
    expect(merged.outgoingFloorIds, {'two', 'zero'});
    final reordered = mapNavigationLandmarks(
      IndoorNavigationGraph(nodes: graph.nodes.reversed, edges: graph.edges),
    );
    expect(
      reordered.map((item) => item.place.id),
      landmarks.map((item) => item.place.id),
    );
  });

  test('closed edges and endpoints remain visible without floor actions', () {
    final graph = IndoorNavigationGraph(
      nodes: [
        node('a', 'one'),
        node('b', 'two'),
        node('closed', 'three', closed: true),
      ],
      edges: [
        edge('a', 'b', bidirectional: true, closed: true),
        edge('a', 'closed', bidirectional: true),
      ],
    );
    final landmarks = mapNavigationLandmarks(graph);
    expect(landmarks, hasLength(3));
    expect(landmarks.every((item) => item.outgoingFloorIds.isEmpty), isTrue);
    expect(
      landmarks.singleWhere((item) => item.nodeIds.contains('closed')).closed,
      isTrue,
    );
  });

  test('an isolated ramp has no invented destination or accessibility', () {
    final landmarks = mapNavigationLandmarks(
      IndoorNavigationGraph(
        nodes: [node('ramp', 'one', kind: 'ramp')],
        edges: [],
      ),
    );
    expect(landmarks.single.place.label, 'Пандус');
    expect(landmarks.single.place.accessible, isNull);
    expect(landmarks.single.outgoingFloorIds, isEmpty);
  });

  test('existing connector rooms suppress only matching floor and kind', () {
    final place = MapPlaceData.fromJson({
      'id': 'stairs-room',
      'legacy_ids': ['old-stairs'],
      'floor_id': 'one',
      'kind': 'stairs',
      'x': 10,
      'y': 20,
    });
    final landmarks = mapNavigationLandmarks(
      IndoorNavigationGraph(
        nodes: [
          node('a', 'one', kind: 'stairs'),
          node('b', 'one', kind: 'stairs', roomId: 'old-stairs', x: 30),
          node('c', 'two', kind: 'stairs', roomId: 'old-stairs'),
          node('d', 'one', kind: 'elevator', roomId: 'old-stairs'),
        ],
        edges: [],
      ),
      places: [place],
    );
    expect(landmarks.map((item) => item.nodeIds.single).toSet(), {'c', 'd'});
  });

  for (final campus in ['v-78', 'v-86', 's-20', 'mp-1']) {
    test('$campus connectors resolve to actual source graph nodes', () {
      final json =
          jsonDecode(
                File(
                  'packages/app_ui/assets/maps/pulse/campus_$campus.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>;
      final graph = IndoorNavigationGraph.fromJson(
        json['graph'] as Map<String, dynamic>,
      );
      final places = (json['rooms'] as List).cast<Map<String, dynamic>>().map(
        MapPlaceData.fromJson,
      );
      final landmarks = mapNavigationLandmarks(graph, places: places);
      if (campus == 'mp-1') {
        expect(landmarks, isEmpty);
        expect(places.where((place) => place.kind == 'stairs'), isNotEmpty);
        return;
      }
      final stairNodes = graph.nodes.where((node) => node.kind == 'stairs');
      expect(landmarks, hasLength(stairNodes.length));
      for (final landmark in landmarks) {
        final source = graph.nodesById[landmark.nodeIds.first]!;
        expect(landmark.place.floorId, source.floorId);
        expect(landmark.place.x, source.x);
        expect(landmark.place.y, source.y);
        final destinations = <String>{};
        for (final edge in graph.edges) {
          if (edge.kind != IndoorEdgeKind.stairs || edge.closed) continue;
          final String destinationId;
          if (edge.fromNodeId == source.id) {
            destinationId = edge.toNodeId;
          } else if (edge.bidirectional && edge.toNodeId == source.id) {
            destinationId = edge.fromNodeId;
          } else {
            continue;
          }
          final destination = graph.nodesById[destinationId]!;
          if (!source.closed &&
              !destination.closed &&
              destination.floorId != source.floorId) {
            destinations.add(destination.floorId);
          }
        }
        expect(landmark.outgoingFloorIds, destinations);
        expect(landmark.outgoingFloorIds, isNot(contains(source.floorId)));
      }
    });
  }
}
