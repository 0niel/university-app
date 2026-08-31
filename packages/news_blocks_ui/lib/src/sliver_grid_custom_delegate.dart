import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/rendering.dart';

class SliverGridCustomDelegate
    extends SliverGridDelegateWithMaxCrossAxisExtent {
  const SliverGridCustomDelegate({
    required super.maxCrossAxisExtent,
    super.mainAxisSpacing = 0.0,
    super.crossAxisSpacing = 0.0,
    super.childAspectRatio = 1.0,
    super.mainAxisExtent,
  });

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    var crossAxisCount =
        (constraints.crossAxisExtent / (maxCrossAxisExtent + crossAxisSpacing))
            .ceil();
    crossAxisCount = math.max(1, crossAxisCount);
    final double usableCrossAxisExtent = math.max(
      0,
      constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1),
    );

    final childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final childMainAxisExtent =
        mainAxisExtent ?? (childCrossAxisExtent / childAspectRatio);
    return HeaderGridTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }
}

class HeaderGridTileLayout extends SliverGridRegularTileLayout {
  const HeaderGridTileLayout({
    required super.crossAxisCount,
    required super.mainAxisStride,
    required super.crossAxisStride,
    required super.childMainAxisExtent,
    required super.childCrossAxisExtent,
    required super.reverseCrossAxis,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is HeaderGridTileLayout &&
        other.crossAxisCount == crossAxisCount &&
        other.mainAxisStride == mainAxisStride &&
        other.crossAxisStride == crossAxisStride &&
        other.childMainAxisExtent == childMainAxisExtent &&
        other.childCrossAxisExtent == childCrossAxisExtent &&
        other.reverseCrossAxis == reverseCrossAxis;
  }

  @override
  int get hashCode => Object.hash(
    crossAxisCount,
    mainAxisStride,
    crossAxisStride,
    childMainAxisExtent,
    childCrossAxisExtent,
    reverseCrossAxis,
  );

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    final result = super.getMinChildIndexForScrollOffset(scrollOffset);
    return (result > 0) ? result - 1 : result;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final isFirstElement = index == 0;

    if (isFirstElement) {
      return SliverGridGeometry(
        scrollOffset: (index ~/ crossAxisCount) * mainAxisStride,
        crossAxisOffset: (index % crossAxisCount) * crossAxisStride,
        mainAxisExtent: (2 * mainAxisStride) - AppSpacing.md,
        crossAxisExtent: 2 * crossAxisStride - AppSpacing.md,
      );
    }

    return SliverGridGeometry(
      scrollOffset:
          (((index + 1) ~/ crossAxisCount) * mainAxisStride) +
          childMainAxisExtent,
      crossAxisOffset: ((index + 1) % crossAxisCount) * crossAxisStride,
      mainAxisExtent: mainAxisStride,
      crossAxisExtent: childCrossAxisExtent,
    );
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    return super.computeMaxScrollOffset(childCount + 3);
  }
}
