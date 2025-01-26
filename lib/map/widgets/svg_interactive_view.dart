import 'dart:async';
import 'dart:math' as math;
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/map/map.dart';
import 'package:app_ui/app_ui.dart';
import 'package:go_router/go_router.dart';

/// A widget that displays an interactive SVG map with zoom, pan, and tap-to-select functionality.
/// Users can tap on rooms (represented as paths in the SVG) to select them, view details, and perform actions.
class SvgInteractiveMap extends StatefulWidget {
  /// The path to the SVG asset file that represents the map.
  final String svgAssetPath;

  /// Creates an instance of [SvgInteractiveMap].
  ///
  /// [svgAssetPath] is the path to the SVG file that will be displayed as the map.
  const SvgInteractiveMap({
    super.key,
    required this.svgAssetPath,
  });

  @override
  State<SvgInteractiveMap> createState() => _SvgInteractiveMapState();
}

/// The state class for [SvgInteractiveMap].
/// Manages zoom, pan, tap animations, and room selection logic.
class _SvgInteractiveMapState extends State<SvgInteractiveMap> with TickerProviderStateMixin {
  /// Controller for managing zoom and pan transformations.
  final TransformationController _transformationController = TransformationController();

  /// Controller for managing zoom animations.
  late final AnimationController _zoomAnimationController;

  /// Animation for smooth zooming in/out on double-tap.
  Animation<Matrix4>? _zoomAnimation;

  /// Tracks whether the initial scale has been set.
  bool _isInitialScaleSet = false;

  /// The initial scale of the map when first loaded.
  double _initialScale = 1.0;

  /// The position where the user double-tapped, used for zooming.
  Offset _doubleTapPosition = Offset.zero;

  /// The ID of the currently selected room.
  String? _selectedRoomId;

  /// List of tap animations (e.g., ripple effects) currently active.
  final List<_TapAnimation> _tapAnimations = [];

  /// Flag to indicate if the user is currently interacting with the map (zooming/panning).
  bool _isInteracting = false;

  /// Timer to debounce tap events during zoom/pan interactions.
  Timer? _debounceTapTimer;

  @override
  void initState() {
    super.initState();

    // Initialize the zoom animation controller.
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

    // Dispose all active tap animations.
    for (var animation in _tapAnimations) {
      animation.controller.dispose();
    }

    _debounceTapTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SvgInteractiveMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the SVG asset path changes, reset the scale to fit the screen.
    if (oldWidget.svgAssetPath != widget.svgAssetPath) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitToScreen(BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height,
        ));
      });

      setState(() {
        _selectedRoomId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MapBloc>().state;
    if (state is! MapLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    // Retrieve the list of rooms and the bounding rectangle of the map.
    final rooms = state.rooms;
    final boundingRect = state.boundingRect;
    final canvasSize = Size(boundingRect?.width ?? 0, boundingRect?.height ?? 0);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Set the initial scale to fit the screen on the first build.
        if (!_isInitialScaleSet) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _fitToScreen(constraints);
          });
          _isInitialScaleSet = true;
        }

        return GestureDetector(
          // Handle single tap events.
          onTapDown: (details) => _handleTapDown(details, constraints),
          // Handle double-tap events.
          onDoubleTapDown: _handleDoubleTapDown,
          onDoubleTap: _handleDoubleTap,

          // Allow gestures to be detected even in empty areas.
          behavior: HitTestBehavior.opaque,

          child: Stack(
            children: [
              // The main widget for zooming and panning.
              InteractiveViewer(
                constrained: false,
                boundaryMargin: const EdgeInsets.all(20000),
                minScale: 0.1,
                maxScale: 50,
                transformationController: _transformationController,

                // Disable taps while zooming/panning.
                onInteractionStart: (details) {
                  _zoomAnimationController.stop();
                  setState(() {
                    _isInteracting = true;
                  });
                },
                // Re-enable taps after a short delay when the interaction ends.
                onInteractionEnd: (details) {
                  _debounceTapTimer?.cancel();
                  _debounceTapTimer = Timer(const Duration(milliseconds: 200), () {
                    if (mounted) {
                      setState(() {
                        _isInteracting = false;
                      });
                    }
                  });
                },

                child: Stack(
                  children: [
                    // The SVG image, sized to match the canvas.
                    SizedBox(
                      width: canvasSize.width,
                      height: canvasSize.height,
                      child: SvgPicture.asset(
                        widget.svgAssetPath,
                        fit: BoxFit.none,
                        alignment: Alignment.topLeft,
                        allowDrawingOutsideViewBox: true,
                      ),
                    ),

                    // A CustomPaint overlay to highlight the selected room.
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

              // Render tap animations (e.g., ripple effects).
              ..._tapAnimations.map((tapAnim) {
                final screenPos = tapAnim.position;
                if (screenPos.dx < 0 ||
                    screenPos.dy < 0 ||
                    screenPos.dx > constraints.maxWidth ||
                    screenPos.dy > constraints.maxHeight) {
                  return const SizedBox();
                }

                // Position the ripple effect centered on the tap location.
                final left = screenPos.dx - 20;
                final top = screenPos.dy - 20;

                return Positioned(
                  left: left,
                  top: top,
                  child: FadeTransition(
                    opacity: tapAnim.animation,
                    child: ScaleTransition(
                      scale: tapAnim.animation,
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

  //------------------------------------------------------------------------------
  // Single Tap Handling
  //------------------------------------------------------------------------------

  /// Handles a single tap event on the map.
  /// If a room is tapped, it is selected, and a ripple animation is triggered.
  void _handleTapDown(TapDownDetails details, BoxConstraints constraints) {
    // Ignore taps during zoom/pan interactions.
    if (_isInteracting) return;

    final state = context.read<MapBloc>().state;
    if (state is! MapLoaded) return;

    final rooms = state.rooms;

    // Convert the tap position to scene coordinates (SVG space).
    final localPos = details.localPosition;
    final tapPos = _transformationController.toScene(localPos);

    // Find all rooms that contain the tapped point.
    final containing = rooms.where((room) => room.path.contains(tapPos)).toList();
    if (containing.isEmpty) {
      return;
    }

    // Select the room closest to the tap position.
    RoomModel? selected;
    double minDist = double.infinity;
    for (final room in containing) {
      final center = room.path.getBounds().center;
      final dist = (center - tapPos).distance;
      if (dist < minDist) {
        minDist = dist;
        selected = room;
      }
    }

    if (selected == null) return;

    setState(() {
      _selectedRoomId = selected!.roomId;
    });
    developer.log('Clicked room: ${selected.roomId}');

    context.read<MapBloc>().add(RoomTapped(selected.roomId));

    // Start the tap ripple animation.
    _startTapAnimation(localPos);

    // Provide haptic feedback.
    HapticFeedback.selectionClick();

    // Show a bottom modal sheet with room details.
    BottomModalSheet.show(
      context,
      child: _buildBottomSheetSelectedRoomContent(roomName: selected.name),
      title: 'Room ${selected.name}',
      description: 'You can quickly find the schedule for this room using the schedule search.',
    );
  }

  /// Builds the content for the bottom modal sheet when a room is selected.
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
          text: 'Search',
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  //------------------------------------------------------------------------------
  // Double Tap Handling
  //------------------------------------------------------------------------------

  /// Records the position of a double-tap for zooming.
  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapPosition = details.localPosition;
  }

  /// Handles the double-tap gesture to zoom in/out.
  void _handleDoubleTap() {
    final currentMatrix = _transformationController.value;
    final currentScale = currentMatrix.getMaxScaleOnAxis();

    // Calculate the focal point of the zoom in scene coordinates.
    final focalPointScene = _transformationController.toScene(_doubleTapPosition);

    // Determine the next scale based on the current scale.
    double nextScale;
    if (currentScale < _initialScale * 2.5) {
      // Zoom in by doubling the current scale.
      nextScale = math.min(currentScale * 2, 50.0);
    } else {
      // Zoom out to the initial scale.
      nextScale = _initialScale;
    }

    // Create a transformation matrix for the zoom.
    final incremental = Matrix4.identity()
      ..translate(focalPointScene.dx, focalPointScene.dy)
      ..scale(nextScale / currentScale)
      ..translate(-focalPointScene.dx, -focalPointScene.dy);

    // Apply the transformation to the current matrix.
    final zoomMatrix = currentMatrix.clone()..multiply(incremental);

    // Clamp the matrix to prevent excessive zoom/pan.
    final clampedMatrix = _clampMatrix(zoomMatrix);

    // Animate the zoom transformation.
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

  /// Adjusts the map's scale and position to fit within the screen.
  void _fitToScreen(BoxConstraints constraints) {
    final state = context.read<MapBloc>().state;
    if (state is! MapLoaded) return;

    final boundingRect = state.boundingRect;
    final w = boundingRect?.width ?? 0;
    final h = boundingRect?.height ?? 0;
    if (w <= 0 || h <= 0) return;

    final sw = constraints.maxWidth;
    final sh = constraints.maxHeight;

    // Calculate the scale to fit the map within the screen.
    final scale = math.min(sw / w, sh / h);

    // Save the initial scale for future reference.
    _initialScale = scale;

    // Calculate the translation to center the map on the screen.
    final translateX = (sw - w * scale) / 2;
    final translateY = (sh - h * scale) / 2;

    // Create a transformation matrix for scaling and translating.
    final matrix = Matrix4.identity()
      ..scale(scale, scale)
      ..translate(translateX / scale, translateY / scale);

    developer.log('FitToScreen => scale=$scale, matrix=$matrix');

    _transformationController.value = matrix;
  }

  /// Clamps the transformation matrix to prevent excessive zoom/pan.
  Matrix4 _clampMatrix(Matrix4 matrix) {
    double scale = matrix.getMaxScaleOnAxis();
    scale = scale.clamp(0.1, 50.0);

    final tx = matrix[12].clamp(-20000.0, 20000.0);
    final ty = matrix[13].clamp(-20000.0, 20000.0);

    return Matrix4.identity()
      ..scale(scale, scale)
      ..setTranslationRaw(tx, ty, 0);
  }

  /// Starts a ripple animation at the specified screen position.
  void _startTapAnimation(Offset screenPos) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    );

    final tapAnimation = _TapAnimation(
      position: screenPos,
      animation: animation,
      controller: controller,
    );

    setState(() {
      _tapAnimations.add(tapAnimation);
    });

    controller.forward();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _tapAnimations.remove(tapAnimation);
        });
        controller.dispose();
      }
    });
  }
}

/// A custom painter that highlights the selected room on the map.
class _RoomsHighlightPainter extends CustomPainter {
  final List<RoomModel> rooms;
  final String? selectedRoomId;

  _RoomsHighlightPainter(this.rooms, {this.selectedRoomId});

  @override
  void paint(Canvas canvas, Size size) {
    final highlightPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Highlight the selected room.
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

/// Represents a tap animation (e.g., a ripple effect).
class _TapAnimation {
  final Offset position; // The position of the tap.
  final Animation<double> animation; // The animation controller.
  final AnimationController controller; // The animation itself.

  _TapAnimation({
    required this.position,
    required this.animation,
    required this.controller,
  });
}
