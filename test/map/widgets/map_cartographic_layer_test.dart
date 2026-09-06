import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/widgets/map_cartographic_layer.dart';

void main() {
  testWidgets('room labels retain screen size while zooming out below one', (
    tester,
  ) async {
    final transform = TransformationController();
    addTearDown(transform.dispose);
    final room = RoomModel(
      roomId: 'room',
      name: '101',
      path: Path()..addRect(const Rect.fromLTWH(0, 0, 1000, 1000)),
    );
    final boundaryKey = GlobalKey();
    final measurements = <Size>[];
    for (final scale in [.7, .2]) {
      transform.value = Matrix4.identity()..scaleByDouble(scale, scale, 1, 1);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: RepaintBoundary(
            key: boundaryKey,
            child: ColoredBox(
              color: Colors.white,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    width: 1000,
                    height: 1000,
                    child: Transform(
                      transform: transform.value,
                      child: MapCartographicLayer(
                        rooms: [room],
                        places: const [],
                        size: const Size(1000, 1000),
                        transform: transform,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final boundary =
          boundaryKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      final image = (await tester.runAsync(boundary.toImage))!;
      final bytes = (await tester.runAsync(
        image.toByteData,
      ))!;
      final pixels = bytes.buffer.asUint8List();
      var left = image.width;
      var right = -1;
      var top = image.height;
      var bottom = -1;
      final center = (500 * scale).round();
      for (var y = center - 30; y < center + 30; y++) {
        for (var x = center - 50; x < center + 50; x++) {
          final offset = (y * image.width + x) * 4;
          if (pixels[offset] < 80 &&
              pixels[offset + 1] < 80 &&
              pixels[offset + 2] < 80 &&
              pixels[offset + 3] > 200) {
            if (x < left) left = x;
            if (x > right) right = x;
            if (y < top) top = y;
            if (y > bottom) bottom = y;
          }
        }
      }
      image.dispose();
      measurements.add(
        Size((right - left + 1).toDouble(), (bottom - top + 1).toDouble()),
      );
    }
    expect(measurements.last.height, greaterThanOrEqualTo(8));
    expect(
      (measurements.first.height - measurements.last.height).abs(),
      lessThanOrEqualTo(2),
    );
    expect(
      (measurements.first.width - measurements.last.width).abs(),
      lessThanOrEqualTo(4),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('new service remains visible at an overview scale', (
    tester,
  ) async {
    final transform = TransformationController(
      Matrix4.identity()..scaleByDouble(.15, .15, 1, 1),
    );
    addTearDown(transform.dispose);
    final place = MapPlaceData.fromJson({
      'id': 'new',
      'floor_id': 'one',
      'label': 'Вода',
      'kind': 'water',
      'x': 100,
      'y': 100,
    });
    final boundaryKey = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: RepaintBoundary(
          key: boundaryKey,
          child: MapCartographicLayer(
            rooms: [
              RoomModel(
                roomId: 'new',
                path: Path()
                  ..addOval(
                    Rect.fromCircle(center: const Offset(100, 100), radius: 12),
                  ),
              ),
            ],
            places: [place],
            size: const Size(200, 200),
            transform: transform,
            syntheticRoomIds: const {'new'},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final boundary =
        boundaryKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
    final image = (await tester.runAsync(boundary.toImage))!;
    final bytes = (await tester.runAsync(
      image.toByteData,
    ))!;
    final pixels = bytes.buffer.asUint8List();
    var greenPixels = 0;
    for (var i = 0; i < pixels.length; i += 4) {
      if (pixels[i] < 80 &&
          pixels[i + 1] > pixels[i] * 1.5 &&
          pixels[i + 3] > 200) {
        greenPixels++;
      }
    }
    image.dispose();
    expect(greenPixels, greaterThan(20));
    expect(tester.takeException(), isNull);
  });
}
