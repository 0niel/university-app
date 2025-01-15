import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/map/map.dart';

class SvgInteractiveView extends StatefulWidget {
  final String svgAssetPath;

  /// List of clickable rooms
  final List<RoomModel> rooms;

  final Rect viewBoxRect;

  const SvgInteractiveView({
    super.key,
    required this.svgAssetPath,
    required this.rooms,
    required this.viewBoxRect,
  });

  @override
  State<SvgInteractiveView> createState() => _SvgInteractiveViewState();
}

class _SvgInteractiveViewState extends State<SvgInteractiveView> {
  final TransformationController _transformationController = TransformationController();

  void _onTapDown(BuildContext context, TapDownDetails details) {
    final tapPos = details.localPosition;

    final matrix = _transformationController.value;
    final inverse = Matrix4.tryInvert(matrix);
    if (inverse == null) return;

    final transformedPos = MatrixUtils.transformPoint(inverse, tapPos);

    for (final room in widget.rooms) {
      if (room.path.contains(transformedPos)) {
        context.read<MapBloc>().add(RoomTapped(room.roomId));

        _showRoomInfo(room);
        break;
      }
    }
  }

  void _showRoomInfo(RoomModel room) {}

  @override
  Widget build(BuildContext context) {
    final width = widget.viewBoxRect.width;
    final height = widget.viewBoxRect.height;

    return InteractiveViewer(
      transformationController: _transformationController,
      boundaryMargin: const EdgeInsets.all(100),
      minScale: 0.2,
      maxScale: 10,
      child: GestureDetector(
        onTapDown: (details) => _onTapDown(context, details),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: SvgPicture.asset(widget.svgAssetPath),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _RoomsOverlayPainter(
                  rooms: widget.rooms,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomsOverlayPainter extends CustomPainter {
  final List<RoomModel> rooms;

  _RoomsOverlayPainter({required this.rooms});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final r in rooms) {
      if (r.isSelected) {
        paint.color = Colors.green.withOpacity(0.3);
        canvas.drawPath(r.path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RoomsOverlayPainter oldDelegate) {
    return oldDelegate.rooms != rooms;
  }
}
