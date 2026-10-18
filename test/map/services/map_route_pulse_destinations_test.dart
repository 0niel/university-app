import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/services/map_route_destinations.dart';

void main() {
  for (final (campusId, startLabel, destinationLabel) in const [
    ('v-78', 'А-107', 'А-203'),
    ('v-86', 'Главный вход', 'К-124'),
    ('s-20', 'Вход', '102'),
  ]) {
    test('actual $campusId Pulse rooms remain eligible for routing', () {
      final document = mapJsonObject(
        jsonDecode(
          File(
            'packages/app_ui/assets/maps/pulse/campus_$campusId.json',
          ).readAsStringSync(),
        ),
      );
      final floors = mapJsonRows(
        document['floors'],
      ).map((row) => MapFloorData.fromJson(row, svgPath: 'floor.svg')).toList();
      final campus = CampusMapData(
        campus: CampusModel(
          id: campusId,
          displayName: campusId,
          floors: floors.map((floor) => floor.floor).toList(),
        ),
        floors: floors,
        rooms: mapJsonRows(
          document['rooms'],
        ).map(MapPlaceData.fromJson).toList(),
        graph: mapJsonObject(document['graph']),
        sourceUrl: '',
        sourceLabel: '',
        revision: document['revision']! as int,
        origin: MapDataOrigin.bundled,
      );
      final planner = IndoorRoutePlanner(
        IndoorNavigationGraph.fromJson(campus.graph),
      );
      final destinations = MapRouteDestinations(
        campus: campus,
        planner: planner,
      );
      final start = campus.rooms.singleWhere(
        (room) => room.label == startLabel,
      );
      final destination = campus.rooms.singleWhere(
        (room) => room.label == destinationLabel,
      );

      expect(destinations.supportsRoom(start.id, endpoint: .start), isTrue);
      expect(
        destinations.supportsRoom(destination.id, endpoint: .destination),
        isTrue,
      );
      expect(
        destinations.supportsRoom(destination.id, endpoint: .start),
        isTrue,
      );
      expect(
        destinations.supportsRoom(
          destination.sourceDatabaseId,
          endpoint: .destination,
        ),
        isTrue,
      );
      final startNode = destinations.nodeForRoom(start.id)!;
      final destinationNode = destinations.nodeForRoom(destination.id)!;
      expect(
        destinations.supportsRoom(
          destination.id,
          endpoint: .destination,
          opposite: startNode,
        ),
        isTrue,
      );
      expect(
        destinations.supportsRoom(
          start.id,
          endpoint: .start,
          opposite: destinationNode,
        ),
        isTrue,
      );
      expect(
        planner
            .findRouteBetween(
              startNodeIds: destinations.nodeIdsFor(startNode),
              destinationNodeIds: destinations.nodeIdsFor(destinationNode),
            )
            .hasRoute,
        isTrue,
      );
    });
  }
}
