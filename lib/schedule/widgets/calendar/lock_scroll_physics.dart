import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LockScrollPhysics extends ScrollPhysics {
  /// Lock swipe on drag-drop gesture
  /// If it is a user gesture, [applyPhysicsToUserOffset] is called before [applyBoundaryConditions];
  /// If it is a programming gesture eg. `controller.animateTo(index)`, [applyPhysicsToUserOffset] is not called.
  bool _lock = false;

  /// Lock scroll to the left
  final bool lockLeft;

  /// Lock scroll to the right
  final bool lockRight;

  /// Creates physics for a [PageView].
  /// [lockLeft] Lock scroll to the left
  /// [lockRight] Lock scroll to the right
  LockScrollPhysics({super.parent, this.lockLeft = false, this.lockRight = false});

  @override
  LockScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return LockScrollPhysics(parent: buildParent(ancestor), lockLeft: lockLeft, lockRight: lockRight);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if ((lockRight && offset < 0) || (lockLeft && offset > 0)) {
      _lock = true;
      return 0.0;
    }

    return offset;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(() {
      if (value == position.pixels) {
        throw FlutterError('$runtimeType.applyBoundaryConditions() was called redundantly.\n'
            'The proposed new position, $value, is exactly equal to the current position of the '
            'given ${position.runtimeType}, ${position.pixels}.\n'
            'The applyBoundaryConditions method should only be called when the value is '
            'going to actually change the pixels, otherwise it is redundant.\n'
            'The physics object in question was:\n'
            '  $this\n'
            'The position object in question was:\n'
            '  $position\n');
      }
      return true;
    }());

    /*
     * Handle the hard boundaries (min and max extents)
     * (identical to ClampingScrollPhysics)
     */
    // under-scroll
    if (value < position.pixels && position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }
    // over-scroll
    else if (position.maxScrollExtent <= position.pixels && position.pixels < value) {
      return value - position.pixels;
    }
    // hit top edge
    else if (value < position.minScrollExtent && position.minScrollExtent < position.pixels) {
      return value - position.pixels;
    }
    // hit bottom edge
    else if (position.pixels < position.maxScrollExtent && position.maxScrollExtent < value) {
      return value - position.pixels;
    }

    var isGoingLeft = value <= position.pixels;
    var isGoingRight = value >= position.pixels;
    if (_lock && ((lockLeft && isGoingLeft) || (lockRight && isGoingRight))) {
      _lock = false;
      return value - position.pixels;
    }

    return 0.0;
  }
}
