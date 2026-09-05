import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'package:rtu_mirea_app/community/view/collab_note_drawing_page.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_canvas.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_canvas_painter.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_stroke.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_tool.dart';

import '../../../../helpers/pump_app.dart';

Future<void> _pumpCanvas(
  WidgetTester tester,
  List<DrawingStroke> strokes, {
  bool stylusOnly = false,
}) {
  var onlyStylus = stylusOnly;
  return tester.pumpApp(
    StatefulBuilder(
      builder: (context, setState) => DrawingCanvas(
        canvasSize: const Size(768, 1024),
        strokes: strokes,
        color: const Color(0xFF121212),
        backgroundColor: const Color(0xFFFFFFFF),
        tool: DrawingTool.pen,
        width: 8,
        stylusOnly: onlyStylus,
        onStylusDetected: () => setState(() => onlyStylus = true),
        onStrokeCompleted: (stroke) => setState(() => strokes.add(stroke)),
      ),
    ),
    size: const Size(360, 640),
  );
}

DrawingCanvasPainter _painter(WidgetTester tester) =>
    tester
            .widget<CustomPaint>(
              find.byWidgetPredicate(
                (widget) =>
                    widget is CustomPaint &&
                    widget.painter is DrawingCanvasPainter,
              ),
            )
            .painter!
        as DrawingCanvasPainter;

void main() {
  testWidgets('eraser reveals paper and preserves nearby ink', (tester) async {
    await tester.runAsync(() async {
      final recorder = ui.PictureRecorder();
      const DrawingCanvasPainter(
        strokes: [
          DrawingStroke(
            points: [PointVector(10, 50, 0.5), PointVector(90, 50, 0.5)],
            color: Color(0xFF000000),
            width: 20,
          ),
          DrawingStroke(
            points: [PointVector(50, 10, 0.5), PointVector(50, 90, 0.5)],
            color: Color(0xFF000000),
            width: 20,
            isEraser: true,
          ),
        ],
        backgroundColor: Color(0xFFFFFFFF),
      ).paint(Canvas(recorder), const Size(100, 100));
      final picture = recorder.endRecording();
      final image = await picture.toImage(100, 100);
      final bytes = await image.toByteData();
      expect(bytes!.getUint32((50 * 100 + 50) * 4), 0xFFFFFFFF);
      expect(bytes.getUint32((50 * 100 + 25) * 4), 0x000000FF);
      image.dispose();
      picture.dispose();
    });
  });

  testWidgets(
    'insert exports entire document while zoomed and returns editable strokes',
    (tester) async {
      late Future<CollabNoteDrawingResult?> result;
      const stroke = DrawingStroke(
        points: [PointVector(20, 20, 0.5), PointVector(700, 950, 0.8)],
        color: Color(0xFF123456),
        width: 8,
        canvasSize: Size(768, 1024),
      );
      await tester.pumpApp(
        Builder(
          builder: (context) => AppButton.primary(
            label: 'Open',
            onPressed: () {
              result = showCollabNoteDrawingPage(
                context,
                initialStrokes: [stroke],
              );
            },
          ),
        ),
        size: const Size(360, 640),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final center = tester.getCenter(find.byType(DrawingCanvas));
      final first = await tester.startGesture(
        center - const Offset(20, 20),
        pointer: 1,
      );
      final second = await tester.startGesture(
        center + const Offset(20, 20),
        pointer: 2,
      );
      await first.moveBy(const Offset(-50, -50));
      await second.moveBy(const Offset(50, 50));
      await first.up();
      await second.up();
      await tester.pump();
      final insert = find.ancestor(
        of: find.text('Вставить'),
        matching: find.byType(AppButton),
      );
      expect(insert.hitTestable(), findsOneWidget);
      CollabNoteDrawingResult? saved;
      unawaited(result.then((value) => saved = value));
      await tester.runAsync(() async {
        tester.widget<AppButton>(insert).onPressed!();
        for (var frame = 0; frame < 100 && saved == null; frame++) {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          await tester.pump();
        }
      });
      expect(saved, isNotNull);
      final drawing = saved!;
      expect(drawing.bytes.buffer.asByteData().getUint32(16), 1536);
      expect(drawing.bytes.buffer.asByteData().getUint32(20), 2048);
      expect(
        decodeDrawingStrokes(drawing.strokesJson).single.toJson(),
        stroke.toJson(),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CollabNoteDrawingPage), findsNothing);
    },
  );

  test(
    'legacy and new strokes retain coordinates, pressure and canvas metadata',
    () {
      final legacy = decodeDrawingStrokes(
        '[{"points":[[12,23],[45,67,0.2]],"width":4,'
        '"color":4278190080,"eraser":true}]',
      ).single;
      expect(legacy.points.first.pressure, 1);
      expect(legacy.isEraser, isTrue);
      const stroke = DrawingStroke(
        points: [PointVector(12.5, 20.25), PointVector(700, 1000)],
        color: Color(0xFF123456),
        width: 4,
        canvasSize: Size(768, 1024),
      );
      final decoded = decodeDrawingStrokes(
        jsonEncode([stroke.toJson()]),
      ).single;
      expect(decoded.toJson(), stroke.toJson());
      expect(decoded.points.first.pressure, isNull);
      expect((stroke.toJson()['points']! as List).first, [12.5, 20.25, 1]);
      expect(decodeDrawingStrokes('broken'), isEmpty);
      expect(
        decodeDrawingStrokes(
          '[{"points":[["bad",2],[1,2]],"width":"bad"}]',
        ).single.points,
        hasLength(1),
      );
    },
  );

  testWidgets('stylus normalizes pressure, supports dots and inverted eraser', (
    tester,
  ) async {
    final strokes = <DrawingStroke>[];
    await _pumpCanvas(tester, strokes);
    await tester.sendEventToBinding(
      const PointerDownEvent(
        pointer: 1,
        kind: PointerDeviceKind.stylus,
        position: Offset(180, 320),
        pressure: 2,
        pressureMin: 0,
        pressureMax: 4,
      ),
    );
    await tester.sendEventToBinding(
      const PointerUpEvent(
        pointer: 1,
        kind: PointerDeviceKind.stylus,
        position: Offset(180, 320),
      ),
    );
    await tester.pump();
    expect(strokes, hasLength(1));
    expect(strokes.single.points.single.pressure, 0.5);
    expect(strokes.single.points.single.x, closeTo(384, 0.01));
    expect(strokes.single.outline(), isNotEmpty);
    await tester.sendEventToBinding(
      const PointerDownEvent(
        pointer: 2,
        kind: PointerDeviceKind.invertedStylus,
        position: Offset(190, 330),
      ),
    );
    await tester.sendEventToBinding(
      const PointerUpEvent(
        pointer: 2,
        kind: PointerDeviceKind.invertedStylus,
        position: Offset(190, 330),
      ),
    );
    expect(strokes.last.isEraser, isTrue);
  });

  testWidgets('stylus cancels preceding palm and ignores palm until lift', (
    tester,
  ) async {
    final strokes = <DrawingStroke>[];
    await _pumpCanvas(tester, strokes);
    final palm = await tester.startGesture(const Offset(160, 300), pointer: 1);
    await palm.moveBy(const Offset(5, 10));
    final pen = await tester.startGesture(
      const Offset(180, 320),
      pointer: 2,
      kind: PointerDeviceKind.stylus,
    );
    await tester.pump();
    await pen.moveBy(const Offset(20, 20));
    await palm.moveBy(const Offset(30, 30));
    await pen.up();
    final before = _painter(tester).offset;
    await palm.moveBy(const Offset(20, 20));
    await palm.up();
    await tester.pump();
    expect(strokes, hasLength(1));
    expect(_painter(tester).offset, before);
    final touch = await tester.startGesture(const Offset(200, 300), pointer: 3);
    await touch.moveBy(const Offset(30, 20));
    await touch.up();
    expect(strokes, hasLength(1));
  });

  testWidgets('touch pinch cancels drawing then pans without adding strokes', (
    tester,
  ) async {
    final strokes = <DrawingStroke>[];
    await _pumpCanvas(tester, strokes);
    final first = await tester.startGesture(const Offset(140, 280), pointer: 1);
    final second = await tester.startGesture(
      const Offset(220, 360),
      pointer: 2,
    );
    final initialScale = _painter(tester).scale;
    await first.moveBy(const Offset(-50, -50));
    await second.moveBy(const Offset(50, 50));
    await tester.pump();
    expect(_painter(tester).scale, greaterThan(initialScale));
    await second.up();
    final before = _painter(tester).offset;
    await first.moveBy(const Offset(20, 20));
    await tester.pump();
    expect(_painter(tester).offset, isNot(before));
    await first.up();
    expect(strokes, isEmpty);
  });

  testWidgets(
    'cancel discards incomplete stroke and touch pressure stays simulated',
    (tester) async {
      final strokes = <DrawingStroke>[];
      await _pumpCanvas(tester, strokes);
      final cancelled = await tester.startGesture(
        const Offset(180, 320),
        pointer: 1,
      );
      await cancelled.moveBy(const Offset(20, 20));
      await cancelled.cancel();
      expect(strokes, isEmpty);
      await tester.tapAt(const Offset(180, 320));
      expect(strokes.single.points.single.pressure, isNull);
    },
  );

  for (final size in [const Size(320, 640), const Size(1200, 800)]) {
    testWidgets('toolbar fits $size at 200% and undo redo retains stroke', (
      tester,
    ) async {
      await tester.pumpApp(
        const CollabNoteDrawingPage(),
        size: size,
        textScaler: const TextScaler.linear(2),
      );
      expect(tester.takeException(), isNull);
      final area = tester.getRect(find.byType(DrawingCanvas));
      await tester.tapAt(area.center);
      await tester.pump();
      expect(
        tester.widget<DrawingCanvas>(find.byType(DrawingCanvas)).strokes,
        hasLength(1),
      );
      await tester.tap(find.byTooltip('Отменить штрих'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<DrawingCanvas>(find.byType(DrawingCanvas)).strokes,
        isEmpty,
      );
      await tester.tap(find.byTooltip('Повторить штрих'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<DrawingCanvas>(find.byType(DrawingCanvas)).strokes,
        hasLength(1),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'reopening preserves document size and strokes at the canvas edge',
    (tester) async {
      const stroke = DrawingStroke(
        points: [PointVector(768, 1024, 0.7)],
        color: Color(0xFF123456),
        width: 8,
        canvasSize: Size(768, 1024),
      );
      await tester.pumpApp(
        const CollabNoteDrawingPage(initialStrokes: [stroke]),
        size: const Size(1200, 800),
      );
      var canvas = tester.widget<DrawingCanvas>(find.byType(DrawingCanvas));
      final serialized = jsonEncode(
        canvas.strokes.map((stroke) => stroke.toJson()).toList(),
      );
      await tester.pumpApp(
        CollabNoteDrawingPage(
          key: const ValueKey('reopened'),
          initialStrokes: decodeDrawingStrokes(serialized),
        ),
        size: const Size(360, 640),
      );
      canvas = tester.widget<DrawingCanvas>(find.byType(DrawingCanvas));
      expect(canvas.canvasSize, const Size(768, 1024));
      expect(canvas.strokes.single.toJson(), stroke.toJson());
    },
  );

  testWidgets('stylus mode can be turned off to resume touch drawing', (
    tester,
  ) async {
    await tester.pumpApp(
      const CollabNoteDrawingPage(),
      size: const Size(1200, 800),
    );
    final center = tester.getCenter(find.byType(DrawingCanvas));
    final pen = await tester.startGesture(
      center,
      kind: PointerDeviceKind.stylus,
    );
    await pen.up();
    await tester.pump();
    expect(
      tester.widget<DrawingCanvas>(find.byType(DrawingCanvas)).stylusOnly,
      isTrue,
    );
    await tester.tap(find.byTooltip('Только стилус'));
    await tester.pumpAndSettle();
    await tester.tapAt(center);
    await tester.pump();
    final canvas = tester.widget<DrawingCanvas>(find.byType(DrawingCanvas));
    expect(canvas.stylusOnly, isFalse);
    expect(canvas.strokes, hasLength(2));
    expect(canvas.strokes.last.points.single.pressure, isNull);
  });
}
