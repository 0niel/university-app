import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRowTrailing', () {
    testWidgets('caps the child at a fraction of the screen width', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                Expanded(child: SizedBox()),
                AppRowTrailing(
                  maxWidthFactor: 0.5,
                  child: SizedBox(width: 400, height: 20),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(AppRowTrailing)).width, 200);
    });

    testWidgets('rejects an out-of-range factor', (tester) async {
      expect(
        () => AppRowTrailing(maxWidthFactor: 0, child: const SizedBox()),
        throwsAssertionError,
      );
    });
  });
}
