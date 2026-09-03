import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_canvas_painter.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_stroke.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_tool.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_toolbar.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CollabNoteDrawingResult {
  const CollabNoteDrawingResult({required this.bytes, required this.strokes});

  final Uint8List bytes;
  final List<DrawingStroke> strokes;

  String get strokesJson => jsonEncode([
    for (final stroke in strokes) stroke.toJson(),
  ]);
}

Future<CollabNoteDrawingResult?> showCollabNoteDrawingPage(
  BuildContext context, {
  List<DrawingStroke> initialStrokes = const [],
}) {
  return Navigator.of(
    context,
    rootNavigator: true,
  ).push<CollabNoteDrawingResult>(
    PageRouteBuilder<CollabNoteDrawingResult>(
      fullscreenDialog: true,
      transitionDuration:
          MediaQuery.disableAnimationsOf(context) ||
              MediaQuery.accessibleNavigationOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 220),
      pageBuilder: (_, _, _) =>
          CollabNoteDrawingPage(initialStrokes: initialStrokes),
      transitionsBuilder: (_, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      ),
    ),
  );
}

class CollabNoteDrawingPage extends StatefulWidget {
  const CollabNoteDrawingPage({super.key, this.initialStrokes = const []});

  final List<DrawingStroke> initialStrokes;

  @override
  State<CollabNoteDrawingPage> createState() => _CollabNoteDrawingPageState();
}

class _CollabNoteDrawingPageState extends State<CollabNoteDrawingPage> {
  final GlobalKey _boundaryKey = GlobalKey();
  final _strokes = <DrawingStroke>[];
  final _redoStack = <DrawingStroke>[];
  final _activePoints = <PointVector>[];
  DrawingTool _tool = DrawingTool.pen;
  DrawingStrokeWidth _strokeWidth = DrawingStrokeWidth.medium;
  Color? _color;
  int? _activePointer;
  var _stylusActive = false;

  @override
  void initState() {
    super.initState();
    _strokes.addAll(widget.initialStrokes);
  }

  List<Color> _palette(BuildContext context) {
    final colors = context.colors;
    return [
      colors.ink,
      colors.accent,
      colors.lecture,
      colors.lab,
      colors.practice,
      colors.exam,
    ];
  }

  Color _resolvedColor(BuildContext context) =>
      _color ?? _palette(context).first;

  void _handlePointerDown(PointerDownEvent event) {
    if (event.kind == PointerDeviceKind.stylus) {
      _stylusActive = true;
    } else if (_stylusActive) {
      return;
    }
    if (_activePointer != null) return;
    _activePointer = event.pointer;
    _activePoints
      ..clear()
      ..add(
        PointVector(
          event.localPosition.dx,
          event.localPosition.dy,
          event.pressure,
        ),
      );
    setState(() {});
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (event.pointer != _activePointer) return;
    _activePoints.add(
      PointVector(
        event.localPosition.dx,
        event.localPosition.dy,
        event.pressure,
      ),
    );
    setState(() {});
  }

  void _endStroke(int pointer) {
    if (pointer != _activePointer) return;
    _activePointer = null;
    if (_activePoints.length > 1) {
      _strokes.add(
        DrawingStroke(
          points: List.of(_activePoints),
          color: _resolvedColor(context),
          width: _strokeWidth.value(_tool),
          isEraser: _tool == .eraser,
        ),
      );
      _redoStack.clear();
    }
    _activePoints.clear();
    setState(() {});
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (event.kind == PointerDeviceKind.stylus) _stylusActive = false;
    _endStroke(event.pointer);
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (event.kind == PointerDeviceKind.stylus) _stylusActive = false;
    if (event.pointer != _activePointer) return;
    _activePointer = null;
    _activePoints.clear();
    setState(() {});
  }

  void _undo() {
    if (_strokes.isEmpty) return;
    setState(() => _redoStack.add(_strokes.removeLast()));
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    setState(() => _strokes.add(_redoStack.removeLast()));
  }

  Future<void> _clear() async {
    if (_strokes.isEmpty) return;
    final confirmed = await showAppConfirmDialog(
      context,
      title: context.l10n.noteDrawingClearConfirmTitle,
      message: context.l10n.noteDrawingClearConfirmBody,
      confirmLabel: context.l10n.noteDrawingClear,
      cancelLabel: context.l10n.cancel,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    setState(() {
      _strokes.clear();
      _redoStack.clear();
    });
  }

  Future<void> _insert() async {
    if (_strokes.isEmpty) {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.noteDrawingEmpty,
      );
      return;
    }
    final boundary =
        _boundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) return;
    final image = await boundary.toImage(pixelRatio: 2);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null || !mounted) return;
    Navigator.of(context).pop(
      CollabNoteDrawingResult(
        bytes: byteData.buffer.asUint8List(),
        strokes: List.of(_strokes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final palette = _palette(context);
    final color = _resolvedColor(context);
    final liveStroke = _activePoints.length > 1
        ? DrawingStroke(
            points: List.of(_activePoints),
            color: color,
            width: _strokeWidth.value(_tool),
            isEraser: _tool == .eraser,
          )
        : null;
    return ColoredBox(
      color: colors.canvas,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.sm,
                AppSpacing.screen,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  AppIconButton(
                    icon: const AppLineIconWidget(
                      AppLineIcon.chevronL,
                      size: 20,
                    ),
                    tooltip: context.l10n.back,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      context.l10n.noteDrawingTitle,
                      style: AppText.headline.copyWith(color: colors.ink),
                    ),
                  ),
                  AppButton.primary(
                    label: context.l10n.noteDrawingInsert,
                    size: AppButtonSize.small,
                    onPressed: () => unawaited(_insert()),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screen,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  child: RepaintBoundary(
                    key: _boundaryKey,
                    child: Listener(
                      behavior: HitTestBehavior.opaque,
                      onPointerDown: _handlePointerDown,
                      onPointerMove: _handlePointerMove,
                      onPointerUp: _handlePointerUp,
                      onPointerCancel: _handlePointerCancel,
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: DrawingCanvasPainter(
                          strokes: [..._strokes, ?liveStroke],
                          backgroundColor: colors.surface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DrawingToolbar(
              tool: _tool,
              onToolChanged: (tool) => setState(() => _tool = tool),
              color: color,
              palette: palette,
              onColorChanged: (value) => setState(() => _color = value),
              strokeWidth: _strokeWidth,
              onStrokeWidthChanged: (value) =>
                  setState(() => _strokeWidth = value),
              canUndo: _strokes.isNotEmpty,
              canRedo: _redoStack.isNotEmpty,
              onUndo: _undo,
              onRedo: _redo,
              onClear: () => unawaited(_clear()),
            ),
            SizedBox(
              height: MediaQuery.viewPaddingOf(context).bottom + AppSpacing.md,
            ),
          ],
        ),
      ),
    );
  }
}
