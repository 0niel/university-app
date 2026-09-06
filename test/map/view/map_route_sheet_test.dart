import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_sheet.dart';

import '../../helpers/pump_app.dart';

void main() {
  Future<void> pump(
    WidgetTester tester, {
    CampusMapData? campus,
    TextScaler textScaler = TextScaler.noScaling,
  }) => tester.pumpApp(
    Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: MapRouteSheet(
          campus: campus ?? _campus(),
          startRoomId: 'room-start',
          destinationRoomId: 'room-destination',
          onApply: (_) {},
          onContribute: () {},
        ),
      ),
    ),
    size: const Size(320, 568),
    textScaler: textScaler,
  );

  testWidgets('shows multi-floor instructions for a directed route', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('По лестнице на 2 этаж'), findsOneWidget);
    expect(find.text('Показать путь'), findsOneWidget);
    expect(find.text('Откуда: Вход'), findsOneWidget);
    expect(find.text('Куда: А-201'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reversing a one-way path clears the previous successful route', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byTooltip('Поменять местами'));
    await tester.pump();

    expect(find.text('Откуда: А-201'), findsOneWidget);
    expect(find.text('Куда: Вход'), findsOneWidget);
    expect(find.text('Показать путь'), findsNothing);
    expect(find.textContaining('Подходящий путь не найден'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final movedRoomId in ['room-start', 'room-destination']) {
    testWidgets('refuses stale graph entry for moved $movedRoomId', (
      tester,
    ) async {
      final campus = _campus();
      final index = campus.rooms.indexWhere((room) => room.id == movedRoomId);
      campus.rooms[index] = MapPlaceData.fromJson({
        ...campus.rooms[index].raw,
        'x': 80,
        'y': 80,
        'navigation_needs_review': true,
      });
      await pump(tester, campus: campus);
      expect(
        find.text('Место перенесено. Проходы к нему ещё проверяются.'),
        findsOneWidget,
      );
      expect(find.text('Показать путь'), findsNothing);
      expect(find.text('По лестнице на 2 этаж'), findsNothing);
      final movedLabel = movedRoomId == 'room-start' ? 'Вход' : 'А-201';
      await tester.tap(
        find.text(
          movedRoomId == 'room-start'
              ? 'Выберите начало'
              : 'Выберите назначение',
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(movedLabel), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('missing start entry requests a point without guessing', (
    tester,
  ) async {
    final campus = _campus();
    final nodes = campus.graph['nodes']! as List;
    (nodes.first as Map).remove('room_id');
    await pump(tester, campus: campus);
    expect(
      find.text('Начальная точка пока не соединена с графом проходов.'),
      findsOneWidget,
    );
    expect(find.text('Выберите начало'), findsOneWidget);
    expect(find.text('Показать путь'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'step-free constraint clears stair-only guidance and restores it',
    (
      tester,
    ) async {
      await pump(tester);
      await tester.ensureVisible(find.text('Параметры маршрута'));
      await tester.tap(find.text('Параметры маршрута'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Без лестниц'));
      await tester.tap(find.text('Без лестниц').last);
      await tester.pump();

      expect(find.text('По лестнице на 2 этаж'), findsNothing);
      expect(find.text('Показать путь'), findsNothing);
      expect(find.textContaining('Подходящий путь не найден'), findsOneWidget);

      await tester.tap(find.text('Без лестниц').last);
      await tester.pump();
      expect(find.text('По лестнице на 2 этаж'), findsOneWidget);
      expect(find.text('Показать путь'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'wheelchair option does not expose an unverified accessible path',
    (
      tester,
    ) async {
      await pump(tester);
      await tester.ensureVisible(find.text('Параметры маршрута'));
      await tester.tap(find.text('Параметры маршрута'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('На коляске'));
      await tester.tap(find.text('На коляске'));
      await tester.pump();
      expect(find.text('Показать путь'), findsNothing);
      expect(find.textContaining('Подходящий путь не найден'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'uses a verified alternative when the first room entry is closed',
    (
      tester,
    ) async {
      await pump(tester, campus: _campus(alternativeEntry: true));
      expect(find.text('На лифте на 2 этаж'), findsOneWidget);
      await tester.ensureVisible(find.text('Параметры маршрута'));
      await tester.tap(find.text('Параметры маршрута'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('На коляске'));
      await tester.tap(find.text('На коляске'));
      await tester.pump();
      expect(find.text('Показать путь'), findsOneWidget);
      expect(find.text('На лифте на 2 этаж'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'unmeasured portal shows guidance without invented metres or ETA',
    (
      tester,
    ) async {
      await pump(tester, campus: _campus(unknownPortal: true));
      expect(find.text('По лестнице на 2 этаж'), findsOneWidget);
      expect(find.text('Показать путь'), findsOneWidget);
      expect(find.text('Оптимальный путь'), findsNothing);
      expect(find.text('2 эт.'), findsOneWidget);
      expect(find.textContaining('мин'), findsNothing);
      expect(find.text('20 м'), findsNothing);
      expect(find.text('15 м'), findsNothing);
      expect(
        find.textContaining('нет оценки расстояния или времени'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'picker groups room entries, sorts naturally and omits technical nodes',
    (
      tester,
    ) async {
      final campus = _campus();
      final nodes = campus.graph['nodes']! as List;
      for (final room in ['А-10', 'А-2']) {
        campus.rooms.add(
          MapPlaceData.fromJson({
            'id': room,
            'floor_id': 'floor-1',
            'label': room,
            'x': 5,
            'y': 5,
          }),
        );
        nodes.add({
          'id': room,
          'floor_id': 'floor-1',
          'room_id': room,
          'x': 5,
          'y': 5,
        });
      }
      nodes.addAll(<Map<String, Object>>[
        {
          'id': 'another-entry',
          'floor_id': 'floor-1',
          'room_id': 'room-start',
          'x': 2,
          'y': 0,
        },
        {
          'id': 'technical',
          'floor_id': 'floor-1',
          'label': 'Служебный узел',
          'kind': 'door',
          'x': 2,
          'y': 0,
        },
      ]);
      await pump(tester, campus: campus);
      await tester.tap(find.text('Откуда: Вход'));
      await tester.pumpAndSettle();
      final labels = tester
          .widgetList<AppListRow>(
            find.descendant(
              of: find.byType(ListView),
              matching: find.byType(AppListRow),
            ),
          )
          .map((row) => row.title)
          .toList();
      expect(labels.take(3), ['А-2', 'А-10', 'Вход']);
      expect(labels.where((label) => label == 'Вход'), hasLength(1));
      expect(find.text('Служебный узел'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('empty graph offers contributions without invented routing', (
    tester,
  ) async {
    await pump(tester, campus: _campus(emptyGraph: true));
    expect(
      find.textContaining('Проходы этого кампуса ещё не проверены'),
      findsOneWidget,
    );
    expect(find.text('Уточнить проходы'), findsOneWidget);
    expect(find.text('Показать путь'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow layout with double text scaling remains scrollable', (
    tester,
  ) async {
    await pump(tester, textScaler: const TextScaler.linear(2));
    await tester.ensureVisible(find.text('Показать путь'));
    await tester.pump();
    expect(find.text('Показать путь'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test(
    'floor transition label resolves destination floor from the catalog',
    () {
      final campus = _campus();
      final graph = IndoorNavigationGraph.fromJson(campus.graph);
      final route = IndoorRoutePlanner(graph)
          .findRoute(startNodeId: 'start', destinationNodeId: 'destination')
          .route!;
      final stairs = route.instructions.firstWhere(
        (instruction) => instruction.maneuver == IndoorManeuver.stairs,
      );
      expect(mapRouteInstructionLabel(stairs, campus), 'По лестнице на 2 этаж');
    },
  );
}

CampusMapData _campus({
  bool emptyGraph = false,
  bool alternativeEntry = false,
  bool unknownPortal = false,
}) {
  final floors = [
    for (final level in [1, 2])
      MapFloorData.fromJson({
        'id': 'floor-$level',
        'level': level,
        'label': '$level этаж',
        'width': 100,
        'height': 100,
      }, svgPath: 'test.svg'),
  ];
  return CampusMapData(
    campus: CampusModel(
      id: 'campus',
      displayName: 'В-78',
      floors: floors.map((item) => item.floor).toList(),
    ),
    floors: floors,
    rooms: [
      MapPlaceData.fromJson({
        'id': 'room-start',
        'floor_id': 'floor-1',
        'label': 'Вход',
        'x': 0,
        'y': 0,
      }),
      MapPlaceData.fromJson({
        'id': 'room-destination',
        'floor_id': 'floor-2',
        'label': 'А-201',
        'x': 10,
        'y': 10,
      }),
    ],
    graph: {
      'nodes': emptyGraph
          ? <Map<String, Object?>>[]
          : [
              {
                'id': 'start',
                'floor_id': 'floor-1',
                'room_id': 'room-start',
                'x': 0,
                'y': 0,
                'closed': alternativeEntry,
              },
              {
                'id': 'destination',
                'floor_id': 'floor-2',
                'room_id': 'room-destination',
                'x': 10,
                'y': 10,
                'wheelchair_accessible': alternativeEntry,
              },
              if (alternativeEntry)
                {
                  'id': 'accessible-start',
                  'floor_id': 'floor-1',
                  'room_id': 'room-start',
                  'x': 5,
                  'y': 5,
                  'wheelchair_accessible': true,
                },
            ],
      'edges': emptyGraph
          ? <Map<String, Object?>>[]
          : [
              {
                'id': 'stairs',
                'from_node_id': 'start',
                'to_node_id': 'destination',
                if (unknownPortal)
                  'traversal_cost': 20
                else ...{
                  'distance_meters': 15,
                  'duration_seconds': 30,
                },
                'kind': 'stairs',
              },
              if (alternativeEntry)
                {
                  'id': 'lift',
                  'from_node_id': 'accessible-start',
                  'to_node_id': 'destination',
                  'distance_meters': 15,
                  'duration_seconds': 45,
                  'kind': 'elevator',
                  'wheelchair_accessible': true,
                },
            ],
    },
    sourceUrl: 'https://pulse.mirea.ru/services/maps',
    sourceLabel: 'Пульс МИРЭА',
    revision: 1,
    origin: MapDataOrigin.remote,
  );
}
