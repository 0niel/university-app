import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_alignment_page.dart';
import 'package:rtu_mirea_app/map/widgets/map_graph_editor_page.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('MapGraphDraft', () {
    test('typed graph caches invalidate only after relevant changes', () {
      final draft = MapGraphDraft(_campus());
      final nodes = draft.nodes;
      final edges = draft.edges;
      expect(identical(nodes, draft.nodes), isTrue);
      expect(identical(edges, draft.edges), isTrue);
      expect(() => draft.nodes.clear(), throwsUnsupportedError);
      draft.saveNode({..._node('a', 21, 20), 'room_id': 'room-a'});
      expect(identical(nodes, draft.nodes), isFalse);
      expect(identical(edges, draft.edges), isTrue);
      expect(draft.nodeForId('a')!.x, 21);
      final changedNodes = draft.nodes;
      draft.saveEdge({..._edge(), 'id': 'ab', 'distance_meters': 16});
      expect(identical(changedNodes, draft.nodes), isTrue);
      expect(identical(edges, draft.edges), isFalse);
      draft.undo();
      expect(draft.edges.single.distanceMeters, 15);
      draft.undo();
      expect(draft.nodeForId('a')!.x, 20);
    });

    test(
      'operation undo restores insertion order and complete removed links',
      () {
        final draft = MapGraphDraft(_campus());
        final original = draft.patch;
        draft.saveEdge(_edge(to: 'c', kind: 'elevator'));
        final withLink = draft.patch;
        draft
          ..removeNode('a')
          ..saveNode(_node('d', 90, 90))
          ..saveEdge({..._edge(to: 'd'), 'from_node_id': 'b'})
          ..undo()
          ..undo()
          ..undo();
        expect(draft.patch, withLink);
        draft.undo();
        expect(draft.patch, original);
      },
    );

    test('deleting a node removes incident edges and undo restores flags', () {
      final draft = MapGraphDraft(_campus())..removeNode('a');
      expect(draft.nodes.map((node) => node.id), ['b', 'c']);
      expect(draft.edges, isEmpty);
      draft.undo();
      expect(draft.validate().edges.single.closed, isTrue);
      expect(draft.edges.single.bidirectional, isFalse);
      expect(draft.nodes.first.roomId, 'room-a');
      expect(draft.canUndo, isFalse);
    });

    test('a rejected cross-floor corridor never changes the draft', () {
      final draft = MapGraphDraft(_campus());
      expect(() => draft.saveEdge(_edge(to: 'c')), throwsFormatException);
      expect(draft.edges.single.id, 'ab');
      expect(draft.canUndo, isFalse);
      draft.saveEdge(_edge(to: 'c', kind: 'elevator'));
      expect(draft.validate().edges.last.kind, IndoorEdgeKind.elevator);
    });

    test(
      'rejects same-node links, negative and non-finite measured distance',
      () {
        for (final row in [
          _edge(to: 'a'),
          {..._edge(), 'distance_meters': -1},
          {..._edge(), 'distance_meters': double.infinity},
          {..._edge(), 'distance_meters': double.nan},
        ]) {
          final draft = MapGraphDraft(_campus());
          expect(() => draft.saveEdge(row), throwsFormatException);
          expect(draft.canUndo, isFalse);
        }
      },
    );

    test('zero-length doorway connectors remain valid', () {
      final draft = MapGraphDraft(_campus())
        ..saveEdge({..._edge(kind: 'door'), 'distance_meters': 0});
      expect(draft.validate().edges.last.distanceMeters, 0);
    });

    test('draft preserves unknown portal distance and traversal cost', () {
      final portal = _edge(to: 'c', kind: 'stairs')
        ..remove('distance_meters')
        ..['traversal_cost'] = 25;
      final draft = MapGraphDraft(_campus())..saveEdge(portal);
      expect(draft.validate().edges.last.distanceMeters, isNull);
      expect(draft.edges.last.traversalCost, 25);
      final exported = mapJsonRows(draft.patch['edges']).last;
      expect(exported.containsKey('distance_meters'), isFalse);
      expect(exported['traversal_cost'], 25);
      draft.saveEdge({...exported, 'closed': true});
      expect(draft.edges.last.traversalCost, 25);
      expect(draft.edges.last.distanceMeters, isNull);
    });

    test('rejects inaccessible steps falsely marked wheelchair accessible', () {
      final draft = MapGraphDraft(_campus());
      expect(
        () => draft.saveEdge({
          ..._edge(to: 'c', kind: 'stairs'),
          'wheelchair_accessible': true,
        }),
        throwsFormatException,
      );
    });

    test('rejects a room on another floor and points outside plan bounds', () {
      final draft = MapGraphDraft(_campus());
      expect(
        () => draft.saveNode({
          ..._node('x', 20, 20),
          'floor_id': 'f2',
          'room_id': 'room-a',
        }),
        throwsFormatException,
      );
      expect(() => draft.saveNode(_node('x', 101, 20)), throwsFormatException);
      expect(() => draft.saveNode(_node('x', -1, 20)), throwsFormatException);
      expect(draft.canUndo, isFalse);
    });

    test('moving a node preserves door association and can be undone', () {
      final draft = MapGraphDraft(_campus())
        ..moveNode('a', const Offset(35, 40));
      expect(draft.nodes.first.x, 35);
      expect(draft.nodes.first.roomId, 'room-a');
      expect(draft.validate, throwsFormatException);
      expect(draft.needsDistanceReview, isTrue);
      draft.undo();
      expect(draft.nodes.first.x, 20);
      expect(draft.edges.single.distanceMeters, 15);
      expect(draft.validate().nodes.first.x, 20);
      expect(draft.needsDistanceReview, isFalse);
    });

    test('remeasuring a moved segment unblocks navigation submission', () {
      final draft = MapGraphDraft(_campus())
        ..moveNode('a', const Offset(35, 40))
        ..saveEdge({..._edge(), 'id': 'ab', 'distance_meters': 21});
      expect(draft.needsDistanceReview, isFalse);
      expect(draft.validate().edges.single.distanceMeters, 21);
    });
  });

  group('floor alignment proposals', () {
    test('anchors alone do not invent a distance scale', () {
      final patch = buildMapFloorAlignmentPatch(
        floor: _floor('f1'),
        anchors: _anchors,
      );
      expect(patch['anchors'], hasLength(3));
      expect(patch.containsKey('meters_per_unit'), isFalse);
    });

    test('only a measured plan baseline defines meters per unit', () {
      final patch = buildMapFloorAlignmentPatch(
        floor: _floor('f1'),
        anchors: _anchors,
        measuredDistanceMeters: 50,
      );
      expect(patch['meters_per_unit'], .5);
    });

    test('rejects incomplete, clustered or collinear control points', () {
      for (final anchors in [
        _anchors.take(2).toList(),
        [
          for (var i = 0; i < 3; i++)
            FloorGeoAnchor(
              x: i.toDouble(),
              y: i.toDouble(),
              latitude: 55.7 + i * .001,
              longitude: 37.5 + i * .001,
            ),
        ],
        const [
          FloorGeoAnchor(x: 0, y: 0, latitude: 55.7, longitude: 37.5),
          FloorGeoAnchor(x: 100, y: 0, latitude: 55.7, longitude: 37.5),
          FloorGeoAnchor(x: 0, y: 100, latitude: 55.7, longitude: 37.5),
        ],
      ]) {
        expect(
          () => buildMapFloorAlignmentPatch(
            floor: _floor('f1'),
            anchors: anchors,
          ),
          throwsFormatException,
        );
      }
    });

    test('rejects invalid measured distance and anchor outside floor', () {
      for (final measurement in [0.0, -1.0, double.nan, double.infinity]) {
        expect(
          () => buildMapFloorAlignmentPatch(
            floor: _floor('f1'),
            anchors: _anchors,
            measuredDistanceMeters: measurement,
          ),
          throwsFormatException,
        );
      }
      expect(
        () => buildMapFloorAlignmentPatch(
          floor: _floor('f1'),
          anchors: [
            const FloorGeoAnchor(x: -1, y: 0, latitude: 55.7, longitude: 37.5),
            ..._anchors.skip(1),
          ],
        ),
        throwsFormatException,
      );
    });
  });

  for (final scale in [1.3, 2.0]) {
    testWidgets(
      'small-screen editor creates named nodes at text scale $scale',
      (tester) async {
        final repository = _repository();
        addTearDown(repository.dispose);
        await tester.pumpApp(
          MapGraphEditorPage(campus: _campus(), repository: repository),
          size: const Size(320, 568),
          textScaler: TextScaler.linear(scale),
        );
        await tester.pumpAndSettle();
        final plan = tester.getRect(
          find.byKey(const ValueKey('map-editor-floor-plan')),
        );
        await tester.tapAt(
          plan.topLeft + Offset(plan.width * .8, plan.height * .8),
        );
        await tester.pumpAndSettle();
        expect(find.text('Новая точка прохода'), findsOneWidget);
        await tester.enterText(find.byType(TextField).first, 'У окна');
        await tester.ensureVisible(find.text('Сохранить в черновик'));
        await tester.tap(find.text('Сохранить в черновик'));
        await tester.pumpAndSettle();
        expect(find.text('У окна'), findsOneWidget);
        await tester.ensureVisible(find.text('Проверить изменения'));
        await tester.tap(find.text('Проверить изменения'));
        await tester.pumpAndSettle();
        expect(find.text('Проверка предложения'), findsOneWidget);
        expect(find.text('Для отправки войдите в аккаунт.'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('alignment keeps plan visible at large text scale', (
    tester,
  ) async {
    final repository = _repository();
    addTearDown(repository.dispose);
    await tester.pumpApp(
      MapFloorAlignmentPage(campus: _campus(), repository: repository),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byType(MapEditorFloorCanvas)).height,
      greaterThanOrEqualTo(160),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'large graph picker is lazy, naturally sorted and floor searchable',
    (tester) async {
      final nodes = List.generate(
        16217,
        (index) => IndoorNavigationNode.fromJson({
          'id': 'native-private-node-$index',
          'floor_id': index == 16216 ? 'f2' : 'f1',
          'x': 20,
          'y': 20,
          'label': 'Аудитория ${index + 1}',
        }),
      );
      IndoorNavigationNode? selected;
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                selected = await showModalBottomSheet<IndoorNavigationNode>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => MapGraphNodePicker(
                    campus: _campus(),
                    nodes: nodes,
                    fromId: nodes.first.id,
                    initialFloorId: 'f1',
                  ),
                );
              },
              child: const Text('Выбрать точку'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Выбрать точку'));
      await tester.pumpAndSettle();
      expect(find.text('Найдено: 16215'), findsOneWidget);
      expect(find.byType(AppListRow).evaluate().length, lessThan(30));
      final visibleTitles = tester
          .widgetList<AppListRow>(find.byType(AppListRow))
          .map((tile) => tile.title)
          .toList();
      expect(visibleTitles.take(3), [
        'Аудитория 2',
        'Аудитория 3',
        'Аудитория 4',
      ]);
      expect(find.textContaining('native-private-node-'), findsNothing);
      await tester.enterText(find.byType(TextField), 'Аудитория 16217');
      await tester.pumpAndSettle();
      expect(find.byType(AppListRow), findsNothing);
      await tester.tap(find.text('Все этажи'));
      await tester.pumpAndSettle();
      expect(find.byType(AppListRow), findsOneWidget);
      await tester.tap(find.widgetWithText(AppListRow, 'Аудитория 16217'));
      await tester.pumpAndSettle();
      expect(selected?.id, 'native-private-node-16216');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('connection target can be selected directly on the floor plan', (
    tester,
  ) async {
    final repository = _repository();
    addTearDown(repository.dispose);
    await tester.pumpApp(
      MapGraphEditorPage(campus: _campus(), repository: repository),
    );
    await tester.pumpAndSettle();
    final rect = tester.getRect(
      find.byKey(const ValueKey('map-editor-floor-plan')),
    );
    await tester.tapAt(
      rect.topLeft + Offset(rect.width * .2, rect.height * .2),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Соединить'));
    await tester.pumpAndSettle();
    expect(
      find.text('Коснитесь конечной точки или найдите её'),
      findsOneWidget,
    );
    final updatedRect = tester.getRect(
      find.byKey(const ValueKey('map-editor-floor-plan')),
    );
    await tester.tapAt(
      updatedRect.topLeft +
          Offset(updatedRect.width * .5, updatedRect.height * .2),
    );
    await tester.pumpAndSettle();
    expect(find.text('Соединить точки'), findsOneWidget);
    expect(find.widgetWithText(AppListRow, 'Точка прохода'), findsOneWidget);
    expect(find.textContaining('x 50.0, y 20.0'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('node search remains scrollable with large text and keyboard', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        resizeToAvoidBottomInset: false,
        body: MapGraphNodePicker(
          campus: _campus(),
          nodes: MapGraphDraft(_campus()).nodes,
          fromId: 'a',
          initialFloorId: 'f1',
        ),
      ),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Точка');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -220));
    await tester.pumpAndSettle();
    expect(find.byType(AppListRow), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'submission keeps revision and draft after failure, then retries',
    (tester) async {
      final calls = <Map<String, Object?>>[];
      final repository = _SignedInRepository((name, parameters) async {
        expect(name, 'submit_map_proposal');
        calls.add(parameters);
        if (calls.length == 1) throw const MapDataException('Offline');
        return {'id': 'proposal', 'status': 'pending'};
      });
      addTearDown(repository.dispose);
      bool? result;
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await showMapEditorReview(
                  context: context,
                  campus: _campus(),
                  repository: repository,
                  entityType: 'graph',
                  entityId: 'campus',
                  patch: MapGraphDraft(_campus()).patch,
                  summary: '3 точки, 1 проход.',
                );
              },
              child: const Text('Проверить'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Проверить'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Отправить на проверку'));
      await tester.pumpAndSettle();
      expect(calls, isEmpty);
      await tester.enterText(
        find.byType(TextField),
        'Измерил проход рулеткой.',
      );
      await tester.tap(find.text('Отправить на проверку'));
      await tester.pumpAndSettle();
      expect(calls.single['p_base_revision'], 7);
      expect(calls.single['p_entity_id'], 'campus');
      expect(calls.single['p_entity_type'], 'graph');
      expect(calls.single['p_patch'], MapGraphDraft(_campus()).patch);
      expect(
        find.textContaining('Подтверждение от сервера не получено'),
        findsOneWidget,
      );
      expect(result, isNull);
      await tester.tap(find.text('Отправить на проверку'));
      await tester.pumpAndSettle();
      expect(calls, hasLength(2));
      expect(calls[1], calls[0]);
      expect(find.text('Изменения на проверке'), findsOneWidget);
      await tester.tap(find.text('Готово'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
}

class _SignedInRepository extends MapDataRepository {
  _SignedInRepository(MapDataRpc rpc)
    : super(organizationId: 'mirea', rpc: rpc);

  @override
  bool get isAuthenticated => true;
}

const _anchors = [
  FloorGeoAnchor(x: 0, y: 0, latitude: 55.7, longitude: 37.5),
  FloorGeoAnchor(x: 100, y: 0, latitude: 55.7, longitude: 37.501),
  FloorGeoAnchor(x: 0, y: 100, latitude: 55.701, longitude: 37.5),
];

MapFloorData _floor(String id) => MapFloorData.fromJson({
  'id': id,
  'level': id == 'f1' ? 1 : 2,
  'width': 100,
  'height': 100,
}, svgPath: 'floor.svg');

Map<String, Object?> _node(String id, double x, double y) => {
  'id': id,
  'floor_id': 'f1',
  'x': x,
  'y': y,
  'label': id,
};

Map<String, Object?> _edge({String to = 'b', String kind = 'corridor'}) => {
  'id': 'new-edge',
  'from_node_id': 'a',
  'to_node_id': to,
  'distance_meters': 15,
  'kind': kind,
};

CampusMapData _campus() => CampusMapData(
  campus: const CampusModel(id: 'campus', displayName: 'Кампус', floors: []),
  floors: [_floor('f1'), _floor('f2')],
  rooms: [
    MapPlaceData.fromJson({'id': 'room-a', 'floor_id': 'f1', 'label': 'А-101'}),
  ],
  graph: {
    'nodes': [
      {..._node('a', 20, 20), 'room_id': 'room-a'},
      _node('b', 50, 20),
      {..._node('c', 20, 20), 'floor_id': 'f2'},
    ],
    'edges': [
      {..._edge(), 'id': 'ab', 'closed': true, 'bidirectional': false},
    ],
  },
  sourceUrl: 'https://pulse.mirea.ru/services/maps',
  sourceLabel: 'Пульс МИРЭА',
  revision: 7,
  origin: MapDataOrigin.remote,
);

MapDataRepository _repository() => MapDataRepository(
  organizationId: 'mirea',
  rpc: (name, parameters) async => throw StateError('No writes while editing'),
  assetLoader: (path) async =>
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"> '
      '<rect width="100" height="100" fill="white"/></svg>',
);
