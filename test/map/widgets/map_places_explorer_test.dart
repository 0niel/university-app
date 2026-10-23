import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/widgets/map_places_explorer.dart';
import 'package:rtu_mirea_app/map/widgets/map_places_index.dart';

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
  testWidgets('place categories scroll from either screen edge at 200% text', (
    tester,
  ) async {
    await tester.pumpApp(
      _page(
        _campus([
          _place('room', '201'),
          _place('service', 'Cafe', kind: 'cafe'),
        ]),
        currentFloorId: 'floor-2',
      ),
      size: const Size(320, 900),
      textScaler: const TextScaler.linear(2),
    );
    final rail = find.byKey(const ValueKey('map-place-categories'));
    await tester.ensureVisible(rail);
    await tester.pumpAndSettle();
    final viewport = tester.getRect(rail);
    expect(viewport.left, 0);
    expect(viewport.right, 320);
    expect(
      tester
          .getRect(
            find.descendant(of: rail, matching: find.byType(AppChip)).first,
          )
          .left,
      AppSpacing.screen,
    );
    final scroll = tester.state<ScrollableState>(
      find.descendant(of: rail, matching: find.byType(Scrollable)),
    );
    await tester.dragFrom(
      Offset(318, viewport.center.dy),
      const Offset(-240, 0),
    );
    await tester.pumpAndSettle();
    expect(scroll.position.pixels, greaterThan(0));
    final previous = scroll.position.pixels;
    await tester.dragFrom(Offset(2, viewport.center.dy), const Offset(240, 0));
    await tester.pumpAndSettle();
    expect(scroll.position.pixels, lessThan(previous));
    final floor = find
        .descendant(of: rail, matching: find.byType(AppChip))
        .first;
    await tester.ensureVisible(floor);
    await tester.tap(floor);
    await tester.pumpAndSettle();
    expect(tester.widget<AppChip>(floor).selected, isTrue);
    expect(tester.takeException(), isNull);
  });

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

  testWidgets('no duplicate source link and large text remains bounded', (
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
    expect(find.textContaining('источник'), findsNothing);
    expect(find.textContaining('Пульс РТУ МИРЭА'), findsNothing);
    expect(find.byType(AppListRow), findsNWidgets(20));
    expect(find.byType(AppIconTile), findsNWidgets(20));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'pagination keeps bounded row repaint layers and existing actions',
    (
      tester,
    ) async {
      final campus = _campus([
        for (var n = 1; n <= 60; n++) _place('room-$n', '$n'),
      ]);
      MapPlaceData? opened;
      await tester.pumpApp(
        _page(campus, onPlace: (place) => opened = place),
        size: const Size(400, 900),
      );
      final first = find.byKey(const ValueKey('map-place-paint-room-1'));
      final boundary = tester.renderObject<RenderRepaintBoundary>(first);
      final layer = boundary.debugLayer! as OffsetLayer;
      final picture = (layer.firstChild! as PictureLayer).picture;
      expect(boundary.size.height, lessThan(200));
      expect(find.byType(AppListRow), findsNWidgets(20));
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -30),
      );
      await tester.pumpAndSettle();
      expect((layer.firstChild! as PictureLayer).picture, same(picture));
      final more = tester.widget<AppButton>(
        find.widgetWithText(AppButton, 'Ещё 40 мест'),
      );
      more.onPressed!();
      await tester.pump();
      expect(find.byType(AppListRow), findsNWidgets(50));
      expect(tester.renderObject<RenderRepaintBoundary>(first), same(boundary));
      await tester.ensureVisible(find.byKey(const ValueKey('room-25')));
      await tester.tap(find.byKey(const ValueKey('room-25')));
      expect(opened?.id, 'room-25');
      expect(tester.takeException(), isNull);
    },
  );

  test(
    'index reuses identical selections and invalidates floor/query/category',
    () {
      final index = MapPlacesIndex(
        _campus([
          _place('other', '2', floor: 'floor-1'),
          _place('current', '20'),
          _place('food', 'Cafe', kind: 'cafe'),
        ]),
      );
      List<MapPlaceEntry> select({
        String query = '',
        String? category,
        String? floor = 'floor-2',
        bool onlyFloor = false,
      }) => index.select(
        query: query,
        category: category,
        currentFloorId: floor,
        onlyCurrentFloor: onlyFloor,
      );
      final all = select();
      expect(select(), same(all));
      expect(select(query: '2').map((entry) => entry.place.id), [
        'other',
        'current',
        'food',
      ]);
      expect(select(category: 'Еда').single.place.id, 'food');
      expect(select(onlyFloor: true).map((entry) => entry.place.id), [
        'current',
        'food',
      ]);
      expect(
        select(floor: 'floor-1', onlyFloor: true).single.place.id,
        'other',
      );
      expect(index.countOnFloor('floor-2'), 2);
      expect(all.clear, throwsUnsupportedError);
    },
  );

  testWidgets('mutated source lists and floor metadata refresh the index', (
    tester,
  ) async {
    final rooms = [_place('first', '101')];
    final campus = _campus(rooms);
    await tester.pumpApp(_page(campus, query: '101'));
    expect(_visibleIds(tester), ['first']);
    rooms[0] = _place('replacement', '102');
    await tester.pumpApp(_page(campus, query: '101'));
    expect(_visibleIds(tester), isEmpty);
    rooms.add(_place('new', '101'));
    await tester.pumpApp(_page(campus, query: '101'));
    expect(_visibleIds(tester), ['new']);
    campus.floors[2] = MapFloorData.fromJson({
      'id': 'floor-2',
      'level': 3,
    }, svgPath: 'floor.svg');
    await tester.pumpApp(_page(campus, query: '101 3 этаж'));
    expect(_visibleIds(tester), ['new']);
    expect(find.text('Аудитория · 3 этаж'), findsOneWidget);
  });
}
