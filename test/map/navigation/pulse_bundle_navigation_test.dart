import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';

void main() {
  const examples = {
    'v-78': (
      start: 'v-78:floor-2:a9q:anchor',
      nearby: 'v-78:floor-2:a7t:anchor',
      upstairs: 'v-78:floor-1:6m1:anchor',
      nearbyDistance: 10.304211,
    ),
    'v-86': (
      start: 'v-86:floor-0:gr:anchor',
      nearby: 'v-86:floor-0:hi:anchor',
      upstairs: 'v-86:floor-3:2mn:anchor',
      nearbyDistance: 10.708678,
    ),
    's-20': (
      start: 's-20:floor-0:108:anchor',
      nearby: 's-20:floor-0:12n:anchor',
      upstairs: 's-20:floor-1:1x9:anchor',
      nearbyDistance: 9.056161,
    ),
  };

  for (final entry in examples.entries) {
    group('Actual ${entry.key} imported navigation', () {
      late IndoorNavigationGraph graph;
      late IndoorRoutePlanner planner;

      setUpAll(() {
        final document =
            jsonDecode(
                  File(
                    'packages/app_ui/assets/maps/pulse/campus_${entry.key}.json',
                  ).readAsStringSync(),
                )
                as Map<String, dynamic>;
        graph = IndoorNavigationGraph.fromJson(
          document['graph'] as Map<String, dynamic>,
        );
        planner = IndoorRoutePlanner(graph);
      });

      test('routes adjacent named rooms through actual source doors', () {
        final result = planner.findRoute(
          startNodeId: entry.value.start,
          destinationNodeId: entry.value.nearby,
        );
        expect(result.status, IndoorRouteStatus.found);
        final route = result.route!;
        expect(route.hasCompleteDistance, isTrue);
        expect(
          route.distanceMeters,
          closeTo(entry.value.nearbyDistance, .0001),
        );
        expect(route.floorSegments, hasLength(1));
        expect(
          route.legs.any((leg) => leg.edge.kind == IndoorEdgeKind.door),
          isTrue,
        );
        expect(route.legs.any((leg) => leg.edge.closed), isFalse);
      });

      test(
        'uses declared floor portals without fabricated physical totals',
        () {
          final result = planner.findRoute(
            startNodeId: entry.value.start,
            destinationNodeId: entry.value.upstairs,
          );
          expect(result.status, IndoorRouteStatus.found);
          final route = result.route!;
          expect(route.floorSegments.length, greaterThanOrEqualTo(2));
          expect(route.hasCompleteDistance, isFalse);
          expect(route.distanceMeters, isNull);
          expect(route.durationSeconds, isNull);
          expect(
            route.instructions.any(
              (step) => step.maneuver == IndoorManeuver.stairs,
            ),
            isTrue,
          );
          for (final segment in route.floorSegments) {
            expect(
              segment.nodes.every((node) => node.floorId == segment.floorId),
              isTrue,
            );
          }
        },
      );

      test('step-free preference never reuses source stair connections', () {
        final result = planner.findRoute(
          startNodeId: entry.value.start,
          destinationNodeId: entry.value.upstairs,
          options: const IndoorRouteOptions(stepFree: true),
        );
        expect(result.status, IndoorRouteStatus.unreachable);
      });
    });
  }
}
