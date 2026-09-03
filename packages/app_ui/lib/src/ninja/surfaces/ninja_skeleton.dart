import 'dart:async';

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class NinjaSkeleton extends StatelessWidget {
  const NinjaSkeleton({
    required this.height,
    super.key,
    this.width,
    this.widthFactor,
    this.radius = AppRadius.checkbox,
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
        radius = AppRadius.full;

  const NinjaSkeleton.tile({
    super.key,
    this.height = 64,
    this.width,
    this.pulse = true,
    this.shimmer = true,
  })  : widthFactor = null,
        radius = AppRadius.field;

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
    final animation =
        pulse && shimmer && scene?.animate == true ? scene!.animation : null;
    Widget geometry = _NinjaSkeletonGeometry(
      width: width,
      height: height,
      radius: radius,
      base: context.colors.surface2,
      animation: animation,
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

  static const Duration period = Duration(milliseconds: 1400);

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
        duration: NinjaSkeletonGroup.period,
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
    required this.animation,
  });

  final double? width;
  final double height;
  final double radius;
  final Color base;
  final Animation<double>? animation;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderNinjaSkeletonGeometry(
      width: width,
      height: height,
      radius: radius,
      base: base,
      animation: animation,
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
      ..animation = animation;
  }
}

class _RenderNinjaSkeletonGeometry extends RenderBox {
  _RenderNinjaSkeletonGeometry({
    required double? width,
    required double height,
    required double radius,
    required Color base,
    required Animation<double>? animation,
  })  : _width = width,
        _height = height,
        _radius = radius,
        _base = base,
        _animation = animation;

  double? _width;
  double _height;
  double _radius;
  Color _base;
  Animation<double>? _animation;

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

  Animation<double>? get animation => _animation;
  set animation(Animation<double>? value) {
    if (_animation == value) return;
    if (attached) _animation?.removeListener(markNeedsPaint);
    _animation = value;
    if (attached) _animation?.addListener(markNeedsPaint);
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

  static double pulseOpacity(double t) {
    final phase = t < .5 ? t * 2 : (1 - t) * 2;
    return 1 - .5 * Curves.easeInOut.transform(phase);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final bounds = offset & size;
    final rrect = RRect.fromRectAndRadius(bounds, Radius.circular(_radius));
    final currentAnimation = _animation;
    final opacity =
        currentAnimation == null ? 1.0 : pulseOpacity(currentAnimation.value);
    context.canvas.drawRRect(
      rrect,
      Paint()..color = _base.withValues(alpha: _base.a * opacity),
    );
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
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NinjaSkeleton.bar(pulse: pulse, shimmer: shimmer),
              const SizedBox(height: AppSpacing.sm),
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

class AppSkeletonRow extends StatelessWidget {
  const AppSkeletonRow({
    super.key,
    this.showTrailing = true,
    this.pulse = true,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.sectionGap,
      vertical: AppSpacing.md,
    ),
  });

  final bool showTrailing;
  final bool pulse;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return NinjaSkeletonGroup(
      pulse: pulse,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: colors.canvas,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            const NinjaSkeleton(width: 44, height: 44, radius: AppRadius.tile),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NinjaSkeleton(
                    height: 12,
                    widthFactor: .7,
                    radius: AppRadius.focusOutline,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  NinjaSkeleton(
                    height: 10,
                    widthFactor: .45,
                    radius: AppRadius.skeletonThin,
                  ),
                ],
              ),
            ),
            if (showTrailing) ...[
              const SizedBox(width: AppSpacing.md),
              const NinjaSkeleton(
                width: 48,
                height: 22,
                radius: AppRadius.full,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NinjaSkeletonMedia extends StatelessWidget {
  const NinjaSkeletonMedia({
    required this.height,
    super.key,
    this.width,
    this.radius = AppRadius.field,
    this.markSize = 42,
  });

  final double? width;
  final double height;
  final double radius;
  final double markSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: ColoredBox(
        color: colors.surface2,
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

typedef AppSkeleton = NinjaSkeleton;

typedef AppSkeletonGroup = NinjaSkeletonGroup;

typedef AppSkeletonMedia = NinjaSkeletonMedia;
