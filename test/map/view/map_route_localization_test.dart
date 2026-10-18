import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_guidance.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_node_picker.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_sheet.dart';

void main() {
  for (final language in ['ru', 'en']) {
    final locale = Locale(language);
    testWidgets('route preview, restrictions and picker use $language', (
      tester,
    ) async {
      final l10n = await AppLocalizations.delegate.load(locale);
      final campus = _campus();
      await _pump(
        tester,
        locale: locale,
        child: MapRouteSheet(
          campus: campus,
          startRoomId: 'entrance',
          destinationRoomId: 'room',
          onApply: (_) {},
          onContribute: () {},
        ),
      );
      expect(
        find.text(language == 'en' ? 'Route ready' : 'Маршрут готов'),
        findsOneWidget,
      );
      expect(find.text(l10n.mapRouteShowPath), findsOneWidget);
      expect(
        find.text(
          language == 'en'
              ? 'Take the stairs to Floor 2'
              : 'По лестнице на 2 этаж',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          language == 'en' ? '≈ 1 min · 2 floors' : '≈ 1 мин · 2 этажа',
        ),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text(l10n.mapRouteOptions));
      await tester.tap(find.text(l10n.mapRouteOptions));
      await tester.pumpAndSettle();
      final wheelchair = find.widgetWithText(AppChip, l10n.mapRouteWheelchair);
      await tester.ensureVisible(wheelchair);
      await tester.tap(wheelchair);
      await tester.pumpAndSettle();
      expect(find.text(l10n.mapRouteRestrictedUnavailable), findsOneWidget);
      expect(find.text(l10n.mapRouteWheelchairHint), findsOneWidget);
      final reset = find.text(l10n.mapRouteResetRestrictions);
      await tester.ensureVisible(reset);
      await tester.tap(reset);
      await tester.pumpAndSettle();
      expect(find.text(l10n.mapRouteReady), findsOneWidget);
      final destination = find.byKey(const ValueKey('map-route-destination'));
      await tester.ensureVisible(destination);
      await tester.tap(destination);
      await tester.pumpAndSettle();
      expect(find.byType(MapRouteNodePicker), findsOneWidget);
      expect(find.text(l10n.mapRoutePickDestination), findsOneWidget);
      expect(find.text(l10n.mapRoutePlaceSearchHint), findsOneWidget);
      final search = find.descendant(
        of: find.byType(MapRouteNodePicker),
        matching: find.byType(TextField),
      );
      await tester.enterText(search, 'not-a-place');
      await tester.pumpAndSettle();
      final noResults = find.text(l10n.searchNoResults);
      await tester.ensureVisible(noResults);
      expect(noResults, findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('unknown distance keeps the available time in $language', (
      tester,
    ) async {
      final l10n = await AppLocalizations.delegate.load(locale);
      await _pump(
        tester,
        locale: locale,
        child: MapRouteSheet(
          campus: _campus(knownDistance: false),
          startRoomId: 'entrance',
          destinationRoomId: 'room',
          onApply: (_) {},
          onContribute: () {},
        ),
      );
      expect(
        find.text(
          language == 'en' ? '≈ 1 min · 2 floors' : '≈ 1 мин · 2 этажа',
        ),
        findsOneWidget,
      );
      expect(find.text(l10n.mapRouteIncompleteDuration), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('guidance and timeline use $language without distances', (
      tester,
    ) async {
      final l10n = await AppLocalizations.delegate.load(locale);
      final campus = _campus();
      final route = IndoorRoutePlanner(
        IndoorNavigationGraph.fromJson(campus.graph),
      ).findRoute(startNodeId: 'start', destinationNodeId: 'end').route!;
      final stepIndex = route.instructions.indexWhere(
        (instruction) => instruction.maneuver == IndoorManeuver.stairs,
      );
      expect(route.distanceMeters, 15);
      expect(route.instructions[stepIndex].distanceMeters, 15);
      await _pump(
        tester,
        locale: locale,
        child: MapRouteGuidance(
          campus: campus,
          route: route,
          stepIndex: stepIndex,
          onClose: () {},
          onNext: () {},
          onStepSelected: (_) {},
        ),
      );
      expect(
        find.text(
          mapRouteInstructionLabel(route.instructions[stepIndex], campus, l10n),
        ),
        findsOneWidget,
      );
      expect(find.byTooltip(l10n.mapRouteFinish), findsOneWidget);
      expect(find.byTooltip(l10n.mapRouteNextStep), findsOneWidget);
      expect(find.text(l10n.mapRouteCompactStart), findsOneWidget);
      expect(find.text(l10n.mapRouteCompactFinish), findsOneWidget);
      final semantics = tester.ensureSemantics();
      await tester.pump();
      expect(
        find.semantics.byValue(
          l10n.mapRouteProgressValue(stepIndex + 1, route.instructions.length),
        ),
        findsOneWidget,
      );
      final distance = RegExp(
        r'\d+(?:[.,]\d+)?\s+(?:м|км|m|km)(?:$|[\s·,])',
      );
      expect(find.textContaining(distance), findsNothing);
      expect(find.semantics.byLabel(distance), findsNothing);
      semantics.dispose();
      expect(tester.takeException(), isNull);
    });

    test('instructions and fallback labels use $language', () async {
      final l10n = await AppLocalizations.delegate.load(locale);
      final campus = _campus();
      const unknown = IndoorNavigationNode(
        id: 'unknown',
        floorId: 'unmapped-floor',
        x: 0,
        y: 0,
      );
      expect(
        mapRouteNodeLabel(unknown, campus, l10n),
        language == 'en' ? 'Point on the map' : 'Точка на плане',
      );
      final start = IndoorNavigationGraph.fromJson(campus.graph).nodes.first;
      expect(
        mapRouteInstructionLabel(
          IndoorRouteInstruction(
            maneuver: IndoorManeuver.stairs,
            atNode: start,
            toNode: unknown,
            distanceMeters: null,
          ),
          campus,
          l10n,
        ),
        language == 'en'
            ? 'Take the stairs to another floor'
            : 'По лестнице на другой этаж',
      );
    });
  }

  testWidgets('an existing route data error updates after a locale change', (
    tester,
  ) async {
    final locale = ValueNotifier(const Locale('ru'));
    addTearDown(locale.dispose);
    final campus = _campus();
    final rooms = [...campus.rooms];
    rooms[0] = MapPlaceData.fromJson({
      ...rooms[0].raw,
      'navigation_needs_review': true,
    });
    final movedCampus = CampusMapData(
      campus: campus.campus,
      floors: campus.floors,
      rooms: rooms,
      graph: campus.graph,
      sourceUrl: campus.sourceUrl,
      sourceLabel: campus.sourceLabel,
      revision: 1,
      origin: MapDataOrigin.bundled,
    );
    final sheet = MapRouteSheet(
      campus: movedCampus,
      startRoomId: 'entrance',
      destinationRoomId: 'room',
      onApply: (_) {},
      onContribute: () {},
    );
    await tester.pumpWidget(
      ValueListenableBuilder<Locale>(
        valueListenable: locale,
        builder: (context, locale, _) => MaterialApp(
          locale: locale,
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: SingleChildScrollView(child: sheet)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final ru = await AppLocalizations.delegate.load(const Locale('ru'));
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(ru.mapRoutePlaceNeedsReview), findsOneWidget);
    locale.value = const Locale('en');
    await tester.pumpAndSettle();
    expect(find.text(en.mapRoutePlaceNeedsReview), findsOneWidget);
    expect(find.text(ru.mapRoutePlaceNeedsReview), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required Locale locale,
  required Widget child,
}) async {
  tester.view
    ..physicalSize = const Size(390, 844)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: child,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

CampusMapData _campus({bool knownDistance = true}) {
  final floors = [
    for (final number in [1, 2])
      MapFloorData.fromJson({
        'id': 'floor-$number',
        'level': number,
        'width': 100,
        'height': 100,
      }, svgPath: 'test.svg'),
  ];
  return CampusMapData(
    campus: CampusModel(
      id: 'campus',
      displayName: 'Campus',
      floors: floors.map((floor) => floor.floor).toList(),
    ),
    floors: floors,
    rooms: [
      MapPlaceData.fromJson({
        'id': 'entrance',
        'floor_id': 'floor-1',
        'label': 'Entrance',
        'x': 0,
        'y': 0,
      }),
      MapPlaceData.fromJson({
        'id': 'room',
        'floor_id': 'floor-2',
        'label': '201',
        'x': 10,
        'y': 10,
      }),
    ],
    graph: {
      'nodes': [
        {
          'id': 'start',
          'room_id': 'entrance',
          'floor_id': 'floor-1',
          'x': 0,
          'y': 0,
        },
        {
          'id': 'end',
          'room_id': 'room',
          'floor_id': 'floor-2',
          'x': 10,
          'y': 10,
        },
      ],
      'edges': [
        {
          'id': 'stairs',
          'from_node_id': 'start',
          'to_node_id': 'end',
          'kind': 'stairs',
          if (knownDistance) 'distance_meters': 15 else 'traversal_cost': 15,
          'duration_seconds': 30,
        },
      ],
    },
    sourceUrl: 'https://example.invalid',
    sourceLabel: 'Fixture',
    revision: 1,
    origin: MapDataOrigin.bundled,
  );
}
