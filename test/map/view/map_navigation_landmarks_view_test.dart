import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/services/objects_service.dart';
import 'package:rtu_mirea_app/map/view/map_view.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_canvas.dart';
import 'package:rtu_mirea_app/map/widgets/svg_interactive_map.dart';
import 'package:rtu_mirea_app/map/widgets/svg_interactive_map_controller.dart';

import '../../helpers/pump_app.dart';

class _CampusRepository extends Mock implements CampusRepository {}

class _NoCache implements MapDataCache {
  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}
}

class _Controller extends SvgInteractiveMapController {
  final focused = <List<Offset>>[];

  @override
  void focusPoints(List<Offset> points) {
    focused.add(List.of(points));
    super.focusPoints(points);
  }
}

Map<String, Object?> _document() => {
  'id': 'campus',
  'short_title': 'В-78',
  'revision': 1,
  'floors': [
    for (final (index, id) in ['one', 'two'].indexed)
      {
        'id': id,
        'level': index + 1,
        'width': 400,
        'height': 400,
        'svg':
            '<svg xmlns="http://www.w3.org/2000/svg" '
            'viewBox="0 0 400 400" width="400" height="400"> '
            '<rect data-object="room-$id" x="10" y="10" '
            'width="80" height="80" fill="#dddddd"/> '
            '<rect x="310" y="310" width="80" height="80" '
            'fill="#dddddd"/></svg>',
      },
  ],
  'rooms': [
    for (final id in ['one', 'two'])
      {
        'id': 'room-$id',
        'floor_id': id,
        'label': 'Аудитория',
        'kind': 'room',
        'x': 50,
        'y': 50,
      },
  ],
  'graph': {
    'nodes': [
      {'id': 'stairs-one', 'floor_id': 'one', 'x': 200, 'y': 200},
      {'id': 'stairs-two', 'floor_id': 'two', 'x': 120, 'y': 200},
    ],
    'edges': [
      {
        'id': 'up-only',
        'from_node_id': 'stairs-one',
        'to_node_id': 'stairs-two',
        'kind': 'stairs',
        'traversal_cost': 20,
      },
    ],
  },
};

Future<void> _waitForLandmarks(WidgetTester tester) async {
  for (var attempt = 0; attempt < 50; attempt++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();
    if (tester
        .widget<MapFloorCanvas>(find.byType(MapFloorCanvas))
        .navigationLandmarks
        .isNotEmpty) {
      await tester.pumpAndSettle();
      return;
    }
  }
  fail('The derived staircase was not prepared');
}

Future<(MapBloc, _Controller)> _pump(WidgetTester tester) async {
  final repository = MapDataRepository(
    organizationId: 'mirea',
    cache: _NoCache(),
    rpc: (name, _) async => name == 'get_map_catalog'
        ? {
            'campuses': [_document()],
          }
        : _document(),
  );
  late MapBloc map;
  late FreeRoomsCubit free;
  final controller = _Controller();
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.runAsync(() async {
      await map.close();
      await free.close();
      repository.dispose();
      controller.dispose();
    });
  });
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
    final loaded = map.stream.firstWhere((state) => state.status == .loaded);
    map.add(const MapEvent.initialized());
    await loaded;
    await free.load();
  });
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
  await _waitForLandmarks(tester);
  return (map, controller);
}

Future<void> _tapStairs(WidgetTester tester) async {
  final canvas = tester.widget<MapFloorCanvas>(find.byType(MapFloorCanvas));
  final marker = canvas.navigationLandmarks.single.place;
  final box = tester.renderObject<RenderBox>(find.byType(MapFloorCanvas));
  final point = Offset(marker.x, marker.y);
  expect(canvas.labelHitIndex!.hitTest(point), marker.id);
  final screenPoint = box.localToGlobal(point);
  expect(screenPoint.dy, inInclusiveRange(180, 670));
  await tester.tapAt(screenPoint);
  await tester.pump(const Duration(milliseconds: 350));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'tap derived stairs opens a sheet and follows only directed floors',
    (tester) async {
      final (map, controller) = await _pump(tester);
      await _tapStairs(tester);
      expect(find.text('Переходы на другие этажи'), findsOneWidget);
      final target = find.widgetWithText(AppListRow, '2 этаж');
      expect(target, findsOneWidget);
      await tester.tap(target);
      await tester.runAsync(() async {
        if (map.state.status == .loaded &&
            map.state.selectedFloor?.id == 'two') {
          return;
        }
        final loaded = map.stream.firstWhere(
          (state) =>
              state.status == .loaded && state.selectedFloor?.id == 'two',
        );
        await loaded;
      });
      await tester.pumpAndSettle();
      expect(map.state.selectedFloor?.id, 'two');
      expect(controller.focused.last, [const Offset(120, 200)]);
      await _tapStairs(tester);
      expect(
        find.text('Связь с другими этажами не указана в плане.'),
        findsOneWidget,
      );
      expect(find.widgetWithText(AppListRow, '1 этаж'), findsNothing);
    },
  );

  testWidgets('an old floor marker cannot open a sheet after changing floors', (
    tester,
  ) async {
    final (map, _) = await _pump(tester);
    final previous = tester.widget<SvgInteractiveMap>(
      find.byType(SvgInteractiveMap),
    );
    final marker = previous.navigationLandmarks.single;
    await tester.runAsync(() async {
      final loaded = map.stream.firstWhere(
        (state) => state.status == .loaded && state.selectedFloor?.id == 'two',
      );
      map.add(
        MapEvent.floorSelected(
          campus: map.state.selectedCampus!,
          floor: map.state.campusData!.floorForId('two')!.floor,
        ),
      );
      await loaded;
    });
    previous.onNavigationLandmarkTap!(marker);
    await tester.pumpAndSettle();
    expect(find.text('Переходы на другие этажи'), findsNothing);
    expect(find.text('Показать переход на плане'), findsNothing);
  });

  testWidgets('a sheet from an old campus snapshot cannot move the camera', (
    tester,
  ) async {
    final (map, controller) = await _pump(tester);
    await _tapStairs(tester);
    final target = tester.widget<AppListRow>(
      find.widgetWithText(AppListRow, '2 этаж'),
    );
    final previous = map.state.campusData;
    final previousMap = tester.widget<SvgInteractiveMap>(
      find.byType(SvgInteractiveMap),
    );
    await tester.runAsync(() async {
      final loaded = map.stream.firstWhere(
        (state) =>
            state.status == .loaded && !identical(state.campusData, previous),
      );
      map.add(const MapEvent.refreshRequested());
      await loaded;
    });
    target.onTap!();
    previousMap.onNavigationLandmarkTap!(
      previousMap.navigationLandmarks.single,
    );
    await tester.pumpAndSettle();
    expect(map.state.selectedFloor?.id, 'one');
    expect(controller.focused, isEmpty);
    expect(find.text('Переходы на другие этажи'), findsNothing);
  });
}
