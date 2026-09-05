import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppZoomableImage extends StatefulWidget {
  const AppZoomableImage({
    required this.imageProvider,
    this.heroTag,
    this.onTap,
    this.onDismissed,
    this.onPrevious,
    this.onNext,
    this.onDismissProgress,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.loadingBuilder,
    this.errorBuilder,
    super.key,
  });

  final ImageProvider<Object> imageProvider;
  final Object? heroTag;
  final VoidCallback? onTap;
  final VoidCallback? onDismissed;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final ValueChanged<double>? onDismissProgress;
  final VoidCallback? onHorizontalDragStart;
  final ValueChanged<double>? onHorizontalDragUpdate;
  final ValueChanged<double>? onHorizontalDragEnd;
  final Widget Function(BuildContext, ImageChunkEvent?)? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  State<AppZoomableImage> createState() => _AppZoomableImageState();
}

class _AppZoomableImageState extends State<AppZoomableImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;
  ImageStream? _stream;
  late final ImageStreamListener _imageListener = ImageStreamListener(
    (info, _) {
      final size =
          Size(info.image.width.toDouble(), info.image.height.toDouble());
      info.dispose();
      if (mounted && size != _imageSize) setState(() => _imageSize = size);
    },
    onError: (error, stackTrace) {},
  );
  Size? _imageSize;
  Size _viewport = Size.zero;
  double _scale = 1;
  Offset _offset = Offset.zero;
  Offset _drag = Offset.zero;
  double _startScale = 1;
  Offset _anchor = Offset.zero;
  Offset _startFocal = Offset.zero;
  bool _pinching = false;
  bool _closing = false;
  bool _paging = false;
  bool _cancelled = false;
  double _fromScale = 1;
  double _toScale = 1;
  Offset _fromOffset = Offset.zero;
  Offset _toOffset = Offset.zero;
  Offset _fromDrag = Offset.zero;
  Offset _toDrag = Offset.zero;
  Offset _doubleTapPosition = Offset.zero;

  bool get _reducedMotion =>
      MediaQuery.disableAnimationsOf(context) ||
      MediaQuery.accessibleNavigationOf(context);

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(vsync: this)..addListener(_tick);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void didUpdateWidget(AppZoomableImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageProvider != widget.imageProvider) {
      _motion.stop();
      _scale = 1;
      _offset = _drag = Offset.zero;
      _imageSize = null;
      _resolveImage();
    }
  }

  void _resolveImage() {
    final next =
        widget.imageProvider.resolve(createLocalImageConfiguration(context));
    if (_stream?.key == next.key) return;
    _stream?.removeListener(_imageListener);
    _stream = next..addListener(_imageListener);
  }

  @override
  void dispose() {
    _stream?.removeListener(_imageListener);
    _motion.dispose();
    super.dispose();
  }

  Offset _bounded(Offset value, double scale) {
    final image = _imageSize ?? _viewport;
    if (image.isEmpty || _viewport.isEmpty) return Offset.zero;
    final fit = math.min(
      _viewport.width / image.width,
      _viewport.height / image.height,
    );
    final maxX = math.max(0, (image.width * fit * scale - _viewport.width) / 2);
    final maxY =
        math.max(0, (image.height * fit * scale - _viewport.height) / 2);
    return Offset(
      value.dx.clamp(-maxX, maxX).toDouble(),
      value.dy.clamp(-maxY, maxY).toDouble(),
    );
  }

  void _tick() {
    final t = Curves.easeOutCubic.transform(_motion.value);
    setState(() {
      _scale = _fromScale + (_toScale - _fromScale) * t;
      _offset = Offset.lerp(_fromOffset, _toOffset, t)!;
      _drag = Offset.lerp(_fromDrag, _toDrag, t)!;
    });
    _reportDrag();
  }

  void _reportDrag() => widget.onDismissProgress?.call(
        _drag.dy.abs() > _drag.dx.abs()
            ? (_drag.dy.abs() / math.max(1, _viewport.height * .6))
                .clamp(0.0, 1.0)
            : 0,
      );

  Future<void> _animate({double scale = 1, Offset offset = Offset.zero}) async {
    _motion.stop();
    _fromScale = _scale;
    _toScale = scale;
    _fromOffset = _offset;
    _toOffset = _bounded(offset, scale);
    _fromDrag = _drag;
    _toDrag = Offset.zero;
    _motion.value = 0;
    try {
      await _motion
          .animateTo(
            1,
            duration: _reducedMotion
                ? Duration.zero
                : const Duration(milliseconds: 240),
          )
          .orCancel;
    } on TickerCanceled {
      return;
    }
  }

  void _doubleTap() {
    if (_closing) return;
    final next = _scale > 1.01 ? 1.0 : 3.0;
    final focal = _doubleTapPosition - _viewport.center(Offset.zero);
    unawaited(
      _animate(
        scale: next,
        offset: next == 1 ? Offset.zero : focal * (1 - next),
      ),
    );
  }

  void _start(ScaleStartDetails details) {
    if (_closing) return;
    _motion.stop();
    _cancelled = false;
    if (_paging) widget.onHorizontalDragEnd?.call(0);
    _paging = false;
    _startScale = _scale;
    _startFocal = details.localFocalPoint;
    _anchor =
        (details.localFocalPoint - _viewport.center(Offset.zero) - _offset) /
            _scale;
    _pinching = details.pointerCount > 1;
  }

  void _update(ScaleUpdateDetails details) {
    if (_closing) return;
    _pinching = _pinching ||
        details.pointerCount > 1 ||
        (details.scale - 1).abs() > .01;
    setState(() {
      if (_pinching || _startScale > 1.01) {
        _drag = Offset.zero;
        _scale = (_startScale * details.scale).clamp(1.0, 5.0);
        _offset = _bounded(
          details.localFocalPoint -
              _viewport.center(Offset.zero) -
              _anchor * _scale,
          _scale,
        );
      } else {
        _drag = details.localFocalPoint - _startFocal;
      }
    });
    _reportDrag();
    if (!_pinching &&
        _startScale <= 1.01 &&
        widget.onHorizontalDragUpdate != null &&
        (_paging ||
            (_drag.dx.abs() > kTouchSlop && _drag.dx.abs() > _drag.dy.abs()))) {
      if (!_paging) widget.onHorizontalDragStart?.call();
      _paging = true;
      widget.onHorizontalDragUpdate!(_drag.dx);
    }
  }

  void _end(ScaleEndDetails details) {
    if (_closing) return;
    if (_cancelled) {
      _cancelled = false;
      return;
    }
    if (details.pointerCount > 0) {
      if (_paging) {
        widget.onHorizontalDragUpdate?.call(0);
        widget.onHorizontalDragEnd?.call(0);
        _paging = false;
      }
      setState(() => _drag = Offset.zero);
      _reportDrag();
      return;
    }
    final velocity = details.velocity.pixelsPerSecond;
    if (_paging) {
      _paging = false;
      widget.onHorizontalDragEnd?.call(velocity.dx);
      unawaited(_animate());
      return;
    }
    if (_pinching || _startScale > 1.01) {
      unawaited(
        _animate(
          scale: _scale < 1.03 ? 1 : _scale,
          offset: _offset + velocity * .12,
        ),
      );
      return;
    }
    final vertical = _drag.dy.abs() > _drag.dx.abs();
    final dismiss = vertical &&
        widget.onDismissed != null &&
        (_drag.dy.abs() > _viewport.height * .16 ||
            (_drag.dy.abs() > 24 &&
                velocity.dy.abs() > 850 &&
                velocity.dy.sign == _drag.dy.sign));
    if (dismiss) {
      _closing = true;
      widget.onDismissed!();
      return;
    }
    if (!vertical &&
        (_drag.dx.abs() > _viewport.width * .18 ||
            (_drag.dx.abs() > 20 && velocity.dx.abs() > 700))) {
      if (_drag.dx < 0) {
        widget.onNext?.call();
      } else {
        widget.onPrevious?.call();
      }
    }
    unawaited(_animate());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _viewport = constraints.biggest;
        final zoomed = _scale > 1.01;
        final vertical = _drag.dy.abs() > _drag.dx.abs();
        final dismissRatio =
            (_drag.dy.abs() / math.max(1, _viewport.height)).clamp(0.0, 1.0);
        final visualDrag = zoomed || _paging
            ? Offset.zero
            : vertical
                ? _drag
                : Offset(_drag.dx * .16, 0);
        Widget image = Image(
          image: widget.imageProvider,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
          frameBuilder: (context, child, frame, synchronous) =>
              frame == null && !synchronous
                  ? widget.loadingBuilder?.call(context, null) ?? child
                  : child,
          loadingBuilder: widget.loadingBuilder == null
              ? null
              : (context, child, progress) => progress == null
                  ? child
                  : widget.loadingBuilder!(context, progress),
          errorBuilder: widget.errorBuilder,
        );
        if (widget.heroTag case final tag?) {
          image = Hero(tag: tag, child: image);
        }
        return CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.escape): () =>
                widget.onDismissed?.call(),
            const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
                widget.onPrevious?.call(),
            const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
                widget.onNext?.call(),
          },
          child: Focus(
            autofocus: true,
            child: Listener(
              onPointerCancel: (_) {
                _cancelled = true;
                if (_paging) {
                  _paging = false;
                  widget.onHorizontalDragUpdate?.call(0);
                  widget.onHorizontalDragEnd?.call(0);
                }
                if (!_closing) {
                  unawaited(_animate(scale: _scale, offset: _offset));
                }
              },
              onPointerSignal: (event) {
                if (event is! PointerScrollEvent) return;
                GestureBinding.instance.pointerSignalResolver.register(event,
                    (_) {
                  final next = (_scale * math.exp(-event.scrollDelta.dy * .002))
                      .clamp(1.0, 5.0);
                  final focal =
                      event.localPosition - _viewport.center(Offset.zero);
                  unawaited(
                    _animate(
                      scale: next,
                      offset: focal - (focal - _offset) / _scale * next,
                    ),
                  );
                });
              },
              child: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                behavior: HitTestBehavior.opaque,
                onTap: widget.onTap,
                onDoubleTapDown: (details) =>
                    _doubleTapPosition = details.localPosition,
                onDoubleTap: _doubleTap,
                onScaleStart: _start,
                onScaleUpdate: _update,
                onScaleEnd: _end,
                child: ClipRect(
                  child: Transform.translate(
                    offset: _offset + visualDrag,
                    child: Transform.scale(
                      key: const ValueKey('image-zoom-transform'),
                      scale: _scale *
                          (vertical && !zoomed ? 1 - dismissRatio * .25 : 1),
                      child: RepaintBoundary(child: image),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
