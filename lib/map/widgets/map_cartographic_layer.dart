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
import 'package:rtu_mirea_app/map/services/map_scale_repaint.dart';
import 'package:rtu_mirea_app/map/services/map_viewport_painter.dart';
import 'package:rtu_mirea_app/map/widgets/map_places_explorer.dart';
import 'package:rtu_mirea_app/map/widgets/map_structure_layer.dart';

class MapCartographicLayer extends StatefulWidget {
  const MapCartographicLayer({
    required this.rooms,
    required this.places,
    required this.size,
    this.transform,
    this.selectedRoomId,
    this.svgContent,
    this.syntheticRoomIds = const {},
    this.navigationLandmarks = const [],
    this.hitIndex,
    this.viewportSize,
    super.key,
  });

  final List<RoomModel> rooms;
  final List<MapPlaceData> places;
  final Size size;
  final ValueListenable<Matrix4>? transform;
  final String? selectedRoomId;
  final String? svgContent;
  final Set<String> syntheticRoomIds;
  final List<MapNavigationLandmark> navigationLandmarks;
  final MapLabelHitIndex? hitIndex;
  final Size? viewportSize;

  @override
  State<MapCartographicLayer> createState() => _MapCartographicLayerState();
}

class _MapCartographicLayerState extends State<MapCartographicLayer> {
  List<_Feature> _features = [];
  double _scale = 1;
  late final MapScaleRepaint _strokeScale;

  @override
  void initState() {
    super.initState();
    _strokeScale = MapScaleRepaint(widget.transform);
    _index();
    _readScale();
    widget.transform?.addListener(_zoomChanged);
  }

  void _index() {
    widget.hitIndex?.clear();
    final places = {for (final place in widget.places) place.id: place};
    final previous = {
      for (final feature in _features) feature.room.roomId: feature,
    };
    _Feature featureFor(RoomModel room) {
      final cached = previous[room.roomId];
      final place = places[room.roomId];
      final synthetic = widget.syntheticRoomIds.contains(room.roomId);
      if (cached != null &&
          identical(cached.room.path, room.path) &&
          cached.room.name == room.name &&
          identical(cached.place, place) &&
          cached.floorSize == widget.size &&
          cached.synthetic == synthetic) {
        return cached;
      }
      return _Feature(
        room,
        place,
        synthetic: synthetic,
        floorSize: widget.size,
      );
    }

    _features = [
      for (final room in widget.rooms) featureFor(room),
      for (final landmark in widget.navigationLandmarks)
        _Feature(
          RoomModel(
            roomId: landmark.place.id,
            name: landmark.place.label,
            path: Path()
              ..addOval(
                Rect.fromCircle(
                  center: Offset(landmark.place.x, landmark.place.y),
                  radius: AppRadius.iconTile,
                ),
              ),
          ),
          landmark.place,
          synthetic: true,
          floorSize: widget.size,
          closed: landmark.closed,
        ),
    ];
  }

  void _readScale() {
    final matrix = widget.transform?.value;
    final raw = matrix == null ? 1.0 : mapPlanarScale(matrix);
    if (raw.isFinite && raw > 0) {
      _scale = math
          .pow(1.12, (math.log(raw) / math.log(1.12)).floor())
          .toDouble();
    }
  }

  void _zoomChanged() {
    final before = _scale;
    _readScale();
    if (_scale != before) {
      widget.hitIndex?.clear();
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(MapCartographicLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _strokeScale.updateTransform(widget.transform);
    if (oldWidget.hitIndex != widget.hitIndex) {
      oldWidget.hitIndex?.clear();
      widget.hitIndex?.clear();
    }
    if (oldWidget.selectedRoomId != widget.selectedRoomId ||
        oldWidget.transform != widget.transform) {
      widget.hitIndex?.clear();
    }
    if (!listEquals(oldWidget.rooms, widget.rooms) ||
        oldWidget.size != widget.size ||
        !listEquals(oldWidget.places, widget.places) ||
        !listEquals(
          oldWidget.navigationLandmarks,
          widget.navigationLandmarks,
        ) ||
        !setEquals(oldWidget.syntheticRoomIds, widget.syntheticRoomIds)) {
      _index();
    }
    if (oldWidget.transform != widget.transform) {
      oldWidget.transform?.removeListener(_zoomChanged);
      widget.transform?.addListener(_zoomChanged);
      _readScale();
    }
  }

  @override
  void dispose() {
    widget.hitIndex?.clear();
    widget.transform?.removeListener(_zoomChanged);
    _strokeScale.dispose();
    super.dispose();
  }

  CustomPainter _painter(CustomPainter painter) => widget.viewportSize == null
      ? painter
      : MapViewportPainter(
          painter: painter,
          sceneSize: widget.size,
          transform: widget.transform,
        );

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
    size: widget.viewportSize ?? widget.size,
    child: Stack(
      fit: StackFit.expand,
      children: [
        if (widget.svgContent case final svg?)
          MapStructureLayer(
            svg: svg,
            size: widget.size,
            transform: widget.transform,
            viewportSize: widget.viewportSize,
          ),
        RepaintBoundary(
          child: CustomPaint(
            painter: _painter(
              _RoomsPainter(
                _features,
                context.colors,
                widget.selectedRoomId,
                _strokeScale,
              ),
            ),
          ),
        ),
        if (widget.svgContent case final svg?)
          MapStructureLayer(
            svg: svg,
            size: widget.size,
            openingsOnly: true,
            transform: widget.transform,
            viewportSize: widget.viewportSize,
          ),
        RepaintBoundary(
          child: CustomPaint(
            painter: _painter(
              _LabelsPainter(
                _features,
                context.colors,
                _scale,
                widget.selectedRoomId,
                MediaQuery.textScalerOf(context).scale(11).clamp(11, 16),
                widget.hitIndex,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _Feature {
  _Feature(
    this.room,
    this.place, {
    required this.synthetic,
    required this.floorSize,
    this.closed = false,
  }) : bounds = room.path.getBounds(),
       location = resolveMapPlaceAnchor(
         room.path,
         floorSize: floorSize,
         place: place,
       );

  final RoomModel room;
  final MapPlaceData? place;
  final bool synthetic;
  final bool closed;
  final Size floorSize;
  final Rect bounds;
  final MapPlaceAnchor location;
  Offset? get anchor => location.point;
  bool get detachedService => location.detachedService;
  static final RegExp _passagePattern = RegExp(
    r'^(коридор|холл|вестибюль|переход)(\s|$)',
    caseSensitive: false,
  );

  String get label => place?.label ?? room.name;
  String get kind => place?.kind ?? 'room';
  late final String category = mapPlaceKindLabel(kind);
  late final bool passage = _passagePattern.hasMatch(label);
  late final bool service = synthetic || category != 'Аудитория';
  late final bool connector = const {
    'stairs',
    'staircase',
    'elevator',
    'lift',
    'ramp',
    'escalator',
  }.contains(kind);
  late final int landmarkPriority = mapPlaceLandmarkPriority(kind);
  late final String compactLabel = _compactLabel(label);

  static String _compactLabel(String label) => label.replaceFirst(
    RegExp(r'^(аудитория|ауд\.?|кабинет|каб\.?)\s+', caseSensitive: false),
    '',
  );

  Color accent(AppColors colors) => switch (mapPlaceKindLabel(kind)) {
    'Еда' || 'Автомат' => colors.warn,
    'Библиотека' || 'Для учёбы' => colors.lab,
    'Медпункт' => colors.exam,
    'Лестница' || 'Лифт' || 'Пандус' || 'Эскалатор' => colors.muted,
    'Вход' || 'Банкомат' || 'Питьевая вода' => colors.lecture,
    _ => colors.accent,
  };
}

class _RoomsPainter extends CustomPainter {
  _RoomsPainter(this.features, this.colors, this.selectedId, this.scale)
    : super(repaint: scale);
  final List<_Feature> features;
  final AppColors colors;
  final String? selectedId;
  final ValueListenable<double> scale;

  @override
  void paint(Canvas canvas, Size size) {
    final visible = canvas.getLocalClipBounds().inflate(2 / scale.value);
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 1 / scale.value
      ..color = Color.alphaBlend(
        colors.muted2.withValues(alpha: .72),
        colors.surface,
      );
    final roomFill = Paint();
    final selectedOutline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 1.2 / scale.value
      ..color = colors.accent;
    for (final feature in features) {
      if (feature.synthetic || !feature.bounds.overlaps(visible)) continue;
      final selected =
          feature.room.roomId == selectedId && !feature.detachedService;
      final fill = selected
          ? colors.tint2
          : feature.passage
          ? colors.surface
          : feature.service && !feature.detachedService
          ? colors.tintOf(feature.accent(colors), colors.isDark ? .24 : .17)
          : Color.alphaBlend(
              colors.accent.withValues(alpha: colors.isDark ? .07 : .035),
              colors.surface2,
            );
      canvas
        ..drawPath(feature.room.path, roomFill..color = fill)
        ..drawPath(feature.room.path, outline);
      if (selected) {
        canvas.drawPath(
          feature.room.path,
          selectedOutline,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_RoomsPainter old) =>
      old.features != features ||
      old.colors != colors ||
      old.selectedId != selectedId ||
      old.scale != scale;
}

class _Label {
  const _Label(this.feature, this.text, this.icon, this.size, this.anchor);
  final _Feature feature;
  final TextPainter? text;
  final IconData? icon;
  final Size size;
  final Offset anchor;
}

class _LabelsPainter extends CustomPainter {
  const _LabelsPainter(
    this.features,
    this.colors,
    this.scale,
    this.selectedId,
    this.fontSize,
    this.hitIndex,
  );
  final List<_Feature> features;
  final AppColors colors;
  final double scale;
  final String? selectedId;
  final double fontSize;
  final MapLabelHitIndex? hitIndex;

  @override
  void paint(Canvas canvas, Size size) {
    hitIndex?.clear();
    final hitBounds = <String, Rect>{};
    final visible = canvas.getLocalClipBounds();
    final labelArea = visible.inflate(200 / scale);
    final labels = <MapLabelCandidate, _Label>{};
    final candidates = <MapLabelCandidate>[];
    final overview = scale < .5;
    final overviewLabels = <String>{};
    if (overview) {
      final landmarks =
          features
              .where(
                (feature) =>
                    feature.landmarkPriority > 0 && feature.label.isNotEmpty,
              )
              .toList()
            ..sort((a, b) {
              final priority = b.landmarkPriority.compareTo(a.landmarkPriority);
              return priority == 0
                  ? a.room.roomId.compareTo(b.room.roomId)
                  : priority;
            });
      final categories = <String>{};
      for (final landmark in landmarks) {
        if (categories.add(landmark.category)) {
          overviewLabels.add(landmark.room.roomId);
        }
        if (overviewLabels.length == 4) break;
      }
    }
    for (final feature in features) {
      final anchor = feature.anchor;
      if (anchor == null || !labelArea.contains(anchor)) continue;
      final width = feature.bounds.width * scale;
      final height = feature.bounds.height * scale;
      final selected = selectedId == feature.room.roomId;
      final service = feature.service;
      final landmark = feature.landmarkPriority > 0;
      final detail = width >= 130 && height >= 55;
      if (!service && feature.label.isEmpty) continue;
      if (!selected && !service && (width < 34 || height < fontSize + 7)) {
        continue;
      }
      if (!selected &&
          service &&
          !feature.synthetic &&
          !feature.detachedService &&
          !landmark &&
          math.max(width, height) < 16) {
        continue;
      }
      if (!selected && feature.passage && (width < 120 || height < 28)) {
        continue;
      }
      final withText =
          feature.label.isNotEmpty &&
          (selected ||
              !service ||
              overviewLabels.contains(feature.room.roomId) ||
              (feature.connector && width >= 58 && height >= 38) ||
              (!overview && width >= 80 && height >= 44));
      TextPainter? text;
      if (withText) {
        text =
            TextPainter(
              text: TextSpan(
                text: selected || detail
                    ? feature.label
                    : feature.connector
                    ? feature.category
                    : feature.compactLabel,
                style: AppText.captionStrong.copyWith(
                  fontSize: fontSize,
                  color: selected
                      ? colors.accent
                      : feature.passage
                      ? colors.muted
                      : colors.ink,
                  height: 1.2,
                  shadows: [
                    Shadow(color: colors.surface, blurRadius: 3),
                    Shadow(color: colors.surface, blurRadius: 2),
                  ],
                  letterSpacing: feature.passage ? .4 : 0,
                ),
              ),
              textDirection: TextDirection.ltr,
              maxLines: selected || detail ? 2 : 1,
              ellipsis: '…',
            )..layout(
              maxWidth: selected || service ? 160 : math.min(180, width * .9),
            );
        if (!selected &&
            !service &&
            (text.didExceedMaxLines && !detail || text.height > height - 8)) {
          text.dispose();
          continue;
        }
      }
      final labelSize = Size(
        math.max(
          service || selected ? 24 : 0,
          (text?.width ?? 0) + (selected ? 16 : 0),
        ),
        (text?.height ?? 0) + (service ? 25 : 0) + (selected ? 8 : 0),
      );
      final icon = service ? mapPlaceKindIcon(feature.kind) : null;
      final priority = selected
          ? 100000
          : service
          ? 10000 +
                feature.landmarkPriority -
                (overview && feature.connector ? 1000 : 0)
          : feature.passage
          ? 500
          : math.min(400, (width * height / 100).round());
      void addLabel(TextPainter? caption, Size dimensions, int rank) {
        final candidate = MapLabelCandidate(
          id: feature.room.roomId,
          anchor: anchor * scale,
          size: dimensions,
          priority: rank,
        );
        candidates.add(candidate);
        labels[candidate] = _Label(feature, caption, icon, dimensions, anchor);
      }

      addLabel(text, labelSize, priority);
      if (service && !selected && text != null) {
        addLabel(null, const Size(24, 25), priority - 1);
      }
    }
    final accepted = placeMapLabels(candidates, gap: 3);
    for (final candidate in accepted) {
      final label = labels[candidate]!;
      final selected = label.feature.room.roomId == selectedId;
      if (!Rect.fromCenter(
        center: label.anchor,
        width: (label.size.width + 6) / scale,
        height: (label.size.height + 6) / scale,
      ).overlaps(visible)) {
        continue;
      }
      canvas
        ..save()
        ..translate(label.anchor.dx, label.anchor.dy)
        ..scale(1 / scale);
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: label.size.width,
        height: label.size.height,
      );
      if (selected) {
        final rounded = RRect.fromRectAndRadius(
          rect.inflate(2),
          const Radius.circular(AppRadius.checkbox),
        );
        canvas
          ..drawRRect(
            rounded.shift(const Offset(0, 2)),
            Paint()..color = colors.scrim.withValues(alpha: .15),
          )
          ..drawRRect(rounded, Paint()..color = colors.surface);
      }
      if (label.icon case final icon?) {
        final center = Offset(0, rect.top + 11 + (selected ? 4 : 0));
        canvas
          ..drawCircle(
            center + const Offset(0, 1),
            12,
            Paint()..color = colors.scrim.withValues(alpha: .12),
          )
          ..drawCircle(center, 11, Paint()..color = colors.surface);
        final painter = TextPainter(
          text: TextSpan(
            text: String.fromCharCode(icon.codePoint),
            style: TextStyle(
              fontFamily: icon.fontFamily,
              package: icon.fontPackage,
              fontSize: 16,
              color: label.feature.accent(colors),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        painter
          ..paint(
            canvas,
            center - Offset(painter.width / 2, painter.height / 2),
          )
          ..dispose();
        if (label.feature.closed) {
          final badge = center + const Offset(8, 8);
          canvas
            ..drawCircle(badge, AppRadius.xs, Paint()..color = colors.exam)
            ..drawLine(
              badge - const Offset(2.5, 0),
              badge + const Offset(2.5, 0),
              Paint()
                ..color = colors.surface
                ..strokeWidth = 1.5,
            );
        }
      }
      if (label.text case final text?) {
        final origin = Offset(
          -text.width / 2,
          rect.bottom - text.height - (selected ? 4 : 0),
        );
        text.paint(canvas, origin);
      }
      canvas.restore();
      var target = rect.inflate(selected ? 2 : 0);
      if (label.feature.closed && label.icon != null) {
        target = target.expandToInclude(
          Rect.fromCircle(
            center: Offset(8, rect.top + 19 + (selected ? 4 : 0)),
            radius: AppRadius.xs,
          ),
        );
      }
      hitBounds[label.feature.room.roomId] = Rect.fromLTRB(
        label.anchor.dx + target.left / scale,
        label.anchor.dy + target.top / scale,
        label.anchor.dx + target.right / scale,
        label.anchor.dy + target.bottom / scale,
      );
    }
    for (final label in labels.values) {
      label.text?.dispose();
    }
    hitIndex?.replace(hitBounds);
  }

  @override
  bool shouldRepaint(_LabelsPainter old) =>
      old.features != features ||
      old.colors != colors ||
      old.scale != scale ||
      old.selectedId != selectedId ||
      old.fontSize != fontSize ||
      old.hitIndex != hitIndex;
}
