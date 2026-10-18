import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/map_planar_scale.dart';
import 'package:rtu_mirea_app/map/services/svg_room_parser.dart';
import 'package:rtu_mirea_app/map/widgets/map_cartographic_layer.dart';
import 'package:rtu_mirea_app/map/widgets/map_loading_plan.dart';

class MapEditorFloorCanvas extends StatefulWidget {
  const MapEditorFloorCanvas({
    required this.floor,
    required this.repository,
    required this.onTap,
    required this.painter,
    this.campus,
    this.places = const [],
    super.key,
  });

  final MapFloorData floor;
  final CampusMapData? campus;
  final MapDataRepository repository;
  final void Function(Offset point, double hitRadius) onTap;
  final CustomPainter painter;
  final List<MapPlaceData> places;

  @override
  State<MapEditorFloorCanvas> createState() => _MapEditorFloorCanvasState();
}

class _MapEditorFloorCanvasState extends State<MapEditorFloorCanvas> {
  final _transform = TransformationController();
  final _planTransform = TransformationController();
  double _fitScale = 1;
  late Future<({String svg, List<RoomModel> rooms})> _plan = _loadPlan();

  Future<({String svg, List<RoomModel> rooms})> _loadPlan() async {
    final path = widget.floor.floor.svgPath;
    final svg = await widget.repository.loadSvg(path, campus: widget.campus);
    final parsed = await SvgRoomParser(
      onLoadSvg: (_) async => svg,
    ).parseSvg(path);
    return (svg: svg, rooms: parsed.$1);
  }

  @override
  void initState() {
    super.initState();
    _transform.addListener(_syncPlanTransform);
  }

  void _syncPlanTransform() {
    _planTransform.value = _transform.value.clone()
      ..scaleByDouble(_fitScale, _fitScale, 1, 1);
  }

  @override
  void didUpdateWidget(MapEditorFloorCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repository != widget.repository ||
        oldWidget.campus != widget.campus ||
        oldWidget.floor.floor.svgPath != widget.floor.floor.svgPath ||
        oldWidget.floor.width != widget.floor.width ||
        oldWidget.floor.height != widget.floor.height) {
      _plan = _loadPlan();
      _transform.value = Matrix4.identity();
    }
  }

  @override
  void dispose() {
    _transform
      ..removeListener(_syncPlanTransform)
      ..dispose();
    _planTransform.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<({String svg, List<RoomModel> rooms})>(
        future: _plan,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Не удалось загрузить план', style: AppText.label),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Проверьте подключение и попробуйте ещё раз.',
                      style: AppText.caption,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton.secondary(
                      label: 'Загрузить план повторно',
                      onPressed: () => setState(() {
                        _plan = _loadPlan();
                      }),
                    ),
                  ],
                ),
              ),
            );
          }
          final plan = snapshot.data;
          if (plan == null ||
              snapshot.connectionState != ConnectionState.done) {
            return Semantics(
              label: 'Загружаем план этажа',
              liveRegion: true,
              child: const MapLoadingPlan(),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final scale = math.min(
                constraints.maxWidth / widget.floor.width,
                constraints.maxHeight / widget.floor.height,
              );
              if (_fitScale != scale) {
                _fitScale = scale;
                _syncPlanTransform();
              }
              return ClipRect(
                child: ColoredBox(
                  key: const ValueKey('map-editor-canvas-surface'),
                  color: context.colors.isDark
                      ? AppColors.mapCanvasDark
                      : AppColors.mapCanvasLight,
                  child: InteractiveViewer(
                    transformationController: _transform,
                    maxScale: 16,
                    child: Center(
                      child: SizedBox(
                        key: const ValueKey('map-editor-floor-plan'),
                        width: widget.floor.width * scale,
                        height: widget.floor.height * scale,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapUp: (details) => widget.onTap(
                            details.localPosition / scale,
                            20 / mapPlanarScale(_planTransform.value),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              RepaintBoundary(
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: MapCartographicLayer(
                                    svgContent: plan.svg,
                                    rooms: plan.rooms,
                                    places: widget.places
                                        .where(
                                          (place) =>
                                              place.floorId ==
                                              widget.floor.floor.id,
                                        )
                                        .toList(),
                                    size: Size(
                                      widget.floor.width,
                                      widget.floor.height,
                                    ),
                                    transform: _planTransform,
                                  ),
                                ),
                              ),
                              IgnorePointer(
                                child: CustomPaint(
                                  key: const ValueKey('map-editor-overlay'),
                                  painter: _EditorOverlayPainter(
                                    widget.painter,
                                    _transform,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
}

class _EditorOverlayPainter extends CustomPainter {
  _EditorOverlayPainter(this.delegate, this.transform)
    : super(repaint: Listenable.merge([delegate, transform]));

  final CustomPainter delegate;
  final TransformationController transform;

  @override
  void paint(Canvas canvas, Size size) {
    final zoom = mapPlanarScale(transform.value);
    canvas
      ..save()
      ..scale(1 / zoom);
    delegate.paint(canvas, size * zoom);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_EditorOverlayPainter oldDelegate) =>
      delegate != oldDelegate.delegate || transform != oldDelegate.transform;
}
