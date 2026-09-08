import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/widgets/map_skeleton.dart';

void main() {
  for (final textScale in [1.0, 2.0]) {
    testWidgets('loading map fits a short viewport at ${textScale}x text', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(320, 420)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MediaQuery(
            data: MediaQueryData(
              size: const Size(320, 420),
              padding: const EdgeInsets.only(top: 36),
              textScaler: TextScaler.linear(textScale),
              disableAnimations: true,
            ),
            child: const AppBottomBarViewport(
              bottomInset: 104,
              child: MapSkeleton(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(AppSkeletonRow), findsNWidgets(3));
      await tester.drag(find.byType(MapSkeleton), const Offset(0, -250));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        tester.getRect(find.byType(AppSkeletonRow).last).bottom,
        lessThan(420),
      );
    });
  }
}
