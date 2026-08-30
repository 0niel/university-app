import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/sliver_grid_custom_delegate.dart';

void main() {
  group('HeaderGridTileLayout', () {
    testWidgets('getMinChildIndexForScrollOffset when '
        'super.getMinChildIndexForScrollOffset is 0', (tester) async {
      const headerTileLayout = HeaderGridTileLayout(
        crossAxisCount: 1,
        mainAxisStride: 14,
        crossAxisStride: 15,
        childMainAxisExtent: 2,
        childCrossAxisExtent: 3,
        reverseCrossAxis: false,
      );

      final result = headerTileLayout.getMinChildIndexForScrollOffset(0);

      expect(result, 0);
    });

    testWidgets('getMinChildIndexForScrollOffset when '
        'super.getMinChildIndexForScrollOffset is greater than 0', (
      tester,
    ) async {
      const headerTileLayout = HeaderGridTileLayout(
        crossAxisCount: 1,
        mainAxisStride: 14,
        crossAxisStride: 15,
        childMainAxisExtent: 2,
        childCrossAxisExtent: 3,
        reverseCrossAxis: false,
      );

      final result = headerTileLayout.getMinChildIndexForScrollOffset(100);

      expect(result, 6);
    });

    testWidgets(
      'getGeometryForChildIndex when index is equal to 0 (first element) ',
      (tester) async {
        const headerTileLayout = HeaderGridTileLayout(
          crossAxisCount: 1,
          mainAxisStride: 14,
          crossAxisStride: 15,
          childMainAxisExtent: 2,
          childCrossAxisExtent: 3,
          reverseCrossAxis: false,
        );

        final geometry = headerTileLayout.getGeometryForChildIndex(0);

        const expectedGeometry = SliverGridGeometry(
          scrollOffset: 0,
          crossAxisOffset: 0,
          mainAxisExtent: 16,
          crossAxisExtent: 18,
        );

        expect(geometry.crossAxisExtent, expectedGeometry.crossAxisExtent);
        expect(geometry.scrollOffset, expectedGeometry.scrollOffset);
        expect(geometry.mainAxisExtent, expectedGeometry.mainAxisExtent);
        expect(geometry.crossAxisExtent, expectedGeometry.crossAxisExtent);
      },
    );

    testWidgets('getGeometryForChildIndex when index is not equal to 0', (
      tester,
    ) async {
      const headerTileLayout = HeaderGridTileLayout(
        crossAxisCount: 1,
        mainAxisStride: 14,
        crossAxisStride: 15,
        childMainAxisExtent: 2,
        childCrossAxisExtent: 3,
        reverseCrossAxis: false,
      );

      final geometry = headerTileLayout.getGeometryForChildIndex(2);

      const expectedGeometry = SliverGridGeometry(
        scrollOffset: 44,
        crossAxisOffset: 0,
        mainAxisExtent: 14,
        crossAxisExtent: 3,
      );

      expect(geometry.crossAxisExtent, expectedGeometry.crossAxisExtent);
      expect(geometry.scrollOffset, expectedGeometry.scrollOffset);
      expect(geometry.mainAxisExtent, expectedGeometry.mainAxisExtent);
      expect(geometry.crossAxisExtent, expectedGeometry.crossAxisExtent);
    });
    testWidgets('computeMaxScrollOffset', (tester) async {
      const headerTileLayout = HeaderGridTileLayout(
        crossAxisCount: 1,
        mainAxisStride: 14,
        crossAxisStride: 15,
        childMainAxisExtent: 2,
        childCrossAxisExtent: 3,
        reverseCrossAxis: false,
      );

      final maxScrollOffset = headerTileLayout.computeMaxScrollOffset(2);

      expect(maxScrollOffset, 58);
    });

    test('compares every layout field and keeps equal hashes stable', () {
      const layout = HeaderGridTileLayout(
        crossAxisCount: 2,
        mainAxisStride: 14,
        crossAxisStride: 15,
        childMainAxisExtent: 2,
        childCrossAxisExtent: 3,
        reverseCrossAxis: false,
      );
      const equalLayout = HeaderGridTileLayout(
        crossAxisCount: 2,
        mainAxisStride: 14,
        crossAxisStride: 15,
        childMainAxisExtent: 2,
        childCrossAxisExtent: 3,
        reverseCrossAxis: false,
      );
      const differentColumnCount = HeaderGridTileLayout(
        crossAxisCount: 3,
        mainAxisStride: 14,
        crossAxisStride: 15,
        childMainAxisExtent: 2,
        childCrossAxisExtent: 3,
        reverseCrossAxis: false,
      );

      expect(layout, equalLayout);
      expect(layout.hashCode, equalLayout.hashCode);
      expect(layout, isNot(differentColumnCount));
    });
  });
}
