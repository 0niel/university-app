import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/widgets/svg_interactive_map.dart';
import 'package:rtu_mirea_app/map/widgets/svg_interactive_map_controller.dart';

import '../../helpers/pump_app.dart';

class _MockMapBloc extends MockBloc<MapEvent, MapState> implements MapBloc {}

void main() {
  for (final kind in [
    'entrance',
    'cafeteria',
    'medical',
    'library',
    'elevator',
    'stairs',
    'storage',
  ]) {
    testWidgets('overview $kind hit target matches the visible landmark', (
      tester,
    ) async {
      final bloc = _MockMapBloc();
      addTearDown(bloc.close);
      final room = RoomModel(
        roomId: 'landmark',
        name: 'Место',
        path: Path()..addRect(const Rect.fromLTWH(998, 498, 4, 4)),
      );
      when(() => bloc.state).thenReturn(
        MapState(
          status: .loaded,
          rooms: [room],
          boundingRect: const Rect.fromLTWH(0, 0, 2000, 1000),
        ),
      );
      RoomModel? selected;
      await tester.pumpApp(
        BlocProvider<MapBloc>.value(
          value: bloc,
          child: SvgInteractiveMap(
            svgAssetPath: 'landmark-test',
            svgContent: '<svg viewBox="0 0 2000 1000"/>',
            showRoomLabels: true,
            places: [
              MapPlaceData.fromJson({
                'id': 'landmark',
                'floor_id': 'one',
                'label': 'Место',
                'kind': kind,
                'x': 1000,
                'y': 500,
              }),
            ],
            onRoomTap: (room) => selected = room,
          ),
        ),
        size: const Size(320, 240),
      );
      await tester.pumpAndSettle();
      final viewerFinder = find.byType(InteractiveViewer);
      final viewer = tester.widget<InteractiveViewer>(viewerFinder);
      final matrix = viewer.transformationController!.value;
      final point = MatrixUtils.transformPoint(matrix, const Offset(1000, 500));
      expect(matrix.storage[0], lessThan(.2));
      await tester.tapAt(
        tester.getTopLeft(viewerFinder) + point + const Offset(12, 0),
      );
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(selected?.roomId, kind == 'storage' ? isNull : 'landmark');
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'published service relocation moves the hit target off its old polygon',
    (tester) async {
      final bloc = _MockMapBloc();
      addTearDown(bloc.close);
      final room = RoomModel(
        roomId: 'service',
        path: Path()..addRect(const Rect.fromLTWH(698, 498, 4, 4)),
      );
      final controller = SvgInteractiveMapController();
      addTearDown(controller.dispose);
      when(() => bloc.state).thenReturn(
        MapState(
          status: .loaded,
          rooms: [room],
          boundingRect: const Rect.fromLTWH(0, 0, 2000, 1000),
        ),
      );
      RoomModel? selected;
      await tester.pumpApp(
        BlocProvider<MapBloc>.value(
          value: bloc,
          child: SvgInteractiveMap(
            controller: controller,
            svgAssetPath: 'relocation-test',
            svgContent: '<svg viewBox="0 0 2000 1000"/>',
            showRoomLabels: true,
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
      final viewerFinder = find.byType(InteractiveViewer);
      final viewer = tester.widget<InteractiveViewer>(viewerFinder);
      final matrix = viewer.transformationController!.value;
      final origin = tester.getTopLeft(viewerFinder);
      await tester.tapAt(
        origin + MatrixUtils.transformPoint(matrix, const Offset(700, 500)),
      );
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(selected, isNull);
      await tester.tapAt(
        origin +
            MatrixUtils.transformPoint(matrix, const Offset(1300, 500)) +
            const Offset(12, 0),
      );
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(selected?.roomId, 'service');
      controller.focusRoom(room);
      await tester.pumpAndSettle();
      final focused = MatrixUtils.transformPoint(
        viewer.transformationController!.value,
        const Offset(1300, 500),
      );
      expect(focused.dx, closeTo(160, 1));
      expect(focused.dy, inInclusiveRange(90, 150));
      expect(room.path.getBounds(), const Rect.fromLTWH(698, 498, 4, 4));
      expect(tester.takeException(), isNull);
    },
  );
}
