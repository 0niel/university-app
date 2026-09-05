import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_canvas.dart';
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
  final _canvasKey = GlobalKey<DrawingCanvasState>();
  final _strokes = <DrawingStroke>[];
  final _redoStack = <DrawingStroke>[];
  late final Size _canvasSize;
  DrawingTool _tool = DrawingTool.pen;
  DrawingStrokeWidth _strokeWidth = DrawingStrokeWidth.medium;
  Color? _color;
  bool _stylusOnly = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    var width = 768.0;
    var height = 1024.0;
    for (final stroke in widget.initialStrokes) {
      if (stroke.canvasSize case final size?) {
        width = math.max(width, size.width);
        height = math.max(height, size.height);
      } else {
        for (final point in stroke.points) {
          width = math.max(width, point.x + stroke.width);
          height = math.max(height, point.y + stroke.width);
        }
      }
    }
    _canvasSize = Size(width, height);
    _strokes.addAll(
      widget.initialStrokes.map((stroke) => stroke.withCanvasSize(_canvasSize)),
    );
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

  void _undo() {
    _canvasKey.currentState?.finishStroke();
    if (_strokes.isEmpty) return;
    setState(() => _redoStack.add(_strokes.removeLast()));
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    setState(() => _strokes.add(_redoStack.removeLast()));
  }

  Future<void> _clear() async {
    _canvasKey.currentState?.finishStroke();
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
    if (_saving) return;
    _canvasKey.currentState?.finishStroke();
    if (_strokes.isEmpty) {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.noteDrawingEmpty,
      );
      return;
    }
    final strokes = List<DrawingStroke>.unmodifiable(_strokes);
    final background = context.colors.surface;
    setState(() => _saving = true);
    ui.Image? image;
    ui.Picture? picture;
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final ratio = math.min<double>(
        2,
        4096 / math.max(_canvasSize.width, _canvasSize.height),
      );
      canvas.scale(ratio);
      DrawingCanvasPainter(
        strokes: strokes,
        backgroundColor: background,
      ).paint(canvas, _canvasSize);
      picture = recorder.endRecording();
      image = await picture.toImage(
        (_canvasSize.width * ratio).ceil(),
        (_canvasSize.height * ratio).ceil(),
      );
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) throw StateError('Empty drawing image');
      if (!mounted) return;
      Navigator.of(context).pop(
        CollabNoteDrawingResult(
          bytes: bytes.buffer.asUint8List(),
          strokes: strokes,
        ),
      );
    } on Object {
      if (mounted) {
        showNinjaToast(
          context,
          showCheck: false,
          message: context.l10n.noteDrawingSaveError,
        );
      }
    } finally {
      image?.dispose();
      picture?.dispose();
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final palette = _palette(context);
    final color = _color ?? palette.first;
    return ColoredBox(
      color: colors.canvas,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  AppIconButton(
                    icon: const AppLineIconWidget(
                      AppLineIcon.chevronL,
                      size: 20,
                    ),
                    tooltip: context.l10n.back,
                    onPressed: _saving
                        ? null
                        : () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      context.l10n.noteDrawingTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.headline.copyWith(color: colors.ink),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppButton.primary(
                    label: context.l10n.noteDrawingInsert,
                    size: AppButtonSize.small,
                    onPressed: _saving ? null : () => unawaited(_insert()),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  child: DrawingCanvas(
                    key: _canvasKey,
                    canvasSize: _canvasSize,
                    strokes: _strokes,
                    color: color,
                    backgroundColor: colors.surface,
                    tool: _tool,
                    width: _strokeWidth.value(_tool),
                    stylusOnly: _stylusOnly,
                    enabled: !_saving,
                    onStylusDetected: () {
                      if (!_stylusOnly) setState(() => _stylusOnly = true);
                    },
                    onStrokeCompleted: (stroke) => setState(() {
                      _strokes.add(stroke);
                      _redoStack.clear();
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            DrawingToolbar(
              enabled: !_saving,
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
              stylusOnly: _stylusOnly,
              onStylusOnlyChanged: (value) =>
                  setState(() => _stylusOnly = value),
              onResetView: () => _canvasKey.currentState?.resetView(),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
