import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/map_label_hit_index.dart';
import 'package:rtu_mirea_app/map/services/map_label_layout.dart';
import 'package:rtu_mirea_app/map/services/map_navigation_landmarks.dart';
import 'package:rtu_mirea_app/map/services/map_place_anchor.dart';
import 'package:rtu_mirea_app/map/services/map_place_landmarks.dart';
import 'package:rtu_mirea_app/map/services/map_planar_scale.dart';
import 'package:rtu_mirea_app/map/services/map_volume_mesh.dart';
import 'package:rtu_mirea_app/map/services/map_volume_projection.dart';
import 'package:rtu_mirea_app/map/widgets/map_places_explorer.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_layer.dart';
import 'package:rtu_mirea_app/map/widgets/map_structure_layer.dart';

class MapVolumeLayer extends StatefulWidget {
  const MapVolumeLayer({
    required this.floorSize,
    required this.viewportSize,
    required this.layers,
    required this.rooms,
    required this.transform,
    this.places = const [],
    this.navigationLandmarks = const [],
    this.syntheticRoomIds = const {},
    this.selectedRoomId,
    this.hitIndex,
    this.bearing = 0,
    this.pitch = .85,
    this.pivot,
    this.routeSegments = const [],
    this.instructionPoint,
    this.showRouteStart = true,
    this.showRouteDestination = true,
    super.key,
  });

  final Size floorSize;
  final Size viewportSize;
  final MapStructureLayers layers;
  final List<RoomModel> rooms;
  final ValueListenable<Matrix4> transform;
  final List<MapPlaceData> places;
  final List<MapNavigationLandmark> navigationLandmarks;
  final Set<String> syntheticRoomIds;
  final String? selectedRoomId;
  final MapLabelHitIndex? hitIndex;
  final double bearing;
  final double pitch;
  final Offset? pivot;
  final List<List<Offset>> routeSegments;
  final Offset? instructionPoint;
  final bool showRouteStart;
  final bool showRouteDestination;

  @override
  State<MapVolumeLayer> createState() => _MapVolumeLayerState();
}

class _MapVolumeLayerState extends State<MapVolumeLayer> {
  late MapVolumeMesh _mesh;
  late List<_VolumePlace> _features;
  late List<_VolumePlace> _overviewFeatures;
  late List<(Offset, double)> _routeMarkers;
  late final ValueNotifier<MapVolumeProjection> _projection;
  late final ValueNotifier<Matrix4> _ground;

  MapVolumeProjection _camera() => MapVolumeProjection(
    viewportSize: widget.viewportSize,
    transform: widget.transform.value,
    bearing: widget.bearing,
    pitch: widget.pitch,
    pivot: widget.pivot,
  );

  @override
  void initState() {
    super.initState();
    _mesh = MapVolumeMesh.fromLayers(
      widget.layers,
      floorSize: widget.floorSize,
    );
    _index();
    _indexRouteMarkers();
    _projection = ValueNotifier(_camera());
    _ground = ValueNotifier(_projection.value.groundMatrix);
    widget.transform.addListener(_cameraChanged);
  }

  void _cameraChanged() {
    _projection.value = _camera();
    _ground.value = _projection.value.groundMatrix;
  }

  void _index() {
    final places = {for (final place in widget.places) place.id: place};
    final represented = <String>{};
    _features = [
      for (final room in widget.rooms)
        if (represented.add(room.roomId))
          _VolumePlace(
            room.path,
            room.roomId,
            places[room.roomId]?.label ?? room.name,
            places[room.roomId]?.kind ?? 'room',
            resolveMapPlaceAnchor(
              room.path,
              floorSize: widget.floorSize,
              place: places[room.roomId],
            ).point,
            synthetic: widget.syntheticRoomIds.contains(room.roomId),
          ),
      for (final place in widget.places)
        if (represented.add(place.id) && place.x.isFinite && place.y.isFinite)
          _VolumePlace(
            Path(),
            place.id,
            place.label,
            place.kind,
            Offset(place.x, place.y),
            synthetic: true,
          ),
      for (final landmark in widget.navigationLandmarks)
        if (represented.add(landmark.place.id))
          _VolumePlace(
            Path(),
            landmark.place.id,
            landmark.place.label,
            landmark.place.kind,
            Offset(landmark.place.x, landmark.place.y),
            synthetic: true,
            closed: landmark.closed,
          ),
    ];
    _features.sort((a, b) => b.priority.compareTo(a.priority));
    _overviewFeatures = [..._features]
      ..sort(
        (a, b) => (b.priority - (b.connector ? 1000 : 0)).compareTo(
          a.priority - (a.connector ? 1000 : 0),
        ),
      );
  }

  void _indexRouteMarkers() {
    Offset? start;
    Offset? end;
    for (final segment in widget.routeSegments) {
      for (final point in segment) {
        if (!point.isFinite) continue;
        start ??= point;
        end = point;
      }
    }
    _routeMarkers = [
      if (start != null) ...[
        if (widget.showRouteStart) (start, 8),
        if (widget.showRouteDestination) (end!, 11.5),
        if (widget.instructionPoint case final point? when point.isFinite)
          (point, 8),
      ],
    ];
  }

  @override
  void didUpdateWidget(MapVolumeLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.layers, oldWidget.layers) ||
        widget.floorSize != oldWidget.floorSize) {
      _mesh = MapVolumeMesh.fromLayers(
        widget.layers,
        floorSize: widget.floorSize,
      );
    }
    if (widget.rooms != oldWidget.rooms ||
        widget.places != oldWidget.places ||
        widget.navigationLandmarks != oldWidget.navigationLandmarks ||
        widget.syntheticRoomIds != oldWidget.syntheticRoomIds ||
        widget.floorSize != oldWidget.floorSize) {
      _index();
    }
    if (widget.transform != oldWidget.transform) {
      oldWidget.transform.removeListener(_cameraChanged);
      widget.transform.addListener(_cameraChanged);
    }
    if (widget.routeSegments != oldWidget.routeSegments ||
        widget.instructionPoint != oldWidget.instructionPoint ||
        widget.showRouteStart != oldWidget.showRouteStart ||
        widget.showRouteDestination != oldWidget.showRouteDestination) {
      _indexRouteMarkers();
    }
    if (widget.hitIndex != oldWidget.hitIndex) oldWidget.hitIndex?.clear();
    _cameraChanged();
  }

  @override
  void dispose() {
    widget.transform.removeListener(_cameraChanged);
    widget.hitIndex?.clear();
    _projection.dispose();
    _ground.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: ClipRect(
      child: SizedBox.fromSize(
        size: widget.viewportSize,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _VolumePainter(
                layers: widget.layers,
                mesh: _mesh,
                features: _features,
                projection: _projection,
                colors: context.colors,
                floorSize: widget.floorSize,
                selectedId: widget.selectedRoomId,
              ),
            ),
            if (widget.routeSegments.isNotEmpty)
              MapRouteLayer(
                size: widget.floorSize,
                viewportSize: widget.viewportSize,
                segments: widget.routeSegments,
                transform: _ground,
                instructionPoint: widget.instructionPoint,
                showStart: widget.showRouteStart,
                showDestination: widget.showRouteDestination,
              ),
            CustomPaint(
              painter: _VolumeLabelsPainter(
                features: _features,
                overviewFeatures: _overviewFeatures,
                routeMarkers: _routeMarkers,
                projection: _projection,
                colors: context.colors,
                selectedId: widget.selectedRoomId,
                hitIndex: widget.hitIndex,
                fontSize: MediaQuery.textScalerOf(
                  context,
                ).scale(11).clamp(11, 16),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _VolumePlace {
  _VolumePlace(
    this.path,
    this.id,
    this.label,
    this.kind,
    this.anchor, {
    required this.synthetic,
    this.closed = false,
  }) : bounds = path.getBounds();

  final Path path;
  final Rect bounds;
  final String id;
  final String label;
  final String kind;
  final Offset? anchor;
  final bool synthetic;
  final bool closed;
  static final _passagePattern = RegExp(
    r'^(коридор|холл|вестибюль|переход)(\s|$)',
    caseSensitive: false,
  );
  bool get passage =>
      const {'corridor', 'hall', 'hallway', 'passage'}.contains(kind) ||
      _passagePattern.hasMatch(label);
  bool get service => !passage && mapPlaceKindLabel(kind) != 'Аудитория';
  bool get connector => const {
    'stairs',
    'staircase',
    'elevator',
    'lift',
    'ramp',
    'escalator',
  }.contains(kind);
  int get priority => mapPlaceLandmarkPriority(kind);

  Color accent(AppColors colors) => switch (mapPlaceKindLabel(kind)) {
    'Еда' || 'Автомат' => colors.warn,
    'Библиотека' || 'Для учёбы' => colors.lab,
    'Медпункт' => colors.exam,
    'Лестница' || 'Лифт' || 'Пандус' || 'Эскалатор' => colors.muted,
    'Вход' || 'Банкомат' || 'Питьевая вода' => colors.lecture,
    _ => colors.accent,
  };
}

class _VolumePainter extends CustomPainter {
  _VolumePainter({
    required this.layers,
    required this.mesh,
    required this.features,
    required this.projection,
    required this.colors,
    required this.floorSize,
    required this.selectedId,
  }) : super(repaint: projection);

  final MapStructureLayers layers;
  final MapVolumeMesh mesh;
  final List<_VolumePlace> features;
  final ValueListenable<MapVolumeProjection> projection;
  final AppColors colors;
  final Size floorSize;
  final String? selectedId;

  @override
  void paint(Canvas canvas, Size size) {
    final camera = projection.value;
    final visible = camera.visibleSceneBounds.inflate(32 / camera.scale);
    final fill = Paint();
    canvas
      ..save()
      ..clipRect(Offset.zero & size)
      ..transform(camera.groundMatrix.storage);
    for (final shape in layers.foundationShapes) {
      if (!shape.fill ||
          shape.fillOpacity <= 0 ||
          !shape.bounds.overlaps(visible)) {
        continue;
      }
      canvas.save();
      shape.clips.forEach(canvas.clipPath);
      canvas
        ..drawPath(shape.path, fill..color = colors.surface)
        ..restore();
    }
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8 / camera.scale
      ..color = colors.muted2.withValues(alpha: .55);
    for (final feature in features) {
      if (feature.synthetic || !feature.bounds.overlaps(visible)) continue;
      final selected = feature.id == selectedId;
      canvas
        ..drawPath(
          feature.path,
          fill
            ..color = selected
                ? colors.tint2
                : feature.service
                ? colors.tintOf(
                    feature.accent(colors),
                    colors.isDark ? .24 : .16,
                  )
                : colors.surface2,
        )
        ..drawPath(feature.path, outline);
    }
    canvas.restore();
    final height = math.min(floorSize.shortestSide * .008, 20 / camera.scale);
    final lift = Offset(0, height * camera.scale * math.sin(camera.pitch));
    if (lift.dy <= .2) return;
    canvas
      ..save()
      ..clipRect(Offset.zero & size);
    final viewport = (Offset.zero & size).inflate(24);
    final faces = <_WallFace>[];
    for (final wall in mesh.walls) {
      if (!wall.bounds.overlaps(visible)) continue;
      final start = camera.sceneToScreen(wall.start);
      final end = camera.sceneToScreen(wall.end);
      final bounds = Rect.fromPoints(start, end).expandToInclude(
        Rect.fromPoints(start - lift, end - lift),
      );
      if (!bounds.overlaps(viewport)) continue;
      faces.add(_WallFace(start, end));
    }
    faces.sort((a, b) => a.depth.compareTo(b.depth));
    final rim = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.butt
      ..color = Color.alphaBlend(
        colors.ink.withValues(alpha: .24),
        colors.surface,
      );
    final facePath = Path();
    for (final face in faces) {
      final delta = face.end - face.start;
      final length = delta.distance;
      final shade = length > 0 ? (delta.dx / length).abs() : 0;
      canvas
        ..drawPath(
          facePath
            ..reset()
            ..moveTo(face.start.dx, face.start.dy)
            ..lineTo(face.end.dx, face.end.dy)
            ..lineTo(face.end.dx - lift.dx, face.end.dy - lift.dy)
            ..lineTo(face.start.dx - lift.dx, face.start.dy - lift.dy)
            ..close(),
          fill
            ..color = Color.alphaBlend(
              colors.muted.withValues(alpha: .24 + shade * .24),
              colors.surface,
            ),
        )
        ..drawLine(face.start - lift, face.end - lift, rim);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_VolumePainter oldDelegate) =>
      oldDelegate.layers != layers ||
      oldDelegate.mesh != mesh ||
      oldDelegate.features != features ||
      oldDelegate.projection != projection ||
      oldDelegate.colors != colors ||
      oldDelegate.floorSize != floorSize ||
      oldDelegate.selectedId != selectedId;
}

class _WallFace {
  const _WallFace(this.start, this.end);
  final Offset start;
  final Offset end;
  double get depth => (start.dy + end.dy) / 2;
}

class _VolumeLabelsPainter extends CustomPainter {
  _VolumeLabelsPainter({
    required this.features,
    required this.overviewFeatures,
    required this.routeMarkers,
    required this.projection,
    required this.colors,
    required this.selectedId,
    required this.hitIndex,
    required this.fontSize,
  }) : super(repaint: projection);

  final List<_VolumePlace> features;
  final ValueListenable<MapVolumeProjection> projection;
  final AppColors colors;
  final String? selectedId;
  final MapLabelHitIndex? hitIndex;
  final double fontSize;
  final List<_VolumePlace> overviewFeatures;
  final List<(Offset, double)> routeMarkers;
  static final _roomPrefix = RegExp(
    r'^(аудитория|ауд\.?|кабинет|каб\.?)\s+',
    caseSensitive: false,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final camera = projection.value;
    final viewport = Offset.zero & size;
    final groundMatrix = camera.groundMatrix;
    final routeScale = mapPlanarScale(groundMatrix).clamp(.01, 100.0);
    final reserved = [
      for (final (point, radius) in routeMarkers)
        MatrixUtils.transformRect(
          groundMatrix,
          Rect.fromCircle(center: point, radius: radius / routeScale),
        ).inflate(3),
    ].where((bounds) => bounds.overlaps(viewport)).toList();
    final labels = <MapLabelCandidate, (_VolumePlace, TextPainter?)>{};
    final textPainters = <TextPainter>[];
    final candidates = <MapLabelCandidate>[];
    final overview = camera.scale < .5;
    final overviewCaptions = <String>{};
    final categories = <String>{};
    if (overview) {
      for (final feature in features) {
        final anchor = feature.anchor;
        if (feature.connector ||
            feature.priority <= 0 ||
            feature.label.isEmpty ||
            anchor == null ||
            !viewport.contains(camera.sceneToScreen(anchor))) {
          continue;
        }
        if (categories.add(mapPlaceKindLabel(feature.kind))) {
          overviewCaptions.add(feature.id);
        }
        if (overviewCaptions.length >= 3) break;
      }
    }
    final orderedFeatures = overview ? overviewFeatures : features;
    final ordered = orderedFeatures
        .where((feature) => feature.id == selectedId)
        .followedBy(
          orderedFeatures.where((feature) => feature.id != selectedId),
        );
    for (final feature in ordered) {
      final anchor = feature.anchor;
      if (anchor == null || !anchor.isFinite) continue;
      final screen = camera.sceneToScreen(anchor);
      if (!viewport.inflate(32).contains(screen)) continue;
      final selected = selectedId == feature.id;
      final extent =
          math.min(feature.bounds.width, feature.bounds.height) *
          camera.scale *
          math.cos(camera.pitch);
      if (!selected && !feature.service && extent < 30) continue;
      if (!selected && feature.passage && extent < 100) continue;
      if (!selected &&
          feature.service &&
          feature.priority == 0 &&
          camera.scale < .025 &&
          extent < 20) {
        continue;
      }
      final caption =
          selected ||
          !feature.service ||
          overviewCaptions.contains(feature.id) ||
          (!overview && extent >= (feature.connector ? 84 : 60));
      final label = feature.label.replaceFirst(_roomPrefix, '');
      if (!feature.service && label.isEmpty) continue;
      final text = caption && label.isNotEmpty
          ? (TextPainter(
              text: TextSpan(
                text: label,
                style: AppText.captionStrong.copyWith(
                  color: selected ? colors.onAccent : colors.ink,
                  fontSize: fontSize,
                  height: 1.2,
                ),
              ),
              textDirection: TextDirection.ltr,
              maxLines: 1,
              ellipsis: '…',
            )..layout(maxWidth: selected ? 170 : 116))
          : null;
      if (text != null) textPainters.add(text);
      final dimensions = Size(
        (text?.width ?? 0) +
            (feature.service ? 18 : 0) +
            (feature.service && text != null ? 5 : 0) +
            10,
        math.max(text?.height ?? 0, feature.service ? 18 : 0) + 8,
      );
      final priority = selected
          ? 100000
          : feature.priority +
                (feature.service ? 100 : 0) -
                (overview && feature.connector ? 1000 : 0);
      void addLabel(TextPainter? caption, Size size, int rank) {
        final candidate = MapLabelCandidate(
          id: feature.id,
          anchor: screen,
          size: size,
          priority: rank,
        );
        if (!viewport.contains(candidate.bounds.topLeft) ||
            !viewport.contains(candidate.bounds.bottomRight) ||
            reserved.any(candidate.bounds.inflate(4).overlaps)) {
          return;
        }
        labels[candidate] = (feature, caption);
        candidates.add(candidate);
      }

      addLabel(text, dimensions, priority);
      if (feature.service && !selected && text != null) {
        addLabel(null, const Size(28, 26), priority - 1);
      }
      if (candidates.length >= 512) break;
    }
    final accepted = placeMapLabels(candidates, gap: 5);
    final hits = <String, Rect>{};
    final fill = Paint();
    for (final candidate in accepted.take(180)) {
      final (feature, text) = labels[candidate]!;
      final bounds = candidate.bounds;
      final selected = feature.id == selectedId;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          bounds,
          const Radius.circular(AppRadius.checkbox),
        ),
        fill
          ..color = selected
              ? colors.accent
              : colors.surface.withValues(alpha: .96),
      );
      var left = bounds.left + 5;
      if (feature.service) {
        final icon = feature.closed
            ? Icons.block_outlined
            : mapPlaceKindIcon(feature.kind);
        final glyph = TextPainter(
          text: TextSpan(
            text: String.fromCharCode(icon.codePoint),
            style: TextStyle(
              fontFamily: icon.fontFamily,
              package: icon.fontPackage,
              fontSize: 18,
              color: selected
                  ? colors.onAccent
                  : feature.closed
                  ? colors.exam
                  : feature.accent(colors),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        glyph
          ..paint(canvas, Offset(left, bounds.center.dy - glyph.height / 2))
          ..dispose();
        left += 23;
      }
      text?.paint(canvas, Offset(left, bounds.center.dy - text.height / 2));
      hits[candidate.id] = bounds.inflate(4);
    }
    hitIndex?.replace(hits);
    for (final text in textPainters) {
      text.dispose();
    }
  }

  @override
  bool shouldRepaint(_VolumeLabelsPainter oldDelegate) =>
      oldDelegate.features != features ||
      oldDelegate.routeMarkers != routeMarkers ||
      oldDelegate.projection != projection ||
      oldDelegate.colors != colors ||
      oldDelegate.selectedId != selectedId ||
      oldDelegate.hitIndex != hitIndex ||
      oldDelegate.fontSize != fontSize;
}
