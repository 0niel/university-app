import 'dart:convert';

import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/services/objects_service.dart';
import 'package:rtu_mirea_app/map/view/map_view.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_canvas.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_sheet.dart';

import '../../helpers/pump_app.dart';

class _CampusRepository extends Mock implements CampusRepository {}

class _NoCache implements MapDataCache {
  @override
  Future<String?> read(String key) async => null;
  @override
  Future<void> write(String key, String value) async {}
}

Map<String, Object?> _document({required bool updated}) => {
  'id': 'campus',
  'short_title': 'В-78',
  'revision': 2,
  'floors': [
    {
      'id': 'first',
      'level': 1,
      'width': 100,
      'height': 100,
      'svg':
          '<svg viewBox="0 0 100 100"> '
          '<rect data-object="start" x="10" y="10" width="10" height="10" /> '
          '<rect data-object="end" x="70" y="70" width="10" height="10" /> '
          '</svg>',
    },
  ],
  'rooms': [
    {'id': 'start', 'floor_id': 'first', 'label': 'А-101', 'x': 15, 'y': 15},
    {'id': 'end', 'floor_id': 'first', 'label': 'А-102', 'x': 75, 'y': 75},
  ],
  'graph': {
    'nodes': [
      {'id': 'n1', 'floor_id': 'first', 'room_id': 'start', 'x': 15, 'y': 15},
      {
        'id': 'n2',
        'floor_id': 'first',
        'room_id': 'end',
        'x': 75,
        'y': updated ? 35 : 75,
      },
    ],
    'edges': [
      {
        'id': 'edge',
        'distance_meters': 20,
        'from_node_id': 'n1',
        'to_node_id': 'n2',
      },
    ],
  },
};

void main() {
  testWidgets(
    'route is cleared when bundle and remote share numeric revision',
    (tester) async {
      var online = false;
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: _NoCache(),
        bundledCatalogAsset: 'catalog.json',
        assetLoader: (path) async => jsonEncode(
          path == 'catalog.json'
              ? {
                  'campuses': [
                    {'id': 'campus', 'revision': 2},
                  ],
                }
              : _document(updated: false),
        ),
        rpc: (name, _) async {
          if (!online) throw const MapDataException('offline');
          return name == 'get_map_catalog'
              ? {
                  'campuses': [
                    {'id': 'campus', 'revision': 2},
                  ],
                }
              : _document(updated: true);
        },
      );
      late MapBloc map;
      late FreeRoomsCubit free;
      await tester.runAsync(() async {
        map = MapBloc(
          availableCampuses: [],
          repository: repository,
          objectsService: ObjectsService(
            onLoadObjects: (_) async => '{"objects":[]}',
          ),
        );
        final campusRepo = _CampusRepository();
        when(campusRepo.getFreeRooms).thenAnswer((_) async => []);
        free = FreeRoomsCubit(campusRepository: campusRepo);
        final ready = map.stream.firstWhere((state) => state.status == .loaded);
        map.add(const MapEvent.initialized());
        await ready;
        await free.load();
      });
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.runAsync(() async {
          await map.close();
          await free.close();
          repository.dispose();
        });
      });
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<MapBloc>.value(value: map),
            BlocProvider<FreeRoomsCubit>.value(value: free),
          ],
          child: const MapView(),
        ),
        size: const Size(390, 844),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Маршрут'));
      await tester.pumpAndSettle();
      final sheet = tester.widget<MapRouteSheet>(find.byType(MapRouteSheet));
      final route = IndoorRoutePlanner(
        IndoorNavigationGraph.fromJson(map.state.campusData!.graph),
      ).findRoute(startNodeId: 'n1', destinationNodeId: 'n2').route!;
      sheet.onApply(route);
      sheet.onClose!();
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<MapFloorCanvas>(find.byType(MapFloorCanvas))
            .routeSegments,
        isNotEmpty,
      );
      online = true;
      await tester.runAsync(() async {
        final refreshed = map.stream.firstWhere(
          (state) =>
              state.status == .loaded &&
              state.campusData?.origin.name == 'remote',
        );
        map.add(const MapEvent.refreshRequested());
        await refreshed;
      });
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<MapFloorCanvas>(find.byType(MapFloorCanvas))
            .routeSegments,
        isEmpty,
      );
      sheet.onApply(route);
      await tester.pump();
      expect(
        find.text('Карта обновилась. Постройте маршрут заново.'),
        findsOneWidget,
      );
      expect(
        tester
            .widget<MapFloorCanvas>(find.byType(MapFloorCanvas))
            .routeSegments,
        isEmpty,
        reason: 'A callback from the old snapshot cannot restore its route',
      );
    },
  );
}
