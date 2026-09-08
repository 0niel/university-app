import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/navigation/indoor_navigation_graph.dart';
import 'package:rtu_mirea_app/map/services/map_label_hit_index.dart';
import 'package:rtu_mirea_app/map/services/map_navigation_landmarks.dart';
import 'package:rtu_mirea_app/map/widgets/map_cartographic_layer.dart';

void main() {
  testWidgets('hidden stairs do not steal the visible food marker hit target', (
    tester,
  ) async {
    final hitIndex = MapLabelHitIndex();
    final transform = TransformationController(
      Matrix4.identity()..scaleByDouble(.2, .2, 1, 1),
    );
    addTearDown(transform.dispose);
    final landmarks = mapNavigationLandmarks(
      IndoorNavigationGraph(
        nodes: const [
          IndoorNavigationNode(
            id: 'stairs',
            floorId: 'one',
            x: 100,
            y: 100,
            kind: 'stairs',
          ),
        ],
        edges: const [],
      ),
    );
    final food = MapPlaceData.fromJson({
      'id': 'food',
      'floor_id': 'one',
      'label': 'Столовая',
      'kind': 'cafeteria',
      'x': 100,
      'y': 100,
    });
    Future<void> render({required bool withFood}) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MapCartographicLayer(
            rooms: [
              if (withFood)
                RoomModel(
                  roomId: food.id,
                  path: Path()
                    ..addOval(
                      Rect.fromCircle(
                        center: const Offset(100, 100),
                        radius: 12,
                      ),
                    ),
                ),
            ],
            places: [if (withFood) food],
            syntheticRoomIds: const {'food'},
            navigationLandmarks: landmarks,
            size: const Size(200, 200),
            transform: transform,
            hitIndex: hitIndex,
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await render(withFood: true);
    expect(hitIndex.bounds.keys, ['food']);
    expect(hitIndex.hitTest(const Offset(100, 100)), 'food');
    expect(hitIndex.bounds['food']!.width, greaterThan(120));
    expect(hitIndex.hitTest(hitIndex.bounds['food']!.bottomRight), isNull);

    await render(withFood: false);
    expect(hitIndex.bounds.keys, [landmarks.single.place.id]);
    expect(hitIndex.hitTest(const Offset(100, 100)), landmarks.single.place.id);

    await tester.pumpWidget(const SizedBox.shrink());
    expect(hitIndex.hitTest(const Offset(100, 100)), isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('graph stairs render without inventing a room polygon', (
    tester,
  ) async {
    final landmarks = mapNavigationLandmarks(
      IndoorNavigationGraph(
        nodes: const [
          IndoorNavigationNode(
            id: 'stairs',
            floorId: 'one',
            x: 100,
            y: 100,
            kind: 'stairs',
            closed: true,
          ),
        ],
        edges: const [],
      ),
    );
    final boundaryKey = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: RepaintBoundary(
          key: boundaryKey,
          child: ColoredBox(
            color: Colors.white,
            child: MapCartographicLayer(
              rooms: const [],
              places: const [],
              size: const Size(200, 200),
              navigationLandmarks: landmarks,
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
    final bytes = (await tester.runAsync(image.toByteData))!;
    final pixels = bytes.buffer.asUint8List();
    var coloredPixels = 0;
    for (var y = 80; y < 120; y++) {
      for (var x = 80; x < 120; x++) {
        final offset = (y * image.width + x) * 4;
        if (pixels[offset] < 220 ||
            pixels[offset + 1] < 220 ||
            pixels[offset + 2] < 220) {
          coloredPixels++;
        }
      }
    }
    final outside = (100 * image.width + 130) * 4;
    expect(pixels.sublist(outside, outside + 3), [255, 255, 255]);
    image.dispose();
    expect(coloredPixels, greaterThan(20));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a service keeps its icon when its caption cannot fit', (
    tester,
  ) async {
    final boundaryKey = GlobalKey();
    final places = [
      MapPlaceData.fromJson({
        'id': 'entrance',
        'floor_id': 'one',
        'label': '',
        'kind': 'entrance',
        'x': 100,
        'y': 100,
      }),
      MapPlaceData.fromJson({
        'id': 'food',
        'floor_id': 'one',
        'label': 'Столовая университета',
        'kind': 'cafeteria',
        'x': 140,
        'y': 100,
      }),
    ];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: RepaintBoundary(
          key: boundaryKey,
          child: MapCartographicLayer(
            rooms: [
              for (final place in places)
                RoomModel(
                  roomId: place.id,
                  path: Path()..addRect(const Rect.fromLTWH(0, 0, 200, 200)),
                ),
            ],
            places: places,
            size: const Size(250, 200),
            syntheticRoomIds: const {'entrance', 'food'},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final boundary =
        boundaryKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
    final image = (await tester.runAsync(boundary.toImage))!;
    final bytes = (await tester.runAsync(image.toByteData))!;
    final pixels = bytes.buffer.asUint8List();
    var orangePixels = 0;
    for (var y = 85; y < 115; y++) {
      for (var x = 125; x < 155; x++) {
        final offset = (y * image.width + x) * 4;
        if (pixels[offset] > 140 &&
            pixels[offset + 1] > 60 &&
            pixels[offset + 1] < 180 &&
            pixels[offset + 2] < 60) {
          orangePixels++;
        }
      }
    }
    image.dispose();
    expect(orangePixels, greaterThan(15));
    expect(tester.takeException(), isNull);
  });

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
