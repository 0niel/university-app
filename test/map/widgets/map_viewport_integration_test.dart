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
