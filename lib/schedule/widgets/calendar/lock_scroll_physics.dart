import 'package:flutter/material.dart';

/// A scroll physics that always locks the scroll to the closest page.
class LockScrollPhysics extends ScrollPhysics {
  /// Creates physics for a [PageView].
  const LockScrollPhysics({super.parent});

  @override
  LockScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return LockScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(mass: 80, stiffness: 100, damping: 1);

  @override
  bool get allowImplicitScrolling => false;

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, then we should animate to the closest page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
    }
    return null;
  }

  double _getTargetPixels(ScrollMetrics position, Tolerance tolerance, double velocity) {
    final page = (position.pixels + 0.5 * position.viewportDimension) / position.viewportDimension;
    final targetPage =
        velocity < -tolerance.velocity
            ? page.floor()
            : velocity > tolerance.velocity
            ? page.ceil()
            : page.round();
    return targetPage * position.viewportDimension;
  }
}
