import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/widgets/map_places_explorer.dart';

import '../../helpers/pump_app.dart';

MapPlaceData _place(
  String id,
  String label, {
  String floor = 'floor-2',
  String kind = 'room',
  double x = 10,
  Map<String, Object?> metadata = const {},
}) => MapPlaceData.fromJson({
  'id': id,
  'label': label,
  'floor_id': floor,
  'kind': kind,
  'x': x,
  'y': 20,
  ...metadata,
});

CampusMapData _campus(List<MapPlaceData> rooms) => CampusMapData(
  campus: const CampusModel(id: 'campus', displayName: 'В-78', floors: []),
  floors: [
    for (final number in [-1, 1, 2])
      MapFloorData.fromJson({
        'id': 'floor-$number',
        'level': number,
      }, svgPath: 'floor.svg'),
  ],
  rooms: rooms,
  graph: {},
  sourceUrl: 'https://pulse.mirea.ru/services/maps',
  sourceLabel: 'Пульс РТУ МИРЭА',
  revision: 3,
  origin: MapDataOrigin.remote,
);

Widget _page(
  CampusMapData campus, {
  String query = '',
  String? currentFloorId,
  ValueChanged<MapPlaceData>? onPlace,
}) => Scaffold(
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: MapPlacesExplorer(
      campus: campus,
      query: query,
      currentFloorId: currentFloorId,
      onPlace: onPlace ?? (_) {},
      onCommunity: () {},
      onRefresh: () {},
    ),
  ),
);

List<String> _visibleIds(WidgetTester tester) => tester
    .widgetList<AppListRow>(find.byType(AppListRow))
    .map((row) => (row.key! as ValueKey<String>).value)
    .toList();

void main() {
  testWidgets('current floor precedes other floors with natural room numbers', (
    tester,
  ) async {
    await tester.pumpApp(
      _page(
        _campus([
          _place('other', '1', floor: 'floor-1'),
          _place('ten', '10'),
          _place('hundred', '101'),
          _place('two', '2'),
          _place('a-ten', 'А-10'),
          _place('a-two', 'А-2'),
        ]),
        currentFloorId: 'floor-2',
      ),
    );
    expect(_visibleIds(tester), [
      'two',
      'ten',
      'hundred',
      'a-two',
      'a-ten',
      'other',
    ]);
    expect(find.text('Аудитория 2'), findsOneWidget);
  });

  testWidgets(
    'deduplicates geometry and opens the richest matching room record',
    (tester) async {
      final enriched = _place(
        'room-details',
        '1',
        x: 400,
        metadata: {
          'description': 'Учебная аудитория',
          'equipment': ['Проектор'],
        },
      );
      MapPlaceData? opened;
      await tester.pumpApp(
        _page(
          _campus([
            _place('shape-1', '1'),
            _place('shape-2', '1', x: 100),
            enriched,
            _place('other-floor', '1', floor: 'floor-1'),
          ]),
          currentFloorId: 'floor-2',
          onPlace: (place) => opened = place,
        ),
      );
      expect(_visibleIds(tester), ['room-details', 'other-floor']);
      await tester.tap(find.byKey(const ValueKey('room-details')));
      expect(opened, same(enriched));
      expect(find.textContaining('Проектор'), findsOneWidget);
    },
  );

  testWidgets('keeps distinct services at different coordinates', (
    tester,
  ) async {
    await tester.pumpApp(
      _page(
        _campus([
          _place(
            'atm-a',
            'Банкомат',
            kind: 'atm',
            metadata: {'opening_hours': '09–18'},
          ),
          _place(
            'atm-a-shape',
            'Банкомат',
            kind: 'atm',
            metadata: {'opening_hours': '09–18'},
          ),
          _place(
            'atm-b',
            'Банкомат',
            kind: 'atm',
            x: 400,
            metadata: {'opening_hours': 'Круглосуточно'},
          ),
        ]),
      ),
    );
    expect(_visibleIds(tester), ['atm-a', 'atm-b']);
  });

  testWidgets('search filters equipment and floor after deduplicating', (
    tester,
  ) async {
    await tester.pumpApp(
      _page(
        _campus([
          _place('plain-shape', '201'),
          _place(
            'equipped',
            '201',
            metadata: {
              'equipment': ['Проектор'],
            },
          ),
          _place(
            'other-equipped',
            '101',
            floor: 'floor-1',
            metadata: {
              'equipment': ['Проектор'],
            },
          ),
        ]),
        query: 'проектор 2 этаж',
      ),
    );
    expect(_visibleIds(tester), ['equipped']);
  });

  testWidgets(
    'exact room match precedes a partial match on the current floor',
    (tester) async {
      await tester.pumpApp(
        _page(
          _campus([
            _place('partial-current', '20'),
            _place('exact-other', '2', floor: 'floor-1'),
          ]),
          currentFloorId: 'floor-2',
          query: '2',
        ),
      );
      expect(_visibleIds(tester), ['exact-other', 'partial-current']);
    },
  );

  testWidgets('floor chip narrows results and follows floor changes', (
    tester,
  ) async {
    final campus = _campus([
      _place('second', '201'),
      _place('first', '101', floor: 'floor-1'),
    ]);
    await tester.pumpApp(_page(campus, currentFloorId: 'floor-2'));
    await tester.tap(find.widgetWithText(AppChip, '2 этаж'));
    await tester.pumpAndSettle();
    expect(_visibleIds(tester), ['second']);
    await tester.pumpApp(_page(campus, currentFloorId: 'floor-1'));
    expect(_visibleIds(tester), ['first']);
  });

  testWidgets('category filter combines with the current floor', (
    tester,
  ) async {
    await tester.pumpApp(
      _page(
        _campus([
          _place('room', '201'),
          _place('food', 'Столовая', kind: 'canteen'),
          _place('other-food', 'Буфет', kind: 'cafe', floor: 'floor-1'),
        ]),
        currentFloorId: 'floor-2',
      ),
    );
    await tester.tap(find.widgetWithText(AppChip, '2 этаж'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(AppChip, 'Еда'));
    await tester.pumpAndSettle();
    expect(_visibleIds(tester), ['food']);
  });

  testWidgets('source is above results and large text remains bounded', (
    tester,
  ) async {
    await tester.pumpApp(
      _page(
        _campus([for (var n = 1; n <= 30; n++) _place('room-$n', '$n')]),
        currentFloorId: 'floor-2',
      ),
      size: const Size(320, 700),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pumpAndSettle();
    final source = find.widgetWithText(AppButton, 'Пульс РТУ МИРЭА · источник');
    expect(source, findsOneWidget);
    expect(tester.getTopLeft(source).dy, lessThan(700));
    expect(
      tester.getTopLeft(source).dy,
      lessThan(tester.getTopLeft(find.byType(AppListGroup)).dy),
    );
    expect(find.byType(AppListRow), findsNWidgets(20));
    expect(find.byType(AppIconTile), findsNWidgets(20));
    expect(tester.takeException(), isNull);
  });
}
