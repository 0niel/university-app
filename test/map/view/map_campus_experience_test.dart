import 'dart:async';

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
import 'package:rtu_mirea_app/map/widgets/map_place_details_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/map_places_explorer.dart';

import '../../helpers/pump_app.dart';

class _CampusRepository extends Mock implements CampusRepository {}

class _MemoryCache implements MapDataCache {
  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}
}

void main() {
  final rooms = [
    {
      'id': 'a101',
      'floor_id': 'one',
      'label': 'А-101',
      'kind': 'room',
      'x': 45,
      'y': 45,
    },
    {
      'id': 'b201',
      'legacy_ids': ['previous-b201'],
      'floor_id': 'two',
      'label': 'Б-201',
      'kind': 'room',
      'x': 45,
      'y': 45,
      'equipment': ['Проектор'],
    },
    {
      'id': 'cafe',
      'floor_id': 'one',
      'label': 'Столовая',
      'kind': 'cafeteria',
      'x': 135,
      'y': 45,
    },
  ];
  final document = <String, Object?>{
    'id': 'test-campus',
    'title': 'Тестовый кампус',
    'short_title': 'В-78',
    'revision': 7,
    'source_url': 'https://pulse.mirea.ru/services/maps',
    'source_label': 'Пульс МИРЭА',
    'floors': [
      for (final (index, id) in ['one', 'two'].indexed)
        {
          'id': id,
          'label': '${index + 1}',
          'level': index + 1,
          'width': 200,
          'height': 100,
          'svg':
              '<svg xmlns="http://www.w3.org/2000/svg" '
              'viewBox="0 0 200 100" width="200" height="100"> '
              '<rect data-object="${index == 0 ? 'a101' : 'b201'}" '
              'x="10" y="10" width="70" height="70" fill="#dddddd"/> '
              '</svg>',
        },
    ],
    'rooms': rooms,
    'graph': {'nodes': <Object>[], 'edges': <Object>[]},
  };

  Future<(MapBloc, FreeRoomsCubit)> pump(
    WidgetTester tester, {
    String? initialRoom,
    TextScaler scaler = TextScaler.noScaling,
    Size size = const Size(390, 844),
  }) async {
    final repository = MapDataRepository(
      organizationId: 'mirea',
      cache: _MemoryCache(),
      rpc: (name, parameters) async => switch (name) {
        'get_map_catalog' => {
          'campuses': [document],
        },
        'get_map_campus' => document,
        'get_map_room' => {
          'room': rooms.firstWhere((r) => r['id'] == parameters['p_room_id']),
          'date': '2026-09-06',
          'revision': 7,
          'schedule_linked': false,
          'schedule': <Object>[],
        },
        _ => <String, Object?>{},
      },
    );
    final map = MapBloc(
      availableCampuses: const [],
      repository: repository,
      objectsService: ObjectsService(
        onLoadObjects: (_) async => '{"objects":[]}',
      ),
    );
    final campusRepository = _CampusRepository();
    when(campusRepository.getFreeRooms).thenAnswer((_) async => []);
    final free = FreeRoomsCubit(campusRepository: campusRepository);
    unawaited(free.load());
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
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
        child: MapView(
          initialCampusId: initialRoom == null ? null : 'test-campus',
          initialRoomId: initialRoom,
        ),
      ),
      size: size,
      textScaler: scaler,
    );
    map.add(const MapEvent.initialized());
    await tester.pumpAndSettle();
    return (map, free);
  }

  for (final scale in [1.0, 2.0]) {
    testWidgets('remote map discovery fits $scale text and opens services', (
      tester,
    ) async {
      await pump(tester, scaler: TextScaler.linear(scale));
      expect(find.text('Маршрут'), findsOneWidget);
      expect(find.byTooltip('Действия с картой'), findsOneWidget);
      await tester.ensureVisible(find.byTooltip('Развернуть список'));
      await tester.tap(find.byTooltip('Развернуть список'));
      await tester.pumpAndSettle();
      expect(find.byType(MapPlacesExplorer), findsOneWidget);
      expect(find.text('Места и сервисы'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('compact campus map stays usable at 320px with $scale text', (
      tester,
    ) async {
      await pump(
        tester,
        scaler: TextScaler.linear(scale),
        size: const Size(320, 568),
      );
      expect(tester.takeException(), isNull);
      final canvas = tester.getRect(
        find.byKey(const ValueKey('map-canvas-surface')),
      );
      final panel = tester.getRect(
        find.byKey(const ValueKey('map-panel-surface')),
      );
      expect(panel.top - canvas.top, greaterThan(280));
      await tester.tap(find.byTooltip('Развернуть список'));
      await tester.pumpAndSettle();
      expect(find.byType(MapPlacesExplorer), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Свернуть список'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('room deep link selects its floor and opens its details', (
    tester,
  ) async {
    final (map, _) = await pump(tester, initialRoom: 'b201');
    expect(map.state.selectedFloor?.id, 'two');
    expect(find.byType(MapPlaceDetailsSheet), findsOneWidget);
    expect(find.text('Б-201'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('legacy room link opens the current room and its floor', (
    tester,
  ) async {
    final (map, _) = await pump(tester, initialRoom: 'previous-b201');
    expect(map.state.selectedFloor?.id, 'two');
    expect(find.byType(MapPlaceDetailsSheet), findsOneWidget);
    expect(
      tester
          .widget<MapPlaceDetailsSheet>(find.byType(MapPlaceDetailsSheet))
          .room
          .id,
      'b201',
    );
    expect(find.textContaining('Место по ссылке не найдено'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byType(AppSheetCloseButton));
    await tester.pumpAndSettle();
    expect(find.byType(MapPlaceDetailsSheet), findsNothing);
  });

  testWidgets('map menu keeps saved places editing and source reachable', (
    tester,
  ) async {
    await pump(
      tester,
      size: const Size(320, 568),
      scaler: const TextScaler.linear(2),
    );
    await tester.tap(find.byTooltip('Действия с картой'));
    await tester.pumpAndSettle();
    expect(find.text('На карте города'), findsOneWidget);
    expect(find.text('Сохранённые места'), findsOneWidget);
    expect(find.text('Улучшить карту'), findsOneWidget);
    await tester.ensureVisible(find.text('О плане и источнике'));
    await tester.tap(find.text('О плане и источнике'));
    await tester.pumpAndSettle();
    expect(find.text('Источник планов: Пульс МИРЭА'), findsOneWidget);
    expect(find.text('Открыть источник'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('search discovers equipment on another floor', (tester) async {
    await pump(tester);
    await tester.enterText(find.byType(AppSearchField), 'проектор');
    await tester.pumpAndSettle();
    expect(find.text('Б-201'), findsOneWidget);
    expect(find.text('Столовая'), findsNothing);
    await tester.tap(find.text('Б-201'));
    await tester.pumpAndSettle();
    expect(find.byType(MapPlaceDetailsSheet), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
