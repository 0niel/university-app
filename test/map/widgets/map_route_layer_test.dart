import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_layer.dart';

void main() {
  testWidgets('floor segments and invalid coordinates never create bridges', (
    tester,
  ) async {
    final painter = await _mount(tester, const [
      [Offset(20, 60), Offset(80, 60)],
      [
        Offset(150, 60),
        Offset(180, 60),
        Offset(double.nan, 60),
        Offset(220, 60),
      ],
    ]);
    final pixels = await _paint(tester, painter);
    expect(pixels.opaqueIn(const Rect.fromLTRB(90, 50, 140, 70)), 0);
    expect(pixels.opaqueIn(const Rect.fromLTRB(190, 50, 205, 70)), 0);
    expect(
      pixels.opaqueIn(const Rect.fromLTRB(30, 55, 70, 65)),
      greaterThan(100),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('route width stays constant on screen as zoom changes', (
    tester,
  ) async {
    final transform = TransformationController();
    addTearDown(transform.dispose);
    final widths = <int>[];
    for (final scale in [.25, 1.0, 4.0]) {
      transform.value = Matrix4.diagonal3Values(scale, scale, 1);
      final painter = await _mount(tester, [
        [Offset(20 / scale, 80 / scale), Offset(220 / scale, 80 / scale)],
      ], transform: transform);
      final pixels = await _paint(tester, painter, scale: scale);
      widths.add(pixels.opaqueIn(const Rect.fromLTRB(70, 60, 71, 100)));
    }
    expect(widths.toSet(), hasLength(1));
    expect(widths.first, inInclusiveRange(6, 8));
  });

  testWidgets('direction chevrons follow turns without drawing shortcuts', (
    tester,
  ) async {
    final painter = await _mount(
      tester,
      const [
        [Offset(20, 40), Offset(120, 40), Offset(120, 160)],
      ],
      showStart: false,
      showDestination: false,
    );
    final pixels = await _paint(tester, painter);
    expect(pixels.opaqueIn(const Rect.fromLTRB(85, 60, 108, 95)), 0);
    expect(pixels.whiteIn(const Rect.fromLTRB(41, 38, 47, 42)), greaterThan(0));
    expect(
      pixels.whiteIn(const Rect.fromLTRB(118, 69, 122, 76)),
      greaterThan(0),
    );
    expect(pixels.whiteIn(const Rect.fromLTRB(52, 39, 60, 41)), 0);
  });

  testWidgets('start is hollow and destination has a distinct flag badge', (
    tester,
  ) async {
    final painter = await _mount(tester, const [
      [Offset(30, 80), Offset(210, 80)],
    ]);
    final pixels = await _paint(tester, painter);
    expect(pixels.whiteIn(const Rect.fromLTRB(29, 79, 31, 81)), 4);
    expect(pixels.accentIn(const Rect.fromLTRB(212, 82, 215, 85)), 9);
    expect(pixels.opaqueIn(const Rect.fromLTRB(21, 71, 24, 74)), 0);
    expect(
      pixels.opaqueIn(const Rect.fromLTRB(201, 71, 204, 74)),
      greaterThan(0),
    );
  });

  testWidgets('transform changes notify paint without rebuilding the widget', (
    tester,
  ) async {
    final transform = TransformationController();
    addTearDown(transform.dispose);
    var builds = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Builder(
          builder: (context) {
            builds++;
            return MapRouteLayer(
              size: const Size(240, 200),
              segments: const [
                [Offset(20, 80), Offset(220, 80)],
              ],
              transform: transform,
            );
          },
        ),
      ),
    );
    final painter = tester
        .widget<CustomPaint>(
          find.descendant(
            of: find.byType(MapRouteLayer),
            matching: find.byType(CustomPaint),
          ),
        )
        .painter!;
    var repaints = 0;
    void repainted() => repaints++;
    painter.addListener(repainted);
    final initialBuilds = builds;
    transform.value = Matrix4.diagonal3Values(2, 2, 1);
    await tester.pump();
    expect(repaints, 1);
    expect(builds, initialBuilds);
    painter.removeListener(repainted);
  });

  testWidgets('empty and repeated points are safe with invalid transforms', (
    tester,
  ) async {
    final transform = TransformationController(
      Matrix4.diagonal3Values(double.nan, 0, 1),
    );
    addTearDown(transform.dispose);
    final painter = await _mount(tester, const [
      [],
      [Offset(double.infinity, 0)],
      [Offset(80, 80), Offset(80, 80), Offset(80, 80)],
    ], transform: transform);
    final pixels = await _paint(tester, painter);
    expect(
      pixels.opaqueIn(const Rect.fromLTRB(65, 65, 95, 95)),
      greaterThan(0),
    );
    expect(tester.takeException(), isNull);
  });
}

Future<CustomPainter> _mount(
  WidgetTester tester,
  List<List<Offset>> segments, {
  TransformationController? transform,
  bool showStart = true,
  bool showDestination = true,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.lightTheme,
      home: MapRouteLayer(
        size: const Size(240, 200),
        segments: segments,
        transform: transform,
        showStart: showStart,
        showDestination: showDestination,
      ),
    ),
  );
  return tester
      .widget<CustomPaint>(
        find.descendant(
          of: find.byType(MapRouteLayer),
          matching: find.byType(CustomPaint),
        ),
      )
      .painter!;
}

Future<_Pixels> _paint(
  WidgetTester tester,
  CustomPainter painter, {
  double scale = 1,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(scale);
  painter.paint(canvas, const Size(240, 200));
  final picture = recorder.endRecording();
  final image = (await tester.runAsync(() => picture.toImage(240, 200)))!;
  final data = (await tester.runAsync(
    image.toByteData,
  ))!;
  image.dispose();
  picture.dispose();
  return _Pixels(data.buffer.asUint8List());
}

class _Pixels {
  const _Pixels(this.bytes);

  final Uint8List bytes;

  int opaqueIn(Rect rect) => _count(rect, (index) => bytes[index + 3] > 200);
  int whiteIn(Rect rect) => _count(
    rect,
    (index) =>
        bytes[index] > 230 && bytes[index + 1] > 230 && bytes[index + 3] > 200,
  );
  int accentIn(Rect rect) => _count(
    rect,
    (index) =>
        bytes[index] < 80 && bytes[index + 1] > 100 && bytes[index + 3] > 200,
  );

  int _count(Rect rect, bool Function(int) accepts) {
    var count = 0;
    for (var y = rect.top.toInt(); y < rect.bottom; y++) {
      for (var x = rect.left.toInt(); x < rect.right; x++) {
        if (accepts((y * 240 + x) * 4)) count++;
      }
    }
    return count;
  }
}
