import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/widgets/map_place_editor_page.dart';

import '../../helpers/pump_app.dart';

void main() {
  test('new service contains an existing floor and chosen plan position', () {
    final patch = buildMapPlaceEditorPatch(
      campus: _campus(),
      floorId: 'f1',
      position: const Offset(20, 30),
      label: '  Банкомат  ',
      kind: 'atm',
    );
    expect(patch, {
      'floor_id': 'f1',
      'x': 20.0,
      'y': 30.0,
      'label': 'Банкомат',
      'kind': 'atm',
    });
    expect(patch.containsKey('id'), isFalse);
  });

  test('missing floor, name, category or invalid coordinates are rejected', () {
    for (final point in [
      null,
      const Offset(-1, 5),
      const Offset(101, 5),
      const Offset(5, 101),
      const Offset(double.nan, 5),
      const Offset(5, double.infinity),
    ]) {
      expect(
        () => buildMapPlaceEditorPatch(
          campus: _campus(),
          floorId: 'f1',
          position: point,
          label: 'Банкомат',
          kind: 'atm',
        ),
        throwsFormatException,
      );
    }
    for (final invalid in [
      (floor: 'missing', label: 'Банкомат', kind: 'atm'),
      (floor: 'f1', label: '   ', kind: 'atm'),
      (floor: 'f1', label: 'Банкомат', kind: 'missing'),
    ]) {
      expect(
        () => buildMapPlaceEditorPatch(
          campus: _campus(),
          floorId: invalid.floor,
          position: const Offset(5, 5),
          label: invalid.label,
          kind: invalid.kind,
        ),
        throwsFormatException,
      );
    }
  });

  test(
    'relocation preserves id and floor while allowing description removal',
    () {
      final campus = _campus();
      final patch = buildMapPlaceEditorPatch(
        campus: campus,
        floorId: 'f1',
        position: const Offset(90, 85),
        label: 'Питьевая вода у лифта',
        kind: 'water',
        room: campus.rooms.single,
      );
      expect(patch.containsKey('id'), isFalse);
      expect(patch.containsKey('floor_id'), isFalse);
      expect(patch['description'], '');
      expect(patch['x'], 90);
      expect(
        () => buildMapPlaceEditorPatch(
          campus: campus,
          floorId: 'f2',
          position: const Offset(90, 85),
          label: 'Питьевая вода',
          kind: 'water',
          room: campus.rooms.single,
        ),
        throwsFormatException,
      );
    },
  );

  test('classroom point cannot move outside its contour or into a hole', () {
    final campus = _campus();
    final geometry = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(const Rect.fromLTWH(10, 10, 60, 60))
      ..addRect(const Rect.fromLTWH(30, 30, 10, 10));
    for (final point in [const Offset(80, 80), const Offset(35, 35)]) {
      expect(
        () => buildMapPlaceEditorPatch(
          campus: campus,
          floorId: 'f1',
          position: point,
          label: 'А-101',
          kind: 'classroom',
          room: campus.rooms.single,
          roomGeometry: geometry,
        ),
        throwsFormatException,
      );
    }
    final patch = buildMapPlaceEditorPatch(
      campus: campus,
      floorId: 'f1',
      position: const Offset(20, 20),
      label: 'А-101',
      kind: 'classroom',
      room: campus.rooms.single,
      roomGeometry: geometry,
    );
    expect(patch['x'], 20);
  });

  for (final scale in [1.3, 2.0]) {
    testWidgets(
      'placing a service writes only after review at text scale $scale',
      (tester) async {
        final calls = <Map<String, Object?>>[];
        final repository = _Repository((name, parameters) async {
          expect(name, 'submit_map_proposal');
          calls.add(parameters);
          return {'id': 'proposal', 'status': 'pending'};
        });
        addTearDown(repository.dispose);
        await tester.pumpApp(
          MapPlaceEditorPage(campus: _campus(), repository: repository),
          size: const Size(320, 568),
          textScaler: TextScaler.linear(scale),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Проверить'));
        await tester.pumpAndSettle();
        expect(
          find.text('Отметьте место на плане.'),
          findsOneWidget,
        );
        expect(calls, isEmpty);
        final plan = tester.getRect(
          find.byKey(const ValueKey('map-editor-floor-plan')),
        );
        final visiblePlan = plan.intersect(
          tester.getRect(find.byType(CustomScrollView)),
        );
        expect(visiblePlan.height, greaterThanOrEqualTo(44));
        final chosenPoint = visiblePlan.center;
        await tester.tapAt(chosenPoint);
        await tester.pumpAndSettle();
        await tester.dragFrom(
          tester.getTopLeft(find.byType(CustomScrollView)) + const Offset(8, 8),
          const Offset(0, -240),
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byType(TextField).first);
        await tester.enterText(
          find.byType(TextField).first,
          'Столовая у входа',
        );
        final category = find.widgetWithText(AppListRow, 'Столовая');
        await tester.ensureVisible(category);
        await tester.tap(category);
        await tester.pumpAndSettle();
        final cafe = find.widgetWithText(AppListRow, 'Кафе');
        await tester.ensureVisible(cafe);
        await tester.tap(cafe);
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppListRow, 'Кафе'), findsOneWidget);
        await tester.tap(find.text('Проверить'));
        await tester.pumpAndSettle();
        expect(find.text('Проверка предложения'), findsOneWidget);
        expect(calls, isEmpty);
        await tester.enterText(
          find.byType(TextField).last,
          'Проверил расположение на первом этаже.',
        );
        await tester.ensureVisible(find.text('Отправить на проверку'));
        await tester.tap(find.text('Отправить на проверку'));
        await tester.pumpAndSettle();
        expect(calls, hasLength(1));
        expect(calls.single['p_entity_type'], 'place_create');
        expect(calls.single['p_base_revision'], 4);
        expect(
          calls.single['p_entity_id'],
          matches(
            r'^[a-f\d]{8}(-[a-f\d]{4}){3}-[a-f\d]{12}$',
          ),
        );
        final patch = calls.single['p_patch']! as Map<String, Object?>;
        expect(patch['floor_id'], 'f1');
        expect(patch['label'], 'Столовая у входа');
        expect(patch['kind'], 'cafe');
        expect(
          patch['x'],
          closeTo(
            (chosenPoint.dx - plan.left) / plan.width * 100,
            .01,
          ),
        );
        expect(
          patch['y'],
          closeTo(
            (chosenPoint.dy - plan.top) / plan.height * 100,
            .01,
          ),
        );
        expect(find.text('Изменения на проверке'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}

class _Repository extends MapDataRepository {
  _Repository(MapDataRpc rpc)
    : super(
        organizationId: 'mirea',
        rpc: rpc,
        assetLoader: (path) async =>
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"> '
            '<rect width="100" height="100" fill="white"/></svg>',
      );

  @override
  bool get isAuthenticated => true;
}

CampusMapData _campus() => CampusMapData(
  campus: const CampusModel(id: 'campus', displayName: 'Кампус', floors: []),
  floors: [
    for (var level = 1; level <= 2; level++)
      MapFloorData.fromJson({
        'id': 'f$level',
        'level': level,
        'width': 100,
        'height': 100,
      }, svgPath: 'floor.svg'),
  ],
  rooms: [
    MapPlaceData.fromJson({
      'id': 'water',
      'floor_id': 'f1',
      'label': 'Питьевая вода',
      'kind': 'water',
      'description': 'Старое описание',
    }),
  ],
  graph: const {'nodes': <Object>[], 'edges': <Object>[]},
  sourceUrl: 'https://pulse.mirea.ru/services/maps',
  sourceLabel: 'Пульс МИРЭА',
  revision: 4,
  origin: MapDataOrigin.remote,
);
