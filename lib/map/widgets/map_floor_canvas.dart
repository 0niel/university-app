import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/map_label_hit_index.dart';
import 'package:rtu_mirea_app/map/services/map_navigation_landmarks.dart';
import 'package:rtu_mirea_app/map/widgets/map_cartographic_layer.dart';
import 'package:rtu_mirea_app/map/widgets/map_places_explorer.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_layer.dart';
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
    this.navigationLandmarks = const [],
    this.labelHitIndex,
    this.routeInstructionPoint,
    this.showRouteStart = true,
    this.showRouteDestination = true,
    this.viewportSize,
    super.key,
  });

  final String svgAssetPath;
  final Size canvasSize;
  final Size? viewportSize;
  final List<RoomModel> rooms;
  final String? selectedRoomId;
  final String? svgContent;
  final List<List<Offset>> routeSegments;
  final List<MapPlaceData> places;
  final ValueListenable<Matrix4>? transform;
  final bool showRoomLabels;
  final Set<String> syntheticRoomIds;
  final List<MapNavigationLandmark> navigationLandmarks;
  final MapLabelHitIndex? labelHitIndex;
  final Offset? routeInstructionPoint;
  final bool showRouteStart;
  final bool showRouteDestination;

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
            viewportSize: viewportSize,
            transform: transform,
            selectedRoomId: selectedRoomId,
            navigationLandmarks: navigationLandmarks,
            hitIndex: labelHitIndex,
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
            child: RepaintBoundary(
              child: MapRouteLayer(
                size: canvasSize,
                viewportSize: viewportSize,
                segments: routeSegments,
                transform: transform,
                instructionPoint: routeInstructionPoint,
                showStart: showRouteStart,
                showDestination: showRouteDestination,
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
