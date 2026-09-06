import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';

void main() {
  group('IndoorRoutePlanner', () {
    test(
      'finds a shorter multi-edge route and replaces stale queue entries',
      () {
        final planner = _planner(
          [_node('a'), _node('b'), _node('c'), _node('d')],
          [
            _edge('ab', 'a', 'b', 30),
            _edge('ac', 'a', 'c', 2),
            _edge('cb', 'c', 'b', 3),
            _edge('bd', 'b', 'd', 4),
            _edge('cd', 'c', 'd', 20),
          ],
        );
        final result = planner.findRoute(
          startNodeId: 'a',
          destinationNodeId: 'd',
        );

        expect(result.status, IndoorRouteStatus.found);
        expect(result.route!.nodes.map((node) => node.id), [
          'a',
          'c',
          'b',
          'd',
        ]);
        expect(result.route!.distanceMeters, 9);
        expect(result.route!.durationSeconds, closeTo(7.5, 1e-10));
      },
    );

    test('fastest routing uses durations independently of distance', () {
      final planner = _planner(
        [_node('a'), _node('b'), _node('c')],
        [
          _edge('ab', 'a', 'b', 5, duration: 90),
          _edge('ac', 'a', 'c', 10, duration: 10),
          _edge('cb', 'c', 'b', 10, duration: 10),
        ],
      );
      final shortest = planner.findRoute(
        startNodeId: 'a',
        destinationNodeId: 'b',
      );
      final fastest = planner.findRoute(
        startNodeId: 'a',
        destinationNodeId: 'b',
        options: const IndoorRouteOptions(metric: IndoorRouteMetric.duration),
      );

      expect(shortest.route!.distanceMeters, 5);
      expect(fastest.route!.distanceMeters, 20);
      expect(fastest.route!.durationSeconds, 20);
    });

    test('respects directed edges and reverses bidirectional geometry', () {
      final planner = _planner(
        [_node('a'), _node('b'), _node('c')],
        [
          _edge('ab', 'a', 'b', 5),
          _edge('bc', 'b', 'c', 5, bidirectional: true),
        ],
      );
      final reverse = planner.findRoute(
        startNodeId: 'c',
        destinationNodeId: 'b',
      );

      expect(reverse.route!.legs.single.from.id, 'c');
      expect(reverse.route!.legs.single.to.id, 'b');
      expect(
        planner.findRoute(startNodeId: 'c', destinationNodeId: 'a').status,
        IndoorRouteStatus.unreachable,
      );
    });

    test('does not connect nearby nodes without an approved edge', () {
      final planner = _planner([_node('a'), _node('b')], []);

      expect(
        planner.findRoute(startNodeId: 'a', destinationNodeId: 'b').status,
        IndoorRouteStatus.unreachable,
      );
    });

    test('honors stored closures and temporary closed nodes and edges', () {
      final planner = _planner(
        [_node('a'), _node('b'), _node('c')],
        [
          _edge('ab', 'a', 'b', 5),
          _edge('ac', 'a', 'c', 1, closed: true),
          _edge('cb', 'c', 'b', 1),
        ],
      );
      expect(
        planner
            .findRoute(startNodeId: 'a', destinationNodeId: 'b')
            .route!
            .distanceMeters,
        5,
      );
      expect(
        planner
            .findRoute(
              startNodeId: 'a',
              destinationNodeId: 'b',
              options: const IndoorRouteOptions(closedEdgeIds: {'ab'}),
            )
            .status,
        IndoorRouteStatus.unreachable,
      );
      expect(
        planner
            .findRoute(
              startNodeId: 'a',
              destinationNodeId: 'b',
              options: const IndoorRouteOptions(closedNodeIds: {'b'}),
            )
            .status,
        IndoorRouteStatus.closedEndpoint,
      );
    });

    test('blocks traversal through closed intermediate nodes', () {
      final planner = _planner(
        [_node('a'), _node('b', closed: true), _node('c')],
        [_edge('ab', 'a', 'b', 5), _edge('bc', 'b', 'c', 5)],
      );
      expect(
        planner.findRoute(startNodeId: 'a', destinationNodeId: 'c').status,
        IndoorRouteStatus.unreachable,
      );
    });

    test('step-free routing selects a lift and emits its floor transition', () {
      final planner = _planner(
        [
          _node('start'),
          _node('stairs'),
          _node('lift'),
          _node('finish', floor: '2'),
        ],
        [
          _edge('s', 'start', 'stairs', 1),
          _edge('sf', 'stairs', 'finish', 3, kind: IndoorEdgeKind.stairs),
          _edge('l', 'start', 'lift', 10),
          _edge('lf', 'lift', 'finish', 3, kind: IndoorEdgeKind.elevator),
        ],
      );
      final walking = planner.findRoute(
        startNodeId: 'start',
        destinationNodeId: 'finish',
      );
      final stepFree = planner.findRoute(
        startNodeId: 'start',
        destinationNodeId: 'finish',
        options: const IndoorRouteOptions(stepFree: true),
      );

      expect(walking.route!.distanceMeters, 4);
      expect(stepFree.route!.nodes.map((node) => node.id), [
        'start',
        'lift',
        'finish',
      ]);
      final instruction = stepFree.route!.instructions.firstWhere(
        (step) => step.maneuver == IndoorManeuver.elevator,
      );
      expect(instruction.floorId, '1');
      expect(instruction.destinationFloorId, '2');
      expect(stepFree.route!.floorIds, ['1', '2']);
    });

    test('wheelchair routes require verified access on edges and nodes', () {
      final planner = _planner(
        [
          _node('a', accessible: true),
          _node('b', accessible: true),
          _node('unknown'),
          _node('c', accessible: true),
        ],
        [
          _edge('ab', 'a', 'b', 1, accessible: true),
          _edge('bc', 'b', 'c', 1),
          _edge('au', 'a', 'unknown', 1, accessible: true),
          _edge('uc', 'unknown', 'c', 1, accessible: true),
          _edge('ac', 'a', 'c', 10, accessible: true),
        ],
      );
      final result = planner.findRoute(
        startNodeId: 'a',
        destinationNodeId: 'c',
        options: const IndoorRouteOptions(wheelchair: true),
      );

      expect(result.route!.distanceMeters, 10);
      expect(
        planner
            .findRoute(
              startNodeId: 'unknown',
              destinationNodeId: 'c',
              options: const IndoorRouteOptions(wheelchair: true),
            )
            .status,
        IndoorRouteStatus.inaccessibleEndpoint,
      );
    });

    test('step-free excludes escalators and mislabeled accessible stairs', () {
      for (final kind in [IndoorEdgeKind.stairs, IndoorEdgeKind.escalator]) {
        final planner = _planner(
          [_node('a', accessible: true), _node('b', accessible: true)],
          [_edge('ab', 'a', 'b', 1, kind: kind, accessible: true)],
        );
        for (final options in [
          const IndoorRouteOptions(stepFree: true),
          const IndoorRouteOptions(wheelchair: true),
        ]) {
          expect(
            planner
                .findRoute(
                  startNodeId: 'a',
                  destinationNodeId: 'b',
                  options: options,
                )
                .status,
            IndoorRouteStatus.unreachable,
          );
        }
      }
    });

    test('reports missing endpoints and zero-length arrival', () {
      final planner = _planner([_node('a')], []);
      expect(
        planner
            .findRoute(startNodeId: 'missing', destinationNodeId: 'a')
            .status,
        IndoorRouteStatus.unknownStart,
      );
      expect(
        planner
            .findRoute(startNodeId: 'a', destinationNodeId: 'missing')
            .status,
        IndoorRouteStatus.unknownDestination,
      );
      final route = planner
          .findRoute(startNodeId: 'a', destinationNodeId: 'a')
          .route!;
      expect(route.legs, isEmpty);
      expect(route.distanceMeters, 0);
      expect(route.durationSeconds, 0);
      expect(route.instructions.single.maneuver, IndoorManeuver.arrive);
    });

    test('does not emit infinite accumulated distance or duration', () {
      final planner = _planner(
        [_node('a'), _node('b'), _node('c')],
        [
          _edge('ab', 'a', 'b', 1e308, duration: 1e308),
          _edge('bc', 'b', 'c', 1e308, duration: 1e308),
        ],
      );
      expect(
        planner.findRoute(startNodeId: 'a', destinationNodeId: 'c').status,
        IndoorRouteStatus.unreachable,
      );
      final durationOverflow = _planner(
        [_node('a'), _node('b'), _node('c')],
        [
          _edge('ab', 'a', 'b', 1, duration: 1e308),
          _edge('bc', 'b', 'c', 1, duration: 1e308),
        ],
      );
      expect(
        durationOverflow
            .findRoute(startNodeId: 'a', destinationNodeId: 'c')
            .status,
        IndoorRouteStatus.unreachable,
      );
    });

    test('finds the optimal pair of room entrances in one search', () {
      final planner = _planner(
        [
          _node('a1'),
          _node('a2'),
          _node('middle'),
          _node('b1'),
          _node('b2'),
        ],
        [
          _edge('first-pair', 'a1', 'b1', 20),
          _edge('second-origin', 'a2', 'middle', 2),
          _edge('second-target', 'middle', 'b2', 3),
        ],
      );
      final result = planner.findRouteBetween(
        startNodeIds: ['a1', 'a2'],
        destinationNodeIds: ['b1', 'b2'],
      );
      expect(result.route!.nodes.map((node) => node.id), [
        'a2',
        'middle',
        'b2',
      ]);
      expect(result.route!.distanceMeters, 5);
    });

    test(
      'ignores blocked or unverified entrances when another is accessible',
      () {
        final planner = _planner(
          [
            _node('closed-start', closed: true, accessible: true),
            _node('unverified-start'),
            _node('open-start', accessible: true),
            _node('closed-destination', closed: true, accessible: true),
            _node('unverified-destination'),
            _node('open-destination', accessible: true),
          ],
          [
            _edge(
              'open-route',
              'open-start',
              'open-destination',
              10,
              accessible: true,
            ),
          ],
        );
        final result = planner.findRouteBetween(
          startNodeIds: ['closed-start', 'unverified-start', 'open-start'],
          destinationNodeIds: [
            'closed-destination',
            'unverified-destination',
            'open-destination',
          ],
          options: const IndoorRouteOptions(wheelchair: true),
        );
        expect(result.route!.nodes.map((node) => node.id), [
          'open-start',
          'open-destination',
        ]);
      },
    );

    test('multi-source fastest mode keeps distance and duration separate', () {
      final planner = _planner(
        [_node('a1'), _node('a2'), _node('b')],
        [
          _edge('short', 'a1', 'b', 5, duration: 100),
          _edge('fast', 'a2', 'b', 30, duration: 20),
        ],
      );
      final result = planner.findRouteBetween(
        startNodeIds: ['missing', 'a1', 'a2', 'a2'],
        destinationNodeIds: ['b'],
        options: const IndoorRouteOptions(metric: IndoorRouteMetric.duration),
      );
      expect(result.route!.nodes.first.id, 'a2');
      expect(result.route!.durationSeconds, 20);
      expect(result.route!.distanceMeters, 30);
    });

    test(
      'overlapping endpoint sets produce arrival at the shared entrance',
      () {
        final planner = _planner([_node('a'), _node('b'), _node('c')], []);
        final result = planner.findRouteBetween(
          startNodeIds: ['a', 'b'],
          destinationNodeIds: ['b', 'c'],
        );
        expect(result.route!.nodes.single.id, 'b');
        expect(
          result.route!.instructions.single.maneuver,
          IndoorManeuver.arrive,
        );
        expect(result.route!.distanceMeters, 0);
      },
    );

    test('reports missing and wholly blocked endpoint sets', () {
      final planner = _planner([_node('a'), _node('b', closed: true)], []);
      expect(
        planner
            .findRouteBetween(startNodeIds: [], destinationNodeIds: ['a'])
            .status,
        IndoorRouteStatus.unknownStart,
      );
      expect(
        planner
            .findRouteBetween(startNodeIds: ['a'], destinationNodeIds: [])
            .status,
        IndoorRouteStatus.unknownDestination,
      );
      expect(
        planner
            .findRouteBetween(startNodeIds: ['b'], destinationNodeIds: ['a'])
            .status,
        IndoorRouteStatus.closedEndpoint,
      );
    });

    test('emits turns using the SVG coordinate system with downward y', () {
      final planner = _planner(
        [
          _node('a'),
          _node('b', x: 10),
          _node('c', x: 10, y: 10),
          _node('d', x: 20, y: 10),
          _node('e', x: 15, y: 10),
        ],
        [
          _edge('ab', 'a', 'b', 10),
          _edge('bc', 'b', 'c', 10),
          _edge('cd', 'c', 'd', 10),
          _edge('de', 'd', 'e', 5),
        ],
      );
      final route = planner
          .findRoute(startNodeId: 'a', destinationNodeId: 'e')
          .route!;
      expect(route.instructions.map((step) => step.maneuver), [
        IndoorManeuver.depart,
        IndoorManeuver.straight,
        IndoorManeuver.turnRight,
        IndoorManeuver.turnLeft,
        IndoorManeuver.turnBack,
        IndoorManeuver.arrive,
      ]);
    });

    test('keeps the incoming bearing across co-located door nodes', () {
      final planner = _planner(
        [
          _node('a'),
          _node('b', x: 10),
          _node('door', x: 10),
          _node('c', x: 10, y: 10),
        ],
        [
          _edge('ab', 'a', 'b', 10),
          _edge('door', 'b', 'door', 0.5, kind: IndoorEdgeKind.door),
          _edge('dc', 'door', 'c', 10),
        ],
      );
      final route = planner
          .findRoute(startNodeId: 'a', destinationNodeId: 'c')
          .route!;
      expect(route.instructions.map((step) => step.maneuver), [
        IndoorManeuver.depart,
        IndoorManeuver.straight,
        IndoorManeuver.turnRight,
        IndoorManeuver.arrive,
      ]);
      expect(route.instructions[1].distanceMeters, 10.5);
      expect(route.instructions[2].atNode.id, 'door');
    });

    test(
      'compacts dense straight geometry without removing route vertices',
      () {
        final planner = _planner(
          List.generate(101, (index) => _node('$index', x: index.toDouble())),
          List.generate(
            100,
            (index) => _edge('$index', '$index', '${index + 1}', 1),
          ),
        );
        final route = planner
            .findRoute(startNodeId: '0', destinationNodeId: '100')
            .route!;
        expect(route.nodes, hasLength(101));
        expect(route.instructions, hasLength(3));
        expect(route.instructions[1].maneuver, IndoorManeuver.straight);
        expect(route.instructions[1].distanceMeters, 100);
        expect(route.instructions[1].atNode.id, '0');
        expect(route.instructions[1].toNode!.id, '100');
      },
    );

    test(
      'does not carry bearings or join geometry across floor transitions',
      () {
        final planner = _planner(
          [
            _node('a'),
            _node('b', x: 10),
            _node('c', x: 1000, y: 1000, floor: '2'),
            _node('d', x: 1000, y: 990, floor: '2'),
            _node('e', x: 20),
            _node('f', x: 20, y: 10),
          ],
          [
            _edge('ab', 'a', 'b', 10),
            _edge('bc', 'b', 'c', 3, kind: IndoorEdgeKind.elevator),
            _edge('cd', 'c', 'd', 10),
            _edge('de', 'd', 'e', 3, kind: IndoorEdgeKind.stairs),
            _edge('ef', 'e', 'f', 10),
          ],
        );
        final route = planner
            .findRoute(startNodeId: 'a', destinationNodeId: 'f')
            .route!;
        expect(route.instructions.map((step) => step.maneuver), [
          IndoorManeuver.depart,
          IndoorManeuver.straight,
          IndoorManeuver.elevator,
          IndoorManeuver.straight,
          IndoorManeuver.stairs,
          IndoorManeuver.straight,
          IndoorManeuver.arrive,
        ]);
        expect(route.floorSegments.map((segment) => segment.floorId), [
          '1',
          '2',
          '1',
        ]);
        expect(
          route
              .segmentsForFloor('1')
              .map((segment) => segment.nodes.map((node) => node.id)),
          [
            ['a', 'b'],
            ['e', 'f'],
          ],
        );
        expect(route.segmentsForFloor('missing'), isEmpty);
        expect(route.floorSegments.clear, throwsUnsupportedError);
      },
    );

    test('calculates turns without overflowing finite coordinates', () {
      final planner = _planner(
        [
          _node('a', x: -1e200, y: -1e200),
          _node('b'),
          _node('c', x: -1e200, y: 1e200),
        ],
        [_edge('ab', 'a', 'b', 10), _edge('bc', 'b', 'c', 10)],
      );
      final route = planner
          .findRoute(startNodeId: 'a', destinationNodeId: 'c')
          .route!;
      expect(route.instructions[2].maneuver, IndoorManeuver.turnRight);
    });

    test(
      'identifies estimated duration without claiming imported measurements',
      () {
        final estimated = _planner(
          [_node('a'), _node('b')],
          [_edge('ab', 'a', 'b', 10)],
        ).findRoute(startNodeId: 'a', destinationNodeId: 'b').route!;
        final measured = _planner(
          [_node('a'), _node('b')],
          [_edge('ab', 'a', 'b', 10, duration: 20)],
        ).findRoute(startNodeId: 'a', destinationNodeId: 'b').route!;
        expect(estimated.hasEstimatedDuration, isTrue);
        expect(measured.hasEstimatedDuration, isFalse);
      },
    );

    test('matches Floyd-Warshall on randomized directed graphs', () {
      final random = Random(714);
      const size = 8;
      for (var sample = 0; sample < 20; sample++) {
        final distances = List.generate(
          size,
          (i) => List.generate(size, (j) => i == j ? 0.0 : double.infinity),
        );
        final edges = <IndoorNavigationEdge>[];
        for (var i = 0; i < size; i++) {
          for (var j = 0; j < size; j++) {
            if (i == j || random.nextDouble() > 0.25) continue;
            final weight = random.nextInt(25) + 1.0;
            distances[i][j] = weight;
            edges.add(_edge('$i-$j', '$i', '$j', weight));
          }
        }
        for (var k = 0; k < size; k++) {
          for (var i = 0; i < size; i++) {
            for (var j = 0; j < size; j++) {
              distances[i][j] = min(
                distances[i][j],
                distances[i][k] + distances[k][j],
              );
            }
          }
        }
        final planner = _planner(
          List.generate(size, (i) => _node('$i')),
          edges,
        );
        for (var i = 0; i < size; i++) {
          for (var j = 0; j < size; j++) {
            final result = planner.findRoute(
              startNodeId: '$i',
              destinationNodeId: '$j',
            );
            if (distances[i][j].isFinite) {
              expect(result.route!.distanceMeters, distances[i][j]);
            } else {
              expect(result.status, IndoorRouteStatus.unreachable);
            }
          }
        }
      }
    });
  });

  group('IndoorNavigationGraph validation', () {
    test('parses the backend contract and preserves directed defaults', () {
      final graph = IndoorNavigationGraph.fromJson({
        'nodes': [
          {'id': 'a', 'floor_id': '1', 'x': 5, 'y': 10, 'room_id': '101'},
          {'id': 'b', 'floor_id': '1', 'x': 10, 'y': 10},
        ],
        'edges': [
          {
            'id': 'ab',
            'from_node_id': 'a',
            'to_node_id': 'b',
            'distance_meters': 5,
            'duration_seconds': 10,
          },
        ],
      });
      expect(graph.nodesForRoom('101').single.id, 'a');
      expect(graph.edges.single.bidirectional, isFalse);
      expect(graph.edges.single.wheelchairAccessible, isFalse);
      expect(graph.edges.single.estimatedDurationSeconds, 10);
      expect(graph.nodes.clear, throwsUnsupportedError);
    });

    test('rejects nonfinite and negative physical weights', () {
      for (final weight in [-1.0, double.nan, double.infinity]) {
        expect(
          () => _planner(
            [_node('a'), _node('b')],
            [_edge('ab', 'a', 'b', weight)],
          ),
          throwsFormatException,
        );
        expect(
          () => _planner(
            [_node('a'), _node('b')],
            [_edge('ab', 'a', 'b', 5, duration: weight)],
          ),
          throwsFormatException,
        );
      }
    });

    test(
      'rejects duplicate ids, missing references and invalid coordinates',
      () {
        expect(
          () => _planner([_node('a'), _node('a')], []),
          throwsFormatException,
        );
        expect(
          () => _planner([_node('a', x: double.nan)], []),
          throwsFormatException,
        );
        expect(
          () => _planner([_node('a')], [_edge('ab', 'a', 'missing', 5)]),
          throwsFormatException,
        );
        expect(
          () => _planner(
            [_node('a'), _node('b')],
            [_edge('ab', 'a', 'b', 5), _edge('ab', 'a', 'b', 10)],
          ),
          throwsFormatException,
        );
      },
    );

    test('rejects unknown edge kinds and untyped floor transitions', () {
      expect(
        () => IndoorNavigationEdge.fromJson({'kind': 'teleport'}),
        throwsFormatException,
      );
      expect(
        () => _planner(
          [_node('a'), _node('b', floor: '2')],
          [_edge('ab', 'a', 'b', 5)],
        ),
        throwsFormatException,
      );
    });
  });
}

IndoorNavigationNode _node(
  String id, {
  String floor = '1',
  double x = 0,
  double y = 0,
  bool accessible = false,
  bool closed = false,
}) => IndoorNavigationNode(
  id: id,
  floorId: floor,
  x: x,
  y: y,
  wheelchairAccessible: accessible,
  closed: closed,
);

IndoorNavigationEdge _edge(
  String id,
  String from,
  String to,
  double distance, {
  double? duration,
  IndoorEdgeKind kind = IndoorEdgeKind.corridor,
  bool bidirectional = false,
  bool accessible = false,
  bool closed = false,
}) => IndoorNavigationEdge(
  id: id,
  fromNodeId: from,
  toNodeId: to,
  distanceMeters: distance,
  durationSeconds: duration,
  kind: kind,
  bidirectional: bidirectional,
  wheelchairAccessible: accessible,
  closed: closed,
);

IndoorRoutePlanner _planner(
  List<IndoorNavigationNode> nodes,
  List<IndoorNavigationEdge> edges,
) => IndoorRoutePlanner(IndoorNavigationGraph(nodes: nodes, edges: edges));
