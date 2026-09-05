import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show clampDouble;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tour/app_tour_anchors.dart';
import 'package:rtu_mirea_app/tour/app_tour_controller.dart';
import 'package:rtu_mirea_app/tour/model/app_tour_step.dart';
import 'package:rtu_mirea_app/tour/view/tour_coach_card.dart';

class AppTourOverlay extends StatefulWidget {
  const AppTourOverlay({
    required this.router,
    required this.child,
    this.controller,
    super.key,
  });

  final GoRouter router;
  final Widget child;

  final AppTourController? controller;

  @override
  State<AppTourOverlay> createState() => _AppTourOverlayState();
}

class _AppTourOverlayState extends State<AppTourOverlay>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static const Duration _pulseDuration = Duration(milliseconds: 1700);
  static const Duration _trackingInterval = Duration(milliseconds: 120);

  late final AppTourController _controller =
      widget.controller ?? AppTourController.instance;
  late final AnimationController _pulse;
  late bool _isTourActive;
  Timer? _trackingTimer;

  @override
  void initState() {
    super.initState();
    _isTourActive = _controller.isActive;
    _pulse = AnimationController(vsync: this, duration: _pulseDuration);
    _controller
      ..router = widget.router
      ..addListener(_onTourChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void didUpdateWidget(AppTourOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.router != widget.router) {
      _controller.router = widget.router;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_onTourChanged);
    _trackingTimer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    if (!_isTourActive) return false;
    _controller.stop();
    return true;
  }

  void _onTourChanged() {
    if (!mounted) return;
    _syncPulse();
    setState(() => _isTourActive = _controller.isActive);
  }

  void _syncPulse() {
    final media = MediaQuery.maybeOf(context);
    final reduceMotion =
        (media?.disableAnimations ?? false) ||
        (media?.accessibleNavigation ?? false);
    if (_isTourActive) {
      _trackingTimer ??= Timer.periodic(
        _trackingInterval,
        (_) => _trackAnchor(),
      );
      _trackAnchor();
    } else {
      _trackingTimer?.cancel();
      _trackingTimer = null;
    }
    final shouldAnimate = _isTourActive && !reduceMotion;
    if (shouldAnimate == _pulse.isAnimating) return;
    if (shouldAnimate) {
      unawaited(_pulse.repeat());
    } else {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  void _trackAnchor() {
    final target = _controller.step?.target;
    if (target == null) return;
    _controller.syncHole(AppTourAnchors.rectOf(target));
  }

  Rect? _localHole(Rect? hole) {
    if (hole == null) return null;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return null;
    return Rect.fromPoints(
      box.globalToLocal(hole.topLeft),
      box.globalToLocal(hole.bottomRight),
    );
  }

  @override
  Widget build(BuildContext context) {
    final step = _controller.step;
    return Stack(
      children: [
        ExcludeSemantics(excluding: step != null, child: widget.child),
        if (step != null)
          Positioned.fill(
            child: _AppTourLayer(
              step: step,
              hole: _localHole(_controller.hole),
              pulse: _pulse,
              moving: _controller.isMoving,
              index: _controller.index,
              total: _controller.length,
              isFirst: _controller.isFirst,
              isLast: _controller.isLast,
              onNext: () => unawaited(_controller.next()),
              onBack: () => unawaited(_controller.back()),
              onSkip: _controller.stop,
            ),
          ),
      ],
    );
  }
}

class _AppTourLayer extends StatefulWidget {
  const _AppTourLayer({
    required this.step,
    required this.hole,
    required this.pulse,
    required this.moving,
    required this.index,
    required this.total,
    required this.isFirst,
    required this.isLast,
    required this.onNext,
    required this.onBack,
    required this.onSkip,
  });

  final AppTourStep step;
  final Rect? hole;
  final Animation<double> pulse;
  final bool moving;
  final int index;
  final int total;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  static const double _margin = 16;
  static const double _gap = 12;
  static const double _maxCardWidth = 420;
  static const double _minCardSpace = 190;

  @override
  State<_AppTourLayer> createState() => _AppTourLayerState();
}

class _AppTourLayerState extends State<_AppTourLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _transition = AnimationController(
    vsync: this,
    duration: NinjaMotion.slow,
    value: 1,
  );
  late final Animation<double> _transitionCurve = CurvedAnimation(
    parent: _transition,
    curve: NinjaMotion.emphasized,
  );
  late Rect? _fromHole = widget.hole;
  late Rect? _toHole = widget.hole;

  @override
  void didUpdateWidget(_AppTourLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hole == widget.hole) return;
    if (_transition.isAnimating && oldWidget.index == widget.index) {
      _toHole = widget.hole;
      return;
    }
    _fromHole = Rect.lerp(_fromHole, _toHole, _transitionCurve.value);
    _toHole = widget.hole;
    final duration = NinjaMotion.of(context, NinjaMotion.slow);
    if (_fromHole == null || _toHole == null || duration == Duration.zero) {
      _transition.value = 1;
      return;
    }
    _transition.duration = duration;
    unawaited(_transition.forward(from: 0));
  }

  @override
  void dispose() {
    _transition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _transition,
      builder: (context, _) => _buildLayer(
        context,
        Rect.lerp(_fromHole, _toHole, _transitionCurve.value),
      ),
    );
  }

  Widget _buildLayer(BuildContext context, Rect? animatedHole) {
    final l10n = context.l10n;
    final size = MediaQuery.sizeOf(context);
    final viewPadding = MediaQuery.paddingOf(context);
    final rect = animatedHole == null
        ? null
        : Rect.fromLTRB(
            math.max(0, animatedHole.left - widget.step.padding),
            math.max(0, animatedHole.top - widget.step.padding),
            math.min(size.width, animatedHole.right + widget.step.padding),
            math.min(size.height, animatedHole.bottom + widget.step.padding),
          );

    final width = math.min(
      size.width - _AppTourLayer._margin * 2,
      _AppTourLayer._maxCardWidth,
    );
    final spaceBelow = rect == null
        ? 0.0
        : size.height -
              viewPadding.bottom -
              rect.bottom -
              _AppTourLayer._gap -
              _AppTourLayer._margin;
    final spaceAbove = rect == null
        ? 0.0
        : rect.top -
              viewPadding.top -
              _AppTourLayer._gap -
              _AppTourLayer._margin;
    final below = spaceBelow >= spaceAbove;
    final space = math.max(spaceBelow, spaceAbove);
    final floating = rect == null || space < _AppTourLayer._minCardSpace;

    final left = rect == null
        ? _AppTourLayer._margin
        : clampDouble(
            rect.center.dx - width / 2,
            _AppTourLayer._margin,
            math.max(
              _AppTourLayer._margin,
              size.width - _AppTourLayer._margin - width,
            ),
          );

    final card = Listener(
      behavior: HitTestBehavior.opaque,
      child: TourCoachCard(
        title: widget.step.title,
        body: widget.step.body,
        progress: l10n.tourProgress(widget.index + 1, widget.total),
        nextLabel: widget.isLast ? l10n.tourFinish : l10n.tourNext,
        onNext: widget.onNext,
        backLabel: widget.isFirst ? null : l10n.tourBack,
        onBack: widget.isFirst ? null : widget.onBack,
        skipLabel: widget.isLast ? null : l10n.tourSkip,
        onSkip: widget.isLast ? null : widget.onSkip,
        arrow: floating
            ? TourCoachArrow.none
            : (below ? TourCoachArrow.up : TourCoachArrow.down),
        arrowOffset: rect == null
            ? 0
            : clampDouble(rect.center.dx - left, 24, width - 24),
      ),
    );
    final transitioning = widget.moving || _transition.isAnimating;
    final cardLayer = SizedBox.expand(
      key: ValueKey(widget.index),
      child: Stack(
        children: [
          if (floating)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(_AppTourLayer._margin),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width),
                  child: card,
                ),
              ),
            )
          else
            Positioned(
              left: left,
              width: width,
              top: below ? rect.bottom + _AppTourLayer._gap : null,
              bottom: below
                  ? null
                  : size.height - rect.top + _AppTourLayer._gap,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: space),
                child: SingleChildScrollView(
                  reverse: !below,
                  child: card,
                ),
              ),
            ),
        ],
      ),
    );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Stack(
        children: [
          NinjaSpotlight(
            hole: rect,
            pulse: widget.pulse,
            shape: widget.step.shape,
            radius: widget.step.radius,
            animateHole: false,
          ),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              excludeFromSemantics: true,
              onTap: transitioning ? null : widget.onNext,
            ),
          ),
          AbsorbPointer(
            absorbing: transitioning,
            child: NinjaStateSwitcher(
              duration: NinjaMotion.slow,
              alignment: Alignment.center,
              slideOffset: 0.025,
              child: cardLayer,
            ),
          ),
        ],
      ),
    );
  }
}
