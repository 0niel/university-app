import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/services/map_route_destinations.dart';

void main() {
  test('only offers endpoints with a directed route to a different place', () {
    final routes = _destinations(
      [
        _node('a'),
        _node('b'),
        _node('isolated'),
        _node('self'),
        _node('internal-1', room: 'internal'),
        _node('internal-2', room: 'internal'),
      ],
      [
        _edge('a', 'b'),
        _edge('self', 'self'),
        _edge('internal-1', 'internal-2', bidirectional: true),
      ],
    );
    expect(_ids(routes.candidates(endpoint: MapRouteEndpoint.start)), {'a'});
    expect(routes.supportsRoom('a', endpoint: MapRouteEndpoint.start), isTrue);
    expect(
      routes.supportsRoom('a', endpoint: MapRouteEndpoint.destination),
      isFalse,
    );
    expect(
      routes.supportsRoom('b', endpoint: MapRouteEndpoint.destination),
      isTrue,
    );
    expect(
      routes.supportsRoom('isolated', endpoint: MapRouteEndpoint.start),
      isFalse,
    );
    expect(_ids(routes.candidates(endpoint: MapRouteEndpoint.destination)), {
      'b',
    });
  });

  test('filters against the opposite endpoint in the correct direction', () {
    final routes = _destinations(
      [_node('a'), _node('b'), _node('c')],
      [_edge('a', 'b'), _edge('c', 'b')],
    );
    expect(
      _ids(
        routes.candidates(
          endpoint: MapRouteEndpoint.destination,
          opposite: routes.nodeForRoom('a'),
        ),
      ),
      {'a', 'b'},
    );
    expect(
      _ids(
        routes.candidates(
          endpoint: MapRouteEndpoint.start,
          opposite: routes.nodeForRoom('b'),
        ),
      ),
      {'a', 'b', 'c'},
    );
    expect(
      routes.supportsRoom(
        'c',
        endpoint: MapRouteEndpoint.destination,
        opposite: routes.nodeForRoom('a'),
      ),
      isFalse,
    );
  });

  test('preserves reversed bidirectional edges and forward-only closures', () {
    final routes = _destinations(
      [_node('a'), _node('b'), _node('c'), _node('blocked', closed: true)],
      [
        _edge('a', 'b', bidirectional: true),
        _edge('b', 'c', closed: true),
        _edge('a', 'blocked'),
      ],
    );
    expect(
      _ids(
        routes.candidates(
          endpoint: MapRouteEndpoint.destination,
          opposite: routes.nodeForRoom('b'),
        ),
      ),
      {'a', 'b'},
    );
    expect(
      routes.candidates(
        endpoint: MapRouteEndpoint.start,
        options: const IndoorRouteOptions(closedEdgeIds: {'a-b'}),
      ),
      isEmpty,
    );
    expect(
      routes.candidates(
        endpoint: MapRouteEndpoint.destination,
        options: const IndoorRouteOptions(closedNodeIds: {'a'}),
      ),
      isEmpty,
    );
  });

  test('uses an alternate reachable entrance and merges room aliases', () {
    final nodes = [
      _node('a'),
      _node('blocked', room: 'b', closed: true),
      _node('isolated-entry', room: 'b'),
      _node('open-entry', room: 'b-legacy'),
    ];
    final routes = _destinations(
      nodes,
      [_edge('a', 'open-entry')],
      places: [
        _place('a'),
        _place('b', legacyIds: ['b-legacy']),
      ],
    );
    final candidates = routes.candidates(
      endpoint: MapRouteEndpoint.destination,
    );
    expect(_ids(candidates), {'open-entry'});
    expect(routes.nodeForRoom('b-legacy')?.id, 'isolated-entry');
    expect(routes.nodeIdsFor(candidates.single), {
      'blocked',
      'isolated-entry',
      'open-entry',
    });
    expect(
      _ids(
        routes.candidates(
          endpoint: MapRouteEndpoint.destination,
          opposite: nodes.first,
        ),
      ),
      {'a', 'open-entry'},
    );
  });

  test('excludes review, orphan and unknown-floor endpoints', () {
    final routes = _destinations(
      [
        _node('a'),
        _node('review'),
        _node('orphan'),
        _node('missing-floor', floor: 'missing'),
      ],
      [
        _edge('a', 'review'),
        _edge('a', 'orphan'),
        _edge('a', 'missing-floor', kind: IndoorEdgeKind.ramp),
      ],
      places: [
        _place('a'),
        _place('review', review: true),
        _place('missing-floor'),
      ],
    );
    expect(routes.nodeForRoom('review'), isNull);
    expect(routes.nodeForRoom('orphan'), isNull);
    expect(routes.candidates(endpoint: MapRouteEndpoint.destination), isEmpty);
    expect(
      _ids(
        routes.candidates(
          endpoint: MapRouteEndpoint.destination,
          opposite: routes.nodeForRoom('a'),
        ),
      ),
      {'a'},
    );
  });

  test(
    'retains named standalone entrances and hides technical graph nodes',
    () {
      final routes = _destinations(
        [
          _node('a'),
          const IndoorNavigationNode(
            id: 'entrance',
            floorId: 'one',
            x: 1,
            y: 1,
            label: 'Главный вход',
            kind: 'entrance',
          ),
          const IndoorNavigationNode(
            id: 'junction',
            floorId: 'one',
            x: 2,
            y: 2,
            label: 'Узел 12',
            kind: 'junction',
          ),
        ],
        [_edge('a', 'entrance'), _edge('a', 'junction')],
      );
      expect(_ids(routes.candidates(endpoint: MapRouteEndpoint.destination)), {
        'entrance',
      });
    },
  );

  test('step-free excludes stairs and escalators, allowing ramps', () {
    final routes = _destinations(
      [_node('a'), _node('stairs'), _node('escalator'), _node('ramp')],
      [
        _edge('a', 'stairs', kind: IndoorEdgeKind.stairs),
        _edge('a', 'escalator', kind: IndoorEdgeKind.escalator),
        _edge('a', 'ramp', kind: IndoorEdgeKind.ramp),
      ],
    );
    expect(
      _ids(
        routes.candidates(
          endpoint: MapRouteEndpoint.destination,
          opposite: routes.nodeForRoom('a'),
          options: const IndoorRouteOptions(stepFree: true),
        ),
      ),
      {'a', 'ramp'},
    );
  });

  test('wheelchair requires verified edges and every traversed node', () {
    final routes = _destinations(
      [_node('a'), _node('b'), _node('unknown', accessible: false), _node('c')],
      [
        _edge('a', 'b', accessible: false),
        _edge('a', 'unknown'),
        _edge('unknown', 'c'),
      ],
    );
    const options = IndoorRouteOptions(wheelchair: true);
    expect(routes.nodeForRoom('unknown', options: options), isNull);
    expect(
      _ids(
        routes.candidates(
          endpoint: MapRouteEndpoint.destination,
          opposite: routes.nodeForRoom('a'),
          options: options,
        ),
      ),
      {'a'},
    );
    expect(
      routes.candidates(endpoint: MapRouteEndpoint.start, options: options),
      isEmpty,
    );
  });

  test('reachability agrees with route planning for every endpoint pair', () {
    final routes = _destinations(
      [_node('a'), _node('b'), _node('c'), _node('d'), _node('e')],
      [
        _edge('a', 'b'),
        _edge('b', 'c', bidirectional: true),
        _edge('c', 'a', kind: IndoorEdgeKind.stairs),
        _edge('d', 'e'),
      ],
    );
    for (final options in [
      const IndoorRouteOptions(),
      const IndoorRouteOptions(stepFree: true),
      const IndoorRouteOptions(wheelchair: true),
      const IndoorRouteOptions(closedEdgeIds: {'b-c'}),
      const IndoorRouteOptions(closedNodeIds: {'b'}),
    ]) {
      for (final opposite in routes.planner.graph.nodes) {
        for (final endpoint in MapRouteEndpoint.values) {
          final candidates = _ids(
            routes.candidates(
              endpoint: endpoint,
              opposite: opposite,
              options: options,
            ),
          );
          for (final node in routes.planner.graph.nodes) {
            final result = routes.planner.findRouteBetween(
              startNodeIds: routes.nodeIdsFor(
                endpoint == MapRouteEndpoint.start ? node : opposite,
              ),
              destinationNodeIds: routes.nodeIdsFor(
                endpoint == MapRouteEndpoint.start ? opposite : node,
              ),
              options: options,
            );
            expect(candidates.contains(node.id), result.hasRoute);
          }
        }
      }
    }
  });
}

Set<String> _ids(Iterable<IndoorNavigationNode> nodes) =>
    nodes.map((node) => node.id).toSet();

IndoorNavigationNode _node(
  String id, {
  String? room,
  String floor = 'one',
  bool closed = false,
  bool accessible = true,
}) => IndoorNavigationNode(
  id: id,
  roomId: room ?? id,
  floorId: floor,
  x: 0,
  y: 0,
  wheelchairAccessible: accessible,
  closed: closed,
);

IndoorNavigationEdge _edge(
  String from,
  String to, {
  bool closed = false,
  bool accessible = true,
  bool bidirectional = false,
  IndoorEdgeKind kind = IndoorEdgeKind.corridor,
}) => IndoorNavigationEdge(
  id: '$from-$to',
  fromNodeId: from,
  toNodeId: to,
  distanceMeters: 1,
  closed: closed,
  wheelchairAccessible: accessible,
  bidirectional: bidirectional,
  kind: kind,
);

MapPlaceData _place(
  String id, {
  bool review = false,
  List<String> legacyIds = const [],
}) => MapPlaceData.fromJson({
  'id': id,
  'label': id,
  'floor_id': 'one',
  'legacy_ids': legacyIds,
  'navigation_needs_review': review,
});

MapRouteDestinations _destinations(
  List<IndoorNavigationNode> nodes,
  List<IndoorNavigationEdge> edges, {
  List<MapPlaceData>? places,
}) => MapRouteDestinations(
  planner: IndoorRoutePlanner(
    IndoorNavigationGraph(nodes: nodes, edges: edges),
  ),
  campus: CampusMapData(
    campus: const CampusModel(id: 'campus', displayName: 'Кампус', floors: []),
    floors: [
      MapFloorData.fromJson({'id': 'one', 'level': 1}, svgPath: ''),
    ],
    rooms:
        places ??
        [
          for (final id in nodes.map((node) => node.roomId).nonNulls.toSet())
            _place(id),
        ],
    graph: const {},
    sourceUrl: '',
    sourceLabel: '',
    revision: 1,
    origin: MapDataOrigin.bundled,
  ),
);
