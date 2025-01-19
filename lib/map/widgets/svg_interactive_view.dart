import 'dart:math' as math;
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rtu_mirea_app/map/map.dart';
import 'package:rtu_mirea_app/presentation/widgets/bottom_modal_sheet.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class SvgInteractiveMap extends StatefulWidget {
  final String svgAssetPath;

  const SvgInteractiveMap({
    super.key,
    required this.svgAssetPath,
  });

  @override
  State<SvgInteractiveMap> createState() => _SvgInteractiveMapState();
}

class _SvgInteractiveMapState extends State<SvgInteractiveMap> with TickerProviderStateMixin {
  final TransformationController _transformationController = TransformationController();
  late AnimationController _zoomAnimationController;
  Animation<Matrix4>? _zoomAnimation;
  bool _isZoomedIn = false;

  Offset _doubleTapPosition = Offset.zero;
  bool _isInitialScaleSet = false;
  double _initialScale = 1.0;
  String? _selectedRoomId;
  final List<_TapAnimation> _tapAnimations = [];

  @override
  void initState() {
    super.initState();
    _zoomAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        if (_zoomAnimation != null) {
          _transformationController.value = _zoomAnimation!.value;
        }
      });
  }

  @override
  void dispose() {
    _zoomAnimationController.dispose();
    _transformationController.dispose();

    for (var animation in _tapAnimations) {
      animation.controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SvgInteractiveMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.svgAssetPath != widget.svgAssetPath) {
      _fitToScreen(BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ));

      setState(() {
        _selectedRoomId = null;
      });
    }
  }

  void _onTapDown(TapDownDetails details, Size viewportSize) {
    final state = context.read<MapBloc>().state;
    if (state is! MapLoaded) return;

    final rooms = state.rooms;
    final tapPos = _transformationController.toScene(details.localPosition);

    final containing = rooms.where((r) {
      final bounds = r.path.getBounds();
      return bounds.contains(tapPos);
    }).toList();

    RoomModel? selectedRoom;
    double minDist = double.infinity;
    for (final room in containing) {
      final center = room.path.getBounds().center;
      final dist = (center - tapPos).distance;
      if (dist < minDist) {
        minDist = dist;
        selectedRoom = room;
      }
    }

    if (selectedRoom == null) {
      return;
    }

    setState(() {
      _selectedRoomId = selectedRoom!.roomId;
    });
    developer.log('Clicked room: ${selectedRoom.name} => isSelected=true');

    context.read<MapBloc>().add(RoomTapped(selectedRoom.roomId));

    _startTapAnimation(details.localPosition);

    HapticFeedback.selectionClick();

    BottomModalSheet.show(
      context,
      child: _buildBottomSheetSelectedRoomContent(roomName: selectedRoom.name),
      title: 'Аудитория ${selectedRoom.name}',
      description: 'Вы можете быстро найти расписание для этой аудитории с помощью поиска по расписани.',
    );
  }

  void _startTapAnimation(Offset screenPosition) {
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 190),
      vsync: this,
    );

    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    final tapAnimation = _TapAnimation(
      position: screenPosition,
      animation: animation,
      controller: animationController,
    );

    setState(() {
      _tapAnimations.add(tapAnimation);
    });

    animationController.forward();

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _tapAnimations.remove(tapAnimation);
        });
        animationController.dispose();
      }
    });
  }

  Widget _buildBottomSheetSelectedRoomContent({required String roomName}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 24),
        PrimaryButton(
          onClick: () {
            context.go('/schedule/search', extra: roomName);
            context.pop();
          },
          text: 'Поиск',
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MapBloc>().state;
    if (state is! MapLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final rooms = state.rooms;
    final boundingRect = state.boundingRect;
    final canvasSize = Size(boundingRect?.width ?? 0, boundingRect?.height ?? 0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);

        if (!_isInitialScaleSet) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _fitToScreen(constraints);
          });
          _isInitialScaleSet = true;
        }

        return GestureDetector(
          onTapDown: (details) => _onTapDown(details, viewportSize),
          onDoubleTapDown: _handleDoubleTapDown,
          onDoubleTap: _handleDoubleTap,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              InteractiveViewer(
                constrained: false,
                transformationController: _transformationController,
                boundaryMargin: const EdgeInsets.all(20000),
                minScale: 0.1,
                maxScale: 50,
                onInteractionStart: (details) {
                  _zoomAnimationController.stop();
                },
                child: Stack(
                  children: [
                    SizedBox(
                      width: canvasSize.width,
                      height: canvasSize.height,
                      child: SvgPicture.asset(
                        widget.svgAssetPath,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        allowDrawingOutsideViewBox: false,
                      ),
                    ),
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _RoomsHighlightPainter(
                          rooms,
                          selectedRoomId: _selectedRoomId,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ..._tapAnimations.map((tapAnimation) {
                final screenPos = tapAnimation.position;
                if (screenPos.dx < 0 ||
                    screenPos.dy < 0 ||
                    screenPos.dx > constraints.maxWidth ||
                    screenPos.dy > constraints.maxHeight) {
                  return Container();
                }

                final clampedLeft = (screenPos.dx - 20).clamp(0.0, constraints.maxWidth - 40);
                final clampedTop = (screenPos.dy - 20).clamp(0.0, constraints.maxHeight - 40);

                return Positioned(
                  left: clampedLeft,
                  top: clampedTop,
                  child: FadeTransition(
                    opacity: tapAnimation.animation,
                    child: ScaleTransition(
                      scale: tapAnimation.animation,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _fitToScreen(BoxConstraints constraints) {
    final state = context.read<MapBloc>().state;
    if (state is! MapLoaded) return;

    final boundingRect = state.boundingRect;
    final canvasSize = Size(boundingRect?.width ?? 0, boundingRect?.height ?? 0);

    final w = canvasSize.width;
    final h = canvasSize.height;
    if (w <= 0 || h <= 0) return;

    final sw = constraints.maxWidth;
    final sh = constraints.maxHeight;

    final scale = math.min(sw / w, sh / h);
    _initialScale = scale;

    final translateX = (sw - w * scale) / 2;
    final translateY = (sh - h * scale) / 2;

    final matrix = Matrix4.identity()
      ..scale(scale, scale)
      ..translate(translateX / scale, translateY / scale);

    developer.log('Initial transformation matrix: $matrix');

    _transformationController.value = matrix;
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapPosition = details.localPosition;
  }

  void _handleDoubleTap() {
    final currentMatrix = _transformationController.value;
    final currentScale = currentMatrix.getMaxScaleOnAxis();
    final nextScale = _isZoomedIn ? _initialScale : (_initialScale * 2).clamp(0.1, 50.0);
    _isZoomedIn = !_isZoomedIn;

    final focalPointScene = _transformationController.toScene(_doubleTapPosition);

    final zoomMatrix = Matrix4.identity()
      ..translate(focalPointScene.dx, focalPointScene.dy)
      ..scale(nextScale / currentScale)
      ..translate(-focalPointScene.dx, -focalPointScene.dy)
      ..multiply(currentMatrix);

    final clampedMatrix = _clampMatrix(zoomMatrix);

    _zoomAnimation = Matrix4Tween(
      begin: currentMatrix,
      end: clampedMatrix,
    ).animate(
      CurvedAnimation(
        parent: _zoomAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _zoomAnimationController.forward(from: 0);
  }

  Matrix4 _clampMatrix(Matrix4 matrix) {
    double scale = matrix.getMaxScaleOnAxis();

    scale = scale.clamp(0.1, 50.0);

    return Matrix4.identity()
      ..scale(scale)
      ..translate(
        matrix[12].clamp(-20000.0, 20000.0),
        matrix[13].clamp(-20000.0, 20000.0),
      );
  }
}

class _RoomsHighlightPainter extends CustomPainter {
  final List<RoomModel> rooms;
  final String? selectedRoomId;

  _RoomsHighlightPainter(this.rooms, {this.selectedRoomId});

  @override
  void paint(Canvas canvas, Size size) {
    final highlightPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (final r in rooms) {
      if (r.roomId == selectedRoomId) {
        canvas.drawPath(r.path, highlightPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_RoomsHighlightPainter oldDelegate) {
    return oldDelegate.selectedRoomId != selectedRoomId || oldDelegate.rooms.length != rooms.length;
  }
}

class _TapAnimation {
  final Offset position;
  final Animation<double> animation;
  final AnimationController controller;

  _TapAnimation({
    required this.position,
    required this.animation,
    required this.controller,
  });
}
