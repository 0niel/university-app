import 'dart:async';

import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class NinjaSkeleton extends StatelessWidget {
  const NinjaSkeleton({
    required this.height,
    super.key,
    this.width,
    this.widthFactor,
    this.radius = 8,
    this.pulse = true,
    this.shimmer = true,
  });

  const NinjaSkeleton.avatar({
    super.key,
    double size = 44,
    this.pulse = true,
    this.shimmer = true,
  })  : width = size,
        height = size,
        widthFactor = null,
        radius = size / 2;

  const NinjaSkeleton.bar({
    super.key,
    this.height = 12,
    this.widthFactor,
    this.pulse = true,
    this.shimmer = true,
  })  : width = null,
        radius = 999;

  const NinjaSkeleton.tile({
    super.key,
    this.height = 64,
    this.width,
    this.pulse = true,
    this.shimmer = true,
  })  : widthFactor = null,
        radius = 18;

  final double? width;
  final double height;
  final double? widthFactor;
  final double radius;
  final bool pulse;
  final bool shimmer;

  @override
  Widget build(BuildContext context) {
    final scene = _NinjaSkeletonSceneData.maybeOf(context);
    if (scene == null) {
      if (!pulse || !shimmer) {
        return ExcludeSemantics(child: _buildGeometry(context, null));
      }
      return NinjaSkeletonGroup(child: _NinjaSkeletonInScene(skeleton: this));
    }
    return ExcludeSemantics(child: _buildGeometry(context, scene));
  }

  Widget _buildGeometry(BuildContext context, _NinjaSkeletonSceneData? scene) {
    final colors = context.ninja;
    final peak = Color.alphaBlend(
      colors.brand.withValues(alpha: colors.isDark ? .09 : .055),
      colors.surfaceAlt,
    );
    final base = Color.lerp(colors.surfaceAlt, peak, .26)!;
    final animation =
        pulse && shimmer && scene?.animate == true ? scene!.animation : null;
    Widget geometry = _NinjaSkeletonGeometry(
      width: width,
      height: height,
      radius: radius,
      base: base,
      highlight: colors.isDark
          ? colors.ink.withValues(alpha: .075)
          : colors.surface.withValues(alpha: .72),
      animation: animation,
      viewportSize: MediaQuery.maybeSizeOf(context) ?? const Size(360, 800),
    );
    final factor = widthFactor;
    if (factor != null) {
      geometry = FractionallySizedBox(
        alignment: AlignmentDirectional.centerStart,
        widthFactor: factor.clamp(0, 1),
        child: geometry,
      );
    }
    return geometry;
  }
}

class _NinjaSkeletonInScene extends StatelessWidget {
  const _NinjaSkeletonInScene({required this.skeleton});

  final NinjaSkeleton skeleton;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: skeleton._buildGeometry(
        context,
        _NinjaSkeletonSceneData.maybeOf(context),
      ),
    );
  }
}

class NinjaSkeletonGroup extends StatefulWidget {
  const NinjaSkeletonGroup({
    required this.child,
    super.key,
    this.excludeSemantics = true,
    this.pulse = true,
    this.semanticsLabel,
  });

  final Widget child;
  final bool excludeSemantics;
  final bool pulse;
  final String? semanticsLabel;

  @override
  State<NinjaSkeletonGroup> createState() => _NinjaSkeletonGroupState();
}

class _NinjaSkeletonGroupState extends State<NinjaSkeletonGroup>
    with SingleTickerProviderStateMixin {
  static const _stoppedAnimation = AlwaysStoppedAnimation<double>(0);
  AnimationController? _controller;
  bool _animate = false;
  _NinjaSkeletonSceneData? _parent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant NinjaSkeletonGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  void _syncAnimation() {
    _parent = _NinjaSkeletonSceneData.maybeOf(context);
    final mediaQuery = MediaQuery.maybeOf(context);
    final reduceMotion = mediaQuery?.disableAnimations == true ||
        mediaQuery?.accessibleNavigation == true;
    final animate = _parent == null &&
        widget.pulse &&
        !reduceMotion &&
        TickerMode.valuesOf(context).enabled;
    if (_animate == animate && (_controller?.isAnimating == true || !animate)) {
      return;
    }
    _animate = animate;
    if (animate) {
      final controller = _controller ??= AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2200),
      );
      unawaited(controller.repeat());
    } else {
      _controller
        ?..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var child = widget.excludeSemantics
        ? ExcludeSemantics(child: widget.child)
        : widget.child;
    final semanticsLabel = widget.semanticsLabel;
    if (semanticsLabel != null) {
      child = Semantics(
        container: true,
        liveRegion: true,
        label: semanticsLabel,
        child: child,
      );
    }

    final parent = _parent;
    if (parent != null) {
      return _NinjaSkeletonSceneData(
        animation: parent.animation,
        animate: parent.animate && widget.pulse,
        child: child,
      );
    }

    final animation = _controller ?? _stoppedAnimation;
    final content = _NinjaSkeletonSceneData(
      animation: animation,
      animate: _animate,
      child: child,
    );
    if (!_animate) return content;
    return RepaintBoundary(child: content);
  }
}

class _NinjaSkeletonSceneData extends InheritedWidget {
  const _NinjaSkeletonSceneData({
    required this.animation,
    required this.animate,
    required super.child,
  });

  final Animation<double> animation;
  final bool animate;

  static _NinjaSkeletonSceneData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(_NinjaSkeletonSceneData oldWidget) {
    return animate != oldWidget.animate || animation != oldWidget.animation;
  }
}

class _NinjaSkeletonGeometry extends LeafRenderObjectWidget {
  const _NinjaSkeletonGeometry({
    required this.width,
    required this.height,
    required this.radius,
    required this.base,
    required this.highlight,
    required this.animation,
    required this.viewportSize,
  });

  final double? width;
  final double height;
  final double radius;
  final Color base;
  final Color highlight;
  final Animation<double>? animation;
  final Size viewportSize;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderNinjaSkeletonGeometry(
      width: width,
      height: height,
      radius: radius,
      base: base,
      highlight: highlight,
      animation: animation,
      viewportSize: viewportSize,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderNinjaSkeletonGeometry renderObject,
  ) {
    renderObject
      ..width = width
      ..height = height
      ..radius = radius
      ..base = base
      ..highlight = highlight
      ..animation = animation
      ..viewportSize = viewportSize;
  }
}

class _RenderNinjaSkeletonGeometry extends RenderBox {
  _RenderNinjaSkeletonGeometry({
    required double? width,
    required double height,
    required double radius,
    required Color base,
    required Color highlight,
    required Animation<double>? animation,
    required Size viewportSize,
  })  : _width = width,
        _height = height,
        _radius = radius,
        _base = base,
        _highlight = highlight,
        _animation = animation,
        _viewportSize = viewportSize;

  double? _width;
  double _height;
  double _radius;
  Color _base;
  Color _highlight;
  Animation<double>? _animation;
  Size _viewportSize;

  double? get width => _width;
  set width(double? value) {
    if (_width == value) return;
    _width = value;
    markNeedsLayout();
  }

  double get height => _height;
  set height(double value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  double get radius => _radius;
  set radius(double value) {
    if (_radius == value) return;
    _radius = value;
    markNeedsPaint();
  }

  Color get base => _base;
  set base(Color value) {
    if (_base == value) return;
    _base = value;
    markNeedsPaint();
  }

  Color get highlight => _highlight;
  set highlight(Color value) {
    if (_highlight == value) return;
    _highlight = value;
    markNeedsPaint();
  }

  Animation<double>? get animation => _animation;
  set animation(Animation<double>? value) {
    if (_animation == value) return;
    if (attached) _animation?.removeListener(markNeedsPaint);
    _animation = value;
    if (attached) _animation?.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  Size get viewportSize => _viewportSize;
  set viewportSize(Size value) {
    if (_viewportSize == value) return;
    _viewportSize = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = constraints.constrain(Size(_width ?? double.infinity, _height));
  }

  @override
  double computeMinIntrinsicWidth(double availableHeight) => _width ?? 0;

  @override
  double computeMaxIntrinsicWidth(double availableHeight) =>
      _width ?? double.infinity;

  @override
  double computeMinIntrinsicHeight(double availableWidth) => _height;

  @override
  double computeMaxIntrinsicHeight(double availableWidth) => _height;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _animation?.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _animation?.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final bounds = offset & size;
    final rrect = RRect.fromRectAndRadius(bounds, Radius.circular(_radius));
    context.canvas.drawRRect(rrect, Paint()..color = _base);
    final currentAnimation = _animation;
    if (currentAnimation == null || size.isEmpty) return;

    final globalOrigin = localToGlobal(Offset.zero);
    final viewportWidth = _viewportSize.width.clamp(1, double.infinity);
    final viewportHeight = _viewportSize.height.clamp(1, double.infinity);
    final progress = Curves.easeInOutCubic.transform(currentAnimation.value);
    final centerX = (-.35 + progress * 1.7) * viewportWidth;
    final localCenterX = centerX - globalOrigin.dx + offset.dx;
    final top = -globalOrigin.dy + offset.dy;
    final sweepWidth = viewportWidth * .34;
    final shader = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        const Color(0x00000000),
        _highlight.withValues(alpha: 0),
        _highlight,
        _highlight.withValues(alpha: 0),
        const Color(0x00000000),
      ],
      stops: const [0, .32, .5, .68, 1],
    ).createShader(
      Rect.fromLTWH(
        localCenterX - sweepWidth,
        top - viewportHeight * .18,
        sweepWidth * 2,
        viewportHeight * 1.36,
      ),
    );
    context.canvas.drawRRect(rrect, Paint()..shader = shader);
  }
}

class NinjaSkeletonRow extends StatelessWidget {
  const NinjaSkeletonRow({super.key, this.pulse = true, this.shimmer = true});

  final bool pulse;
  final bool shimmer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NinjaSkeleton.avatar(pulse: pulse, shimmer: shimmer),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NinjaSkeleton.bar(pulse: pulse, shimmer: shimmer),
              const SizedBox(height: 8),
              NinjaSkeleton.bar(
                height: 10,
                widthFactor: 0.58,
                pulse: pulse,
                shimmer: shimmer,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NinjaSkeletonMedia extends StatelessWidget {
  const NinjaSkeletonMedia({
    required this.height,
    super.key,
    this.width,
    this.radius = 18,
    this.markSize = 42,
  });

  final double? width;
  final double height;
  final double radius;
  final double markSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: ColoredBox(
        color: Color.alphaBlend(
          colors.brand.withValues(alpha: colors.isDark ? .08 : .05),
          colors.surfaceAlt,
        ),
        child: SizedBox(
          width: width ?? double.infinity,
          height: height,
          child: Center(
            child: NinjaSkeleton(
              width: markSize,
              height: markSize,
              radius: markSize * .32,
            ),
          ),
        ),
      ),
    );
  }
}
