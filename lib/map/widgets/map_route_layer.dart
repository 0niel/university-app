import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/services/map_planar_scale.dart';

class MapRouteLayer extends StatelessWidget {
  const MapRouteLayer({
    required this.size,
    required this.segments,
    this.transform,
    this.instructionPoint,
    this.showStart = true,
    this.showDestination = true,
    super.key,
  });

  final Size size;
  final List<List<Offset>> segments;
  final ValueListenable<Matrix4>? transform;
  final Offset? instructionPoint;
  final bool showStart;
  final bool showDestination;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: SizedBox.fromSize(
      size: size,
      child: CustomPaint(
        painter: _RoutePainter(
          segments: segments,
          colors: context.colors,
          transform: transform,
          instructionPoint: instructionPoint,
          showStart: showStart,
          showDestination: showDestination,
        ),
      ),
    ),
  );
}

class _RoutePainter extends CustomPainter {
  _RoutePainter({
    required this.segments,
    required this.colors,
    required this.transform,
    required this.instructionPoint,
    required this.showStart,
    required this.showDestination,
  }) : parts = _routeParts(segments),
       super(repaint: transform);

  final List<List<Offset>> segments;
  final AppColors colors;
  final ValueListenable<Matrix4>? transform;
  final Offset? instructionPoint;
  final bool showStart;
  final bool showDestination;
  final List<_RoutePart> parts;

  @override
  void paint(Canvas canvas, Size size) {
    if (parts.isEmpty) return;
    final rawScale = transform == null ? 1.0 : mapPlanarScale(transform!.value);
    final scale = rawScale.isFinite && rawScale > 0
        ? rawScale.clamp(.01, 100.0)
        : 1.0;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final part in parts) {
      canvas.drawPath(
        part.path,
        stroke
          ..color = colors.surface
          ..strokeWidth = 7.5 / scale,
      );
    }
    for (final part in parts) {
      canvas.drawPath(
        part.path,
        stroke
          ..color = colors.accent
          ..strokeWidth = 4.5 / scale,
      );
    }

    final totalLength = parts.fold<double>(0, (sum, part) => sum + part.length);
    final spacing = math.max(54 / scale, totalLength / 160);
    final arrow = Paint()
      ..color = colors.onAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 / scale
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    var remainingArrows = 160;
    for (final part in parts) {
      var next = spacing / 2;
      var traversed = 0.0;
      for (final edge in part.edges) {
        final edgeEnd = traversed + edge.length;
        while (next < edgeEnd && remainingArrows > 0) {
          final localDistance = next - traversed;
          if (localDistance >= 7 / scale &&
              localDistance <= edge.length - 7 / scale &&
              next >= 18 / scale &&
              part.length - next >= 18 / scale) {
            final tip = edge.start + edge.direction * localDistance;
            final back = tip - edge.direction * (4.5 / scale);
            final side =
                Offset(-edge.direction.dy, edge.direction.dx) * (2.2 / scale);
            canvas.drawPath(
              Path()
                ..moveTo((back + side).dx, (back + side).dy)
                ..lineTo(tip.dx, tip.dy)
                ..lineTo((back - side).dx, (back - side).dy),
              arrow,
            );
            remainingArrows--;
          }
          next += spacing;
        }
        traversed = edgeEnd;
      }
    }

    if (showStart) {
      final start = parts.first.points.first;
      canvas
        ..drawCircle(start, 8 / scale, Paint()..color = colors.surface)
        ..drawCircle(
          start,
          5 / scale,
          stroke
            ..color = colors.accent
            ..strokeWidth = 2.5 / scale,
        );
    }
    if (showDestination) {
      final end = parts.last.points.last;
      final marker = RRect.fromRectAndRadius(
        Rect.fromCenter(center: end, width: 19 / scale, height: 19 / scale),
        Radius.circular(6 / scale),
      );
      canvas
        ..drawRRect(
          marker.inflate(2 / scale),
          Paint()..color = colors.surface,
        )
        ..drawRRect(marker, Paint()..color = colors.accent)
        ..save()
        ..translate(end.dx, end.dy)
        ..scale(1 / scale)
        ..drawPath(
          Path()
            ..moveTo(-3, 5)
            ..lineTo(-3, -5)
            ..lineTo(4, -5)
            ..lineTo(2, -1.5)
            ..lineTo(-3, -1.5),
          stroke
            ..color = colors.onAccent
            ..strokeWidth = 1.5,
        )
        ..restore();
    }
    final instruction = instructionPoint;
    if (instruction != null && instruction.isFinite) {
      canvas
        ..drawCircle(instruction, 8 / scale, Paint()..color = colors.surface)
        ..drawCircle(
          instruction,
          5.5 / scale,
          stroke
            ..color = colors.accent
            ..strokeWidth = 2 / scale,
        )
        ..drawCircle(instruction, 2 / scale, Paint()..color = colors.accent);
    }
  }

  @override
  bool shouldRepaint(_RoutePainter oldDelegate) =>
      oldDelegate.segments != segments ||
      oldDelegate.colors != colors ||
      oldDelegate.transform != transform ||
      oldDelegate.instructionPoint != instructionPoint ||
      oldDelegate.showStart != showStart ||
      oldDelegate.showDestination != showDestination;
}

List<_RoutePart> _routeParts(List<List<Offset>> segments) {
  final parts = <_RoutePart>[];
  for (final segment in segments) {
    var points = <Offset>[];
    void flush() {
      if (points.isNotEmpty) parts.add(_RoutePart(points));
      points = [];
    }

    for (final point in segment) {
      if (!point.isFinite) {
        flush();
        continue;
      }
      if (points.isEmpty) {
        points.add(point);
      } else {
        final distance = (point - points.last).distance;
        if (!distance.isFinite) {
          flush();
          points.add(point);
        } else if (distance > 1e-9) {
          points.add(point);
        }
      }
    }
    flush();
  }
  return parts;
}

class _RoutePart {
  _RoutePart(this.points) {
    path.moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final start = points[i - 1];
      final delta = points[i] - start;
      final distance = delta.distance;
      edges.add(_RouteEdge(start, delta / distance, distance));
      length += distance;
      path.lineTo(points[i].dx, points[i].dy);
    }
  }

  final List<Offset> points;
  final Path path = Path();
  final List<_RouteEdge> edges = [];
  double length = 0;
}

class _RouteEdge {
  const _RouteEdge(this.start, this.direction, this.length);

  final Offset start;
  final Offset direction;
  final double length;
}
