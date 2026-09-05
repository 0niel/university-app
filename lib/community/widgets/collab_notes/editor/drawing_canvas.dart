import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_canvas_painter.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_stroke.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_tool.dart';

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({
    required this.canvasSize,
    required this.strokes,
    required this.color,
    required this.backgroundColor,
    required this.tool,
    required this.width,
    required this.stylusOnly,
    required this.onStylusDetected,
    required this.onStrokeCompleted,
    this.enabled = true,
    super.key,
  });

  final Size canvasSize;
  final List<DrawingStroke> strokes;
  final Color color;
  final Color backgroundColor;
  final DrawingTool tool;
  final double width;
  final bool stylusOnly;
  final bool enabled;
  final VoidCallback onStylusDetected;
  final ValueChanged<DrawingStroke> onStrokeCompleted;

  @override
  State<DrawingCanvas> createState() => DrawingCanvasState();
}

class DrawingCanvasState extends State<DrawingCanvas> {
  final _touches = <int, Offset>{};
  final _ignored = <int>{};
  final _points = <PointVector>[];
  final _paths = <DrawingStroke, Path>{};
  int? _activePointer;
  bool _activeStylus = false;
  bool _eraser = false;
  Color _color = const Color(0xFF000000);
  double _width = 1;
  Size _viewport = Size.zero;
  double _scale = 1;
  Offset _offset = Offset.zero;

  double get _fitScale => math.min(
    _viewport.width / widget.canvasSize.width,
    _viewport.height / widget.canvasSize.height,
  );

  @override
  void didUpdateWidget(DrawingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stylusOnly != widget.stylusOnly || !widget.enabled) {
      if (!_activeStylus) _cancelStroke();
    }
  }

  void finishStroke() {
    if (_points.isEmpty) return;
    final stroke = _stroke;
    setState(_cancelStroke);
    widget.onStrokeCompleted(stroke);
  }

  void resetView() {
    finishStroke();
    setState(_fit);
  }

  void _fit() {
    _scale = _fitScale;
    _offset = Offset(
      (_viewport.width - widget.canvasSize.width * _scale) / 2,
      (_viewport.height - widget.canvasSize.height * _scale) / 2,
    );
  }

  bool _isStylus(PointerDeviceKind kind) =>
      kind == PointerDeviceKind.stylus ||
      kind == PointerDeviceKind.invertedStylus;

  void _cancelStroke() {
    _activePointer = null;
    _activeStylus = false;
    _points.clear();
  }

  PointVector _point(PointerEvent event) {
    final position = (event.localPosition - _offset) / _scale;
    final range = event.pressureMax - event.pressureMin;
    final pressure =
        _isStylus(event.kind) && range > 0 && event.pressure.isFinite
        ? ((event.pressure - event.pressureMin) / range).clamp(0.0, 1.0)
        : null;
    return PointVector(
      position.dx.clamp(0, widget.canvasSize.width),
      position.dy.clamp(0, widget.canvasSize.height),
      pressure,
    );
  }

  void _down(PointerDownEvent event) {
    if (!widget.enabled) return;
    final stylus = _isStylus(event.kind);
    if (stylus) {
      _ignored.addAll(_touches.keys);
      _touches.clear();
      if (!_activeStylus) _cancelStroke();
      widget.onStylusDetected();
    } else if (_activeStylus) {
      _ignored.add(event.pointer);
      return;
    }
    if (event.kind == PointerDeviceKind.touch) {
      _touches[event.pointer] = event.localPosition;
      if (widget.stylusOnly || _touches.length > 1) {
        setState(_cancelStroke);
        return;
      }
    }
    if (_activePointer != null ||
        (event.kind == PointerDeviceKind.mouse &&
            event.buttons != kPrimaryButton)) {
      return;
    }
    final position = (event.localPosition - _offset) / _scale;
    if (!(Offset.zero & widget.canvasSize).contains(position)) return;
    setState(() {
      _activePointer = event.pointer;
      _activeStylus = stylus;
      _eraser =
          widget.tool == DrawingTool.eraser ||
          event.kind == PointerDeviceKind.invertedStylus;
      _color = widget.tool == DrawingTool.marker && !_eraser
          ? widget.color.withValues(alpha: 0.35)
          : widget.color;
      _width = widget.width;
      _points
        ..clear()
        ..add(_point(event));
    });
  }

  Offset get _touchCenter =>
      _touches.values.fold(Offset.zero, (sum, point) => sum + point) /
      _touches.length.toDouble();

  double get _touchSpan {
    if (_touches.length < 2) return 0;
    final values = _touches.values.take(2).toList();
    return (values.first - values.last).distance;
  }

  void _transform(Offset before, Offset after, double factor) {
    final scale = (_scale * factor).clamp(_fitScale, _fitScale * 8);
    _offset = after - (before - _offset) * (scale / _scale);
    _scale = scale;
    final width = widget.canvasSize.width * _scale;
    final height = widget.canvasSize.height * _scale;
    _offset = Offset(
      width <= _viewport.width
          ? (_viewport.width - width) / 2
          : _offset.dx.clamp(_viewport.width - width, 0),
      height <= _viewport.height
          ? (_viewport.height - height) / 2
          : _offset.dy.clamp(_viewport.height - height, 0),
    );
  }

  void _move(PointerMoveEvent event) {
    if (!widget.enabled || _ignored.contains(event.pointer)) return;
    if (_touches.containsKey(event.pointer)) {
      final before = _touchCenter;
      final span = _touchSpan;
      _touches[event.pointer] = event.localPosition;
      if (_activePointer == null) {
        setState(
          () => _transform(
            before,
            _touchCenter,
            span > 0 ? _touchSpan / span : 1,
          ),
        );
        return;
      }
    }
    if (event.pointer != _activePointer) return;
    setState(() => _points.add(_point(event)));
  }

  DrawingStroke get _stroke => DrawingStroke(
    points: List.unmodifiable(_points),
    color: _color,
    width: _width,
    isEraser: _eraser,
    canvasSize: widget.canvasSize,
  );

  void _end(PointerEvent event, {bool cancel = false}) {
    _ignored.remove(event.pointer);
    _touches.remove(event.pointer);
    if (event.pointer != _activePointer) return;
    final stroke = _stroke;
    setState(_cancelStroke);
    if (!cancel && widget.enabled && stroke.points.isNotEmpty) {
      widget.onStrokeCompleted(stroke);
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final viewport = constraints.biggest;
      if (viewport != _viewport) {
        _viewport = viewport;
        _fit();
      }
      _paths.removeWhere((stroke, _) => !widget.strokes.contains(stroke));
      for (final stroke in widget.strokes) {
        _paths.putIfAbsent(stroke, () => DrawingCanvasPainter.pathFor(stroke));
      }
      return Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _down,
        onPointerMove: _move,
        onPointerUp: _end,
        onPointerCancel: (event) => _end(event, cancel: true),
        onPointerHover: (event) {
          if (_isStylus(event.kind) && !widget.stylusOnly) {
            widget.onStylusDetected();
          }
        },
        onPointerSignal: (event) {
          if (event is PointerScrollEvent &&
              _activePointer == null &&
              widget.enabled) {
            GestureBinding.instance.pointerSignalResolver.register(event, (_) {
              setState(
                () => _transform(
                  event.localPosition,
                  event.localPosition,
                  math.exp(-event.scrollDelta.dy / 300),
                ),
              );
            });
          }
        },
        child: RepaintBoundary(
          child: CustomPaint(
            size: Size.infinite,
            painter: DrawingCanvasPainter(
              strokes: [...widget.strokes, if (_points.isNotEmpty) _stroke],
              backgroundColor: widget.backgroundColor,
              canvasSize: widget.canvasSize,
              offset: _offset,
              scale: _scale,
              paths: _paths,
            ),
          ),
        ),
      );
    },
  );
}
