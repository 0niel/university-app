import 'dart:async';
import 'dart:convert';

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
import 'package:rtu_mirea_app/map/widgets/map_place_details_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_sheet.dart';

import '../../helpers/pump_app.dart';

class _CampusRepository extends Mock implements CampusRepository {}

class _MemoryCache implements MapDataCache {
  final entries = <String, String>{};

  @override
  Future<String?> read(String key) async => entries[key];

  @override
  Future<void> write(String key, String value) async => entries[key] = value;
}

Map<String, Object?> _campus(int revision, {bool newerSource = false}) => {
  'id': 'campus',
  'short_title': 'В-78',
  'revision': revision,
  'source_plan_sha256': newerSource ? 'new-source' : 'published-source',
  'source_captured_at': newerSource
      ? '2026-10-02T00:00:00Z'
      : '2026-10-01T00:00:00Z',
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
      {'id': 'n2', 'floor_id': 'first', 'room_id': 'end', 'x': 75, 'y': 75},
    ],
    'edges': [
      {
        'id': 'edge',
        'distance_meters': revision == 7 ? 20 : 42,
        'from_node_id': 'n1',
        'to_node_id': 'n2',
      },
    ],
  },
};

Map<String, Object?> _catalog(int revision) => {
  'campuses': [
    {'id': 'campus', 'revision': revision},
  ],
};

class _RefreshFixture {
  _RefreshFixture({this.newerBundle = false, this.delayFirstRoom = false});

  final bool newerBundle;
  final bool delayFirstRoom;
  final requests = <String>[];
  final campusRequests = <Completer<Object?>>[];
  final firstRoom = Completer<Object?>();
  late final MapDataRepository repository;
  late final MapBloc map;

  int get initialRevision => newerBundle ? 17 : 7;
  int get nextRevision => initialRevision + 1;

  Map<String, Object?> roomDetails(int revision) => {
    'room': (_campus(revision)['rooms']! as List).last,
    'date': '2026-10-10',
    'revision': revision,
    'schedule_linked': false,
    'schedule': <Object>[],
  };

  MapPlaceDetailsSheet sheet(WidgetTester tester) =>
      tester.widget<MapPlaceDetailsSheet>(find.byType(MapPlaceDetailsSheet));

  Future<void> pump(WidgetTester tester) async {
    final cache = _MemoryCache();
    final now = DateTime.utc(2026, 10, 10);
    final bundled = _campus(2, newerSource: true);
    MapDataRepository create(MapDataRpc rpc) => MapDataRepository(
      organizationId: 'mirea',
      cache: cache,
      clock: () => now,
      bundledCatalogAsset: newerBundle ? 'catalog.json' : null,
      assetLoader: (path) async => jsonEncode(
        path == 'catalog.json'
            ? {
                'campuses': [bundled],
              }
            : bundled,
      ),
      rpc: rpc,
    );
    final seed = create(
      (name, _) async => name == 'get_map_catalog'
          ? _catalog(initialRevision)
          : _campus(initialRevision),
    );
    await seed.loadCatalog();
    await seed.loadCampus('campus');
    seed.dispose();
    repository = create((name, _) async {
      requests.add(name);
      return switch (name) {
        'get_map_catalog' => _catalog(nextRevision),
        'get_map_campus' => () {
          final request = Completer<Object?>();
          campusRequests.add(request);
          return request.future;
        }(),
        'get_map_room'
            when delayFirstRoom &&
                requests.where((name) => name == 'get_map_room').length == 1 =>
          firstRoom.future,
        'get_map_room' => roomDetails(nextRevision),
        _ => <String, Object?>{},
      };
    });
    map = MapBloc(
      availableCampuses: const [],
      repository: repository,
      objectsService: ObjectsService(
        onLoadObjects: (_) async => '{"objects":[]}',
      ),
    );
    final campusRepository = _CampusRepository();
    when(campusRepository.getFreeRooms).thenAnswer((_) async => []);
    final free = FreeRoomsCubit(campusRepository: campusRepository);
    map.add(const MapEvent.initialized());
    unawaited(free.load());
    await tick(tester);
    expect(map.state.status, MapStatus.loaded);
    expect(requests, isEmpty);
    expect(repository.isCampusCacheFresh('campus'), isTrue);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      if (!firstRoom.isCompleted) {
        firstRoom.complete(roomDetails(initialRevision));
      }
      for (final request in campusRequests) {
        if (!request.isCompleted) request.complete(_campus(nextRevision));
      }
      var closed = false;
      unawaited(map.close().then((_) => closed = true));
      for (var i = 0; i < 10 && !closed; i++) {
        await tester.pump(const Duration(milliseconds: 1));
      }
      expect(closed, isTrue);
      await free.close();
      repository.dispose();
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
    await tester.enterText(find.byType(AppSearchField), 'А-102');
    await tester.pumpAndSettle();
    await tester.tap(find.text('А-102').last);
    await tick(tester);
  }

  Future<void> tick(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> complete(WidgetTester tester, {bool fail = false}) async {
    if (fail) {
      campusRequests.last.completeError(const MapDataException('offline'));
    } else {
      campusRequests.last.complete(_campus(nextRevision));
    }
    await tester.pumpAndSettle();
    expect(map.state.status, MapStatus.loaded);
  }
}

void _expectRouteEnabled(WidgetTester tester, bool enabled) {
  for (final label in ['Маршрут сюда', 'Отсюда']) {
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, label)).onPressed,
      enabled ? isNotNull : isNull,
    );
  }
}

void main() {
  testWidgets('opening newer room details refreshes the plan in place', (
    tester,
  ) async {
    final fixture = _RefreshFixture();
    await fixture.pump(tester);
    final sheetState = tester.state(find.byType(MapPlaceDetailsSheet));
    expect(fixture.campusRequests, hasLength(1));
    expect(fixture.sheet(tester).isRefreshing, isTrue);
    expect(find.text('Обновляем план и проходы для маршрута…'), findsOneWidget);
    _expectRouteEnabled(tester, false);
    await fixture.tick(tester);
    expect(fixture.campusRequests, hasLength(1));

    await fixture.complete(tester);
    expect(tester.state(find.byType(MapPlaceDetailsSheet)), same(sheetState));
    expect(fixture.sheet(tester).campus, same(fixture.map.state.campusData));
    expect(fixture.sheet(tester).campus.revision, 8);
    expect(fixture.sheet(tester).isRefreshing, isFalse);
    expect(find.text('Обновить карту'), findsNothing);
    _expectRouteEnabled(tester, true);

    await tester.tap(find.text('Маршрут сюда'));
    await tester.pumpAndSettle();
    final routeSheet = tester.widget<MapRouteSheet>(find.byType(MapRouteSheet));
    expect(routeSheet.campus, same(fixture.map.state.campusData));
    expect(routeSheet.destinationRoomId, 'end');
    await tester.tap(find.text('Выберите начало'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('А-101'));
    await tester.pumpAndSettle();
    expect(find.text('42 м · ≈ 1 мин · 1 эт.'), findsOneWidget);
    await tester.tap(find.text('Показать путь'));
    await tester.pumpAndSettle();
    expect(find.byType(MapRouteSheet), findsNothing);
    expect(
      tester.widget<MapFloorCanvas>(find.byType(MapFloorCanvas)).routeSegments,
      isNotEmpty,
    );
    expect(fixture.campusRequests, hasLength(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('failed automatic refresh keeps the sheet open for retry', (
    tester,
  ) async {
    final fixture = _RefreshFixture();
    await fixture.pump(tester);
    final sheetState = tester.state(find.byType(MapPlaceDetailsSheet));
    await fixture.complete(tester, fail: true);
    expect(tester.state(find.byType(MapPlaceDetailsSheet)), same(sheetState));
    expect(fixture.sheet(tester).campus.revision, 7);
    expect(fixture.sheet(tester).isRefreshing, isFalse);
    expect(
      find.textContaining('Не удалось обновить план для маршрута'),
      findsOneWidget,
    );
    _expectRouteEnabled(tester, false);
    await fixture.tick(tester);
    expect(fixture.campusRequests, hasLength(1));

    await tester.ensureVisible(find.text('Обновить карту'));
    await tester.tap(find.text('Обновить карту'));
    await fixture.tick(tester);
    expect(fixture.campusRequests, hasLength(2));
    expect(fixture.sheet(tester).isRefreshing, isTrue);
    _expectRouteEnabled(tester, false);
    await fixture.complete(tester);
    expect(tester.state(find.byType(MapPlaceDetailsSheet)), same(sheetState));
    expect(fixture.sheet(tester).campus.revision, 8);
    _expectRouteEnabled(tester, true);
    expect(find.text('Обновить карту'), findsNothing);
    expect(fixture.campusRequests, hasLength(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('publication refresh accepts a retained newer bundled plan', (
    tester,
  ) async {
    final fixture = _RefreshFixture(newerBundle: true);
    await fixture.pump(tester);
    final displayed = fixture.map.state.campusData!;
    final sheetState = tester.state(find.byType(MapPlaceDetailsSheet));
    expect(displayed.revision, 2);
    expect(fixture.campusRequests, hasLength(1));
    _expectRouteEnabled(tester, false);

    await fixture.complete(tester);
    expect(fixture.map.state.campusData, same(displayed));
    expect(tester.state(find.byType(MapPlaceDetailsSheet)), same(sheetState));
    expect(fixture.sheet(tester).campus, same(displayed));
    _expectRouteEnabled(tester, true);
    expect(find.text('Обновить карту'), findsNothing);
    await fixture.tick(tester);
    expect(fixture.campusRequests, hasLength(1));
    await tester.tap(find.text('Маршрут сюда'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MapRouteSheet>(find.byType(MapRouteSheet)).campus,
      same(displayed),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('late room details cannot invalidate an updated plan', (
    tester,
  ) async {
    final fixture = _RefreshFixture(delayFirstRoom: true);
    await fixture.pump(tester);
    final sheetState = tester.state(find.byType(MapPlaceDetailsSheet));
    expect(fixture.campusRequests, isEmpty);
    fixture.map.add(const MapEvent.refreshRequested());
    await fixture.tick(tester);
    expect(fixture.campusRequests, hasLength(1));
    await fixture.complete(tester);
    expect(tester.state(find.byType(MapPlaceDetailsSheet)), same(sheetState));
    expect(fixture.sheet(tester).campus.revision, 8);
    expect(
      fixture.requests.where((name) => name == 'get_map_room'),
      hasLength(2),
    );
    _expectRouteEnabled(tester, true);

    fixture.firstRoom.complete(fixture.roomDetails(7));
    await fixture.tick(tester);
    _expectRouteEnabled(tester, true);
    expect(find.text('Обновить карту'), findsNothing);
    expect(fixture.campusRequests, hasLength(1));
    expect(tester.takeException(), isNull);
  });
}
