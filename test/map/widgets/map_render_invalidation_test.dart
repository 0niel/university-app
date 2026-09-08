import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/services/svg_room_parser.dart';
import 'package:rtu_mirea_app/map/widgets/map_cartographic_layer.dart';

void main() {
  testWidgets('V78 pan preserves cached layers while zoom updates strokes', (
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
    expect(rooms.length, greaterThan(100));
    final transform = TransformationController();
    addTearDown(transform.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: AnimatedBuilder(
          animation: transform,
          builder: (_, child) => Transform(
            transform: transform.value,
            child: child,
          ),
          child: MapCartographicLayer(
            rooms: rooms,
            places: const [],
            size: bounds.size,
            svgContent: svg,
            transform: transform,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    var invalidations = 0;
    void invalidated() => invalidations++;
    final painters = tester
        .widgetList<CustomPaint>(
          find.descendant(
            of: find.byType(MapCartographicLayer),
            matching: find.byType(CustomPaint),
          ),
        )
        .map((widget) => widget.painter!)
        .toList();
    expect(painters, hasLength(4));
    final fullFloorPaths = _drawPaths(painters, bounds.size);
    for (final painter in painters) {
      painter.addListener(invalidated);
      addTearDown(() => painter.removeListener(invalidated));
    }
    for (var frame = 1; frame <= 60; frame++) {
      transform.value = Matrix4.identity()
        ..translateByDouble(frame.toDouble(), frame * .5, 0, 1);
      await tester.pump();
    }
    expect(
      invalidations,
      0,
      reason: 'Translation does not change scene strokes',
    );
    transform.value = Matrix4.identity()..scaleByDouble(2, 2, 1, 1);
    expect(invalidations, 3, reason: 'Both structure layers and rooms rescale');
    await tester.pump();
    expect(tester.takeException(), isNull);

    final center = rooms.first.path.getBounds().center;
    transform.value = Matrix4.identity()
      ..translateByDouble(160 - center.dx * 8, 210 - center.dy * 8, 0, 1)
      ..scaleByDouble(8, 8, 1, 1);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Center(
          child: MapCartographicLayer(
            rooms: rooms,
            places: const [],
            size: bounds.size,
            viewportSize: const Size(320, 420),
            svgContent: svg,
            transform: transform,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final boundedPaints = find.descendant(
      of: find.byType(MapCartographicLayer),
      matching: find.byType(CustomPaint),
    );
    for (final element in boundedPaints.evaluate()) {
      expect((element.renderObject! as RenderBox).size, const Size(320, 420));
    }
    final boundedPaths = _drawPaths(
      tester
          .widgetList<CustomPaint>(boundedPaints)
          .map((widget) => widget.painter!),
      const Size(320, 420),
    );
    expect(boundedPaths, greaterThan(0));
    expect(boundedPaths, lessThan(fullFloorPaths ~/ 2));
    debugPrint(
      'V78 recorded paths: full floor $fullFloorPaths, viewport $boundedPaths',
    );
    expect(tester.takeException(), isNull);
  });
}

int _drawPaths(Iterable<CustomPainter> painters, Size size) {
  final recorder = ui.PictureRecorder();
  final canvas = _CountingCanvas(Canvas(recorder));
  for (final painter in painters) {
    painter.paint(canvas, size);
  }
  recorder.endRecording().dispose();
  return canvas.paths;
}

class _CountingCanvas extends Fake implements Canvas {
  _CountingCanvas(this.delegate);

  final Canvas delegate;
  int paths = 0;

  @override
  void drawPath(Path path, Paint paint) {
    paths++;
    delegate.drawPath(path, paint);
  }

  @override
  void save() => delegate.save();
  @override
  void restore() => delegate.restore();
  @override
  void translate(double dx, double dy) => delegate.translate(dx, dy);
  @override
  void scale(double sx, [double? sy]) => delegate.scale(sx, sy);
  @override
  void transform(Float64List matrix4) => delegate.transform(matrix4);
  @override
  Rect getLocalClipBounds() => delegate.getLocalClipBounds();
  @override
  void clipRect(
    Rect rect, {
    ui.ClipOp clipOp = ui.ClipOp.intersect,
    bool doAntiAlias = true,
  }) => delegate.clipRect(rect, clipOp: clipOp, doAntiAlias: doAntiAlias);
  @override
  void clipPath(Path path, {bool doAntiAlias = true}) =>
      delegate.clipPath(path, doAntiAlias: doAntiAlias);
  @override
  void drawCircle(Offset center, double radius, Paint paint) =>
      delegate.drawCircle(center, radius, paint);
  @override
  void drawRRect(RRect rrect, Paint paint) => delegate.drawRRect(rrect, paint);
  @override
  void drawLine(Offset p1, Offset p2, Paint paint) =>
      delegate.drawLine(p1, p2, paint);
  @override
  void drawParagraph(ui.Paragraph paragraph, Offset offset) =>
      delegate.drawParagraph(paragraph, offset);
}
