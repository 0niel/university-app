import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

List<DrawingStroke> decodeDrawingStrokes(String json) {
  try {
    final raw = jsonDecode(json);
    if (raw is! List) return const [];
    return [
      for (final entry in raw)
        if (entry is Map)
          DrawingStroke.fromJson(Map<String, Object?>.from(entry)),
    ];
  } on FormatException {
    return const [];
  }
}

class DrawingStroke {
  const DrawingStroke({
    required this.points,
    required this.color,
    required this.width,
    this.isEraser = false,
    this.canvasSize,
  });

  factory DrawingStroke.fromJson(Map<String, Object?> json) {
    final rawPoints = json['points'];
    final points = <PointVector>[
      if (rawPoints is List)
        for (final entry in rawPoints)
          if (entry is List &&
              entry.length >= 2 &&
              entry[0] is num &&
              entry[1] is num &&
              (entry[0] as num).isFinite &&
              (entry[1] as num).isFinite)
            PointVector(
              (entry[0] as num).toDouble(),
              (entry[1] as num).toDouble(),
              json['simulatePressure'] == true
                  ? null
                  : entry.length > 2 &&
                        entry[2] is num &&
                        (entry[2] as num).isFinite
                  ? (entry[2] as num).toDouble().clamp(0, 1)
                  : 1,
            ),
    ];
    return DrawingStroke(
      points: points,
      color: Color(json['color'] is int ? json['color']! as int : 0xFF000000),
      width: json['width'] is num && (json['width']! as num).isFinite
          ? (json['width']! as num).toDouble().clamp(0.1, 100)
          : 6,
      isEraser: json['eraser'] == true,
      canvasSize: switch (json['canvas']) {
        [final num width, final num height]
            when width.isFinite && height.isFinite && width > 0 && height > 0 =>
          Size(width.toDouble(), height.toDouble()),
        _ => null,
      },
    );
  }

  final List<PointVector> points;
  final Color color;
  final double width;
  final bool isEraser;
  final Size? canvasSize;

  DrawingStroke withCanvasSize(Size size) => DrawingStroke(
    points: points,
    color: color,
    width: width,
    isEraser: isEraser,
    canvasSize: size,
  );

  Map<String, Object?> toJson() => {
    'points': [
      for (final point in points) [point.x, point.y, point.pressure ?? 1],
    ],
    'color': color.toARGB32(),
    'width': width,
    'eraser': isEraser,
    if (points.every((point) => point.pressure == null))
      'simulatePressure': true,
    if (canvasSize case final size?) 'canvas': [size.width, size.height],
  };

  List<Offset> outline() {
    return getStroke(
      points,
      options: StrokeOptions(
        size: width,
        thinning: 0.6,
        smoothing: 0.5,
        streamline: 0.5,
        simulatePressure: points.every((point) => point.pressure == null),
      ),
    );
  }
}
