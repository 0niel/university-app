@Tags(['gallery'])
library;

import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/services/map_navigation_landmarks.dart';
import 'package:rtu_mirea_app/map/services/svg_room_parser.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_guidance.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/map_structure_layer.dart';
import 'package:rtu_mirea_app/map/widgets/map_volume_layer.dart';

import 'gallery_fonts.dart';

class _Cache implements MapDataCache {
  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}
}

void main() {
  setUpAll(() async {
    await loadGalleryFonts();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });

  testWidgets('Pulse volume route with stairs and arrival', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repository = MapDataRepository(
      organizationId: 'mirea',
      cache: _Cache(),
      bundledCatalogAsset: MapDataRepository.pulseCatalogAsset,
      rpc: (_, _) async => throw const MapDataException('offline'),
    );
    addTearDown(repository.dispose);
    final campus = (await tester.runAsync(
      () => repository.loadCampus('v-78'),
    ))!;
    final start = campus.rooms.firstWhere((room) => room.label == 'А-107');
    final destination = campus.rooms.firstWhere(
      (room) => room.label == 'А-203',
    );
    final graph = IndoorNavigationGraph.fromJson(campus.graph);
    final result = IndoorRoutePlanner(graph).findRouteBetween(
      startNodeIds: graph.nodesForRoom(start.id).map((node) => node.id),
      destinationNodeIds: graph
          .nodesForRoom(destination.id)
          .map((node) => node.id),
    );
    expect(result.status, IndoorRouteStatus.found);
    final route = result.route!;
    expect(route.floorIds, hasLength(2));
    final stairsIndex = route.instructions.indexWhere(
      (step) => step.maneuver == IndoorManeuver.stairs,
    );
    expect(stairsIndex, greaterThanOrEqualTo(0));
    final landmarks = mapNavigationLandmarks(graph, places: campus.rooms);
    for (final (index, floorId) in route.floorIds.indexed) {
      final floor = campus.floorForId(floorId)!.floor;
      final svg = await repository.loadSvg(floor.svgPath);
      final (rooms, bounds) = await SvgRoomParser(
        onLoadSvg: repository.loadSvg,
      ).parseSvg(floor.svgPath);
      final segments = [
        for (final segment in route.segmentsForFloor(floorId))
          [for (final node in segment.nodes) Offset(node.x, node.y)],
      ];
      final points = segments.expand((segment) => segment).toList();
      var routeBounds = Rect.fromPoints(points.first, points.last);
      for (final point in points) {
        routeBounds = routeBounds.expandToInclude(
          Rect.fromPoints(point, point),
        );
      }
      final stepIndex = index == 0
          ? stairsIndex
          : route.instructions.length - 1;
      final instruction = route.instructions[stepIndex].atNode;
      final camera = TransformationController();
      addTearDown(camera.dispose);
      final boundaryKey = ValueKey('volume-route-$floorId');
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundaryKey,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final viewport = constraints.biggest;
                        final scale = math
                            .min(
                              (viewport.width - 100) /
                                  math.max(routeBounds.width, 30),
                              (viewport.height - 140) /
                                  math.max(
                                    routeBounds.height * math.cos(.85),
                                    30,
                                  ),
                            )
                            .clamp(.1, 10.0);
                        camera.value = Matrix4.identity()
                          ..translateByDouble(
                            viewport.width / 2 - routeBounds.center.dx * scale,
                            viewport.height / 2 - routeBounds.center.dy * scale,
                            0,
                            1,
                          )
                          ..scaleByDouble(scale, scale, 1, 1);
                        return MapVolumeLayer(
                          floorSize: bounds.size,
                          viewportSize: viewport,
                          layers: MapStructureLayers.fromSvg(svg),
                          rooms: rooms,
                          places: campus.rooms
                              .where((place) => place.floorId == floorId)
                              .toList(),
                          navigationLandmarks: landmarks
                              .where(
                                (landmark) => landmark.place.floorId == floorId,
                              )
                              .toList(),
                          transform: camera,
                          routeSegments: segments,
                          instructionPoint: Offset(
                            instruction.x,
                            instruction.y,
                          ),
                          showRouteStart: index == 0,
                          showRouteDestination:
                              index == route.floorIds.length - 1,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: MapRouteGuidance(
                      campus: campus,
                      route: route,
                      stepIndex: stepIndex,
                      onClose: () {},
                      onNext: index == 0 ? () {} : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(MapRouteGuidance), findsOneWidget);
      expect(tester.takeException(), isNull);
      if (const bool.fromEnvironment('MAP_PREVIEWS')) {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(boundaryKey),
        );
        await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 2);
          final png = await image.toByteData(format: ui.ImageByteFormat.png);
          image.dispose();
          final directory = Directory('output/campus-map/previews');
          await directory.create(recursive: true);
          await File(
            '${directory.path}/route-volume-${index == 0 ? 'stairs' : 'arrival'}-dark.png',
          ).writeAsBytes(png!.buffer.asUint8List());
        });
      }
    }
  });

  for (final dark in [false, true]) {
    testWidgets('Pulse route ${dark ? 'dark' : 'light'}', (tester) async {
      tester.view
        ..physicalSize = const Size(390, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final scale = ValueNotifier<TextScaler>(TextScaler.noScaling);
      addTearDown(scale.dispose);
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: _Cache(),
        bundledCatalogAsset: MapDataRepository.pulseCatalogAsset,
        rpc: (_, _) async => throw const MapDataException('offline'),
      );
      addTearDown(repository.dispose);
      final campus = (await tester.runAsync(
        () => repository.loadCampus('v-78'),
      ))!;
      final start = campus.rooms.firstWhere((room) => room.label == 'А-107');
      final destination = campus.rooms.firstWhere(
        (room) => room.label == 'А-203',
      );
      final graph = IndoorNavigationGraph.fromJson(campus.graph);
      final route = IndoorRoutePlanner(graph).findRouteBetween(
        startNodeIds: graph.nodesForRoom(start.id).map((node) => node.id),
        destinationNodeIds: graph
            .nodesForRoom(destination.id)
            .map((node) => node.id),
      );
      expect(route.status, IndoorRouteStatus.found);
      expect(route.route!.hasCompleteDistance, isFalse);
      expect(route.route!.floorIds, hasLength(2));
      const boundaryKey = ValueKey('map-route-preview');
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundaryKey,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => ValueListenableBuilder<TextScaler>(
              valueListenable: scale,
              builder: (context, value, _) => MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: value),
                child: child!,
              ),
            ),
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: AppButton.primary(
                    label: 'Маршрут',
                    onPressed: () => showAppSheet<void>(
                      context,
                      child: MapRouteSheet(
                        campus: campus,
                        startRoomId: start.id,
                        destinationRoomId: destination.id,
                        onApply: (_) {},
                        onContribute: () {},
                        onClose: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Маршрут'));
      await tester.pumpAndSettle();
      expect(find.text('Показать путь'), findsOneWidget);
      expect(tester.takeException(), isNull);

      Future<void> capture(String suffix) async {
        if (!const bool.fromEnvironment('MAP_PREVIEWS')) return;
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(boundaryKey),
        );
        await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 2);
          final png = await image.toByteData(format: ui.ImageByteFormat.png);
          image.dispose();
          final directory = Directory('output/campus-map/previews');
          await directory.create(recursive: true);
          await File(
            '${directory.path}/route-${dark ? 'dark' : 'light'}-$suffix.png',
          ).writeAsBytes(png!.buffer.asUint8List());
        });
      }

      await capture('overview');
      await tester.tap(find.text('Откуда: А-107'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'А-1');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await capture('picker');
      Navigator.of(tester.element(find.byType(TextField))).pop();
      await tester.pumpAndSettle();
      tester.view.physicalSize = const Size(320, 568);
      scale.value = const TextScaler.linear(2);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await capture('compact-large-text');
      expect(find.text('Показать путь').hitTestable(), findsOneWidget);
      expect(
        tester
            .renderObject<RenderParagraph>(find.text('Показать путь'))
            .didExceedMaxLines,
        isFalse,
      );
      await tester.tap(find.text('Откуда: А-107'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'А-1');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await capture('picker-large-text');
      final longRoomLabel = campus.rooms
          .firstWhere((room) => room.label.startsWith('А-101-А'))
          .label;
      final roomText = tester.renderObject<RenderParagraph>(
        find.text(longRoomLabel),
      );
      expect(roomText.didExceedMaxLines, isFalse);
      Navigator.of(tester.element(find.byType(TextField))).pop();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('По лестнице на 2 этаж').first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await capture('steps-large-text');
      await tester.ensureVisible(find.text('Показать путь'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await capture('action-large-text');
      await tester.ensureVisible(find.text('Откуда: А-107'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Откуда: А-107'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), longRoomLabel);
      await tester.pumpAndSettle();
      await tester.tap(find.text(longRoomLabel).last);
      await tester.pumpAndSettle();
      final selectedRoom = tester.renderObject<RenderParagraph>(
        find.text('Откуда: $longRoomLabel'),
      );
      expect(selectedRoom.didExceedMaxLines, isFalse);
      expect(tester.takeException(), isNull);
      await capture('selected-long-label');
    });
  }
}
