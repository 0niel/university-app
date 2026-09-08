import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/services/objects_service.dart';
import 'package:rtu_mirea_app/map/view/map_view.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_guidance.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/svg_interactive_map.dart';
import 'package:rtu_mirea_app/map/widgets/svg_interactive_map_controller.dart';

import '../../gallery/gallery_fonts.dart';
import '../../helpers/pump_app.dart';

class _CampusRepository extends Mock implements CampusRepository {}

class _NoCache implements MapDataCache {
  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}
}

class _RecordingController extends SvgInteractiveMapController {
  final focuses = <List<Offset>>[];

  @override
  void focusPoints(List<Offset> points) => focuses.add(List.of(points));
}

Map<String, Object?> _document({bool updated = false}) => {
  'id': 'campus',
  'short_title': 'В-78',
  'revision': 2,
  'floors': [
    for (final level in [1, 2])
      {
        'id': 'floor-$level',
        'level': level,
        'width': 100,
        'height': 100,
        'svg':
            '<svg viewBox="0 0 100 100"> '
            '<rect x="10" y="10" width="80" height="80" /> '
            '</svg>',
      },
  ],
  'rooms': [
    {'id': 'start', 'floor_id': 'floor-1', 'label': 'А-101', 'x': 15, 'y': 15},
    {'id': 'end', 'floor_id': 'floor-2', 'label': 'А-201', 'x': 15, 'y': 75},
  ],
  'graph': {
    'nodes': [
      {'id': 'n1', 'floor_id': 'floor-1', 'room_id': 'start', 'x': 15, 'y': 15},
      {'id': 'n2', 'floor_id': 'floor-1', 'kind': 'stairs', 'x': 75, 'y': 15},
      {'id': 'n3', 'floor_id': 'floor-2', 'kind': 'stairs', 'x': 75, 'y': 75},
      {
        'id': 'n4',
        'floor_id': 'floor-2',
        'room_id': 'end',
        'x': 15,
        'y': updated ? 65 : 75,
      },
    ],
    'edges': [
      {
        'id': 'walk-1',
        'distance_meters': 20,
        'from_node_id': 'n1',
        'to_node_id': 'n2',
      },
      {
        'id': 'stairs',
        'kind': 'stairs',
        'traversal_cost': 10,
        'from_node_id': 'n2',
        'to_node_id': 'n3',
      },
      {
        'id': 'walk-2',
        'distance_meters': 20,
        'from_node_id': 'n3',
        'to_node_id': 'n4',
      },
    ],
  },
};

class _Harness {
  final controller = _RecordingController();
  late final MapDataRepository repository;
  late final MapBloc map;
  late final FreeRoomsCubit free;
  late final IndoorRoute route;
  bool online = false;
  bool updated = false;

  Future<void> mount(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    TextScaler textScaler = TextScaler.noScaling,
  }) async {
    repository = MapDataRepository(
      organizationId: 'mirea',
      cache: _NoCache(),
      bundledCatalogAsset: 'catalog.json',
      assetLoader: (path) async => jsonEncode(
        path == 'catalog.json'
            ? {
                'campuses': [
                  {'id': 'campus', 'revision': 2},
                ],
              }
            : _document(),
      ),
      rpc: (name, _) async {
        if (!online) throw const MapDataException('offline');
        return name == 'get_map_catalog'
            ? {
                'campuses': [
                  {'id': 'campus', 'revision': 2},
                ],
              }
            : _document(updated: updated);
      },
    );
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
      final ready = map.stream.firstWhere((state) => state.status == .loaded);
      map.add(const MapEvent.initialized());
      await ready;
      await free.load();
    });
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(() async {
        await map.close();
        await free.close();
        repository.dispose();
      });
    });
    route = IndoorRoutePlanner(
      IndoorNavigationGraph.fromJson(map.state.campusData!.graph),
    ).findRoute(startNodeId: 'n1', destinationNodeId: 'n4').route!;
    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<MapBloc>.value(value: map),
          BlocProvider<FreeRoomsCubit>.value(value: free),
        ],
        child: RepaintBoundary(
          key: const ValueKey('route-timeline-preview'),
          child: MapView(mapController: controller),
        ),
      ),
      size: size,
      textScaler: textScaler,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Маршрут'));
    await tester.pumpAndSettle();
    final sheet = tester.widget<MapRouteSheet>(find.byType(MapRouteSheet));
    sheet.onApply(route);
    sheet.onClose!();
    await tester.pumpAndSettle();
    controller.focuses.clear();
  }

  MapRouteGuidance guidance(WidgetTester tester) =>
      tester.widget<MapRouteGuidance>(find.byType(MapRouteGuidance));

  Future<void> move(
    WidgetTester tester, {
    required String expectedFloor,
    bool back = false,
  }) async {
    final callback = back
        ? guidance(tester).onPrevious!
        : guidance(tester).onNext!;
    if (map.state.selectedFloor!.id == expectedFloor) {
      callback();
    } else {
      await tester.runAsync(() async {
        final loaded = map.stream.firstWhere(
          (state) =>
              state.status == .loaded &&
              state.selectedFloor?.id == expectedFloor,
        );
        callback();
        await loaded.timeout(const Duration(seconds: 10));
      });
    }
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets(
    'timeline previews while dragging and commits the final floor once',
    (tester) async {
      final harness = _Harness();
      await harness.mount(tester);
      final slider = tester.getRect(find.byType(AppSlider));
      final gesture = await tester.startGesture(
        Offset(slider.left + 2, slider.center.dy),
      );
      await gesture.moveTo(Offset(slider.right - 2, slider.center.dy));
      await tester.pump();
      expect(harness.guidance(tester).stepIndex, 0);
      expect(harness.map.state.selectedFloor!.id, 'floor-1');
      expect(harness.controller.focuses, isEmpty);
      expect(find.text('Конец маршрута'), findsOneWidget);
      await tester.runAsync(() async {
        final loaded = harness.map.stream.firstWhere(
          (state) =>
              state.status == .loaded && state.selectedFloor?.id == 'floor-2',
        );
        await gesture.up();
        await loaded.timeout(const Duration(seconds: 10));
      });
      await tester.pumpAndSettle();
      expect(
        harness.guidance(tester).stepIndex,
        harness.route.instructions.length - 1,
      );
      expect(harness.controller.focuses, [
        [const Offset(15, 75)],
      ]);
      expect(
        tester.widget<AppSlider>(find.byType(AppSlider)).value,
        harness.route.instructions.length.toDouble(),
      );
    },
  );

  testWidgets('tap without a preview rebuild commits the touched step', (
    tester,
  ) async {
    final harness = _Harness();
    await harness.mount(tester);
    final count = harness.route.instructions.length;
    final stair = harness.route.instructions.indexWhere(
      (step) => step.maneuver == IndoorManeuver.stairs,
    );
    final slider = tester.getRect(find.byType(AppSlider));
    await tester.tapAt(
      Offset(
        slider.left + slider.width * stair / (count - 1),
        slider.center.dy,
      ),
    );
    await tester.pumpAndSettle();
    expect(harness.guidance(tester).stepIndex, stair);
    expect(harness.controller.focuses, [
      [const Offset(75, 15)],
    ]);
    harness.guidance(tester).onStepSelected!(stair);
    await tester.pumpAndSettle();
    expect(harness.controller.focuses, hasLength(1));
  });

  testWidgets(
    'cancelled scrubbing restores the committed thumb without moving the map',
    (tester) async {
      final harness = _Harness();
      await harness.mount(tester);
      final slider = tester.getRect(find.byType(AppSlider));
      final gesture = await tester.startGesture(
        Offset(slider.left + 2, slider.center.dy),
      );
      await gesture.moveTo(Offset(slider.right - 2, slider.center.dy));
      await tester.pump();
      await gesture.cancel();
      await tester.pumpAndSettle();
      expect(tester.widget<AppSlider>(find.byType(AppSlider)).value, 1);
      expect(harness.controller.focuses, isEmpty);
      expect(harness.guidance(tester).stepIndex, 0);
    },
  );

  testWidgets('scrubbing away and back before a frame does not move the map', (
    tester,
  ) async {
    final harness = _Harness();
    await harness.mount(tester);
    final slider = tester.getRect(find.byType(AppSlider));
    final start = Offset(slider.left + 2, slider.center.dy);
    final gesture = await tester.startGesture(start);
    await gesture.moveTo(Offset(slider.right - 2, slider.center.dy));
    await gesture.moveTo(start);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(harness.guidance(tester).stepIndex, 0);
    expect(harness.controller.focuses, isEmpty);
    expect(tester.widget<AppSlider>(find.byType(AppSlider)).value, 1);
  });

  testWidgets(
    'rapid keyboard selections use the latest step before a frame',
    (tester) async {
      final harness = _Harness();
      await harness.mount(tester);
      final slider = tester.getRect(find.byType(AppSlider));
      await tester.tapAt(Offset(slider.left + 2, slider.center.dy));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pumpAndSettle();
      expect(harness.guidance(tester).stepIndex, 0);
      harness.controller.focuses.clear();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(harness.guidance(tester).stepIndex, 2);
      expect(harness.controller.focuses, [
        [const Offset(75, 15)],
      ]);
      expect(tester.widget<AppSlider>(find.byType(AppSlider)).value, 3);
    },
  );

  testWidgets(
    'selected milestone restores its floor after manually changing floors',
    (tester) async {
      final harness = _Harness();
      await harness.mount(tester);
      await tester.runAsync(() async {
        final loaded = harness.map.stream.firstWhere(
          (state) =>
              state.status == .loaded && state.selectedFloor?.id == 'floor-2',
        );
        harness.map.add(
          MapEvent.floorSelected(
            campus: harness.map.state.selectedCampus!,
            floor: harness.map.state.campusData!.floorForId('floor-2')!.floor,
          ),
        );
        await loaded.timeout(const Duration(seconds: 10));
      });
      await tester.pumpAndSettle();
      expect(harness.guidance(tester).stepIndex, 0);
      final loaded = harness.map.stream.firstWhere(
        (state) =>
            state.status == .loaded && state.selectedFloor?.id == 'floor-1',
      );
      await tester.tap(
        find.descendant(
          of: find.byType(MapRouteGuidance),
          matching: find.widgetWithText(AppChip, 'Старт'),
        ),
      );
      await tester.runAsync(() => loaded.timeout(const Duration(seconds: 10)));
      await tester.pumpAndSettle();
      expect(harness.map.state.selectedFloor!.id, 'floor-1');
      expect(harness.guidance(tester).stepIndex, 0);
      expect(harness.controller.focuses, [
        [const Offset(15, 15)],
      ]);
    },
  );

  testWidgets(
    'keyboard steps and rapid jumps keep only the latest focus',
    (tester) async {
      final harness = _Harness();
      await harness.mount(tester);
      final slider = tester.getRect(find.byType(AppSlider));
      await tester.tapAt(Offset(slider.left + 2, slider.center.dy));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      final stair = harness.guidance(tester).stepIndex;
      expect(stair, greaterThan(0));
      harness.controller.focuses.clear();
      final selected = harness.guidance(tester).onStepSelected!;
      selected(0);
      selected(stair);
      await tester.pumpAndSettle();
      final step = harness.route.instructions[stair];
      expect(harness.controller.focuses, [
        [
          Offset(step.atNode.x, step.atNode.y),
          if (step.toNode case final next?
              when next.floorId == step.atNode.floorId)
            Offset(next.x, next.y),
        ],
      ]);
      selected(0);
      harness.guidance(tester).onClose();
      await tester.pumpAndSettle();
      expect(harness.controller.focuses, hasLength(1));
      selected(stair);
      await tester.pumpAndSettle();
      expect(find.byType(MapRouteGuidance), findsNothing);
    },
  );

  testWidgets('snapshot replacement cancels a scrub before pointer release', (
    tester,
  ) async {
    final harness = _Harness();
    await harness.mount(tester);
    final selected = harness.guidance(tester).onStepSelected!;
    final slider = tester.getRect(find.byType(AppSlider));
    final gesture = await tester.startGesture(
      Offset(slider.left + 2, slider.center.dy),
    );
    await gesture.moveTo(Offset(slider.right - 2, slider.center.dy));
    await tester.pump();
    harness
      ..online = true
      ..updated = true;
    await tester.runAsync(() async {
      final refreshed = harness.map.stream.firstWhere(
        (state) =>
            state.status == .loaded &&
            state.campusData?.origin.name == 'remote',
      );
      harness.map.add(const MapEvent.refreshRequested());
      await refreshed.timeout(const Duration(seconds: 10));
    });
    await tester.pumpAndSettle();
    await gesture.up();
    selected(harness.route.instructions.length - 1);
    await tester.pumpAndSettle();
    expect(find.byType(MapRouteGuidance), findsNothing);
    expect(harness.controller.focuses, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'screen reader visits every step even on routes over 100 instructions',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        final harness = _Harness();
        await harness.mount(tester);
        final graph = IndoorNavigationGraph.fromJson({
          'nodes': [
            for (var i = 0; i < 130; i++)
              {
                'id': 'n$i',
                'floor_id': 'floor-1',
                'x': (i ~/ 2) * 10,
                'y': ((i + 1) ~/ 2) * 10,
              },
          ],
          'edges': [
            for (var i = 0; i < 129; i++)
              {
                'id': 'e$i',
                'from_node_id': 'n$i',
                'to_node_id': 'n${i + 1}',
                'distance_meters': 10,
              },
          ],
        });
        final route = IndoorRoutePlanner(
          graph,
        ).findRoute(startNodeId: 'n0', destinationNodeId: 'n129').route!;
        expect(route.instructions.length, greaterThan(100));
        var index = 99;
        await tester.pumpApp(
          StatefulBuilder(
            builder: (context, update) => Scaffold(
              body: MapRouteGuidance(
                campus: harness.map.state.campusData!,
                route: route,
                stepIndex: index,
                onClose: () {},
                onStepSelected: (step) => update(() => index = step),
              ),
            ),
          ),
        );
        expect(
          tester.widget<AppSlider>(find.byType(AppSlider)).divisions,
          isNull,
        );
        tester.semantics.increase(
          find.semantics.byValue('100 из ${route.instructions.length}'),
        );
        await tester.pump();
        expect(index, 100);
        tester.semantics.decrease(
          find.semantics.byValue('101 из ${route.instructions.length}'),
        );
        await tester.pump();
        expect(index, 99);
      } finally {
        semantics.dispose();
      }
    },
  );

  for (final size in [const Size(390, 844), const Size(320, 420)]) {
    testWidgets('timeline leaves visible map at $size with large text', (
      tester,
    ) async {
      const previews = bool.fromEnvironment('MAP_TIMELINE_PREVIEWS');
      await loadGalleryFonts();
      if (previews) {
        final icons = FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
        await icons.load();
      }
      final harness = _Harness();
      await harness.mount(
        tester,
        size: size,
        textScaler: TextScaler.linear(size.height < 600 ? 2 : 1),
      );
      if (size.height < 600) {
        harness.guidance(tester).onStepSelected!(
          harness.route.instructions.indexWhere(
            (step) => step.maneuver == IndoorManeuver.stairs,
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester
              .renderObject<RenderParagraph>(find.text('Лестница'))
              .didExceedMaxLines,
          isFalse,
        );
      }
      final guide = tester.getRect(find.byType(MapRouteGuidance));
      final map = tester.widget<SvgInteractiveMap>(
        find.byType(SvgInteractiveMap),
      );
      final padding = map.viewportPaddingListenable!.value;
      expect(guide.bottom, lessThan(size.height - padding.bottom - 32));
      expect(
        tester.getRect(find.byTooltip('Завершить маршрут')).bottom,
        lessThan(size.height),
      );
      expect(tester.takeException(), isNull);
      if (previews) {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(const ValueKey('route-timeline-preview')),
        );
        final image = (await tester.runAsync(boundary.toImage))!;
        final bytes = (await tester.runAsync(
          () => image.toByteData(format: ui.ImageByteFormat.png),
        ))!;
        await tester.runAsync(() async {
          final file = File(
            'output/campus-map/previews/route-timeline-${size.width.toInt()}x${size.height.toInt()}.png',
          );
          await file.parent.create(recursive: true);
          await file.writeAsBytes(bytes.buffer.asUint8List());
        });
        image.dispose();
      }
    });
  }

  testWidgets(
    'stairs stay on departure floor until advancing and back restores it',
    (tester) async {
      final harness = _Harness();
      await harness.mount(tester);
      final stairIndex = harness.route.instructions.indexWhere(
        (instruction) => instruction.maneuver == IndoorManeuver.stairs,
      );
      for (var index = 0; index < stairIndex; index++) {
        await harness.move(tester, expectedFloor: 'floor-1');
      }
      expect(harness.map.state.selectedFloor!.id, 'floor-1');
      expect(harness.guidance(tester).stepIndex, stairIndex);
      expect(harness.controller.focuses.last, [const Offset(75, 15)]);
      await harness.move(tester, expectedFloor: 'floor-2');
      expect(harness.map.state.selectedFloor!.id, 'floor-2');
      expect(harness.controller.focuses.last, [
        const Offset(75, 75),
        const Offset(15, 75),
      ]);
      await harness.move(tester, expectedFloor: 'floor-1', back: true);
      expect(harness.map.state.selectedFloor!.id, 'floor-1');
      expect(harness.guidance(tester).stepIndex, stairIndex);
      expect(harness.controller.focuses.last, [const Offset(75, 15)]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'closing route cancels camera focus already queued for next frame',
    (tester) async {
      final harness = _Harness();
      await harness.mount(tester);
      final guidance = harness.guidance(tester);
      guidance.onNext!();
      guidance.onClose();
      await tester.pumpAndSettle();
      expect(find.byType(MapRouteGuidance), findsNothing);
      expect(harness.controller.focuses, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('closing during floor change cancels deferred arrival focus', (
    tester,
  ) async {
    final harness = _Harness();
    await harness.mount(tester);
    final stairIndex = harness.route.instructions.indexWhere(
      (instruction) => instruction.maneuver == IndoorManeuver.stairs,
    );
    for (var index = 0; index < stairIndex; index++) {
      await harness.move(tester, expectedFloor: 'floor-1');
    }
    harness.controller.focuses.clear();
    final guidance = harness.guidance(tester);
    await tester.runAsync(() async {
      final loaded = harness.map.stream.firstWhere(
        (state) =>
            state.status == .loaded && state.selectedFloor?.id == 'floor-2',
      );
      guidance.onNext!();
      guidance.onClose();
      await loaded.timeout(const Duration(seconds: 10));
    });
    await tester.pumpAndSettle();
    expect(harness.map.state.selectedFloor!.id, 'floor-2');
    expect(find.byType(MapRouteGuidance), findsNothing);
    expect(harness.controller.focuses, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'snapshot replacement cancels queued focus even at same revision',
    (tester) async {
      final harness = _Harness();
      await harness.mount(tester);
      final snapshot = harness.map.state.campusData;
      harness.guidance(tester).onNext!();
      harness
        ..online = true
        ..updated = true;
      await tester.runAsync(() async {
        final refreshed = harness.map.stream.firstWhere(
          (state) =>
              state.status == .loaded &&
              state.campusData?.origin.name == 'remote',
        );
        harness.map.add(const MapEvent.refreshRequested());
        await refreshed.timeout(const Duration(seconds: 10));
      });
      await tester.pumpAndSettle();
      expect(identical(snapshot, harness.map.state.campusData), isFalse);
      expect(snapshot!.revision, harness.map.state.campusData!.revision);
      expect(find.byType(MapRouteGuidance), findsNothing);
      expect(harness.controller.focuses, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('unchanged refresh preserves route progress and floor', (
    tester,
  ) async {
    final harness = _Harness();
    await harness.mount(tester);
    final stairIndex = harness.route.instructions.indexWhere(
      (instruction) => instruction.maneuver == IndoorManeuver.stairs,
    );
    for (var index = 0; index < stairIndex; index++) {
      await harness.move(tester, expectedFloor: 'floor-1');
    }
    await harness.move(tester, expectedFloor: 'floor-2');
    final snapshot = harness.map.state.campusData;
    final step = harness.guidance(tester).stepIndex;
    harness.controller.focuses.clear();
    harness.online = true;
    await tester.runAsync(() async {
      final refreshed = harness.map.stream.firstWhere(
        (state) => state.status == .loaded && !state.isOffline,
      );
      harness.map.add(const MapEvent.refreshRequested());
      await refreshed.timeout(const Duration(seconds: 10));
    });
    await tester.pumpAndSettle();
    expect(harness.map.state.campusData, same(snapshot));
    expect(harness.map.state.selectedFloor!.id, 'floor-2');
    expect(harness.guidance(tester).stepIndex, step);
    expect(harness.controller.focuses, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('refresh discards a route focus waiting on a different floor', (
    tester,
  ) async {
    final harness = _Harness();
    await harness.mount(tester);
    final stairIndex = harness.route.instructions.indexWhere(
      (instruction) => instruction.maneuver == IndoorManeuver.stairs,
    );
    for (var index = 0; index < stairIndex; index++) {
      await harness.move(tester, expectedFloor: 'floor-1');
    }
    harness.controller.focuses.clear();
    harness
      ..online = true
      ..updated = true;
    await tester.runAsync(() async {
      final refreshed = harness.map.stream.firstWhere(
        (state) =>
            state.status == .loaded &&
            state.campusData?.origin.name == 'remote',
      );
      harness.guidance(tester).onNext!();
      harness.map.add(const MapEvent.refreshRequested());
      await refreshed.timeout(const Duration(seconds: 10));
    });
    await tester.pumpAndSettle();
    expect(harness.map.state.selectedFloor!.id, 'floor-1');
    expect(find.byType(MapRouteGuidance), findsNothing);
    await tester.runAsync(() async {
      final loaded = harness.map.stream.firstWhere(
        (state) =>
            state.status == .loaded && state.selectedFloor?.id == 'floor-2',
      );
      harness.map.add(
        MapEvent.floorSelected(
          campus: harness.map.state.selectedCampus!,
          floor: harness.map.state.campusData!.floorForId('floor-2')!.floor,
        ),
      );
      await loaded.timeout(const Duration(seconds: 10));
    });
    await tester.pumpAndSettle();
    expect(harness.controller.focuses, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
