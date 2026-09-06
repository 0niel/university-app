import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/map_label_layout.dart';
import 'package:rtu_mirea_app/map/services/map_place_anchor.dart';
import 'package:rtu_mirea_app/map/services/map_place_landmarks.dart';
import 'package:rtu_mirea_app/map/services/map_planar_scale.dart';
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
    super.key,
  });

  final List<RoomModel> rooms;
  final List<MapPlaceData> places;
  final Size size;
  final ValueListenable<Matrix4>? transform;
  final String? selectedRoomId;
  final String? svgContent;
  final Set<String> syntheticRoomIds;

  @override
  State<MapCartographicLayer> createState() => _MapCartographicLayerState();
}

class _MapCartographicLayerState extends State<MapCartographicLayer> {
  List<_Feature> _features = [];
  double _scale = 1;

  @override
  void initState() {
    super.initState();
    _index();
    _readScale();
    widget.transform?.addListener(_zoomChanged);
  }

  void _index() {
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
    if (_scale != before) setState(() {});
  }

  @override
  void didUpdateWidget(MapCartographicLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.rooms, widget.rooms) ||
        oldWidget.size != widget.size ||
        !listEquals(oldWidget.places, widget.places) ||
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
    widget.transform?.removeListener(_zoomChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
    size: widget.size,
    child: Stack(
      fit: StackFit.expand,
      children: [
        if (widget.svgContent case final svg?)
          MapStructureLayer(
            svg: svg,
            size: widget.size,
            transform: widget.transform,
          ),
        RepaintBoundary(
          child: CustomPaint(
            painter: _RoomsPainter(
              _features,
              context.colors,
              widget.selectedRoomId,
              widget.transform,
            ),
          ),
        ),
        if (widget.svgContent case final svg?)
          MapStructureLayer(
            svg: svg,
            size: widget.size,
            openingsOnly: true,
            transform: widget.transform,
          ),
        RepaintBoundary(
          child: CustomPaint(
            painter: _LabelsPainter(
              _features,
              context.colors,
              _scale,
              widget.selectedRoomId,
              MediaQuery.textScalerOf(context).scale(11).clamp(11, 16),
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
  }) : bounds = room.path.getBounds(),
       location = resolveMapPlaceAnchor(
         room.path,
         floorSize: floorSize,
         place: place,
       );

  final RoomModel room;
  final MapPlaceData? place;
  final bool synthetic;
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
  late final int landmarkPriority = mapPlaceLandmarkPriority(kind);

  Color accent(AppColors colors) => switch (mapPlaceKindLabel(kind)) {
    'Еда' || 'Автомат' => colors.warn,
    'Библиотека' || 'Для учёбы' => colors.lab,
    'Медпункт' => colors.exam,
    'Вход' || 'Банкомат' || 'Питьевая вода' => colors.lecture,
    _ => colors.accent,
  };
}

class _RoomsPainter extends CustomPainter {
  _RoomsPainter(this.features, this.colors, this.selectedId, this.transform)
    : super(repaint: transform);
  final List<_Feature> features;
  final AppColors colors;
  final String? selectedId;
  final ValueListenable<Matrix4>? transform;

  @override
  void paint(Canvas canvas, Size size) {
    final raw = transform == null ? 1.0 : mapPlanarScale(transform!.value);
    final scale = raw.isFinite && raw > 0 ? raw : 1.0;
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 1 / scale
      ..color = Color.alphaBlend(
        colors.muted2.withValues(alpha: .72),
        colors.surface,
      );
    for (final feature in features) {
      if (feature.synthetic) continue;
      final selected =
          feature.room.roomId == selectedId && !feature.detachedService;
      final fill = selected
          ? colors.tint2
          : feature.passage
          ? colors.surface
          : feature.service && !feature.detachedService
          ? colors.tintOf(feature.accent(colors), colors.isDark ? .24 : .17)
          : Color.alphaBlend(
              colors.accent.withValues(alpha: colors.isDark ? .17 : .11),
              colors.surface2,
            );
      canvas
        ..drawPath(feature.room.path, Paint()..color = fill)
        ..drawPath(feature.room.path, outline);
      if (selected) {
        canvas.drawPath(
          feature.room.path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1.2 / scale
            ..color = colors.accent,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_RoomsPainter old) =>
      old.features != features ||
      old.colors != colors ||
      old.selectedId != selectedId ||
      old.transform != transform;
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
  );
  final List<_Feature> features;
  final AppColors colors;
  final double scale;
  final String? selectedId;
  final double fontSize;

  @override
  void paint(Canvas canvas, Size size) {
    final labels = <String, _Label>{};
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
        if (overviewLabels.length == 3) break;
      }
    }
    for (final feature in features) {
      final anchor = feature.anchor;
      if (anchor == null) continue;
      final width = feature.bounds.width * scale;
      final height = feature.bounds.height * scale;
      final selected = selectedId == feature.room.roomId;
      final service = feature.service;
      final landmark = feature.landmarkPriority > 0;
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
              (!overview && width >= 80 && height >= 44));
      TextPainter? text;
      if (withText) {
        text =
            TextPainter(
              text: TextSpan(
                text: feature.label,
                style: AppText.captionStrong.copyWith(
                  fontSize: fontSize,
                  color: selected
                      ? colors.accent
                      : feature.passage
                      ? colors.muted
                      : colors.ink,
                  height: 1.15,
                  letterSpacing: feature.passage ? .4 : 0,
                ),
              ),
              textDirection: TextDirection.ltr,
              maxLines: 1,
              ellipsis: selected || service ? '…' : null,
            )..layout(
              maxWidth: selected || service ? 170 : double.infinity,
            );
        if (!selected && !service && text.width > width * 1.35) {
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
      labels[feature.room.roomId] = _Label(
        feature,
        text,
        icon,
        labelSize,
        anchor,
      );
      candidates.add(
        MapLabelCandidate(
          id: feature.room.roomId,
          anchor: anchor * scale,
          size: labelSize,
          priority: selected
              ? 100000
              : service
              ? 10000 + feature.landmarkPriority
              : feature.passage
              ? 500
              : math.min(400, (width * height / 100).round()),
        ),
      );
    }
    final accepted = placeMapLabels(candidates, gap: 3);
    for (final candidate in accepted) {
      final label = labels[candidate.id]!;
      final selected = candidate.id == selectedId;
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
      }
      if (label.text case final text?) {
        final origin = Offset(
          -text.width / 2,
          rect.bottom - text.height - (selected ? 4 : 0),
        );
        if (!selected) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              (origin & text.size).inflate(2),
              const Radius.circular(AppRadius.bar),
            ),
            Paint()
              ..color =
                  (label.feature.passage ? colors.surface : colors.surface2)
                      .withValues(alpha: .72),
          );
        }
        text.paint(canvas, origin);
      }
      canvas.restore();
    }
    for (final label in labels.values) {
      label.text?.dispose();
    }
  }

  @override
  bool shouldRepaint(_LabelsPainter old) =>
      old.features != features ||
      old.colors != colors ||
      old.scale != scale ||
      old.selectedId != selectedId ||
      old.fontSize != fontSize;
}
