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
import 'package:rtu_mirea_app/map/widgets/map_route_guidance.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/svg_interactive_map_controller.dart';

import '../../helpers/pump_app.dart';

class _CampusRepository extends Mock implements CampusRepository {}

class _NoCache implements MapDataCache {
  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}
}

class _RecordingController extends SvgInteractiveMapController {
  final focuses = <List<Offset>>[];

  @override
  void focusPoints(List<Offset> points) => focuses.add(List.of(points));
}

Map<String, Object?> _document() => {
  'id': 'campus',
  'short_title': 'В-78',
  'revision': 2,
  'floors': [
    for (final level in [1, 2])
      {
        'id': 'floor-$level',
        'level': level,
        'width': 100,
        'height': 100,
        'svg':
            '<svg viewBox="0 0 100 100"> '
            '<rect x="10" y="10" width="80" height="80" /> '
            '</svg>',
      },
  ],
  'rooms': [
    {'id': 'start', 'floor_id': 'floor-1', 'label': 'А-101', 'x': 15, 'y': 15},
    {'id': 'end', 'floor_id': 'floor-2', 'label': 'А-201', 'x': 15, 'y': 75},
  ],
  'graph': {
    'nodes': [
      {'id': 'n1', 'floor_id': 'floor-1', 'room_id': 'start', 'x': 15, 'y': 15},
      {'id': 'n2', 'floor_id': 'floor-1', 'kind': 'stairs', 'x': 75, 'y': 15},
      {'id': 'n3', 'floor_id': 'floor-2', 'kind': 'stairs', 'x': 75, 'y': 75},
      {'id': 'n4', 'floor_id': 'floor-2', 'room_id': 'end', 'x': 15, 'y': 75},
    ],
    'edges': [
      {
        'id': 'walk-1',
        'distance_meters': 20,
        'from_node_id': 'n1',
        'to_node_id': 'n2',
      },
      {
        'id': 'stairs',
        'kind': 'stairs',
        'traversal_cost': 10,
        'from_node_id': 'n2',
        'to_node_id': 'n3',
      },
      {
        'id': 'walk-2',
        'distance_meters': 20,
        'from_node_id': 'n3',
        'to_node_id': 'n4',
      },
    ],
  },
};

class _Harness {
  final controller = _RecordingController();
  late final MapDataRepository repository;
  late final MapBloc map;
  late final FreeRoomsCubit free;
  late final IndoorRoute route;
  bool online = false;

  Future<void> mount(WidgetTester tester) async {
    repository = MapDataRepository(
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
            : _document(),
      ),
      rpc: (name, _) async {
        if (!online) throw const MapDataException('offline');
        return name == 'get_map_catalog'
            ? {
                'campuses': [
                  {'id': 'campus', 'revision': 2},
                ],
              }
            : _document();
      },
    );
    await tester.runAsync(() async {
      map = MapBloc(
        availableCampuses: [],
        repository: repository,
        objectsService: ObjectsService(
          onLoadObjects: (_) async => '{"objects":[]}',
        ),
      );
      final campusRepository = _CampusRepository();
      when(campusRepository.getFreeRooms).thenAnswer((_) async => []);
      free = FreeRoomsCubit(campusRepository: campusRepository);
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
    route = IndoorRoutePlanner(
      IndoorNavigationGraph.fromJson(map.state.campusData!.graph),
    ).findRoute(startNodeId: 'n1', destinationNodeId: 'n4').route!;
    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<MapBloc>.value(value: map),
          BlocProvider<FreeRoomsCubit>.value(value: free),
        ],
        child: MapView(mapController: controller),
      ),
      size: const Size(390, 844),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Маршрут'));
    await tester.pumpAndSettle();
    final sheet = tester.widget<MapRouteSheet>(find.byType(MapRouteSheet));
    sheet.onApply(route);
    sheet.onClose!();
    await tester.pumpAndSettle();
    controller.focuses.clear();
  }

  MapRouteGuidance guidance(WidgetTester tester) =>
      tester.widget<MapRouteGuidance>(find.byType(MapRouteGuidance));

  Future<void> move(
    WidgetTester tester, {
    required String expectedFloor,
    bool back = false,
  }) async {
    final callback = back
        ? guidance(tester).onPrevious!
        : guidance(tester).onNext!;
    if (map.state.selectedFloor!.id == expectedFloor) {
      callback();
    } else {
      await tester.runAsync(() async {
        final loaded = map.stream.firstWhere(
          (state) =>
              state.status == .loaded &&
              state.selectedFloor?.id == expectedFloor,
        );
        callback();
        await loaded.timeout(const Duration(seconds: 10));
      });
    }
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets(
    'stairs stay on departure floor until advancing and back restores it',
    (tester) async {
      final harness = _Harness();
      await harness.mount(tester);
      final stairIndex = harness.route.instructions.indexWhere(
        (instruction) => instruction.maneuver == IndoorManeuver.stairs,
      );
      for (var index = 0; index < stairIndex; index++) {
        await harness.move(tester, expectedFloor: 'floor-1');
      }
      expect(harness.map.state.selectedFloor!.id, 'floor-1');
      expect(harness.guidance(tester).stepIndex, stairIndex);
      expect(harness.controller.focuses.last, [const Offset(75, 15)]);
      await harness.move(tester, expectedFloor: 'floor-2');
      expect(harness.map.state.selectedFloor!.id, 'floor-2');
      expect(harness.controller.focuses.last, [
        const Offset(75, 75),
        const Offset(15, 75),
      ]);
      await harness.move(tester, expectedFloor: 'floor-1', back: true);
      expect(harness.map.state.selectedFloor!.id, 'floor-1');
      expect(harness.guidance(tester).stepIndex, stairIndex);
      expect(harness.controller.focuses.last, [const Offset(75, 15)]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'closing route cancels camera focus already queued for next frame',
    (tester) async {
      final harness = _Harness();
      await harness.mount(tester);
      final guidance = harness.guidance(tester);
      guidance.onNext!();
      guidance.onClose();
      await tester.pumpAndSettle();
      expect(find.byType(MapRouteGuidance), findsNothing);
      expect(harness.controller.focuses, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('closing during floor change cancels deferred arrival focus', (
    tester,
  ) async {
    final harness = _Harness();
    await harness.mount(tester);
    final stairIndex = harness.route.instructions.indexWhere(
      (instruction) => instruction.maneuver == IndoorManeuver.stairs,
    );
    for (var index = 0; index < stairIndex; index++) {
      await harness.move(tester, expectedFloor: 'floor-1');
    }
    harness.controller.focuses.clear();
    final guidance = harness.guidance(tester);
    await tester.runAsync(() async {
      final loaded = harness.map.stream.firstWhere(
        (state) =>
            state.status == .loaded && state.selectedFloor?.id == 'floor-2',
      );
      guidance.onNext!();
      guidance.onClose();
      await loaded.timeout(const Duration(seconds: 10));
    });
    await tester.pumpAndSettle();
    expect(harness.map.state.selectedFloor!.id, 'floor-2');
    expect(find.byType(MapRouteGuidance), findsNothing);
    expect(harness.controller.focuses, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'snapshot replacement cancels queued focus even at same revision',
    (tester) async {
      final harness = _Harness();
      await harness.mount(tester);
      final snapshot = harness.map.state.campusData;
      harness.guidance(tester).onNext!();
      harness.online = true;
      await tester.runAsync(() async {
        final refreshed = harness.map.stream.firstWhere(
          (state) =>
              state.status == .loaded &&
              state.campusData?.origin.name == 'remote',
        );
        harness.map.add(const MapEvent.refreshRequested());
        await refreshed.timeout(const Duration(seconds: 10));
      });
      await tester.pumpAndSettle();
      expect(identical(snapshot, harness.map.state.campusData), isFalse);
      expect(snapshot!.revision, harness.map.state.campusData!.revision);
      expect(find.byType(MapRouteGuidance), findsNothing);
      expect(harness.controller.focuses, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('refresh discards a route focus waiting on a different floor', (
    tester,
  ) async {
    final harness = _Harness();
    await harness.mount(tester);
    final stairIndex = harness.route.instructions.indexWhere(
      (instruction) => instruction.maneuver == IndoorManeuver.stairs,
    );
    for (var index = 0; index < stairIndex; index++) {
      await harness.move(tester, expectedFloor: 'floor-1');
    }
    harness.controller.focuses.clear();
    harness.online = true;
    await tester.runAsync(() async {
      final refreshed = harness.map.stream.firstWhere(
        (state) =>
            state.status == .loaded &&
            state.campusData?.origin.name == 'remote',
      );
      harness.guidance(tester).onNext!();
      harness.map.add(const MapEvent.refreshRequested());
      await refreshed.timeout(const Duration(seconds: 10));
    });
    await tester.pumpAndSettle();
    expect(harness.map.state.selectedFloor!.id, 'floor-1');
    expect(find.byType(MapRouteGuidance), findsNothing);
    await tester.runAsync(() async {
      final loaded = harness.map.stream.firstWhere(
        (state) =>
            state.status == .loaded && state.selectedFloor?.id == 'floor-2',
      );
      harness.map.add(
        MapEvent.floorSelected(
          campus: harness.map.state.selectedCampus!,
          floor: harness.map.state.campusData!.floorForId('floor-2')!.floor,
        ),
      );
      await loaded.timeout(const Duration(seconds: 10));
    });
    await tester.pumpAndSettle();
    expect(harness.controller.focuses, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
