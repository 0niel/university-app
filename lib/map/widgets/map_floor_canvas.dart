import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/widgets/rooms_highlight_painter.dart';

class MapFloorCanvas extends StatelessWidget {
  const MapFloorCanvas({
    required this.svgAssetPath,
    required this.canvasSize,
    required this.rooms,
    this.selectedRoomId,
    super.key,
  });

  final String svgAssetPath;
  final Size canvasSize;
  final List<RoomModel> rooms;
  final String? selectedRoomId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: canvasSize.width,
          height: canvasSize.height,
          child: SvgPicture.asset(
            svgAssetPath,
            fit: BoxFit.none,
            alignment: Alignment.topLeft,
            allowDrawingOutsideViewBox: true,
          ),
        ),
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
      ],
    );
  }
}
