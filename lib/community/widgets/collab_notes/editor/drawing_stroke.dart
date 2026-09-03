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
  });

  factory DrawingStroke.fromJson(Map<String, Object?> json) {
    final rawPoints = json['points'];
    final points = <PointVector>[
      if (rawPoints is List)
        for (final entry in rawPoints)
          if (entry is List && entry.length >= 2)
            PointVector(
              (entry[0] as num).toDouble(),
              (entry[1] as num).toDouble(),
              entry.length > 2 ? (entry[2] as num).toDouble() : 1,
            ),
    ];
    return DrawingStroke(
      points: points,
      color: Color(json['color'] as int? ?? 0xFF000000),
      width: (json['width'] as num?)?.toDouble() ?? 6,
      isEraser: json['eraser'] as bool? ?? false,
    );
  }

  final List<PointVector> points;
  final Color color;
  final double width;
  final bool isEraser;

  Map<String, Object?> toJson() => {
    'points': [
      for (final point in points) [point.x, point.y, point.pressure ?? 1.0],
    ],
    'color': color.toARGB32(),
    'width': width,
    'eraser': isEraser,
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
