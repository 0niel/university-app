import 'dart:convert';
import 'dart:math' as math;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/map_planar_scale.dart';
import 'package:rtu_mirea_app/map/services/map_volume_projection.dart';
import 'package:rtu_mirea_app/map/services/svg_room_parser.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_canvas.dart';
import 'package:rtu_mirea_app/map/widgets/map_volume_layer.dart';
import 'package:rtu_mirea_app/map/widgets/svg_interactive_map.dart';
import 'package:rtu_mirea_app/map/widgets/svg_interactive_map_controller.dart';

import '../../helpers/pump_app.dart';

class _Map extends MockBloc<MapEvent, MapState> implements MapBloc {}

void main() {
  for (final reduced in [false, true]) {
    for (final bearing in [0.0, math.pi / 4]) {
      testWidgets(
        'volume viewport refits rendered geometry and room taps, '
        'reduce=$reduced, bearing=$bearing',
        (tester) async {
          final fixture = await _pumpVolume(
            tester,
            reduced: reduced,
            bearing: bearing,
          );
          final initial = fixture.layer(tester);
          final initialMatrix = List<double>.of(
            initial.transform.value.storage,
          );
          for (final bottom in [150.0, 200.0, 250.0, 300.0]) {
            fixture.padding.value = EdgeInsets.only(bottom: bottom);
            await tester.pump(const Duration(milliseconds: 16));
            expect(fixture.layer(tester), same(initial));
            expect(
              initial.transform.value.storage,
              orderedEquals(initialMatrix),
            );
          }
          await tester.pump(const Duration(milliseconds: 120));
          if (!reduced) {
            final previous = MapVolumeProjection(
              viewportSize: initial.viewportSize,
              transform: Matrix4.fromList(initialMatrix),
              bearing: initial.bearing,
              pitch: initial.pitch,
              pivot: initial.pivot,
            );
            expect(
              (fixture.projection(tester).sceneToScreen(Offset.zero) -
                      previous.sceneToScreen(Offset.zero))
                  .distance,
              lessThan(.000001),
            );
          }
          await tester.pumpAndSettle();
          final projection = fixture.projection(tester);
          final visible = Rect.fromLTWH(
            0,
            0,
            320,
            420 - fixture.padding.value.bottom,
          );
          for (final corner in [
            _VolumeFixture.bounds.topLeft,
            _VolumeFixture.bounds.topRight,
            _VolumeFixture.bounds.bottomLeft,
            _VolumeFixture.bounds.bottomRight,
          ]) {
            final point = projection.sceneToScreen(corner);
            expect(point.dx, inInclusiveRange(visible.left, visible.right));
            expect(point.dy, inInclusiveRange(visible.top, visible.bottom));
          }
          await fixture.tapRoom(tester);
          expect(fixture.tapped, [fixture.room]);
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets(
      'volume geometry remains tappable before viewport settles, '
      'reduce=$reduced',
      (tester) async {
        final fixture = await _pumpVolume(
          tester,
          reduced: reduced,
          bearing: math.pi / 4,
        );
        final initial = fixture.layer(tester);
        fixture.padding.value = const EdgeInsets.only(bottom: 300);
        await tester.pump(const Duration(milliseconds: 16));
        expect(fixture.layer(tester), same(initial));
        fixture.hitRoom(tester);
        await tester.pump();
        expect(fixture.tapped, [fixture.room]);
        await tester.pump(const Duration(milliseconds: 120));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'volume viewport preserves explored route focus and zoom, '
      'reduce=$reduced',
      (tester) async {
        final fixture = await _pumpVolume(
          tester,
          reduced: reduced,
          bearing: math.pi / 4,
        );
        fixture.controller.focusPoints(const [
          Offset(800, 400),
          Offset(1200, 600),
        ]);
        await tester.pumpAndSettle();
        final scale = fixture.controller.currentScale;
        final center = fixture
            .projection(tester)
            .screenToScene(
              const Offset(160, 210),
            );
        for (final bottom in [200.0, 300.0, 0.0]) {
          fixture.padding.value = EdgeInsets.only(bottom: bottom);
          await tester.pump(const Duration(milliseconds: 120));
          await tester.pumpAndSettle();
          final current = fixture.projection(tester);
          expect(fixture.controller.currentScale, closeTo(scale!, .000001));
          expect(
            (current.screenToScene(Offset(160, (420 - bottom) / 2)) - center)
                .distance,
            lessThan(.000001),
          );
        }
        await fixture.tapRoom(tester);
        expect(fixture.tapped, [fixture.room]);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final (disableAnimations, accessibleNavigation) in [
    (false, false),
    (true, false),
    (false, true),
  ]) {
    testWidgets(
      'viewport drag settles before refitting, '
      'reduce=$disableAnimations, accessible=$accessibleNavigation',
      (tester) async {
        const bounds = Rect.fromLTWH(0, 0, 2000, 1000);
        final bloc = _Map();
        when(() => bloc.state).thenReturn(
          const MapState(status: .loaded, boundingRect: bounds),
        );
        addTearDown(bloc.close);
        final padding = ValueNotifier<EdgeInsets>(EdgeInsets.zero);
        addTearDown(padding.dispose);
        await tester.pumpApp(
          BlocProvider<MapBloc>.value(
            value: bloc,
            child: MediaQuery(
              data: MediaQueryData(
                disableAnimations: disableAnimations,
                accessibleNavigation: accessibleNavigation,
              ),
              child: SvgInteractiveMap(
                svgAssetPath: 'floor',
                svgContent: '<svg viewBox="0 0 2000 1000" />',
                showRoomLabels: true,
                viewportPaddingListenable: padding,
              ),
            ),
          ),
          size: const Size(320, 420),
        );
        await tester.pumpAndSettle();
        final viewport = tester.getSize(find.byType(SvgInteractiveMap));
        final camera = tester
            .widget<InteractiveViewer>(find.byType(InteractiveViewer))
            .transformationController!;
        final initial = List<double>.of(camera.value.storage);
        var changes = 0;
        void changed() => changes++;
        camera.addListener(changed);
        addTearDown(() => camera.removeListener(changed));
        for (final bottom in [150.0, 200.0, 250.0, 300.0, 340.0]) {
          await tester.pump(const Duration(milliseconds: 16));
          padding.value = EdgeInsets.only(bottom: bottom);
          tester.binding.scheduleFrame();
          await tester.pump();
          expect(changes, 0);
          expect(camera.value.storage, orderedEquals(initial));
        }
        await tester.pump(const Duration(milliseconds: 119));
        expect(changes, 0);
        await tester.pump(const Duration(milliseconds: 1));
        await tester.pumpAndSettle();
        final availableHeight = viewport.height - padding.value.bottom;
        final scale = availableHeight / bounds.height;
        expect(mapPlanarScale(camera.value), closeTo(scale, .000001));
        expect(
          camera.value[12],
          closeTo((viewport.width - bounds.width * scale) / 2, .000001),
        );
        expect(camera.value[13], closeTo(0, .000001));
        if (disableAnimations || accessibleNavigation) {
          expect(changes, 1);
        } else {
          expect(changes, greaterThan(1));
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('actual V78 paint surfaces remain bounded at maximum zoom', (
    tester,
  ) async {
    final document = (await tester.runAsync(
      () => rootBundle.loadString(
        'packages/app_ui/assets/maps/pulse/campus_v-78.json',
      ),
    ))!;
    final data = jsonDecode(document) as Map<String, dynamic>;
    final floor = (data['floors'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .firstWhere((floor) => floor['level'] == 1);
    final svg = floor['svg'] as String;
    final (rooms, bounds) = await SvgRoomParser(
      onLoadSvg: (_) async => svg,
    ).parseSvg('v78-first');
    final bloc = _Map();
    when(() => bloc.state).thenReturn(
      MapState(
        status: .loaded,
        rooms: rooms,
        boundingRect: bounds,
        svgContent: svg,
      ),
    );
    addTearDown(bloc.close);
    final point = rooms.first.path.getBounds().center;
    await tester.pumpApp(
      BlocProvider<MapBloc>.value(
        value: bloc,
        child: SvgInteractiveMap(
          svgAssetPath: 'v78-first',
          svgContent: svg,
          showRoomLabels: true,
          routeSegments: [
            [point, point + const Offset(100, 0)],
          ],
        ),
      ),
      size: const Size(320, 420),
    );
    await tester.pumpAndSettle();
    final viewport = tester.getSize(find.byType(SvgInteractiveMap));
    final viewer = tester.widget<InteractiveViewer>(
      find.byType(InteractiveViewer),
    );
    final camera = viewer.transformationController!;
    final canvas = tester.widget<MapFloorCanvas>(find.byType(MapFloorCanvas));
    expect(canvas.viewportSize, viewport);
    expect(
      find.ancestor(
        of: find.byType(MapFloorCanvas),
        matching: find.byType(InteractiveViewer),
      ),
      findsNothing,
    );
    expect(bounds.width, greaterThan(viewport.width));
    for (final scale in [mapPlanarScale(camera.value), 50.0]) {
      camera.value = Matrix4.identity()
        ..translateByDouble(
          viewport.width / 2 - point.dx * scale,
          viewport.height / 2 - point.dy * scale,
          0,
          1,
        )
        ..scaleByDouble(scale, scale, 1, 1);
      await tester.pump();
      final paints = find.descendant(
        of: find.byType(SvgInteractiveMap),
        matching: find.byType(CustomPaint),
      );
      expect(paints.evaluate().length, greaterThanOrEqualTo(5));
      final surfaces = [
        ...paints.evaluate(),
        ...find
            .descendant(
              of: find.byType(SvgInteractiveMap),
              matching: find.byType(RepaintBoundary),
            )
            .evaluate(),
      ];
      for (final surface in surfaces) {
        final size = (surface.renderObject! as RenderBox).size;
        expect(size.width, lessThanOrEqualTo(viewport.width));
        expect(size.height, lessThanOrEqualTo(viewport.height));
      }
      expect(tester.takeException(), isNull);
    }
  });
}

Future<_VolumeFixture> _pumpVolume(
  WidgetTester tester, {
  required bool reduced,
  required double bearing,
}) async {
  final fixture = _VolumeFixture();
  final bloc = _Map();
  when(() => bloc.state).thenReturn(
    MapState(
      status: .loaded,
      boundingRect: _VolumeFixture.bounds,
      rooms: [fixture.room],
    ),
  );
  addTearDown(bloc.close);
  addTearDown(fixture.padding.dispose);
  addTearDown(fixture.controller.dispose);
  await tester.pumpApp(
    BlocProvider<MapBloc>.value(
      value: bloc,
      child: MediaQuery(
        data: MediaQueryData(disableAnimations: reduced),
        child: SvgInteractiveMap(
          controller: fixture.controller,
          svgAssetPath: 'volume-floor',
          svgContent: '<svg viewBox="0 0 2000 1000" />',
          is3D: true,
          bearing: bearing,
          viewportPaddingListenable: fixture.padding,
          onRoomTap: fixture.tapped.add,
        ),
      ),
    ),
    size: const Size(320, 420),
  );
  await tester.pumpAndSettle();
  return fixture;
}

class _VolumeFixture {
  static const bounds = Rect.fromLTWH(0, 0, 2000, 1000);

  final room = RoomModel(
    roomId: 'room',
    path: Path()..addRect(const Rect.fromLTWH(970, 470, 60, 60)),
  );
  final padding = ValueNotifier<EdgeInsets>(EdgeInsets.zero);
  final controller = SvgInteractiveMapController();
  final tapped = <RoomModel>[];

  MapVolumeLayer layer(WidgetTester tester) =>
      tester.widget<MapVolumeLayer>(find.byType(MapVolumeLayer));

  MapVolumeProjection projection(WidgetTester tester) {
    final volume = layer(tester);
    return MapVolumeProjection(
      viewportSize: volume.viewportSize,
      transform: volume.transform.value,
      bearing: volume.bearing,
      pitch: volume.pitch,
      pivot: volume.pivot,
    );
  }

  Future<void> tapRoom(WidgetTester tester) async {
    final canvas = tester.renderObject<RenderBox>(find.byType(MapVolumeLayer));
    final point = projection(
      tester,
    ).sceneToScreen(room.path.getBounds().center);
    await tester.tapAt(canvas.localToGlobal(point));
    await tester.pump(kDoubleTapTimeout);
    await tester.pumpAndSettle();
  }

  void hitRoom(WidgetTester tester) {
    final canvas = tester.renderObject<RenderBox>(find.byType(MapVolumeLayer));
    final point = projection(
      tester,
    ).sceneToScreen(room.path.getBounds().center);
    final detector = tester.widget<GestureDetector>(
      find.ancestor(
        of: find.byType(MapVolumeLayer),
        matching: find.byType(GestureDetector),
      ),
    );
    detector.onTapUp!(
      TapUpDetails(
        localPosition: point,
        globalPosition: canvas.localToGlobal(point),
        kind: PointerDeviceKind.touch,
      ),
    );
  }
}
