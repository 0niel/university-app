import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/map_navigation_preparation.dart';

CampusMapData campus(
  Map<String, Object?> graph, {
  List<MapPlaceData> rooms = const [],
}) => CampusMapData(
  campus: const CampusModel(id: 'v-78', displayName: 'В-78', floors: []),
  floors: [],
  rooms: rooms,
  graph: graph,
  sourceUrl: '',
  sourceLabel: '',
  revision: 1,
  origin: MapDataOrigin.bundled,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'prepares actual V-78 graph and immutable floor landmarks asynchronously',
    () async {
      final source =
          jsonDecode(
                File(
                  'packages/app_ui/assets/maps/pulse/campus_v-78.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>;
      final prepared = await prepareMapNavigation(
        campus(
          source['graph'] as Map<String, dynamic>,
          rooms: (source['rooms'] as List)
              .cast<Map<String, dynamic>>()
              .map(MapPlaceData.fromJson)
              .toList(),
        ),
      );
      expect(prepared.graph, isNotNull);
      expect(prepared.graph!.nodes, hasLength(16237));
      expect(prepared.graph!.edges, hasLength(41218));
      expect(prepared.byFloor, hasLength(5));
      expect(prepared.byFloor.values.expand((items) => items), hasLength(94));
      for (final entry in prepared.byFloor.entries) {
        expect(
          entry.value.every((item) => item.place.floorId == entry.key),
          isTrue,
        );
        expect(entry.value.clear, throwsUnsupportedError);
      }
      expect(prepared.byFloor.clear, throwsUnsupportedError);
      expect(() => prepared.graph!.nodes.clear(), throwsUnsupportedError);
    },
  );

  test(
    'invalid graph returns an empty fallback instead of failing the future',
    () async {
      final prepared = await prepareMapNavigation(campus({'nodes': []}));
      expect(prepared.graph, isNull);
      expect(prepared.byFloor, isEmpty);
    },
  );

  test(
    'an empty valid graph remains usable without invented markers',
    () async {
      final prepared = await prepareMapNavigation(
        campus({'nodes': [], 'edges': []}),
      );
      expect(prepared.graph, isNotNull);
      expect(prepared.graph!.nodes, isEmpty);
      expect(prepared.byFloor, isEmpty);
    },
  );
}
