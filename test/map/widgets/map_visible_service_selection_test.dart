import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/map_volume_projection.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_canvas.dart';
import 'package:rtu_mirea_app/map/widgets/map_volume_layer.dart';
import 'package:rtu_mirea_app/map/widgets/svg_interactive_map.dart';

import '../../helpers/pump_app.dart';

class _MapBloc extends MockBloc<MapEvent, MapState> implements MapBloc {}

Future<void> _tap(WidgetTester tester, Offset point) async {
  await tester.tapAt(point);
  await tester.pump(const Duration(milliseconds: 350));
  await tester.pumpAndSettle();
}

void main() {
  for (final synthetic in [true, false]) {
    testWidgets(
      'hidden ${synthetic ? 'synthetic' : 'relocated'} service '
      'does not intercept auditorium taps',
      (tester) async {
        final bloc = _MapBloc();
        addTearDown(bloc.close);
        final auditorium = RoomModel(
          roomId: 'auditorium',
          name: '101',
          path: Path()..addRect(const Rect.fromLTWH(500, 200, 1000, 600)),
        );
        final service = RoomModel(
          roomId: 'service',
          name: 'Гардероб',
          path: Path()..addRect(const Rect.fromLTWH(1248, 498, 4, 4)),
        );
        final entrance = RoomModel(
          roomId: 'entrance',
          path: Path()..addRect(const Rect.fromLTWH(1398, 498, 4, 4)),
        );
        when(() => bloc.state).thenReturn(
          MapState(
            status: .loaded,
            rooms: [auditorium, service, entrance],
            boundingRect: const Rect.fromLTWH(0, 0, 2000, 1000),
          ),
        );
        RoomModel? selected;
        await tester.pumpApp(
          BlocProvider<MapBloc>.value(
            value: bloc,
            child: SvgInteractiveMap(
              svgAssetPath: 'hidden-service',
              svgContent: '<svg viewBox="0 0 2000 1000"/>',
              showRoomLabels: true,
              syntheticRoomIds: synthetic ? {'service'} : {},
              places: [
                MapPlaceData.fromJson({
                  'id': 'entrance',
                  'floor_id': 'one',
                  'kind': 'entrance',
                  'label': '',
                  'x': 1400,
                  'y': 500,
                }),
                MapPlaceData.fromJson({
                  'id': 'service',
                  'floor_id': 'one',
                  'kind': 'storage',
                  'label': 'Гардероб',
                  'x': 1250,
                  'y': synthetic ? 500 : 510,
                }),
              ],
              onRoomTap: (room) => selected = room,
            ),
          ),
          size: const Size(320, 240),
        );
        await tester.pumpAndSettle();
        final canvas = tester.widget<MapFloorCanvas>(
          find.byType(MapFloorCanvas),
        );
        expect(canvas.labelHitIndex!.bounds, isNot(contains('service')));
        const point = Offset(1250, 500);
        expect(canvas.labelHitIndex!.hitTest(point), isNull);
        await _tap(
          tester,
          tester.getTopLeft(find.byType(SvgInteractiveMap)) +
              MatrixUtils.transformPoint(canvas.transform!.value, point),
        );
        expect(selected?.roomId, 'auditorium');
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('rotated 3D service uses its visible screen bounds', (
    tester,
  ) async {
    final bloc = _MapBloc();
    addTearDown(bloc.close);
    final service = RoomModel(
      roomId: 'service',
      name: 'Банкомат',
      path: Path()..addRect(const Rect.fromLTWH(698, 498, 4, 4)),
    );
    when(() => bloc.state).thenReturn(
      MapState(
        status: .loaded,
        rooms: [service],
        boundingRect: const Rect.fromLTWH(0, 0, 2000, 1000),
      ),
    );
    RoomModel? selected;
    await tester.pumpApp(
      BlocProvider<MapBloc>.value(
        value: bloc,
        child: SvgInteractiveMap(
          svgAssetPath: 'rotated-service',
          svgContent: '<svg viewBox="0 0 2000 1000"/>',
          is3D: true,
          bearing: 1.1,
          places: [
            MapPlaceData.fromJson({
              'id': 'service',
              'floor_id': 'one',
              'kind': 'atm',
              'label': 'Банкомат',
              'x': 1300,
              'y': 500,
            }),
          ],
          onRoomTap: (room) => selected = room,
        ),
      ),
      size: const Size(320, 240),
    );
    await tester.pumpAndSettle();
    final layer = tester.widget<MapVolumeLayer>(find.byType(MapVolumeLayer));
    final projection = MapVolumeProjection(
      viewportSize: layer.viewportSize,
      transform: layer.transform.value,
      bearing: layer.bearing,
      pitch: layer.pitch,
      pivot: layer.pivot,
    );
    final origin = tester.getTopLeft(find.byType(SvgInteractiveMap));
    final oldPoint = projection.sceneToScreen(const Offset(700, 500));
    expect(layer.hitIndex!.hitTest(oldPoint), isNull);
    await _tap(tester, origin + oldPoint);
    expect(selected, isNull);
    final bounds = layer.hitIndex!.bounds['service'];
    expect(bounds, isNotNull);
    final markerPoint = Offset(bounds!.right - 5, bounds.center.dy);
    expect(
      service.path.contains(projection.screenToScene(markerPoint)),
      isFalse,
    );
    await _tap(tester, origin + markerPoint);
    expect(selected?.roomId, 'service');
    expect(tester.takeException(), isNull);
  });
}
