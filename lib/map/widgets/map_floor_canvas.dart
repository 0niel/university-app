import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/map_planar_scale.dart';
import 'package:rtu_mirea_app/map/widgets/map_cartographic_layer.dart';
import 'package:rtu_mirea_app/map/widgets/map_places_explorer.dart';
import 'package:rtu_mirea_app/map/widgets/map_svg_colors.dart';
import 'package:rtu_mirea_app/map/widgets/rooms_highlight_painter.dart';

class MapFloorCanvas extends StatelessWidget {
  const MapFloorCanvas({
    required this.svgAssetPath,
    required this.canvasSize,
    required this.rooms,
    this.selectedRoomId,
    this.svgContent,
    this.routeSegments = const [],
    this.places = const [],
    this.transform,
    this.showRoomLabels = false,
    this.syntheticRoomIds = const {},
    super.key,
  });

  final String svgAssetPath;
  final Size canvasSize;
  final List<RoomModel> rooms;
  final String? selectedRoomId;
  final String? svgContent;
  final List<List<Offset>> routeSegments;
  final List<MapPlaceData> places;
  final ValueListenable<Matrix4>? transform;
  final bool showRoomLabels;
  final Set<String> syntheticRoomIds;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showRoomLabels)
          MapCartographicLayer(
            svgContent: svgContent,
            syntheticRoomIds: syntheticRoomIds,
            rooms: rooms,
            places: places,
            size: canvasSize,
            transform: transform,
            selectedRoomId: selectedRoomId,
          )
        else
          SizedBox(
            width: canvasSize.width,
            height: canvasSize.height,
            child: svgContent != null
                ? SvgPicture.string(
                    svgContent!,
                    colorMapper: MapSvgColors(context.colors),
                    fit: BoxFit.none,
                    alignment: Alignment.topLeft,
                    allowDrawingOutsideViewBox: true,
                  )
                : SvgPicture.asset(
                    svgAssetPath,
                    fit: BoxFit.none,
                    alignment: Alignment.topLeft,
                    allowDrawingOutsideViewBox: true,
                  ),
          ),
        if (!showRoomLabels)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: RoomsHighlightPainter(
                  rooms,
                  selectedRoomId: selectedRoomId,
                  highlightColor: context.colors.accent,
                ),
              ),
            ),
          ),
        if (places.isNotEmpty && !showRoomLabels)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _PlaceMarkerPainter(
                  places,
                  context.colors.accent,
                  context.colors.surface,
                ),
              ),
            ),
          ),
        if (routeSegments.isNotEmpty)
          Positioned.fill(
            child: IgnorePointer(
              child: ValueListenableBuilder<Matrix4>(
                valueListenable:
                    transform ?? AlwaysStoppedAnimation(Matrix4.identity()),
                builder: (context, matrix, _) => CustomPaint(
                  painter: _RoutePainter(
                    routeSegments,
                    context.colors.accent,
                    context.colors.surface,
                    mapPlanarScale(matrix).clamp(.01, 100),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PlaceMarkerPainter extends CustomPainter {
  const _PlaceMarkerPainter(this.places, this.color, this.background);

  final List<MapPlaceData> places;
  final Color color;
  final Color background;

  @override
  void paint(Canvas canvas, Size size) {
    for (final place in places) {
      final center = Offset(place.x, place.y);
      canvas.drawCircle(center, 12, Paint()..color = background);
      final icon = mapPlaceKindIcon(place.kind);
      final painter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
            fontSize: 18,
            color: color,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter
        ..paint(canvas, center - Offset(painter.width / 2, painter.height / 2))
        ..dispose();
    }
  }

  @override
  bool shouldRepaint(_PlaceMarkerPainter oldDelegate) =>
      oldDelegate.places != places ||
      oldDelegate.color != color ||
      oldDelegate.background != background;
}

class _RoutePainter extends CustomPainter {
  const _RoutePainter(this.segments, this.color, this.outline, this.scale);

  final List<List<Offset>> segments;
  final Color color;
  final Color outline;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final segment in segments) {
      if (segment.isEmpty) continue;
      final path = Path()..moveTo(segment.first.dx, segment.first.dy);
      for (final point in segment.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas
        ..drawPath(
          path,
          paint
            ..color = outline
            ..strokeWidth = 9 / scale,
        )
        ..drawPath(
          path,
          paint
            ..color = color
            ..strokeWidth = 5 / scale,
        );
      for (final point in [segment.first, segment.last]) {
        canvas
          ..drawCircle(point, 7 / scale, Paint()..color = outline)
          ..drawCircle(point, 4 / scale, Paint()..color = color);
      }
    }
  }

  @override
  bool shouldRepaint(_RoutePainter oldDelegate) =>
      oldDelegate.segments != segments ||
      oldDelegate.color != color ||
      oldDelegate.outline != outline ||
      oldDelegate.scale != scale;
}
