import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';

void main() {
  test('unmeasured portals never produce physical totals', () {
    final planner = _planner([
      _edge('ab', 'a', 'b', distance: 10),
      _edge('bc', 'b', 'c', cost: 20, kind: IndoorEdgeKind.stairs),
    ], destinationFloor: '2');
    final route = planner
        .findRoute(startNodeId: 'a', destinationNodeId: 'c')
        .route!;
    expect(route.hasCompleteDistance, isFalse);
    expect(route.hasCompleteDuration, isFalse);
    expect(route.distanceMeters, isNull);
    expect(route.durationSeconds, isNull);
    expect(route.hasEstimatedDuration, isFalse);
    expect(route.instructions[1].distanceMeters, 10);
    expect(route.instructions[2].distanceMeters, isNull);
    expect(route.legs.last.edge.distanceKnown, isFalse);
    expect(planner.graph.hasCompleteDistance, isFalse);
    expect(planner.graph.hasCompleteDuration, isFalse);
  });

  test('search penalties are not added to physical distance', () {
    final planner = _planner([
      _edge('ac', 'a', 'c', distance: 1, cost: 50),
      _edge('ab', 'a', 'b', distance: 10),
      _edge('bc', 'b', 'c', distance: 10),
    ]);
    final route = planner
        .findRoute(startNodeId: 'a', destinationNodeId: 'c')
        .route!;
    expect(route.nodes.map((node) => node.id), ['a', 'b', 'c']);
    expect(route.distanceMeters, 20);
    expect(route.hasCompleteDistance, isTrue);
  });

  test('duration mode can use a search cost without inventing an ETA', () {
    final planner = _planner([
      _edge('ac', 'a', 'c', cost: 20, kind: IndoorEdgeKind.stairs),
      _edge(
        'lift',
        'a',
        'c',
        cost: 30,
        duration: 30,
        kind: IndoorEdgeKind.elevator,
      ),
    ], destinationFloor: '2');
    final route = planner
        .findRoute(
          startNodeId: 'a',
          destinationNodeId: 'c',
          options: const IndoorRouteOptions(metric: IndoorRouteMetric.duration),
        )
        .route!;
    expect(route.legs.single.edge.id, 'ac');
    expect(route.durationSeconds, isNull);
    expect(route.distanceMeters, isNull);
  });

  test('zero-cost doorway cycles terminate with correct zero totals', () {
    final planner = _planner([
      _edge(
        'ab',
        'a',
        'b',
        distance: 0,
        kind: IndoorEdgeKind.door,
        bidirectional: true,
      ),
      _edge(
        'bc',
        'b',
        'c',
        distance: 0,
        duration: 0,
        kind: IndoorEdgeKind.door,
        bidirectional: true,
      ),
    ]);
    final route = planner
        .findRoute(startNodeId: 'a', destinationNodeId: 'c')
        .route!;
    expect(route.nodes.map((node) => node.id), ['a', 'b', 'c']);
    expect(route.distanceMeters, 0);
    expect(route.durationSeconds, 0);
    expect(route.hasCompleteDistance, isTrue);
    expect(route.hasCompleteDuration, isTrue);
  });

  test('closed imported portals remain excluded', () {
    final planner = _planner([
      _edge(
        'ac',
        'a',
        'c',
        cost: 20,
        kind: IndoorEdgeKind.stairs,
        closed: true,
      ),
    ], destinationFloor: '2');
    expect(
      planner.findRoute(startNodeId: 'a', destinationNodeId: 'c').status,
      IndoorRouteStatus.unreachable,
    );
  });

  test('unknown distance requires a positive finite traversal cost', () {
    for (final cost in [null, 0.0, -1.0, double.nan, double.infinity]) {
      expect(
        () => _planner([_edge('ac', 'a', 'c', cost: cost)]),
        throwsFormatException,
      );
    }
    final graph = IndoorNavigationGraph.fromJson({
      'nodes': [
        {'id': 'a', 'floor_id': '1', 'x': 0, 'y': 0},
        {'id': 'b', 'floor_id': '2', 'x': 0, 'y': 0},
      ],
      'edges': [
        {
          'id': 'ab',
          'from_node_id': 'a',
          'to_node_id': 'b',
          'distance_meters': null,
          'traversal_cost': 20,
          'kind': 'stairs',
        },
      ],
    });
    expect(graph.edges.single.routingCost, 20);
    expect(graph.edges.single.distanceMeters, isNull);
    expect(graph.edges.single.estimatedDurationSeconds, isNull);
  });

  test(
    'source duration may remain known when physical distance is unknown',
    () {
      final route = _planner(
        [
          _edge(
            'ac',
            'a',
            'c',
            cost: 20,
            duration: 30,
            kind: IndoorEdgeKind.stairs,
          ),
        ],
        destinationFloor: '2',
      ).findRoute(startNodeId: 'a', destinationNodeId: 'c').route!;
      expect(route.hasCompleteDistance, isFalse);
      expect(route.hasCompleteDuration, isTrue);
      expect(route.durationSeconds, 30);
      expect(route.hasEstimatedDuration, isFalse);
    },
  );

  test('compacting mixed-known straight legs keeps their distance unknown', () {
    final route = _planner([
      _edge('ab', 'a', 'b', distance: 10),
      _edge('bc', 'b', 'c', cost: 20),
    ]).findRoute(startNodeId: 'a', destinationNodeId: 'c').route!;
    expect(route.instructions, hasLength(3));
    expect(route.instructions[1].distanceMeters, isNull);
  });
}

IndoorRoutePlanner _planner(
  List<IndoorNavigationEdge> edges, {
  String destinationFloor = '1',
}) => IndoorRoutePlanner(
  IndoorNavigationGraph(
    nodes: [
      const IndoorNavigationNode(id: 'a', floorId: '1', x: 0, y: 0),
      const IndoorNavigationNode(id: 'b', floorId: '1', x: 10, y: 0),
      IndoorNavigationNode(id: 'c', floorId: destinationFloor, x: 20, y: 0),
    ],
    edges: edges,
  ),
);

IndoorNavigationEdge _edge(
  String id,
  String from,
  String to, {
  double? distance,
  double? cost,
  double? duration,
  IndoorEdgeKind kind = IndoorEdgeKind.corridor,
  bool bidirectional = false,
  bool closed = false,
}) => IndoorNavigationEdge(
  id: id,
  fromNodeId: from,
  toNodeId: to,
  distanceMeters: distance,
  traversalCost: cost,
  durationSeconds: duration,
  kind: kind,
  bidirectional: bidirectional,
  closed: closed,
);
