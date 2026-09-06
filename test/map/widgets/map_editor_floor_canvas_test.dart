import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/widgets/map_graph_editor_page.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      'editor ${dark ? 'dark' : 'light'} canvas preserves strokes '
      'and coordinates through zoom',
      (tester) async {
        var loads = 0;
        final repository = MapDataRepository(
          organizationId: 'mirea',
          rpc: (_, _) async =>
              throw StateError('Rendering cannot write map data'),
          assetLoader: (_) async {
            loads++;
            return '<svg viewBox="0 0 1000 500"> '
                '<g data-object="room" data-name="101"> '
                '<rect x="200" y="100" width="500" height="300" stroke="black" stroke-width="40"/> '
                '</g></svg>';
          },
        );
        addTearDown(repository.dispose);
        final floor = MapFloorData.fromJson({
          'id': 'one',
          'level': 1,
          'width': 1000,
          'height': 500,
        }, svgPath: 'editor.svg');
        final boundaryKey = GlobalKey();
        Offset? tapped;
        double? radius;
        tester.view.physicalSize = const Size(400, 240);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            home: RepaintBoundary(
              key: boundaryKey,
              child: MapEditorFloorCanvas(
                floor: floor,
                repository: repository,
                places: [
                  MapPlaceData.fromJson({
                    'id': 'room',
                    'floor_id': 'one',
                    'kind': 'room',
                    'label': '101',
                    'x': 450,
                    'y': 250,
                  }),
                ],
                painter: _ProbePainter(),
                onTap: (point, hitRadius) {
                  tapped = point;
                  radius = hitRadius;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final viewer = tester.widget<InteractiveViewer>(
          find.byType(InteractiveViewer),
        );
        for (final zoom in [1.0, 16.0]) {
          viewer.transformationController!.value = Matrix4.identity()
            ..translateByDouble(80 - 80 * zoom, 50 - 60 * zoom, 0, 1)
            ..scaleByDouble(zoom, zoom, 1, 1);
          await tester.pumpAndSettle();
          final boundary =
              boundaryKey.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
          final image = (await tester.runAsync(boundary.toImage))!;
          final bytes = (await tester.runAsync(
            image.toByteData,
          ))!.buffer.asUint8List();
          (int, int, int) pixel(int x, int y) {
            final i = (y * image.width + x) * 4;
            return (bytes[i], bytes[i + 1], bytes[i + 2]);
          }

          final background = dark
              ? AppColors.mapCanvasDark
              : AppColors.mapCanvasLight;
          final argb = background.toARGB32();
          expect(pixel(20, 20), (
            (argb >> 16) & 255,
            (argb >> 8) & 255,
            argb & 255,
          ));
          final interior = pixel(84, 100);
          final border = [for (var x = 80; x < 84; x++) pixel(x, 100)].where(
            (p) =>
                (p.$1 - interior.$1).abs() +
                    (p.$2 - interior.$2).abs() +
                    (p.$3 - interior.$3).abs() >
                15,
          );
          expect(border.length, inInclusiveRange(1, 2));
          final lineX = (80 + 8 * zoom).round();
          final linePixels = [
            for (var x = lineX - 6; x <= lineX + 6; x++) pixel(x, 100),
          ].where((p) => p.$1 > 200 && p.$2 < 100 && p.$3 < 100).length;
          expect(linePixels, inInclusiveRange(2, 4));
          final circleX = (80 + 12 * zoom).round();
          final circleY = (50 + 4 * zoom).round();
          final circlePixels = [
            for (var x = circleX - 9; x <= circleX + 9; x++) pixel(x, circleY),
          ].where((p) => p.$1 > 200 && p.$2 < 100 && p.$3 < 100).length;
          expect(circlePixels, inInclusiveRange(8, 12));
          image.dispose();
          await tester.tapAt(Offset(80 + 4 * zoom, 50 + 8 * zoom));
          await tester.pumpAndSettle();
          expect(tapped!.dx, closeTo(210, .001));
          expect(tapped!.dy, closeTo(120, .001));
          expect(radius, closeTo(20 / (.4 * zoom), .001));
          expect(tester.takeException(), isNull);
        }
        expect(loads, 1);
      },
    );
  }
}

class _ProbePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..drawLine(
        Offset(size.width * .22, size.height * .2),
        Offset(size.width * .22, size.height * .8),
        Paint()
          ..color = Colors.red
          ..strokeWidth = 2.5,
      )
      ..drawCircle(
        Offset(size.width * .23, size.height * .22),
        5,
        Paint()..color = Colors.red,
      );
  }

  @override
  bool shouldRepaint(_ProbePainter oldDelegate) => false;
}
