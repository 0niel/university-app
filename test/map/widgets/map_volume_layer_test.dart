import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/map_label_hit_index.dart';
import 'package:rtu_mirea_app/map/services/map_volume_mesh.dart';
import 'package:rtu_mirea_app/map/services/map_volume_projection.dart';
import 'package:rtu_mirea_app/map/widgets/map_structure_layer.dart';
import 'package:rtu_mirea_app/map/widgets/map_volume_layer.dart';

import '../../gallery/gallery_fonts.dart';

void main() {
  setUpAll(loadGalleryFonts);
  test(
    'ground projection round trips rotation, pitch, pan and off-centre pivot',
    () {
      for (final bearing in [0.0, math.pi / 3, -math.pi / 2]) {
        for (final pitch in [0.0, .85, 1.2]) {
          final projection = MapVolumeProjection(
            viewportSize: const Size(320, 640),
            transform: Matrix4.identity()
              ..translateByDouble(70, -120, 0, 1)
              ..scaleByDouble(.025, .025, 1, 1),
            bearing: bearing,
            pitch: pitch,
            pivot: const Offset(160, 210),
          );
          const point = Offset(4900, 7300);
          final screen = projection.sceneToScreen(point);
          expect(
            (projection.screenToScene(screen) - point).distance,
            lessThan(1e-8),
          );
          const delta = Offset(27, -43);
          final moved = projection.sceneToScreen(
            point + projection.screenDeltaToScene(delta),
          );
          expect((moved - screen - delta).distance, lessThan(1e-8));
          expect(
            projection.visibleSceneBounds.contains(
              projection.screenToScene(const Offset(160, 320)),
            ),
            isTrue,
          );
        }
      }
    },
  );

  test(
    'height changes true projected z without changing the ground hit point',
    () {
      final projection = MapVolumeProjection(
        viewportSize: const Size(200, 200),
        transform: Matrix4.diagonal3Values(2, 2, 1),
      );
      const ground = Offset(60, 80);
      final base = projection.sceneToScreen(ground);
      final top = projection.sceneToScreen(ground, height: 10);
      expect(top.dx, base.dx);
      expect(base.dy - top.dy, closeTo(20 * math.sin(.85), 1e-8));
      expect(
        (projection.screenToScene(base) - ground).distance,
        lessThan(1e-8),
      );
    },
  );

  test('singular and nonfinite cameras use a safe ground transform', () {
    for (final camera in [
      Matrix4.zero(),
      Matrix4.diagonal3Values(double.nan, 1, 1),
    ]) {
      final projection = MapVolumeProjection(
        viewportSize: const Size(200, 200),
        transform: camera,
      );
      const point = Offset(30, 50);
      expect(
        (projection.screenToScene(projection.sceneToScreen(point)) - point)
            .distance,
        lessThan(1e-8),
      );
    }
  });

  test('wall extrusion keeps source doorways open', () {
    final mesh = MapVolumeMesh.fromLayers(
      _layers('''
      <path d="M20 100 H180" fill="none" stroke="black"/>
      <line x1="80" y1="100" x2="120" y2="100" stroke="white"/>
    '''),
      floorSize: const Size(1000, 1000),
    );
    expect(mesh.walls, hasLength(2));
    expect(mesh.walls.first.start.dx, closeTo(20, .1));
    expect(mesh.walls.first.end.dx, closeTo(80, .1));
    expect(mesh.walls.last.start.dx, closeTo(120, .1));
    expect(mesh.walls.last.end.dx, closeTo(180, .1));
  });

  test('extruded walls obey clipping regions including inner holes', () {
    final mesh = MapVolumeMesh.fromLayers(
      _layers('''
      <defs><clipPath id="cut"><path clip-rule="evenodd"
        d="M10 20H90V80H10Z M40 30H60V70H40Z"/></clipPath></defs>
      <path d="M0 50H100" fill="none" stroke="black" clip-path="url(#cut)"/>
    '''),
      floorSize: const Size(1000, 1000),
    );
    expect(mesh.walls, hasLength(2));
    for (final wall in mesh.walls) {
      expect(math.min(wall.start.dx, wall.end.dx), greaterThanOrEqualTo(9.9));
      expect(math.max(wall.start.dx, wall.end.dx), lessThanOrEqualTo(90.1));
      expect(wall.bounds.contains(const Offset(50, 50)), isFalse);
    }
  });

  test('curve tessellation and geometry memory have a hard edge budget', () {
    final mesh = MapVolumeMesh.fromLayers(
      _layers('''
      <circle cx="100" cy="100" r="80" fill="none" stroke="black"/>
    '''),
      floorSize: const Size(1000, 1000),
      maximumEdges: 12,
    );
    expect(mesh.walls.length, lessThanOrEqualTo(12));
    expect(mesh.truncated, isTrue);
    expect(
      mesh.walls.every((wall) => wall.start.isFinite && wall.end.isFinite),
      isTrue,
    );
  });

  testWidgets('3D paints elevated wall faces while retaining the door gap', (
    tester,
  ) async {
    final transform = TransformationController();
    addTearDown(transform.dispose);
    final boundaryKey = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Align(
          alignment: Alignment.topLeft,
          child: RepaintBoundary(
            key: boundaryKey,
            child: MapVolumeLayer(
              floorSize: const Size(1000, 1000),
              viewportSize: const Size(240, 200),
              layers: _layers('''
              <path d="M20 100 H180" fill="none" stroke="black"/>
              <line x1="80" y1="100" x2="120" y2="100" stroke="white"/>
            '''),
              rooms: const [],
              transform: transform,
              pivot: Offset.zero,
            ),
          ),
        ),
      ),
    );
    final boundary =
        boundaryKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
    final image = (await tester.runAsync(boundary.toImage))!;
    final data = (await tester.runAsync(image.toByteData))!;
    final bytes = data.buffer.asUint8List();
    int opaque(int left, int right, int top, int bottom) {
      var count = 0;
      for (var y = top; y < bottom; y++) {
        for (var x = left; x < right; x++) {
          if (bytes[(y * image.width + x) * 4 + 3] > 200) count++;
        }
      }
      return count;
    }

    expect(opaque(30, 70, 61, 65), greaterThan(100));
    expect(opaque(85, 115, 58, 68), 0);
    expect(image.width, 240);
    expect(image.height, 200);
    image.dispose();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'billboard labels retain screen hit bounds during camera movement',
    (tester) async {
      final transform = TransformationController();
      addTearDown(transform.dispose);
      final hits = MapLabelHitIndex();
      final room = RoomModel(
        roomId: 'stairs',
        path: Path()..addRect(const Rect.fromLTWH(30, 30, 80, 80)),
      );
      var builds = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) {
              builds++;
              return Align(
                alignment: Alignment.topLeft,
                child: MapVolumeLayer(
                  floorSize: const Size(60000, 30000),
                  viewportSize: const Size(240, 200),
                  layers: _layers(''),
                  rooms: [room],
                  places: [
                    MapPlaceData.fromJson({
                      'id': 'stairs',
                      'floor_id': 'one',
                      'label': 'Лестница',
                      'kind': 'stairs',
                      'x': 70,
                      'y': 70,
                    }),
                  ],
                  transform: transform,
                  hitIndex: hits,
                  bearing: .3,
                ),
              );
            },
          ),
        ),
      );
      final first = hits.bounds['stairs']!;
      final initialBuilds = builds;
      transform.value = Matrix4.identity()..translateByDouble(20, 10, 0, 1);
      await tester.pump();
      final second = hits.bounds['stairs']!;
      expect(first.size, second.size);
      expect(first.center, isNot(second.center));
      expect(hits.hitTest(second.center), 'stairs');
      expect(builds, initialBuilds);
      for (final paint in tester.widgetList<CustomPaint>(
        find.descendant(
          of: find.byType(MapVolumeLayer),
          matching: find.byType(CustomPaint),
        ),
      )) {
        final finder = find.byWidget(paint);
        expect(tester.getSize(finder), const Size(240, 200));
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('selected Cyrillic captions use the app typography metrics', (
    tester,
  ) async {
    final transform = TransformationController();
    addTearDown(transform.dispose);
    final hits = MapLabelHitIndex();
    await _labelMap(tester, transform, hits, [
      _place('stairs', 'stairs', 'Лестница', const Offset(120, 100)),
    ], selectedId: 'stairs');
    final text = TextPainter(
      text: TextSpan(
        text: 'Лестница',
        style: AppText.captionStrong.copyWith(
          fontSize: 11,
          height: 1.2,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: 170);
    expect(hits.bounds['stairs']!.width, closeTo(text.width + 41, .01));
    text.dispose();
  });

  testWidgets(
    'overview keeps food above repeated stairs and falls back to icons',
    (tester) async {
      final transform = TransformationController(
        Matrix4.diagonal3Values(.3, .3, 1),
      );
      addTearDown(transform.dispose);
      final hits = MapLabelHitIndex();
      await _labelMap(tester, transform, hits, [
        for (var i = 0; i < 520; i++)
          _place(
            'stairs$i',
            'stairs',
            'Лестница',
            const Offset(1000 / 3, 1000 / 3),
          ),
        _place(
          'entrance',
          'entrance',
          'Главный вход',
          const Offset(500 / 3, 1000 / 3),
        ),
        _place(
          'food',
          'cafeteria',
          'Столовая университета',
          const Offset(1000 / 3, 1000 / 3),
        ),
      ]);
      expect(hits.bounds, contains('entrance'));
      expect(hits.bounds, contains('food'));
      expect(hits.bounds['food']!.width, 36);
      expect(hits.bounds.keys.where((id) => id.startsWith('stairs')), isEmpty);
    },
  );

  testWidgets(
    'overview stairs stay compact and passages do not get fake pins',
    (tester) async {
      final transform = TransformationController(
        Matrix4.diagonal3Values(.3, .3, 1),
      );
      addTearDown(transform.dispose);
      final hits = MapLabelHitIndex();
      await _labelMap(tester, transform, hits, [
        _place('stairs', 'stairs', 'Лестница', const Offset(400, 300)),
        _place('corridor', 'corridor', 'Коридор', const Offset(700, 300)),
      ]);
      expect(hits.bounds['stairs']!.width, 36);
      expect(hits.bounds, isNot(contains('corridor')));
    },
  );
}

MapStructureLayers _layers(String content) => MapStructureLayers.fromSvg(
  '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000">$content</svg>',
);

MapPlaceData _place(String id, String kind, String label, Offset point) =>
    MapPlaceData.fromJson({
      'id': id,
      'kind': kind,
      'label': label,
      'floor_id': 'one',
      'x': point.dx,
      'y': point.dy,
    });

Future<void> _labelMap(
  WidgetTester tester,
  TransformationController transform,
  MapLabelHitIndex hits,
  List<MapPlaceData> places, {
  String? selectedId,
}) => tester.pumpWidget(
  MaterialApp(
    theme: AppTheme.lightTheme,
    home: Align(
      alignment: Alignment.topLeft,
      child: MapVolumeLayer(
        floorSize: const Size(1000, 1000),
        viewportSize: const Size(320, 200),
        layers: _layers(''),
        rooms: const [],
        places: places,
        transform: transform,
        hitIndex: hits,
        selectedRoomId: selectedId,
        pivot: Offset.zero,
        pitch: 0,
      ),
    ),
  ),
);
