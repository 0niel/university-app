import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/navigation/indoor_navigation_graph.dart';
import 'package:rtu_mirea_app/map/services/map_navigation_landmarks.dart';
import 'package:rtu_mirea_app/map/services/svg_room_parser.dart';
import 'package:rtu_mirea_app/map/widgets/map_cartographic_layer.dart';
import 'package:rtu_mirea_app/map/widgets/map_structure_layer.dart';

void main() {
  for (final scale in [.15, 1.0, 8.0, 30.0]) {
    testWidgets(
      'room border has no halo and stays one pixel at zoom $scale',
      (tester) async {
        final transform = TransformationController(
          Matrix4.identity()
            ..translateByDouble(80, 40, 0, 1)
            ..scaleByDouble(scale, scale, 1, 1),
        );
        addTearDown(transform.dispose);
        final image = await _render(
          tester,
          transform,
          (transform) => MapCartographicLayer(
            rooms: [
              RoomModel(
                roomId: 'room',
                path: Path()..addRect(const Rect.fromLTWH(0, 0, 1000, 1000)),
              ),
            ],
            places: const [],
            size: const Size(2000, 1000),
            transform: transform,
          ),
        );
        expect(
          [for (var x = 0; x < 79; x++) image.at(x, 100)].every(
            (pixel) => pixel.$1 > 250 && pixel.$2 > 250 && pixel.$3 > 250,
          ),
          isTrue,
          reason: 'Room shadows must not paint outside the boundary',
        );
        final interior = image.at(140, 100);
        final outlinePixels = [
          for (var x = 80; x < 120; x++) image.at(x, 100),
        ].where((pixel) => _difference(pixel, interior) > 8).length;
        expect(outlinePixels, lessThanOrEqualTo(2));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'transformed structural strokes stay thin at zoom $scale',
      (tester) async {
        const svg =
            '<svg viewBox="0 0 2000 1000"> '
            '<g transform="translate(10 20) scale(2)"> '
            '<path fill="none" stroke="black" stroke-width="45" '
            'd="M0 0H500V500H0Z"/></g></svg>';
        final transform = TransformationController(
          Matrix4.identity()
            ..translateByDouble(80 - 10 * scale, 40 - 20 * scale, 0, 1)
            ..scaleByDouble(scale, scale, 1, 1),
        );
        addTearDown(transform.dispose);
        final image = await _render(
          tester,
          transform,
          (transform) => MapStructureLayer(
            svg: svg,
            size: const Size(2000, 1000),
            transform: transform,
          ),
        );
        final darkPixels = [
          for (var x = 60; x < 101; x++) image.at(x, 100),
        ].where((pixel) => pixel.$1 + pixel.$2 + pixel.$3 < 740).length;
        expect(darkPixels, inInclusiveRange(1, 2));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('door opening strokes stay thin at zoom $scale', (
      tester,
    ) async {
      const svg =
          '<svg viewBox="0 0 2000 1000"> '
          '<g transform="translate(10 20) scale(2)"> '
          '<line stroke="white" stroke-width="90" '
          'x1="0" y1="0" x2="0" y2="500"/></g></svg>';
      final transform = TransformationController(
        Matrix4.identity()
          ..translateByDouble(80 - 10 * scale, 40 - 20 * scale, 0, 1)
          ..scaleByDouble(scale, scale, 1, 1),
      );
      addTearDown(transform.dispose);
      final image = await _render(
        tester,
        transform,
        (transform) => MapStructureLayer(
          svg: svg,
          size: const Size(2000, 1000),
          transform: transform,
          openingsOnly: true,
        ),
        background: Colors.black,
      );
      final openingPixels = [
        for (var x = 60; x < 101; x++) image.at(x, 100),
      ].where((pixel) => pixel.$1 + pixel.$2 + pixel.$3 > 30).length;
      expect(openingPixels, inInclusiveRange(1, 2));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('a service without room geometry remains a marker at 30x', (
    tester,
  ) async {
    final transform = TransformationController(
      Matrix4.identity()
        ..translateByDouble(-2800, -2880, 0, 1)
        ..scaleByDouble(30, 30, 1, 1),
    );
    addTearDown(transform.dispose);
    final image = await _render(
      tester,
      transform,
      (transform) => MapCartographicLayer(
        rooms: [
          RoomModel(
            roomId: 'water',
            path: Path()
              ..addOval(
                Rect.fromCircle(center: const Offset(100, 100), radius: 12),
              ),
          ),
        ],
        places: [
          MapPlaceData.fromJson({
            'id': 'water',
            'floor_id': 'one',
            'label': 'Вода',
            'kind': 'water',
            'x': 100,
            'y': 100,
          }),
        ],
        size: const Size(2000, 1000),
        transform: transform,
        syntheticRoomIds: const {'water'},
      ),
    );
    expect(image.at(300, 120), (255, 255, 255));
    expect(image.at(100, 120), (255, 255, 255));
    final markerPixels =
        [
          for (var y = 95; y < 145; y++)
            for (var x = 180; x < 220; x++) image.at(x, y),
        ].where(
          (pixel) =>
              pixel.$1 < 120 &&
              pixel.$2 > pixel.$1 * 1.5 &&
              pixel.$2 > pixel.$3 * 1.2,
        );
    expect(markerPixels.length, greaterThan(15));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'published service location moves its marker without moving walls',
    (tester) async {
      final transform = TransformationController();
      addTearDown(transform.dispose);
      final room = RoomModel(
        roomId: 'water',
        path: Path()..addRect(const Rect.fromLTWH(40, 50, 60, 80)),
      );
      MapPlaceData place(double x, double y) => MapPlaceData.fromJson({
        'id': 'water',
        'floor_id': 'one',
        'label': 'Вода',
        'kind': 'water',
        'x': x,
        'y': y,
      });
      Future<_Image> render(MapPlaceData? place) => _render(
        tester,
        transform,
        (transform) => MapCartographicLayer(
          rooms: [room],
          places: [?place],
          size: const Size(2000, 1000),
          transform: transform,
        ),
      );
      final before = await render(place(70, 90));
      final after = await render(place(250, 120));
      final source = await render(null);
      int greenPixels(_Image image, Rect area) {
        var count = 0;
        for (var y = area.top.round(); y < area.bottom; y++) {
          for (var x = area.left.round(); x < area.right; x++) {
            final (r, g, b) = image.at(x, y);
            if (r < 120 && g > r * 1.5 && g > b * 1.2) count++;
          }
        }
        return count;
      }

      const oldArea = Rect.fromLTWH(45, 65, 50, 50);
      const newArea = Rect.fromLTWH(225, 95, 50, 50);
      expect(greenPixels(before, oldArea), greaterThan(15));
      expect(greenPixels(after, oldArea), 0);
      expect(greenPixels(after, newArea), greaterThan(15));
      expect(after.at(40, 60), source.at(40, 60));
      expect(after.at(50, 60), source.at(50, 60));
      expect(after.at(200, 60), (255, 255, 255));
      expect(room.path.getBounds(), const Rect.fromLTWH(40, 50, 60, 80));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('V-78 E-206 rooms retain native outlines at 8x and 30x', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final font = FontLoader(AppText.sansFamily)
        ..addFont(
          rootBundle.load(
            'packages/app_ui/assets/fonts/Onest/Onest-SemiBold.ttf',
          ),
        );
      await font.load();
      await (FontLoader(
        'MaterialIcons',
      )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    });
    final source = (await tester.runAsync(
      () => rootBundle.loadString(
        'packages/app_ui/assets/maps/pulse/campus_v-78.json',
      ),
    ))!;
    final data = jsonDecode(source) as Map<String, dynamic>;
    final floor = (data['floors'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .firstWhere((floor) => floor['level'] == 2);
    final svg = floor['svg'] as String;
    final parsed = await SvgRoomParser(
      onLoadSvg: (_) async => svg,
    ).parseSvg('f2');
    final first = parsed.$1.firstWhere((room) => room.name == 'Е-206.1');
    final second = parsed.$1.firstWhere((room) => room.name == 'Е-206.2');
    final overlap = Path.combine(
      PathOperation.intersect,
      first.path,
      second.path,
    ).getBounds();
    expect(overlap.width * overlap.height, lessThan(.0001));
    final layers = MapStructureLayers.fromSvg(svg);
    expect(layers.foundationShapes.length, greaterThan(50));
    expect(layers.openingShapes, hasLength(423));
    expect(
      layers.foundationShapes
          .where((shape) => shape.path.fillType == PathFillType.evenOdd)
          .length,
      layers.foundationShapes.length,
    );
    for (final scale in [8.0, 30.0]) {
      final bounds = first.path.getBounds();
      final center =
          (scale == 8
                  ? bounds.expandToInclude(second.path.getBounds())
                  : bounds.intersect(second.path.getBounds()))
              .center;
      final transform = TransformationController(
        Matrix4.identity()
          ..translateByDouble(
            200 - center.dx * scale,
            120 - center.dy * scale,
            0,
            1,
          )
          ..scaleByDouble(scale, scale, 1, 1),
      );
      addTearDown(transform.dispose);
      for (final dark in [false, true]) {
        await _render(
          tester,
          transform,
          (transform) => MapCartographicLayer(
            rooms: parsed.$1,
            places: const [],
            size: parsed.$2.size,
            svgContent: svg,
            transform: transform,
          ),
          dark: dark,
          file: 'v78-e206-${dark ? 'dark' : 'light'}-${scale.round()}x.png',
        );
        expect(identical(layers, MapStructureLayers.fromSvg(svg)), isTrue);
        expect(tester.takeException(), isNull);
      }
    }
  });
  testWidgets('V-86 overview retains the entrance and cafeteria landmarks', (
    tester,
  ) async {
    final source = (await tester.runAsync(
      () => rootBundle.loadString(
        'packages/app_ui/assets/maps/pulse/campus_v-86.json',
      ),
    ))!;
    final data = jsonDecode(source) as Map<String, dynamic>;
    final floor = (data['floors'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .firstWhere((floor) => floor['level'] == 1);
    final svg = floor['svg'] as String;
    final parsed = await SvgRoomParser(
      onLoadSvg: (_) async => svg,
    ).parseSvg('v86-f1');
    final places = mapJsonRows(data['rooms'])
        .where((room) => room['floor_id'] == floor['id'])
        .map(MapPlaceData.fromJson)
        .toList();
    final navigationLandmarks = mapNavigationLandmarks(
      IndoorNavigationGraph.fromJson(data['graph'] as Map<String, dynamic>),
      places: places,
    ).where((landmark) => landmark.place.floorId == floor['id']).toList();
    expect(navigationLandmarks, isNotEmpty);
    expect(places.where((place) => place.kind == 'entrance'), hasLength(1));
    expect(places.where((place) => place.kind == 'cafeteria'), hasLength(1));
    final transform = TransformationController(
      Matrix4.identity()
        ..translateByDouble(50, 17, 0, 1)
        ..scaleByDouble(.15, .15, 1, 1),
    );
    addTearDown(transform.dispose);
    for (final dark in [false, true]) {
      final image = await _render(
        tester,
        transform,
        (transform) => MapCartographicLayer(
          rooms: parsed.$1,
          places: places,
          navigationLandmarks: navigationLandmarks,
          size: parsed.$2.size,
          svgContent: svg,
          transform: transform,
        ),
        childSize: parsed.$2.size,
        dark: dark,
        file: 'v86-overview-${dark ? 'dark' : 'light'}.png',
      );
      if (!dark) {
        var entrancePixels = 0;
        var cafeteriaPixels = 0;
        for (var y = 0; y < 240; y++) {
          for (var x = 0; x < 400; x++) {
            final (r, g, b) = image.at(x, y);
            if (r < 120 && g > r * 1.5 && g > b * 1.2) entrancePixels++;
            if (r > 140 && g > 60 && g < 180 && b < 60) cafeteriaPixels++;
          }
        }
        expect(entrancePixels, greaterThan(15));
        expect(cafeteriaPixels, greaterThan(15));
      }
      expect(tester.takeException(), isNull);
    }
  });
}

int _difference((int, int, int) a, (int, int, int) b) =>
    (a.$1 - b.$1).abs() + (a.$2 - b.$2).abs() + (a.$3 - b.$3).abs();

class _Image {
  const _Image(this.pixels, this.width);
  final Uint8List pixels;
  final int width;
  (int, int, int) at(int x, int y) {
    final index = (y * width + x) * 4;
    return (pixels[index], pixels[index + 1], pixels[index + 2]);
  }
}

Future<_Image> _render(
  WidgetTester tester,
  TransformationController transform,
  Widget Function(TransformationController) child, {
  Color background = Colors.white,
  bool dark = false,
  String? file,
  Size childSize = const Size(2000, 1000),
}) async {
  final boundaryKey = GlobalKey();
  tester.view.physicalSize = const Size(400, 240);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: RepaintBoundary(
        key: boundaryKey,
        child: ColoredBox(
          color: dark ? const Color(0xff181a1e) : background,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                width: childSize.width,
                height: childSize.height,
                child: Transform(
                  transform: transform.value,
                  child: child(transform),
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
      boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final image = (await tester.runAsync(boundary.toImage))!;
  final bytes = (await tester.runAsync(image.toByteData))!;
  if (file != null && const bool.fromEnvironment('MAP_RENDER_PREVIEWS')) {
    final png = (await tester.runAsync(
      () => image.toByteData(
        format: ui.ImageByteFormat.png,
      ),
    ))!;
    await tester.runAsync(() async {
      final directory = Directory('output/campus-map/previews')
        ..createSync(recursive: true);
      await File(
        '${directory.path}/$file',
      ).writeAsBytes(png.buffer.asUint8List());
    });
  }
  final result = _Image(bytes.buffer.asUint8List(), image.width);
  image.dispose();
  return result;
}
