import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/services/map_planar_scale.dart';
import 'package:rtu_mirea_app/map/services/svg_room_parser.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_canvas.dart';
import 'package:rtu_mirea_app/map/widgets/svg_interactive_map.dart';

import '../../helpers/pump_app.dart';

class _Map extends MockBloc<MapEvent, MapState> implements MapBloc {}

void main() {
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
